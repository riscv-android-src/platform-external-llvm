//===- ARMInstructionSelector.cpp ----------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the InstructionSelector class for ARM.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "ARMInstructionSelector.h"
#include "ARMRegisterBankInfo.h"
#include "ARMSubtarget.h"
#include "ARMTargetMachine.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "arm-isel"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

ARMInstructionSelector::ARMInstructionSelector(const ARMSubtarget &STI,
                                               const ARMRegisterBankInfo &RBI)
    : InstructionSelector(), TII(*STI.getInstrInfo()),
      TRI(*STI.getRegisterInfo()) {}

bool ARMInstructionSelector::select(llvm::MachineInstr &I) const {
  return !isPreISelGenericOpcode(I.getOpcode());
}
