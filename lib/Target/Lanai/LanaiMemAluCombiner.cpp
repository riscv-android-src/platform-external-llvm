//===-- LanaiMemAluCombiner.cpp - Pass to combine memory & ALU operations -===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// Simple pass to combine memory and ALU operations
//
// The Lanai ISA supports instructions where a load/store modifies the base
// register used in the load/store operation. This pass finds suitable
// load/store and ALU instructions and combines them into one instruction.
//
// For example,
//   ld [ %r6 -- ], %r12
// is a supported instruction that is not currently generated by the instruction
// selection pass of this backend. This pass generates these instructions by
// merging
//   add %r6, -4, %r6
// followed by
//   ld [ %r6 ], %r12
// in the same machine basic block into one machine instruction.
//===----------------------------------------------------------------------===//

#include "Lanai.h"
#include "LanaiTargetMachine.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/Support/CommandLine.h"
using namespace llvm;

#define GET_INSTRMAP_INFO
#include "LanaiGenInstrInfo.inc"

#define DEBUG_TYPE "lanai-mem-alu-combiner"

STATISTIC(NumLdStAluCombined, "Number of memory and ALU instructions combined");

static llvm::cl::opt<bool> DisableMemAluCombiner(
    "disable-lanai-mem-alu-combiner", llvm::cl::init(false),
    llvm::cl::desc("Do not combine ALU and memory operators"),
    llvm::cl::Hidden);

namespace llvm {
void initializeLanaiMemAluCombinerPass(PassRegistry &);
} // namespace llvm

namespace {
typedef MachineBasicBlock::iterator MbbIterator;
typedef MachineFunction::iterator MfIterator;

class LanaiMemAluCombiner : public MachineFunctionPass {
public:
  static char ID;
  explicit LanaiMemAluCombiner() : MachineFunctionPass(ID) {
    initializeLanaiMemAluCombinerPass(*PassRegistry::getPassRegistry());
  }

  StringRef getPassName() const override {
    return "Lanai load / store optimization pass";
  }

  bool runOnMachineFunction(MachineFunction &F) override;

  MachineFunctionProperties getRequiredProperties() const override {
    return MachineFunctionProperties().set(
        MachineFunctionProperties::Property::NoVRegs);
  }

private:
  MbbIterator findClosestSuitableAluInstr(MachineBasicBlock *BB,
                                          const MbbIterator &MemInstr,
                                          bool Decrement);
  void insertMergedInstruction(MachineBasicBlock *BB,
                               const MbbIterator &MemInstr,
                               const MbbIterator &AluInstr, bool Before);
  bool combineMemAluInBasicBlock(MachineBasicBlock *BB);

  // Target machine description which we query for register names, data
  // layout, etc.
  const TargetInstrInfo *TII;
};
} // namespace

char LanaiMemAluCombiner::ID = 0;

INITIALIZE_PASS(LanaiMemAluCombiner, DEBUG_TYPE,
                "Lanai memory ALU combiner pass", false, false)

