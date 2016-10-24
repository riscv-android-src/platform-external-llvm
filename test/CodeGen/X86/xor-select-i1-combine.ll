; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;RUN: llc < %s -O2 -mattr=+avx512f -mtriple=x86_64-unknown | FileCheck %s

@n = common global i32 0, align 4
@m = common global i32 0, align 4

define i32 @main(i8 %small) {
; CHECK-LABEL: main:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movl $n, %eax
; CHECK-NEXT:    movl $m, %ecx
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    cmovneq %rax, %rcx
; CHECK-NEXT:    movl (%rcx), %eax
; CHECK-NEXT:    retq
entry:
  %0 = and i8 %small, 1
  %cmp = icmp eq i8 %0, 0
  %m.n = select i1 %cmp, i32* @m, i32* @n
  %retval = load volatile i32, i32* %m.n, align 4
  ret i32 %retval
}


define i32 @main2(i8 %small) {
; CHECK-LABEL: main2:
; CHECK:       # BB#0: # %entry
; CHECK-NEXT:    movl $m, %eax
; CHECK-NEXT:    movl $n, %ecx
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    cmovneq %rax, %rcx
; CHECK-NEXT:    movl (%rcx), %eax
; CHECK-NEXT:    retq
entry:
  %0 = and i8 %small, 1
  %cmp = icmp eq i8 %0, 1
  %m.n = select i1 %cmp, i32* @m, i32* @n
  %retval = load volatile i32, i32* %m.n, align 4
  ret i32 %retval
}
