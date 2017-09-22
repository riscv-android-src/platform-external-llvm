; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

; Make sure dagcombine doesn't eliminate the comparison due
; to an off-by-one bug with computeKnownBits information.

declare void @qux()

define void @foo(i32 %a) {
; CHECK-LABEL: foo:
; CHECK:       # BB#0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:  .Lcfi0:
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shrl $23, %eax
; CHECK-NEXT:    testb $1, %ah
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  # BB#1: # %true
; CHECK-NEXT:    callq qux
; CHECK-NEXT:  .LBB0_2: # %false
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
  %t0 = lshr i32 %a, 23
  br label %next
next:
  %t1 = and i32 %t0, 256
  %t2 = icmp eq i32 %t1, 0
  br i1 %t2, label %true, label %false
true:
  call void @qux()
  ret void
false:
  ret void
}