namespace {
bool isSpls(uint16_t Opcode) { return Lanai::splsIdempotent(Opcode) == Opcode; }

// Determine the opcode for the merged instruction created by considering the
// old memory operation's opcode and whether the merged opcode will have an
// immediate offset.
unsigned mergedOpcode(unsigned OldOpcode, bool ImmediateOffset) {
  switch (OldOpcode) {
  case Lanai::LDW_RI:
  case Lanai::LDW_RR:
    if (ImmediateOffset)
      return Lanai::LDW_RI;
    return Lanai::LDW_RR;
  case Lanai::LDHs_RI:
  case Lanai::LDHs_RR:
    if (ImmediateOffset)
      return Lanai::LDHs_RI;
    return Lanai::LDHs_RR;
  case Lanai::LDHz_RI:
  case Lanai::LDHz_RR:
    if (ImmediateOffset)
      return Lanai::LDHz_RI;
    return Lanai::LDHz_RR;
  case Lanai::LDBs_RI:
  case Lanai::LDBs_RR:
    if (ImmediateOffset)
      return Lanai::LDBs_RI;
    return Lanai::LDBs_RR;
  case Lanai::LDBz_RI:
  case Lanai::LDBz_RR:
    if (ImmediateOffset)
      return Lanai::LDBz_RI;
    return Lanai::LDBz_RR;
  case Lanai::SW_RI:
  case Lanai::SW_RR:
    if (ImmediateOffset)
      return Lanai::SW_RI;
    return Lanai::SW_RR;
  case Lanai::STB_RI:
  case Lanai::STB_RR:
    if (ImmediateOffset)
      return Lanai::STB_RI;
    return Lanai::STB_RR;
  case Lanai::STH_RI:
  case Lanai::STH_RR:
    if (ImmediateOffset)
      return Lanai::STH_RI;
    return Lanai::STH_RR;
  default:
    return 0;
  }
}

// Check if the machine instruction has non-volatile memory operands of the type
// supported for combining with ALU instructions.
bool isNonVolatileMemoryOp(const MachineInstr &MI) {
  if (!MI.hasOneMemOperand())
    return false;

  // Determine if the machine instruction is a supported memory operation by
  // testing if the computed merge opcode is a valid memory operation opcode.
  if (mergedOpcode(MI.getOpcode(), false) == 0)
    return false;

  const MachineMemOperand *MemOperand = *MI.memoperands_begin();

  // Don't move volatile memory accesses
  if (MemOperand->isVolatile())
    return false;

  return true;
}

// Test to see if two machine operands are of the same type. This test is less
// strict than the MachineOperand::isIdenticalTo function.
bool isSameOperand(const MachineOperand &Op1, const MachineOperand &Op2) {
  if (Op1.getType() != Op2.getType())
    return false;

  switch (Op1.getType()) {
  case MachineOperand::MO_Register:
    return Op1.getReg() == Op2.getReg();
  case MachineOperand::MO_Immediate:
    return Op1.getImm() == Op2.getImm();
  default:
    return false;
  }
}

bool isZeroOperand(const MachineOperand &Op) {
  return ((Op.isReg() && Op.getReg() == Lanai::R0) ||
          (Op.isImm() && Op.getImm() == 0));
}

// Determines whether a register is used by an instruction.
bool InstrUsesReg(const MbbIterator &Instr, const MachineOperand *Reg) {
  for (MachineInstr::const_mop_iterator Mop = Instr->operands_begin();
       Mop != Instr->operands_end(); ++Mop) {
    if (isSameOperand(*Mop, *Reg))
      return true;
  }
  return false;
}

// Converts between machine opcode and AluCode.
// Flag using/modifying ALU operations should not be considered for merging and
// are omitted from this list.
LPAC::AluCode mergedAluCode(unsigned AluOpcode) {
  switch (AluOpcode) {
  case Lanai::ADD_I_LO:
  case Lanai::ADD_R:
    return LPAC::ADD;
  case Lanai::SUB_I_LO:
  case Lanai::SUB_R:
    return LPAC::SUB;
  case Lanai::AND_I_LO:
  case Lanai::AND_R:
    return LPAC::AND;
  case Lanai::OR_I_LO:
  case Lanai::OR_R:
    return LPAC::OR;
  case Lanai::XOR_I_LO:
  case Lanai::XOR_R:
    return LPAC::XOR;
  case Lanai::SHL_R:
    return LPAC::SHL;
  case Lanai::SRL_R:
    return LPAC::SRL;
  case Lanai::SRA_R:
    return LPAC::SRA;
  case Lanai::SA_I:
  case Lanai::SL_I:
  default:
    return LPAC::UNKNOWN;
  }
}

// Insert a new combined memory and ALU operation instruction.
//
// This function builds a new machine instruction using the MachineInstrBuilder
// class and inserts it before the memory instruction.
void LanaiMemAluCombiner::insertMergedInstruction(MachineBasicBlock *BB,
                                                  const MbbIterator &MemInstr,
                                                  const MbbIterator &AluInstr,
                                                  bool Before) {
  // Insert new combined load/store + alu operation
  MachineOperand Dest = MemInstr->getOperand(0);
  MachineOperand Base = MemInstr->getOperand(1);
  MachineOperand MemOffset = MemInstr->getOperand(2);
  MachineOperand AluOffset = AluInstr->getOperand(2);

  // Abort if ALU offset is not a register or immediate
  assert((AluOffset.isReg() || AluOffset.isImm()) &&
         "Unsupported operand type in merge");

  // Determined merged instructions opcode and ALU code
  LPAC::AluCode AluOpcode = mergedAluCode(AluInstr->getOpcode());
  unsigned NewOpc = mergedOpcode(MemInstr->getOpcode(), AluOffset.isImm());

  assert(AluOpcode != LPAC::UNKNOWN && "Unknown ALU code in merging");
  assert(NewOpc != 0 && "Unknown merged node opcode");

  // Build and insert new machine instruction
  MachineInstrBuilder InstrBuilder =
      BuildMI(*BB, MemInstr, MemInstr->getDebugLoc(), TII->get(NewOpc));
  InstrBuilder.addReg(Dest.getReg(), getDefRegState(true));
  InstrBuilder.addReg(Base.getReg(), getKillRegState(true));

  // Add offset to machine instruction
  if (AluOffset.isReg())
    InstrBuilder.addReg(AluOffset.getReg());
  else if (AluOffset.isImm())
    InstrBuilder.addImm(AluOffset.getImm());
  else
    llvm_unreachable("Unsupported ld/st ALU merge.");

  // Create a pre-op if the ALU operation preceded the memory operation or the
  // MemOffset is non-zero (i.e. the memory value should be adjusted before
  // accessing it), else create a post-op.
  if (Before || !isZeroOperand(MemOffset))
    InstrBuilder.addImm(LPAC::makePreOp(AluOpcode));
  else
    InstrBuilder.addImm(LPAC::makePostOp(AluOpcode));

  // Transfer memory operands.
  InstrBuilder.setMemRefs(MemInstr->memoperands());
}

// Function determines if ALU operation (in alu_iter) can be combined with
// a load/store with base and offset.
bool isSuitableAluInstr(bool IsSpls, const MbbIterator &AluIter,
                        const MachineOperand &Base,
                        const MachineOperand &Offset) {
  // ALU operations have 3 operands
  if (AluIter->getNumOperands() != 3)
    return false;

  MachineOperand &Dest = AluIter->getOperand(0);
  MachineOperand &Op1 = AluIter->getOperand(1);
  MachineOperand &Op2 = AluIter->getOperand(2);

  // Only match instructions using the base register as destination and with the
  // base and first operand equal
  if (!isSameOperand(Dest, Base) || !isSameOperand(Dest, Op1))
    return false;

  if (Op2.isImm()) {
    // It is not a match if the 2nd operand in the ALU operation is an
    // immediate but the ALU operation is not an addition.
    if (AluIter->getOpcode() != Lanai::ADD_I_LO)
      return false;

    if (Offset.isReg() && Offset.getReg() == Lanai::R0)
      return true;

    if (Offset.isImm() &&
        ((Offset.getImm() == 0 &&
          // Check that the Op2 would fit in the immediate field of the
          // memory operation.
          ((IsSpls && isInt<10>(Op2.getImm())) ||
           (!IsSpls && isInt<16>(Op2.getImm())))) ||
         Offset.getImm() == Op2.getImm()))
      return true;
  } else if (Op2.isReg()) {
    // The Offset and 2nd operand are both registers and equal
    if (Offset.isReg() && Op2.getReg() == Offset.getReg())
      return true;
  } else
    // Only consider operations with register or immediate values
    return false;

  return false;
}

MbbIterator LanaiMemAluCombiner::findClosestSuitableAluInstr(
    MachineBasicBlock *BB, const MbbIterator &MemInstr, const bool Decrement) {
  MachineOperand *Base = &MemInstr->getOperand(1);
  MachineOperand *Offset = &MemInstr->getOperand(2);
  bool IsSpls = isSpls(MemInstr->getOpcode());

  MbbIterator First = MemInstr;
  MbbIterator Last = Decrement ? BB->begin() : BB->end();

  while (First != Last) {
    Decrement ? --First : ++First;

    if (First == Last)
      break;

    // Skip over debug instructions
    if (First->isDebugInstr())
      continue;

    if (isSuitableAluInstr(IsSpls, First, *Base, *Offset)) {
      return First;
    }

    // Usage of the base or offset register is not a form suitable for merging.
    if (First != Last) {
      if (InstrUsesReg(First, Base))
        break;
      if (Offset->isReg() && InstrUsesReg(First, Offset))
        break;
    }
  }

  return MemInstr;
}

bool LanaiMemAluCombiner::combineMemAluInBasicBlock(MachineBasicBlock *BB) {
  bool Modified = false;

  MbbIterator MBBIter = BB->begin(), End = BB->end();
  while (MBBIter != End) {
    bool IsMemOp = isNonVolatileMemoryOp(*MBBIter);

    if (IsMemOp) {
      MachineOperand AluOperand = MBBIter->getOperand(3);
      unsigned int DestReg = MBBIter->getOperand(0).getReg(),
                   BaseReg = MBBIter->getOperand(1).getReg();
      assert(AluOperand.isImm() && "Unexpected memory operator type");
      LPAC::AluCode AluOpcode = static_cast<LPAC::AluCode>(AluOperand.getImm());

      // Skip memory operations that already modify the base register or if
      // the destination and base register are the same
      if (!LPAC::modifiesOp(AluOpcode) && DestReg != BaseReg) {
        for (int Inc = 0; Inc <= 1; ++Inc) {
          MbbIterator AluIter =
              findClosestSuitableAluInstr(BB, MBBIter, Inc == 0);
          if (AluIter != MBBIter) {
            insertMergedInstruction(BB, MBBIter, AluIter, Inc == 0);

            ++NumLdStAluCombined;
            Modified = true;

            // Erase the matching ALU instruction
            BB->erase(AluIter);
            // Erase old load/store instruction
            BB->erase(MBBIter++);
            break;
          }
        }
      }
    }
    if (MBBIter == End)
      break;
    ++MBBIter;
  }

  return Modified;
}

// Driver function that iterates over the machine basic building blocks of a
// machine function
bool LanaiMemAluCombiner::runOnMachineFunction(MachineFunction &MF) {
  if (DisableMemAluCombiner)
    return false;

  TII = MF.getSubtarget<LanaiSubtarget>().getInstrInfo();
  bool Modified = false;
  for (MfIterator MFI = MF.begin(); MFI != MF.end(); ++MFI) {
    Modified |= combineMemAluInBasicBlock(&*MFI);
  }
  return Modified;
}
} // namespace

FunctionPass *llvm::createLanaiMemAluCombinerPass() {
  return new LanaiMemAluCombiner();
}
