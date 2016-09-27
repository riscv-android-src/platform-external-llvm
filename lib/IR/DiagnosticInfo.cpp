//===- llvm/Support/DiagnosticInfo.cpp - Diagnostic Definitions -*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the different classes involved in low level diagnostics.
//
// Diagnostics reporting is still done as part of the LLVMContext.
//===----------------------------------------------------------------------===//

#include "llvm/IR/DiagnosticInfo.h"
#include "LLVMContextImpl.h"
#include "llvm/ADT/Twine.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugInfo.h"
#include "llvm/IR/DiagnosticPrinter.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Regex.h"
#include <atomic>
#include <string>

using namespace llvm;

namespace {

/// \brief Regular expression corresponding to the value given in one of the
/// -pass-remarks* command line flags. Passes whose name matches this regexp
/// will emit a diagnostic when calling the associated diagnostic function
/// (emitOptimizationRemark, emitOptimizationRemarkMissed or
/// emitOptimizationRemarkAnalysis).
struct PassRemarksOpt {
  std::shared_ptr<Regex> Pattern;

  void operator=(const std::string &Val) {
    // Create a regexp object to match pass names for emitOptimizationRemark.
    if (!Val.empty()) {
      Pattern = std::make_shared<Regex>(Val);
      std::string RegexError;
      if (!Pattern->isValid(RegexError))
        report_fatal_error("Invalid regular expression '" + Val +
                               "' in -pass-remarks: " + RegexError,
                           false);
    }
  }
};

static PassRemarksOpt PassRemarksOptLoc;
static PassRemarksOpt PassRemarksMissedOptLoc;
static PassRemarksOpt PassRemarksAnalysisOptLoc;

// -pass-remarks
//    Command line flag to enable emitOptimizationRemark()
static cl::opt<PassRemarksOpt, true, cl::parser<std::string>>
PassRemarks("pass-remarks", cl::value_desc("pattern"),
            cl::desc("Enable optimization remarks from passes whose name match "
                     "the given regular expression"),
            cl::Hidden, cl::location(PassRemarksOptLoc), cl::ValueRequired,
            cl::ZeroOrMore);

// -pass-remarks-missed
//    Command line flag to enable emitOptimizationRemarkMissed()
static cl::opt<PassRemarksOpt, true, cl::parser<std::string>> PassRemarksMissed(
    "pass-remarks-missed", cl::value_desc("pattern"),
    cl::desc("Enable missed optimization remarks from passes whose name match "
             "the given regular expression"),
    cl::Hidden, cl::location(PassRemarksMissedOptLoc), cl::ValueRequired,
    cl::ZeroOrMore);

// -pass-remarks-analysis
//    Command line flag to enable emitOptimizationRemarkAnalysis()
static cl::opt<PassRemarksOpt, true, cl::parser<std::string>>
PassRemarksAnalysis(
    "pass-remarks-analysis", cl::value_desc("pattern"),
    cl::desc(
        "Enable optimization analysis remarks from passes whose name match "
        "the given regular expression"),
    cl::Hidden, cl::location(PassRemarksAnalysisOptLoc), cl::ValueRequired,
    cl::ZeroOrMore);
}

int llvm::getNextAvailablePluginDiagnosticKind() {
  static std::atomic<int> PluginKindID(DK_FirstPluginKind);
  return ++PluginKindID;
}

const char *DiagnosticInfoOptimizationRemarkAnalysis::AlwaysPrint = "";

DiagnosticInfoInlineAsm::DiagnosticInfoInlineAsm(const Instruction &I,
                                                 const Twine &MsgStr,
                                                 DiagnosticSeverity Severity)
    : DiagnosticInfo(DK_InlineAsm, Severity), LocCookie(0), MsgStr(MsgStr),
      Instr(&I) {
  if (const MDNode *SrcLoc = I.getMetadata("srcloc")) {
    if (SrcLoc->getNumOperands() != 0)
      if (const auto *CI =
              mdconst::dyn_extract<ConstantInt>(SrcLoc->getOperand(0)))
        LocCookie = CI->getZExtValue();
  }
}

void DiagnosticInfoInlineAsm::print(DiagnosticPrinter &DP) const {
  DP << getMsgStr();
  if (getLocCookie())
    DP << " at line " << getLocCookie();
}

void DiagnosticInfoResourceLimit::print(DiagnosticPrinter &DP) const {
  DP << getResourceName() << " limit";

  if (getResourceLimit() != 0)
    DP << " of " << getResourceLimit();

  DP << " exceeded (" <<  getResourceSize() << ") in " << getFunction();
}

void DiagnosticInfoDebugMetadataVersion::print(DiagnosticPrinter &DP) const {
  DP << "ignoring debug info with an invalid version (" << getMetadataVersion()
     << ") in " << getModule();
}

void DiagnosticInfoIgnoringInvalidDebugMetadata::print(
    DiagnosticPrinter &DP) const {
  DP << "ignoring invalid debug info in " << getModule().getModuleIdentifier();
}

void DiagnosticInfoSampleProfile::print(DiagnosticPrinter &DP) const {
  if (!FileName.empty()) {
    DP << getFileName();
    if (LineNum > 0)
      DP << ":" << getLineNum();
    DP << ": ";
  }
  DP << getMsg();
}

