//===--------------------- InstructionInfoView.cpp -------------------*- C++
//-*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
///
/// This file implements the InstructionView API.
///
//===----------------------------------------------------------------------===//

#include "InstructionInfoView.h"

namespace mca {

using namespace llvm;

void InstructionInfoView::printView(raw_ostream &OS) const {
  std::string Buffer;
  raw_string_ostream TempStream(Buffer);
  const MCSchedModel &SM = STI.getSchedModel();
  unsigned Instructions = Source.size();

  std::string Instruction;
  raw_string_ostream InstrStream(Instruction);

  TempStream << "\n\nInstruction Info:\n";
  TempStream << "[1]: #uOps\n[2]: Latency\n[3]: RThroughput\n"
             << "[4]: MayLoad\n[5]: MayStore\n[6]: HasSideEffects\n\n";

  TempStream << "[1]    [2]    [3]    [4]    [5]    [6]    Instructions:\n";
  for (unsigned I = 0, E = Instructions; I < E; ++I) {
    const MCInst &Inst = Source.getMCInstFromIndex(I);
    const MCInstrDesc &MCDesc = MCII.get(Inst.getOpcode());
    const MCSchedClassDesc &SCDesc =
        *SM.getSchedClassDesc(MCDesc.getSchedClass());

    unsigned NumMicroOpcodes = SCDesc.NumMicroOps;
    unsigned Latency = MCSchedModel::computeInstrLatency(STI, SCDesc);
    Optional<double> RThroughput =
        MCSchedModel::getReciprocalThroughput(STI, SCDesc);

    TempStream << ' ' << NumMicroOpcodes << "    ";
    if (NumMicroOpcodes < 10)
      TempStream << "  ";
    else if (NumMicroOpcodes < 100)
      TempStream << ' ';
    TempStream << Latency << "   ";
    if (Latency < 10)
      TempStream << "  ";
    else if (Latency < 100)
      TempStream << ' ';

    if (RThroughput.hasValue()) {
      double RT = RThroughput.getValue();
      TempStream << format("%.2f", RT) << ' ';
      if (RT < 10.0)
        TempStream << "  ";
      else if (RT < 100.0)
        TempStream << ' ';
    } else {
      TempStream << " -     ";
    }
    TempStream << (MCDesc.mayLoad() ? " *     " : "       ");
    TempStream << (MCDesc.mayStore() ? " *     " : "       ");
    TempStream << (MCDesc.hasUnmodeledSideEffects() ? " * " : "   ");

    MCIP.printInst(&Inst, InstrStream, "", STI);
    InstrStream.flush();

    // Consume any tabs or spaces at the beginning of the string.
    StringRef Str(Instruction);
    Str = Str.ltrim();
    TempStream << "    " << Str << '\n';
    Instruction = "";
  }

  TempStream.flush();
  OS << Buffer;
}
} // namespace mca.
