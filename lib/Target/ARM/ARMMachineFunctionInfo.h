//===-- ARMMachineFunctionInfo.h - ARM machine function info ----*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares ARM-specific per-machine-function information.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_ARM_ARMMACHINEFUNCTIONINFO_H
#define LLVM_LIB_TARGET_ARM_ARMMACHINEFUNCTIONINFO_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/Support/ErrorHandling.h"
#include <utility>

namespace llvm {

/// ARMFunctionInfo - This class is derived from MachineFunctionInfo and
/// contains private ARM-specific information for each MachineFunction.
class ARMFunctionInfo : public MachineFunctionInfo {
  virtual void anchor();

  /// isThumb - True if this function is compiled under Thumb mode.
  /// Used to initialized Align, so must precede it.
  bool isThumb = false;

  /// hasThumb2 - True if the target architecture supports Thumb2. Do not use
  /// to determine if function is compiled under Thumb mode, for that use
  /// 'isThumb'.
  bool hasThumb2 = false;

  /// StByValParamsPadding - For parameter that is split between
  /// GPRs and memory; while recovering GPRs part, when
  /// StackAlignment > 4, and GPRs-part-size mod StackAlignment != 0,
  /// we need to insert gap before parameter start address. It allows to
  /// "attach" GPR-part to the part that was passed via stack.
  unsigned StByValParamsPadding = 0;

  /// VarArgsRegSaveSize - Size of the register save area for vararg functions.
  ///
  unsigned ArgRegsSaveSize = 0;

  /// ReturnRegsCount - Number of registers used up in the return.
  unsigned ReturnRegsCount = 0;

  /// HasStackFrame - True if this function has a stack frame. Set by
  /// determineCalleeSaves().
  bool HasStackFrame = false;

  /// RestoreSPFromFP - True if epilogue should restore SP from FP. Set by
  /// emitPrologue.
  bool RestoreSPFromFP = false;

  /// LRSpilledForFarJump - True if the LR register has been for spilled to
  /// enable far jump.
  bool LRSpilledForFarJump = false;

  /// FramePtrSpillOffset - If HasStackFrame, this records the frame pointer
  /// spill stack offset.
  unsigned FramePtrSpillOffset = 0;

  /// GPRCS1Offset, GPRCS2Offset, DPRCSOffset - Starting offset of callee saved
  /// register spills areas. For Mac OS X:
  ///
  /// GPR callee-saved (1) : r4, r5, r6, r7, lr
  /// --------------------------------------------
  /// GPR callee-saved (2) : r8, r10, r11
  /// --------------------------------------------
  /// DPR callee-saved : d8 - d15
  ///
  /// Also see AlignedDPRCSRegs below. Not all D-regs need to go in area 3.
  /// Some may be spilled after the stack has been realigned.
  unsigned GPRCS1Offset = 0;
  unsigned GPRCS2Offset = 0;
  unsigned DPRCSOffset = 0;

  /// GPRCS1Size, GPRCS2Size, DPRCSSize - Sizes of callee saved register spills
  /// areas.
  unsigned GPRCS1Size = 0;
  unsigned GPRCS2Size = 0;
  unsigned DPRCSAlignGapSize = 0;
  unsigned DPRCSSize = 0;

  /// NumAlignedDPRCS2Regs - The number of callee-saved DPRs that are saved in
  /// the aligned portion of the stack frame.  This is always a contiguous
  /// sequence of D-registers starting from d8.
  ///
  /// We do not keep track of the frame indices used for these registers - they
  /// behave like any other frame index in the aligned stack frame.  These
  /// registers also aren't included in DPRCSSize above.
  unsigned NumAlignedDPRCS2Regs = 0;

  unsigned PICLabelUId = 0;

  /// VarArgsFrameIndex - FrameIndex for start of varargs area.
  int VarArgsFrameIndex = 0;

  /// HasITBlocks - True if IT blocks have been inserted.
  bool HasITBlocks = false;

  /// CPEClones - Track constant pool entries clones created by Constant Island
  /// pass.
  DenseMap<unsigned, unsigned> CPEClones;

  /// ArgumentStackSize - amount of bytes on stack consumed by the arguments
  /// being passed on the stack
  unsigned ArgumentStackSize = 0;

  /// CoalescedWeights - mapping of basic blocks to the rolling counter of
  /// coalesced weights.
  DenseMap<const MachineBasicBlock*, unsigned> CoalescedWeights;

  /// True if this function has a subset of CSRs that is handled explicitly via
  /// copies.
  bool IsSplitCSR = false;

  /// Globals that have had their storage promoted into the constant pool.
  SmallPtrSet<const GlobalVariable*,2> PromotedGlobals;

  /// The amount the literal pool has been increasedby due to promoted globals.
  int PromotedGlobalsIncrease = 0;
  
public:
  ARMFunctionInfo() = default;

  explicit ARMFunctionInfo(MachineFunction &MF);

  bool isThumbFunction() const { return isThumb; }
  bool isThumb1OnlyFunction() const { return isThumb && !hasThumb2; }
  bool isThumb2Function() const { return isThumb && hasThumb2; }

