//===-- AMDGPUInstPrinter.h - AMDGPU MC Inst -> ASM interface ---*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
/// \file
//===----------------------------------------------------------------------===//

#ifndef AMDGPUINSTPRINTER_H
#define AMDGPUINSTPRINTER_H

#include "llvm/ADT/StringRef.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/Support/raw_ostream.h"

namespace llvm {

class AMDGPUInstPrinter : public MCInstPrinter {
public:
  AMDGPUInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                     const MCRegisterInfo &MRI)
    : MCInstPrinter(MAI, MII, MRI) {}

  //Autogenerated by tblgen
  void printInstruction(const MCInst *MI, raw_ostream &O);
  static const char *getRegisterName(unsigned RegNo);

  virtual void printInst(const MCInst *MI, raw_ostream &O, StringRef Annot);

private:
  static void printRegOperand(unsigned RegNo, raw_ostream &O);
  static void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printInterpSlot(const MCInst *MI, unsigned OpNum, raw_ostream &O);
  static void printMemOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printIfSet(const MCInst *MI, unsigned OpNo, raw_ostream &O,
                         StringRef Asm, StringRef Default = "");
  static void printAbs(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printClamp(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printLiteral(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printLast(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printNeg(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printOMOD(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printRel(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printUpdateExecMask(const MCInst *MI, unsigned OpNo,
                                  raw_ostream &O);
  static void printUpdatePred(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printWrite(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printSel(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printBankSwizzle(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printRSel(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printCT(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printKCache(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printSendMsg(const MCInst *MI, unsigned OpNo, raw_ostream &O);
  static void printWaitFlag(const MCInst *MI, unsigned OpNo, raw_ostream &O);
};

} // End namespace llvm

#endif // AMDGPUINSTRPRINTER_H
