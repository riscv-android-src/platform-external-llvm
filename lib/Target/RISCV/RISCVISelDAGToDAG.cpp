//===-- RISCVISelDAGToDAG.cpp - A dag to dag inst selector for RISCV ------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines an instruction selector for the RISCV target.
//
//===----------------------------------------------------------------------===//

#include "RISCV.h"
#include "MCTargetDesc/RISCVMCTargetDesc.h"
#include "RISCVTargetMachine.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "riscv-isel"

// RISCV-specific code to select RISCV machine instructions for
// SelectionDAG operations.
namespace {
class RISCVDAGToDAGISel final : public SelectionDAGISel {
public:
  explicit RISCVDAGToDAGISel(RISCVTargetMachine &TargetMachine)
      : SelectionDAGISel(TargetMachine) {}

  StringRef getPassName() const override {
    return "RISCV DAG->DAG Pattern Instruction Selection";
  }

  void Select(SDNode *Node) override;

// Include the pieces autogenerated from the target description.
#include "RISCVGenDAGISel.inc"
};
}

void RISCVDAGToDAGISel::Select(SDNode *Node) {
  // Dump information about the Node being selected.
  DEBUG(dbgs() << "Selecting: "; Node->dump(CurDAG); dbgs() << "\n");

  // If we have a custom node, we have already selected
  if (Node->isMachineOpcode()) {
    DEBUG(dbgs() << "== "; Node->dump(CurDAG); dbgs() << "\n");
    Node->setNodeId(-1);
    return;
  }

  // Select the default instruction.
  SelectCode(Node);
}

// This pass converts a legalized DAG into a RISCV-specific DAG, ready
// for instruction scheduling.
FunctionPass *llvm::createRISCVISelDag(RISCVTargetMachine &TM) {
  return new RISCVDAGToDAGISel(TM);
}
