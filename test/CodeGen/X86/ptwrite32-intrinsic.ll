; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+ptwrite | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+ptwrite | FileCheck %s --check-prefix=X86_64

define void @test_ptwrite(i32 %value) {
; X86-LABEL: test_ptwrite:
; X86:       # %bb.0: # %entry
; X86-NEXT:    ptwritel {{[0-9]+}}(%esp)
; X86-NEXT:    retl
;
; X86_64-LABEL: test_ptwrite:
; X86_64:       # %bb.0: # %entry
; X86_64-NEXT:    ptwritel %edi
; X86_64-NEXT:    retq
entry:
  call void @llvm.x86.ptwrite32(i32 %value)
  ret void
}

define void @test_ptwrite2(i32 %x) {
; X86-LABEL: test_ptwrite2:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    incl %eax
; X86-NEXT:    ptwritel %eax
; X86-NEXT:    retl
;
; X86_64-LABEL: test_ptwrite2:
; X86_64:       # %bb.0: # %entry
; X86_64-NEXT:    incl %edi
; X86_64-NEXT:    ptwritel %edi
; X86_64-NEXT:    retq
entry:
  %value = add i32 %x, 1
  call void @llvm.x86.ptwrite32(i32 %value)
  ret void
}

define void @test_ptwrite32p(i32* %pointer) {
; X86-LABEL: test_ptwrite32p:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    ptwritel (%eax)
; X86-NEXT:    retl
;
; X86_64-LABEL: test_ptwrite32p:
; X86_64:       # %bb.0: # %entry
; X86_64-NEXT:    ptwritel (%rdi)
; X86_64-NEXT:    retq
entry:
  %value = load i32, i32* %pointer, align 4
  call void @llvm.x86.ptwrite32(i32 %value)
  ret void
}

declare void @llvm.x86.ptwrite32(i32)
