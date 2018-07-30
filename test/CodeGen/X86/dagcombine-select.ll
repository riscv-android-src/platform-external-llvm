; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK,NOBMI -enable-var-scope
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -verify-machineinstrs -mattr=+bmi | FileCheck %s -check-prefixes=CHECK,BMI -enable-var-scope

define i32 @select_and1(i32 %x, i32 %y) {
; CHECK-LABEL: select_and1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpl $11, %edi
; CHECK-NEXT:    cmovgel %esi, %eax
; CHECK-NEXT:    retq
  %c = icmp slt i32 %x, 11
  %s = select i1 %c, i32 0, i32 -1
  %a = and i32 %y, %s
  ret i32 %a
}

define i32 @select_and2(i32 %x, i32 %y) {
; CHECK-LABEL: select_and2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpl $11, %edi
; CHECK-NEXT:    cmovgel %esi, %eax
; CHECK-NEXT:    retq
  %c = icmp slt i32 %x, 11
  %s = select i1 %c, i32 0, i32 -1
  %a = and i32 %s, %y
  ret i32 %a
}

define i32 @select_and3(i32 %x, i32 %y) {
; CHECK-LABEL: select_and3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpl $11, %edi
; CHECK-NEXT:    cmovll %esi, %eax
; CHECK-NEXT:    retq
  %c = icmp slt i32 %x, 11
  %s = select i1 %c, i32 -1, i32 0
  %a = and i32 %y, %s
  ret i32 %a
}

define <4 x i32> @select_and_v4(i32 %x, <4 x i32> %y) {
; CHECK-LABEL: select_and_v4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpl $11, %edi
; CHECK-NEXT:    xorps %xmm1, %xmm1
; CHECK-NEXT:    jl .LBB3_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movaps %xmm0, %xmm1
; CHECK-NEXT:  .LBB3_2:
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %c = icmp slt i32 %x, 11
  %s = select i1 %c, <4 x i32> zeroinitializer, <4 x i32><i32 -1, i32 -1, i32 -1, i32 -1>
  %a = and <4 x i32> %s, %y
  ret <4 x i32> %a
}

define i32 @select_or1(i32 %x, i32 %y) {
; CHECK-LABEL: select_or1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpl $11, %edi
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    cmovll %esi, %eax
; CHECK-NEXT:    retq
  %c = icmp slt i32 %x, 11
  %s = select i1 %c, i32 0, i32 -1
  %a = or i32 %y, %s
  ret i32 %a
}

define i32 @select_or2(i32 %x, i32 %y) {
; CHECK-LABEL: select_or2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpl $11, %edi
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    cmovll %esi, %eax
; CHECK-NEXT:    retq
  %c = icmp slt i32 %x, 11
  %s = select i1 %c, i32 0, i32 -1
  %a = or i32 %s, %y
  ret i32 %a
}

define i32 @select_or3(i32 %x, i32 %y) {
; CHECK-LABEL: select_or3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpl $11, %edi
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    cmovgel %esi, %eax
; CHECK-NEXT:    retq
  %c = icmp slt i32 %x, 11
  %s = select i1 %c, i32 -1, i32 0
  %a = or i32 %y, %s
  ret i32 %a
}

define <4 x i32> @select_or_v4(i32 %x, <4 x i32> %y) {
; CHECK-LABEL: select_or_v4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpl $11, %edi
; CHECK-NEXT:    jl .LBB7_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    pcmpeqd %xmm0, %xmm0
; CHECK-NEXT:  .LBB7_2:
; CHECK-NEXT:    retq
  %c = icmp slt i32 %x, 11
  %s = select i1 %c, <4 x i32> zeroinitializer, <4 x i32><i32 -1, i32 -1, i32 -1, i32 -1>
  %a = or <4 x i32> %s, %y
  ret <4 x i32> %a
}

define i32 @sel_constants_sub_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: sel_constants_sub_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    movl $9, %ecx
; CHECK-NEXT:    movl $2, %eax
; CHECK-NEXT:    cmovnel %ecx, %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 -4, i32 3
  %bo = sub i32 5, %sel
  ret i32 %bo
}

define i32 @sdiv_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: sdiv_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    notb %dil
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    leal (%rax,%rax,4), %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 121, i32 23
  %bo = sdiv i32 120, %sel
  ret i32 %bo
}

define i32 @udiv_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: udiv_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    notb %dil
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    leal (%rax,%rax,4), %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 -4, i32 23
  %bo = udiv i32 120, %sel
  ret i32 %bo
}

define i32 @srem_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: srem_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    movl $120, %ecx
; CHECK-NEXT:    movl $5, %eax
; CHECK-NEXT:    cmovnel %ecx, %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 121, i32 23
  %bo = srem i32 120, %sel
  ret i32 %bo
}

define i32 @urem_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: urem_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    movl $120, %ecx
; CHECK-NEXT:    movl $5, %eax
; CHECK-NEXT:    cmovnel %ecx, %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 -4, i32 23
  %bo = urem i32 120, %sel
  ret i32 %bo
}

define i32 @sel_constants_shl_constant(i1 %cond) {
; CHECK-LABEL: sel_constants_shl_constant:
; CHECK:       # %bb.0:
; CHECK-NEXT:    notb %dil
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    andl $1, %eax
; CHECK-NEXT:    orl $2, %eax
; CHECK-NEXT:    shll $8, %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 2, i32 3
  %bo = shl i32 %sel, 8
  ret i32 %bo
}

define i32 @shl_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: shl_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andb $1, %dil
; CHECK-NEXT:    xorb $3, %dil
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    shll %cl, %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 2, i32 3
  %bo = shl i32 1, %sel
  ret i32 %bo
}

