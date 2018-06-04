; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+sse4a -show-mc-encoding | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+sse4a,+avx -show-mc-encoding | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4a -show-mc-encoding | FileCheck %s --check-prefixes=X64
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4a,+avx -show-mc-encoding | FileCheck %s --check-prefixes=X64

define void @test_movntss(i8* %p, <4 x float> %a) nounwind optsize ssp {
; X86-LABEL: test_movntss:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    movntss %xmm0, (%eax) # encoding: [0xf3,0x0f,0x2b,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_movntss:
; X64:       # %bb.0:
; X64-NEXT:    movntss %xmm0, (%rdi) # encoding: [0xf3,0x0f,0x2b,0x07]
; X64-NEXT:    retq # encoding: [0xc3]
  tail call void @llvm.x86.sse4a.movnt.ss(i8* %p, <4 x float> %a) nounwind
  ret void
}

declare void @llvm.x86.sse4a.movnt.ss(i8*, <4 x float>)

define void @test_movntsd(i8* %p, <2 x double> %a) nounwind optsize ssp {
; X86-LABEL: test_movntsd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x04]
; X86-NEXT:    movntsd %xmm0, (%eax) # encoding: [0xf2,0x0f,0x2b,0x00]
; X86-NEXT:    retl # encoding: [0xc3]
;
; X64-LABEL: test_movntsd:
; X64:       # %bb.0:
; X64-NEXT:    movntsd %xmm0, (%rdi) # encoding: [0xf2,0x0f,0x2b,0x07]
; X64-NEXT:    retq # encoding: [0xc3]
  tail call void @llvm.x86.sse4a.movnt.sd(i8* %p, <2 x double> %a) nounwind
  ret void
}

declare void @llvm.x86.sse4a.movnt.sd(i8*, <2 x double>)