  unsigned getStoredByValParamsPadding() const { return StByValParamsPadding; }
  void setStoredByValParamsPadding(unsigned p) { StByValParamsPadding = p; }

  unsigned getArgRegsSaveSize() const { return ArgRegsSaveSize; }
  void setArgRegsSaveSize(unsigned s) { ArgRegsSaveSize = s; }

  unsigned getReturnRegsCount() const { return ReturnRegsCount; }
  void setReturnRegsCount(unsigned s) { ReturnRegsCount = s; }

  bool hasStackFrame() const { return HasStackFrame; }
  void setHasStackFrame(bool s) { HasStackFrame = s; }

  bool shouldRestoreSPFromFP() const { return RestoreSPFromFP; }
  void setShouldRestoreSPFromFP(bool s) { RestoreSPFromFP = s; }

  bool isLRSpilledForFarJump() const { return LRSpilledForFarJump; }
  void setLRIsSpilledForFarJump(bool s) { LRSpilledForFarJump = s; }

  unsigned getFramePtrSpillOffset() const { return FramePtrSpillOffset; }
  void setFramePtrSpillOffset(unsigned o) { FramePtrSpillOffset = o; }

  unsigned getNumAlignedDPRCS2Regs() const { return NumAlignedDPRCS2Regs; }
  void setNumAlignedDPRCS2Regs(unsigned n) { NumAlignedDPRCS2Regs = n; }

  unsigned getGPRCalleeSavedArea1Offset() const { return GPRCS1Offset; }
  unsigned getGPRCalleeSavedArea2Offset() const { return GPRCS2Offset; }
  unsigned getDPRCalleeSavedAreaOffset()  const { return DPRCSOffset; }

  void setGPRCalleeSavedArea1Offset(unsigned o) { GPRCS1Offset = o; }
  void setGPRCalleeSavedArea2Offset(unsigned o) { GPRCS2Offset = o; }
  void setDPRCalleeSavedAreaOffset(unsigned o)  { DPRCSOffset = o; }

  unsigned getGPRCalleeSavedArea1Size() const { return GPRCS1Size; }
  unsigned getGPRCalleeSavedArea2Size() const { return GPRCS2Size; }
  unsigned getDPRCalleeSavedGapSize() const   { return DPRCSAlignGapSize; }
  unsigned getDPRCalleeSavedAreaSize()  const { return DPRCSSize; }

  void setGPRCalleeSavedArea1Size(unsigned s) { GPRCS1Size = s; }
  void setGPRCalleeSavedArea2Size(unsigned s) { GPRCS2Size = s; }
  void setDPRCalleeSavedGapSize(unsigned s)   { DPRCSAlignGapSize = s; }
  void setDPRCalleeSavedAreaSize(unsigned s)  { DPRCSSize = s; }

  unsigned getArgumentStackSize() const { return ArgumentStackSize; }
  void setArgumentStackSize(unsigned size) { ArgumentStackSize = size; }

  void initPICLabelUId(unsigned UId) {
    PICLabelUId = UId;
  }

  unsigned getNumPICLabels() const {
    return PICLabelUId;
  }

  unsigned createPICLabelUId() {
    return PICLabelUId++;
  }

  int getVarArgsFrameIndex() const { return VarArgsFrameIndex; }
  void setVarArgsFrameIndex(int Index) { VarArgsFrameIndex = Index; }

  bool hasITBlocks() const { return HasITBlocks; }
  void setHasITBlocks(bool h) { HasITBlocks = h; }

  bool isSplitCSR() const { return IsSplitCSR; }
  void setIsSplitCSR(bool s) { IsSplitCSR = s; }

  void recordCPEClone(unsigned CPIdx, unsigned CPCloneIdx) {
    if (!CPEClones.insert(std::make_pair(CPCloneIdx, CPIdx)).second)
      llvm_unreachable("Duplicate entries!");
  }

  unsigned getOriginalCPIdx(unsigned CloneIdx) const {
    DenseMap<unsigned, unsigned>::const_iterator I = CPEClones.find(CloneIdx);
    if (I != CPEClones.end())
      return I->second;
    else
      return -1U;
  }

  DenseMap<const MachineBasicBlock*, unsigned>::iterator getCoalescedWeight(
                                                  MachineBasicBlock* MBB) {
    auto It = CoalescedWeights.find(MBB);
    if (It == CoalescedWeights.end()) {
      It = CoalescedWeights.insert(std::make_pair(MBB, 0)).first;
    }
    return It;
  }

  /// Indicate to the backend that \c GV has had its storage changed to inside
  /// a constant pool. This means it no longer needs to be emitted as a
  /// global variable.
  void markGlobalAsPromotedToConstantPool(const GlobalVariable *GV) {
    PromotedGlobals.insert(GV);
  }
  SmallPtrSet<const GlobalVariable*, 2>& getGlobalsPromotedToConstantPool() {
    return PromotedGlobals;
  }
  int getPromotedConstpoolIncrease() const {
    return PromotedGlobalsIncrease;
  }
  void setPromotedConstpoolIncrease(int Sz) {
    PromotedGlobalsIncrease = Sz;
  }
};

} // end namespace llvm

#endif // LLVM_LIB_TARGET_ARM_ARMMACHINEFUNCTIONINFO_H