define i32 @lshr_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: lshr_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andb $1, %dil
; CHECK-NEXT:    xorb $3, %dil
; CHECK-NEXT:    movl $64, %eax
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    shrl %cl, %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 2, i32 3
  %bo = lshr i32 64, %sel
  ret i32 %bo
}

define i32 @ashr_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: ashr_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andb $1, %dil
; CHECK-NEXT:    xorb $3, %dil
; CHECK-NEXT:    movl $128, %eax
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    shrl %cl, %eax
; CHECK-NEXT:    retq
  %sel = select i1 %cond, i32 2, i32 3
  %bo = ashr i32 128, %sel
  ret i32 %bo
}

define double @fsub_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: fsub_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    jne .LBB17_1
; CHECK-NEXT:  # %bb.2:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB17_1:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retq
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = fsub double 5.1, %sel
  ret double %bo
}

define double @fdiv_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: fdiv_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    jne .LBB18_1
; CHECK-NEXT:  # %bb.2:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB18_1:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retq
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = fdiv double 5.1, %sel
  ret double %bo
}

define double @frem_constant_sel_constants(i1 %cond) {
; CHECK-LABEL: frem_constant_sel_constants:
; CHECK:       # %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    jne .LBB19_1
; CHECK-NEXT:  # %bb.2:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB19_1:
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retq
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = frem double 5.1, %sel
  ret double %bo
}

declare i64 @llvm.cttz.i64(i64, i1)
define i64 @cttz_64_eq_select(i64 %v) nounwind {
; NOBMI-LABEL: cttz_64_eq_select:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    bsfq %rdi, %rcx
; NOBMI-NEXT:    movq $-1, %rax
; NOBMI-NEXT:    cmovneq %rcx, %rax
; NOBMI-NEXT:    addq $6, %rax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: cttz_64_eq_select:
; BMI:       # %bb.0:
; BMI-NEXT:    tzcntq %rdi, %rcx
; BMI-NEXT:    movq $-1, %rax
; BMI-NEXT:    cmovaeq %rcx, %rax
; BMI-NEXT:    addq $6, %rax
; BMI-NEXT:    retq

  %cnt = tail call i64 @llvm.cttz.i64(i64 %v, i1 true)
  %tobool = icmp eq i64 %v, 0
  %.op = add nuw nsw i64 %cnt, 6
  %add = select i1 %tobool, i64 5, i64 %.op
  ret i64 %add
}

define i64 @cttz_64_ne_select(i64 %v) nounwind {
; NOBMI-LABEL: cttz_64_ne_select:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    bsfq %rdi, %rcx
; NOBMI-NEXT:    movq $-1, %rax
; NOBMI-NEXT:    cmovneq %rcx, %rax
; NOBMI-NEXT:    addq $6, %rax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: cttz_64_ne_select:
; BMI:       # %bb.0:
; BMI-NEXT:    tzcntq %rdi, %rcx
; BMI-NEXT:    movq $-1, %rax
; BMI-NEXT:    cmovaeq %rcx, %rax
; BMI-NEXT:    addq $6, %rax
; BMI-NEXT:    retq

  %cnt = tail call i64 @llvm.cttz.i64(i64 %v, i1 true)
  %tobool = icmp ne i64 %v, 0
  %.op = add nuw nsw i64 %cnt, 6
  %add = select i1 %tobool, i64 %.op, i64 5
  ret i64 %add
}

declare i32 @llvm.cttz.i32(i32, i1)
define i32 @cttz_32_eq_select(i32 %v) nounwind {
; NOBMI-LABEL: cttz_32_eq_select:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    bsfl %edi, %ecx
; NOBMI-NEXT:    movl $-1, %eax
; NOBMI-NEXT:    cmovnel %ecx, %eax
; NOBMI-NEXT:    addl $6, %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: cttz_32_eq_select:
; BMI:       # %bb.0:
; BMI-NEXT:    tzcntl %edi, %ecx
; BMI-NEXT:    movl $-1, %eax
; BMI-NEXT:    cmovael %ecx, %eax
; BMI-NEXT:    addl $6, %eax
; BMI-NEXT:    retq

  %cnt = tail call i32 @llvm.cttz.i32(i32 %v, i1 true)
  %tobool = icmp eq i32 %v, 0
  %.op = add nuw nsw i32 %cnt, 6
  %add = select i1 %tobool, i32 5, i32 %.op
  ret i32 %add
}

define i32 @cttz_32_ne_select(i32 %v) nounwind {
; NOBMI-LABEL: cttz_32_ne_select:
; NOBMI:       # %bb.0:
; NOBMI-NEXT:    bsfl %edi, %ecx
; NOBMI-NEXT:    movl $-1, %eax
; NOBMI-NEXT:    cmovnel %ecx, %eax
; NOBMI-NEXT:    addl $6, %eax
; NOBMI-NEXT:    retq
;
; BMI-LABEL: cttz_32_ne_select:
; BMI:       # %bb.0:
; BMI-NEXT:    tzcntl %edi, %ecx
; BMI-NEXT:    movl $-1, %eax
; BMI-NEXT:    cmovael %ecx, %eax
; BMI-NEXT:    addl $6, %eax
; BMI-NEXT:    retq

  %cnt = tail call i32 @llvm.cttz.i32(i32 %v, i1 true)
  %tobool = icmp ne i32 %v, 0
  %.op = add nuw nsw i32 %cnt, 6
  %add = select i1 %tobool, i32 %.op, i32 5
  ret i32 %add
}