void DiagnosticInfoPGOProfile::print(DiagnosticPrinter &DP) const {
  if (getFileName())
    DP << getFileName() << ": ";
  DP << getMsg();
}

bool DiagnosticInfoWithDebugLocBase::isLocationAvailable() const {
  return getDebugLoc();
}

void DiagnosticInfoWithDebugLocBase::getLocation(StringRef *Filename,
                                                 unsigned *Line,
                                                 unsigned *Column) const {
  DILocation *L = getDebugLoc();
  assert(L != nullptr && "debug location is invalid");
  *Filename = L->getFilename();
  *Line = L->getLine();
  *Column = L->getColumn();
}

const std::string DiagnosticInfoWithDebugLocBase::getLocationStr() const {
  StringRef Filename("<unknown>");
  unsigned Line = 0;
  unsigned Column = 0;
  if (isLocationAvailable())
    getLocation(&Filename, &Line, &Column);
  return (Filename + ":" + Twine(Line) + ":" + Twine(Column)).str();
}

void DiagnosticInfoOptimizationBase::print(DiagnosticPrinter &DP) const {
  DP << getLocationStr() << ": " << getMsg();
  if (Hotness)
    DP << " (hotness: " << *Hotness << ")";
}

bool DiagnosticInfoOptimizationRemark::isEnabled() const {
  return PassRemarksOptLoc.Pattern &&
         PassRemarksOptLoc.Pattern->match(getPassName());
}

bool DiagnosticInfoOptimizationRemarkMissed::isEnabled() const {
  return PassRemarksMissedOptLoc.Pattern &&
         PassRemarksMissedOptLoc.Pattern->match(getPassName());
}

bool DiagnosticInfoOptimizationRemarkAnalysis::isEnabled() const {
  return shouldAlwaysPrint() ||
         (PassRemarksAnalysisOptLoc.Pattern &&
          PassRemarksAnalysisOptLoc.Pattern->match(getPassName()));
}

void DiagnosticInfoMIRParser::print(DiagnosticPrinter &DP) const {
  DP << Diagnostic;
}

void llvm::emitOptimizationRemark(LLVMContext &Ctx, const char *PassName,
                                  const Function &Fn, const DebugLoc &DLoc,
                                  const Twine &Msg) {
  Ctx.diagnose(DiagnosticInfoOptimizationRemark(PassName, Fn, DLoc, Msg));
}

void llvm::emitOptimizationRemarkMissed(LLVMContext &Ctx, const char *PassName,
                                        const Function &Fn,
                                        const DebugLoc &DLoc,
                                        const Twine &Msg) {
  Ctx.diagnose(DiagnosticInfoOptimizationRemarkMissed(PassName, Fn, DLoc, Msg));
}

void llvm::emitOptimizationRemarkAnalysis(LLVMContext &Ctx,
                                          const char *PassName,
                                          const Function &Fn,
                                          const DebugLoc &DLoc,
                                          const Twine &Msg) {
  Ctx.diagnose(
      DiagnosticInfoOptimizationRemarkAnalysis(PassName, Fn, DLoc, Msg));
}

void llvm::emitOptimizationRemarkAnalysisFPCommute(LLVMContext &Ctx,
                                                   const char *PassName,
                                                   const Function &Fn,
                                                   const DebugLoc &DLoc,
                                                   const Twine &Msg) {
  Ctx.diagnose(DiagnosticInfoOptimizationRemarkAnalysisFPCommute(PassName, Fn,
                                                                 DLoc, Msg));
}

void llvm::emitOptimizationRemarkAnalysisAliasing(LLVMContext &Ctx,
                                                  const char *PassName,
                                                  const Function &Fn,
                                                  const DebugLoc &DLoc,
                                                  const Twine &Msg) {
  Ctx.diagnose(DiagnosticInfoOptimizationRemarkAnalysisAliasing(PassName, Fn,
                                                                DLoc, Msg));
}

bool DiagnosticInfoOptimizationFailure::isEnabled() const {
  // Only print warnings.
  return getSeverity() == DS_Warning;
}

void DiagnosticInfoUnsupported::print(DiagnosticPrinter &DP) const {
  std::string Str;
  raw_string_ostream OS(Str);

  OS << getLocationStr() << ": in function " << getFunction().getName() << ' '
     << *getFunction().getFunctionType() << ": " << Msg << '\n';
  OS.flush();
  DP << Str;
}

void llvm::emitLoopVectorizeWarning(LLVMContext &Ctx, const Function &Fn,
                                    const DebugLoc &DLoc, const Twine &Msg) {
  Ctx.diagnose(DiagnosticInfoOptimizationFailure(
      Fn, DLoc, Twine("loop not vectorized: " + Msg)));
}

void llvm::emitLoopInterleaveWarning(LLVMContext &Ctx, const Function &Fn,
                                     const DebugLoc &DLoc, const Twine &Msg) {
  Ctx.diagnose(DiagnosticInfoOptimizationFailure(
      Fn, DLoc, Twine("loop not interleaved: " + Msg)));
}

void DiagnosticInfoISelFallback::print(DiagnosticPrinter &DP) const {
  DP << "Instruction selection used fallback path for " << getFunction();
}
