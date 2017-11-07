; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin10 -mcpu=generic | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-apple-darwin10 -mcpu=atom    | FileCheck %s --check-prefix=CHECK --check-prefix=ATOM
; RUN: llc < %s -mtriple=i386-intel-elfiamcu                 | FileCheck %s --check-prefix=MCU

; PR5757
%0 = type { i64, i32 }

define i32 @test1(%0* %p, %0* %q, i1 %r) nounwind {
; CHECK-LABEL: test1:
; CHECK:       ## BB#0:
; CHECK-NEXT:    addq $8, %rdi
; CHECK-NEXT:    addq $8, %rsi
; CHECK-NEXT:    testb $1, %dl
; CHECK-NEXT:    cmovneq %rdi, %rsi
; CHECK-NEXT:    movl (%rsi), %eax
; CHECK-NEXT:    retq
;
; MCU-LABEL: test1:
; MCU:       # BB#0:
; MCU-NEXT:    testb $1, %cl
; MCU-NEXT:    jne .LBB0_1
; MCU-NEXT:  # BB#2:
; MCU-NEXT:    addl $8, %edx
; MCU-NEXT:    movl %edx, %eax
; MCU-NEXT:    movl (%eax), %eax
; MCU-NEXT:    retl
; MCU-NEXT:  .LBB0_1:
; MCU-NEXT:    addl $8, %eax
; MCU-NEXT:    movl (%eax), %eax
; MCU-NEXT:    retl
  %t0 = load %0, %0* %p
  %t1 = load %0, %0* %q
  %t4 = select i1 %r, %0 %t0, %0 %t1
  %t5 = extractvalue %0 %t4, 1
  ret i32 %t5
}

; PR2139
define i32 @test2() nounwind {
; GENERIC-LABEL: test2:
; GENERIC:       ## BB#0: ## %entry
; GENERIC-NEXT:    pushq %rax
; GENERIC-NEXT:    callq _return_false
; GENERIC-NEXT:    xorl %ecx, %ecx
; GENERIC-NEXT:    testb $1, %al
; GENERIC-NEXT:    movl $-480, %eax ## imm = 0xFE20
; GENERIC-NEXT:    cmovnel %ecx, %eax
; GENERIC-NEXT:    shll $3, %eax
; GENERIC-NEXT:    cmpl $32768, %eax ## imm = 0x8000
; GENERIC-NEXT:    jge LBB1_1
; GENERIC-NEXT:  ## BB#2: ## %bb91
; GENERIC-NEXT:    xorl %eax, %eax
; GENERIC-NEXT:    popq %rcx
; GENERIC-NEXT:    retq
; GENERIC-NEXT:  LBB1_1: ## %bb90
;
; ATOM-LABEL: test2:
; ATOM:       ## BB#0: ## %entry
; ATOM-NEXT:    pushq %rax
; ATOM-NEXT:    callq _return_false
; ATOM-NEXT:    xorl %ecx, %ecx
; ATOM-NEXT:    movl $-480, %edx ## imm = 0xFE20
; ATOM-NEXT:    testb $1, %al
; ATOM-NEXT:    cmovnel %ecx, %edx
; ATOM-NEXT:    shll $3, %edx
; ATOM-NEXT:    cmpl $32768, %edx ## imm = 0x8000
; ATOM-NEXT:    jge LBB1_1
; ATOM-NEXT:  ## BB#2: ## %bb91
; ATOM-NEXT:    xorl %eax, %eax
; ATOM-NEXT:    popq %rcx
; ATOM-NEXT:    retq
; ATOM-NEXT:  LBB1_1: ## %bb90
;
; MCU-LABEL: test2:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    calll return_false
; MCU-NEXT:    xorl %ecx, %ecx
; MCU-NEXT:    testb $1, %al
; MCU-NEXT:    jne .LBB1_2
; MCU-NEXT:  # BB#1: # %entry
; MCU-NEXT:    movl $-480, %ecx # imm = 0xFE20
; MCU-NEXT:  .LBB1_2: # %entry
; MCU-NEXT:    shll $3, %ecx
; MCU-NEXT:    cmpl $32768, %ecx # imm = 0x8000
; MCU-NEXT:    jge .LBB1_3
; MCU-NEXT:  # BB#4: # %bb91
; MCU-NEXT:    xorl %eax, %eax
; MCU-NEXT:    retl
; MCU-NEXT:  .LBB1_3: # %bb90
entry:
  %tmp73 = tail call i1 @return_false()
  %g.0 = select i1 %tmp73, i16 0, i16 -480
  %tmp7778 = sext i16 %g.0 to i32
  %tmp80 = shl i32 %tmp7778, 3
  %tmp87 = icmp sgt i32 %tmp80, 32767
  br i1 %tmp87, label %bb90, label %bb91
bb90:
  unreachable
bb91:
  ret i32 0
}

declare i1 @return_false()

;; Select between two floating point constants.
define float @test3(i32 %x) nounwind readnone {
; CHECK-LABEL: test3:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    sete %al
; CHECK-NEXT:    leaq {{.*}}(%rip), %rcx
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    retq
;
; MCU-LABEL: test3:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    xorl %ecx, %ecx
; MCU-NEXT:    testl %eax, %eax
; MCU-NEXT:    sete %cl
; MCU-NEXT:    flds {{\.LCPI.*}}(,%ecx,4)
; MCU-NEXT:    retl
entry:
  %0 = icmp eq i32 %x, 0
  %iftmp.0.0 = select i1 %0, float 4.200000e+01, float 2.300000e+01
  ret float %iftmp.0.0
}

define signext i8 @test4(i8* nocapture %P, double %F) nounwind readonly {
; CHECK-LABEL: test4:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    ucomisd %xmm0, %xmm1
; CHECK-NEXT:    seta %al
; CHECK-NEXT:    movsbl (%rdi,%rax,4), %eax
; CHECK-NEXT:    retq
;
; MCU-LABEL: test4:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    movl %eax, %ecx
; MCU-NEXT:    fldl {{[0-9]+}}(%esp)
; MCU-NEXT:    flds {{\.LCPI.*}}
; MCU-NEXT:    fucompp
; MCU-NEXT:    fnstsw %ax
; MCU-NEXT:    xorl %edx, %edx
; MCU-NEXT:    # kill: %AH<def> %AH<kill> %AX<kill>
; MCU-NEXT:    sahf
; MCU-NEXT:    seta %dl
; MCU-NEXT:    movb (%ecx,%edx,4), %al
; MCU-NEXT:    retl
entry:
  %0 = fcmp olt double %F, 4.200000e+01
  %iftmp.0.0 = select i1 %0, i32 4, i32 0
  %1 = getelementptr i8, i8* %P, i32 %iftmp.0.0
  %2 = load i8, i8* %1, align 1
  ret i8 %2
}

define void @test5(i1 %c, <2 x i16> %a, <2 x i16> %b, <2 x i16>* %p) nounwind {
; CHECK-LABEL: test5:
; CHECK:       ## BB#0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    jne LBB4_2
; CHECK-NEXT:  ## BB#1:
; CHECK-NEXT:    movdqa %xmm1, %xmm0
; CHECK-NEXT:  LBB4_2:
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,2,2,3,4,5,6,7]
; CHECK-NEXT:    movd %xmm0, (%rsi)
; CHECK-NEXT:    retq
;
; MCU-LABEL: test5:
; MCU:       # BB#0:
; MCU-NEXT:    pushl %esi
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %esi
; MCU-NEXT:    testb $1, %al
; MCU-NEXT:    jne .LBB4_2
; MCU-NEXT:  # BB#1:
; MCU-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; MCU-NEXT:    movzwl {{[0-9]+}}(%esp), %edx
; MCU-NEXT:  .LBB4_2:
; MCU-NEXT:    movw %cx, 2(%esi)
; MCU-NEXT:    movw %dx, (%esi)
; MCU-NEXT:    popl %esi
; MCU-NEXT:    retl
  %x = select i1 %c, <2 x i16> %a, <2 x i16> %b
  store <2 x i16> %x, <2 x i16>* %p
  ret void
}

; Verify that the fmul gets sunk into the one part of the diamond where it is needed.
define void @test6(i32 %C, <4 x float>* %A, <4 x float>* %B) nounwind {
; CHECK-LABEL: test6:
; CHECK:       ## BB#0:
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    je LBB5_1
; CHECK-NEXT:  ## BB#2:
; CHECK-NEXT:    movaps (%rsi), %xmm0
; CHECK-NEXT:    movaps %xmm0, (%rsi)
; CHECK-NEXT:    retq
; CHECK-NEXT:  LBB5_1:
; CHECK-NEXT:    movaps (%rdx), %xmm0
; CHECK-NEXT:    mulps %xmm0, %xmm0
; CHECK-NEXT:    movaps %xmm0, (%rsi)
; CHECK-NEXT:    retq
;
; MCU-LABEL: test6:
; MCU:       # BB#0:
; MCU-NEXT:    pushl %eax
; MCU-NEXT:    flds 12(%edx)
; MCU-NEXT:    fstps (%esp) # 4-byte Folded Spill
; MCU-NEXT:    flds 8(%edx)
; MCU-NEXT:    flds 4(%edx)
; MCU-NEXT:    flds (%ecx)
; MCU-NEXT:    flds 4(%ecx)
; MCU-NEXT:    flds 8(%ecx)
; MCU-NEXT:    flds 12(%ecx)
; MCU-NEXT:    fmul %st(0), %st(0)
; MCU-NEXT:    fxch %st(1)
; MCU-NEXT:    fmul %st(0), %st(0)
; MCU-NEXT:    fxch %st(2)
; MCU-NEXT:    fmul %st(0), %st(0)
; MCU-NEXT:    fxch %st(3)
; MCU-NEXT:    fmul %st(0), %st(0)
; MCU-NEXT:    testl %eax, %eax
; MCU-NEXT:    flds (%edx)
; MCU-NEXT:    je .LBB5_2
; MCU-NEXT:  # BB#1:
; MCU-NEXT:    fstp %st(1)
; MCU-NEXT:    fstp %st(3)
; MCU-NEXT:    fstp %st(1)
; MCU-NEXT:    fstp %st(0)
; MCU-NEXT:    flds (%esp) # 4-byte Folded Reload
; MCU-NEXT:    fldz
; MCU-NEXT:    fldz
; MCU-NEXT:    fldz
; MCU-NEXT:    fxch %st(1)
; MCU-NEXT:    fxch %st(6)
; MCU-NEXT:    fxch %st(1)
; MCU-NEXT:    fxch %st(5)
; MCU-NEXT:    fxch %st(4)
; MCU-NEXT:    fxch %st(1)
; MCU-NEXT:    fxch %st(3)
; MCU-NEXT:    fxch %st(2)
; MCU-NEXT:  .LBB5_2:
; MCU-NEXT:    fstp %st(0)
; MCU-NEXT:    fstp %st(5)
; MCU-NEXT:    fstp %st(3)
; MCU-NEXT:    fxch %st(2)
; MCU-NEXT:    fstps 12(%edx)
; MCU-NEXT:    fxch %st(1)
; MCU-NEXT:    fstps 8(%edx)
; MCU-NEXT:    fstps 4(%edx)
; MCU-NEXT:    fstps (%edx)
; MCU-NEXT:    popl %eax
; MCU-NEXT:    retl
  %tmp = load <4 x float>, <4 x float>* %A
  %tmp3 = load <4 x float>, <4 x float>* %B
  %tmp9 = fmul <4 x float> %tmp3, %tmp3
  %tmp.upgrd.1 = icmp eq i32 %C, 0
  %iftmp.38.0 = select i1 %tmp.upgrd.1, <4 x float> %tmp9, <4 x float> %tmp
  store <4 x float> %iftmp.38.0, <4 x float>* %A
  ret void
}

; Select with fp80's
define x86_fp80 @test7(i32 %tmp8) nounwind {
; CHECK-LABEL: test7:
; CHECK:       ## BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    setns %al
; CHECK-NEXT:    shlq $4, %rax
; CHECK-NEXT:    leaq {{.*}}(%rip), %rcx
; CHECK-NEXT:    fldt (%rax,%rcx)
; CHECK-NEXT:    retq
;
; MCU-LABEL: test7:
; MCU:       # BB#0:
; MCU-NEXT:    xorl %ecx, %ecx
; MCU-NEXT:    testl %eax, %eax
; MCU-NEXT:    setns %cl
; MCU-NEXT:    shll $4, %ecx
; MCU-NEXT:    fldt {{\.LCPI.*}}(%ecx)
; MCU-NEXT:    retl
  %tmp9 = icmp sgt i32 %tmp8, -1
  %retval = select i1 %tmp9, x86_fp80 0xK4005B400000000000000, x86_fp80 0xK40078700000000000000
  ret x86_fp80 %retval
}

; widening select v6i32 and then a sub
define void @test8(i1 %c, <6 x i32>* %dst.addr, <6 x i32> %src1,<6 x i32> %src2) nounwind {
; GENERIC-LABEL: test8:
; GENERIC:       ## BB#0:
; GENERIC-NEXT:    testb $1, %dil
; GENERIC-NEXT:    jne LBB7_1
; GENERIC-NEXT:  ## BB#2:
; GENERIC-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; GENERIC-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; GENERIC-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; GENERIC-NEXT:    movd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; GENERIC-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; GENERIC-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; GENERIC-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; GENERIC-NEXT:    movd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; GENERIC-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; GENERIC-NEXT:    jmp LBB7_3
; GENERIC-NEXT:  LBB7_1:
; GENERIC-NEXT:    movd %r9d, %xmm0
; GENERIC-NEXT:    movd %r8d, %xmm1
; GENERIC-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; GENERIC-NEXT:    movd %ecx, %xmm2
; GENERIC-NEXT:    movd %edx, %xmm0
; GENERIC-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; GENERIC-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; GENERIC-NEXT:    movd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; GENERIC-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; GENERIC-NEXT:  LBB7_3:
; GENERIC-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm2[0],xmm1[1],xmm2[1]
; GENERIC-NEXT:    pcmpeqd %xmm2, %xmm2
; GENERIC-NEXT:    paddd %xmm2, %xmm0
; GENERIC-NEXT:    paddd %xmm2, %xmm1
; GENERIC-NEXT:    movq %xmm1, 16(%rsi)
; GENERIC-NEXT:    movdqa %xmm0, (%rsi)
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test8:
; ATOM:       ## BB#0:
; ATOM-NEXT:    testb $1, %dil
; ATOM-NEXT:    jne LBB7_1
; ATOM-NEXT:  ## BB#2:
; ATOM-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; ATOM-NEXT:    movd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; ATOM-NEXT:    movd {{.*#+}} xmm3 = mem[0],zero,zero,zero
; ATOM-NEXT:    movd {{.*#+}} xmm4 = mem[0],zero,zero,zero
; ATOM-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; ATOM-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; ATOM-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; ATOM-NEXT:    jmp LBB7_3
; ATOM-NEXT:  LBB7_1:
; ATOM-NEXT:    movd %r9d, %xmm0
; ATOM-NEXT:    movd %r8d, %xmm2
; ATOM-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1]
; ATOM-NEXT:    movd %ecx, %xmm3
; ATOM-NEXT:    movd %edx, %xmm0
; ATOM-NEXT:    movd {{.*#+}} xmm4 = mem[0],zero,zero,zero
; ATOM-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; ATOM-NEXT:  LBB7_3:
; ATOM-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1]
; ATOM-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm2[0]
; ATOM-NEXT:    pcmpeqd %xmm2, %xmm2
; ATOM-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm4[0],xmm1[1],xmm4[1]
; ATOM-NEXT:    paddd %xmm2, %xmm0
; ATOM-NEXT:    paddd %xmm2, %xmm1
; ATOM-NEXT:    movdqa %xmm0, (%rsi)
; ATOM-NEXT:    movq %xmm1, 16(%rsi)
; ATOM-NEXT:    retq
;
; MCU-LABEL: test8:
; MCU:       # BB#0:
; MCU-NEXT:    pushl %ebp
; MCU-NEXT:    pushl %ebx
; MCU-NEXT:    pushl %edi
; MCU-NEXT:    pushl %esi
; MCU-NEXT:    testb $1, %al
; MCU-NEXT:    jne .LBB7_1
; MCU-NEXT:  # BB#2:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %eax
; MCU-NEXT:    movl (%eax), %eax
; MCU-NEXT:    je .LBB7_5
; MCU-NEXT:  .LBB7_4:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %ecx
; MCU-NEXT:    movl (%ecx), %ecx
; MCU-NEXT:    je .LBB7_8
; MCU-NEXT:  .LBB7_7:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %esi
; MCU-NEXT:    movl (%esi), %esi
; MCU-NEXT:    je .LBB7_11
; MCU-NEXT:  .LBB7_10:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %edi
; MCU-NEXT:    movl (%edi), %edi
; MCU-NEXT:    je .LBB7_14
; MCU-NEXT:  .LBB7_13:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %ebx
; MCU-NEXT:    movl (%ebx), %ebx
; MCU-NEXT:    je .LBB7_17
; MCU-NEXT:  .LBB7_16:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %ebp
; MCU-NEXT:    jmp .LBB7_18
; MCU-NEXT:  .LBB7_1:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %eax
; MCU-NEXT:    movl (%eax), %eax
; MCU-NEXT:    jne .LBB7_4
; MCU-NEXT:  .LBB7_5:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %ecx
; MCU-NEXT:    movl (%ecx), %ecx
; MCU-NEXT:    jne .LBB7_7
; MCU-NEXT:  .LBB7_8:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %esi
; MCU-NEXT:    movl (%esi), %esi
; MCU-NEXT:    jne .LBB7_10
; MCU-NEXT:  .LBB7_11:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %edi
; MCU-NEXT:    movl (%edi), %edi
; MCU-NEXT:    jne .LBB7_13
; MCU-NEXT:  .LBB7_14:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %ebx
; MCU-NEXT:    movl (%ebx), %ebx
; MCU-NEXT:    jne .LBB7_16
; MCU-NEXT:  .LBB7_17:
; MCU-NEXT:    leal {{[0-9]+}}(%esp), %ebp
; MCU-NEXT:  .LBB7_18:
; MCU-NEXT:    movl (%ebp), %ebp
; MCU-NEXT:    decl %ebp
; MCU-NEXT:    decl %ebx
; MCU-NEXT:    decl %edi
; MCU-NEXT:    decl %esi
; MCU-NEXT:    decl %ecx
; MCU-NEXT:    decl %eax
; MCU-NEXT:    movl %eax, 20(%edx)
; MCU-NEXT:    movl %ecx, 16(%edx)
; MCU-NEXT:    movl %esi, 12(%edx)
; MCU-NEXT:    movl %edi, 8(%edx)
; MCU-NEXT:    movl %ebx, 4(%edx)
; MCU-NEXT:    movl %ebp, (%edx)
; MCU-NEXT:    popl %esi
; MCU-NEXT:    popl %edi
; MCU-NEXT:    popl %ebx
; MCU-NEXT:    popl %ebp
; MCU-NEXT:    retl
  %x = select i1 %c, <6 x i32> %src1, <6 x i32> %src2
  %val = sub <6 x i32> %x, < i32 1, i32 1, i32 1, i32 1, i32 1, i32 1 >
  store <6 x i32> %val, <6 x i32>* %dst.addr
  ret void
}


;; Test integer select between values and constants.

define i64 @test9(i64 %x, i64 %y) nounwind readnone ssp noredzone {
; GENERIC-LABEL: test9:
; GENERIC:       ## BB#0:
; GENERIC-NEXT:    cmpq $1, %rdi
; GENERIC-NEXT:    sbbq %rax, %rax
; GENERIC-NEXT:    orq %rsi, %rax
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test9:
; ATOM:       ## BB#0:
; ATOM-NEXT:    cmpq $1, %rdi
; ATOM-NEXT:    sbbq %rax, %rax
; ATOM-NEXT:    orq %rsi, %rax
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
;
; MCU-LABEL: test9:
; MCU:       # BB#0:
; MCU-NEXT:    orl %edx, %eax
; MCU-NEXT:    jne .LBB8_1
; MCU-NEXT:  # BB#2:
; MCU-NEXT:    movl $-1, %eax
; MCU-NEXT:    movl $-1, %edx
; MCU-NEXT:    retl
; MCU-NEXT:  .LBB8_1:
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %eax
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %edx
; MCU-NEXT:    retl
  %cmp = icmp ne i64 %x, 0
  %cond = select i1 %cmp, i64 %y, i64 -1
  ret i64 %cond
}

;; Same as test9
define i64 @test9a(i64 %x, i64 %y) nounwind readnone ssp noredzone {
; GENERIC-LABEL: test9a:
; GENERIC:       ## BB#0:
; GENERIC-NEXT:    cmpq $1, %rdi
; GENERIC-NEXT:    sbbq %rax, %rax
; GENERIC-NEXT:    orq %rsi, %rax
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test9a:
; ATOM:       ## BB#0:
; ATOM-NEXT:    cmpq $1, %rdi
; ATOM-NEXT:    sbbq %rax, %rax
; ATOM-NEXT:    orq %rsi, %rax
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
;
; MCU-LABEL: test9a:
; MCU:       # BB#0:
; MCU-NEXT:    orl %edx, %eax
; MCU-NEXT:    movl $-1, %eax
; MCU-NEXT:    movl $-1, %edx
; MCU-NEXT:    je .LBB9_2
; MCU-NEXT:  # BB#1:
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %eax
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %edx
; MCU-NEXT:  .LBB9_2:
; MCU-NEXT:    retl
  %cmp = icmp eq i64 %x, 0
  %cond = select i1 %cmp, i64 -1, i64 %y
  ret i64 %cond
}

define i64 @test9b(i64 %x, i64 %y) nounwind readnone ssp noredzone {
; GENERIC-LABEL: test9b:
; GENERIC:       ## BB#0:
; GENERIC-NEXT:    cmpq $1, %rdi
; GENERIC-NEXT:    sbbq %rax, %rax
; GENERIC-NEXT:    orq %rsi, %rax
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test9b:
; ATOM:       ## BB#0:
; ATOM-NEXT:    cmpq $1, %rdi
; ATOM-NEXT:    sbbq %rax, %rax
; ATOM-NEXT:    orq %rsi, %rax
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
;
; MCU-LABEL: test9b:
; MCU:       # BB#0:
; MCU-NEXT:    movl %edx, %ecx
; MCU-NEXT:    xorl %edx, %edx
; MCU-NEXT:    orl %ecx, %eax
; MCU-NEXT:    sete %dl
; MCU-NEXT:    negl %edx
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %eax
; MCU-NEXT:    orl %edx, %eax
; MCU-NEXT:    orl {{[0-9]+}}(%esp), %edx
; MCU-NEXT:    retl
  %cmp = icmp eq i64 %x, 0
  %A = sext i1 %cmp to i64
  %cond = or i64 %y, %A
  ret i64 %cond
}

;; Select between -1 and 1.
define i64 @test10(i64 %x, i64 %y) nounwind readnone ssp noredzone {
; CHECK-LABEL: test10:
; CHECK:       ## BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testq %rdi, %rdi
; CHECK-NEXT:    setne %al
; CHECK-NEXT:    leaq -1(%rax,%rax), %rax
; CHECK-NEXT:    retq
;
; MCU-LABEL: test10:
; MCU:       # BB#0:
; MCU-NEXT:    orl %edx, %eax
; MCU-NEXT:    movl $-1, %eax
; MCU-NEXT:    movl $-1, %edx
; MCU-NEXT:    je .LBB11_2
; MCU-NEXT:  # BB#1:
; MCU-NEXT:    xorl %edx, %edx
; MCU-NEXT:    movl $1, %eax
; MCU-NEXT:  .LBB11_2:
; MCU-NEXT:    retl
  %cmp = icmp eq i64 %x, 0
  %cond = select i1 %cmp, i64 -1, i64 1
  ret i64 %cond
}

define i64 @test11(i64 %x, i64 %y) nounwind readnone ssp noredzone {
; CHECK-LABEL: test11:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq $1, %rdi
; CHECK-NEXT:    sbbq %rax, %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    orq %rsi, %rax
; CHECK-NEXT:    retq
;
; MCU-LABEL: test11:
; MCU:       # BB#0:
; MCU-NEXT:    orl %edx, %eax
; MCU-NEXT:    je .LBB12_1
; MCU-NEXT:  # BB#2:
; MCU-NEXT:    movl $-1, %eax
; MCU-NEXT:    movl $-1, %edx
; MCU-NEXT:    retl
; MCU-NEXT:  .LBB12_1:
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %eax
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %edx
; MCU-NEXT:    retl
  %cmp = icmp eq i64 %x, 0
  %cond = select i1 %cmp, i64 %y, i64 -1
  ret i64 %cond
}

define i64 @test11a(i64 %x, i64 %y) nounwind readnone ssp noredzone {
; CHECK-LABEL: test11a:
; CHECK:       ## BB#0:
; CHECK-NEXT:    cmpq $1, %rdi
; CHECK-NEXT:    sbbq %rax, %rax
; CHECK-NEXT:    notq %rax
; CHECK-NEXT:    orq %rsi, %rax
; CHECK-NEXT:    retq
;
; MCU-LABEL: test11a:
; MCU:       # BB#0:
; MCU-NEXT:    orl %edx, %eax
; MCU-NEXT:    movl $-1, %eax
; MCU-NEXT:    movl $-1, %edx
; MCU-NEXT:    jne .LBB13_2
; MCU-NEXT:  # BB#1:
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %eax
; MCU-NEXT:    movl {{[0-9]+}}(%esp), %edx
; MCU-NEXT:  .LBB13_2:
; MCU-NEXT:    retl
  %cmp = icmp ne i64 %x, 0
  %cond = select i1 %cmp, i64 -1, i64 %y
  ret i64 %cond
}


declare noalias i8* @_Znam(i64) noredzone

define noalias i8* @test12(i64 %count) nounwind ssp noredzone {
; GENERIC-LABEL: test12:
; GENERIC:       ## BB#0: ## %entry
; GENERIC-NEXT:    movl $4, %ecx
; GENERIC-NEXT:    movq %rdi, %rax
; GENERIC-NEXT:    mulq %rcx
; GENERIC-NEXT:    movq $-1, %rdi
; GENERIC-NEXT:    cmovnoq %rax, %rdi
; GENERIC-NEXT:    jmp __Znam ## TAILCALL
;
; ATOM-LABEL: test12:
; ATOM:       ## BB#0: ## %entry
; ATOM-NEXT:    movq %rdi, %rax
; ATOM-NEXT:    movl $4, %ecx
; ATOM-NEXT:    mulq %rcx
; ATOM-NEXT:    movq $-1, %rdi
; ATOM-NEXT:    cmovnoq %rax, %rdi
; ATOM-NEXT:    jmp __Znam ## TAILCALL
;
; MCU-LABEL: test12:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    pushl %ebp
; MCU-NEXT:    pushl %ebx
; MCU-NEXT:    pushl %edi
; MCU-NEXT:    pushl %esi
; MCU-NEXT:    movl %edx, %ebx
; MCU-NEXT:    movl %eax, %ebp
; MCU-NEXT:    movl $4, %ecx
; MCU-NEXT:    mull %ecx
; MCU-NEXT:    movl %eax, %esi
; MCU-NEXT:    leal (%edx,%ebx,4), %edi
; MCU-NEXT:    movl %edi, %edx
; MCU-NEXT:    pushl $0
; MCU-NEXT:    pushl $4
; MCU-NEXT:    calll __udivdi3
; MCU-NEXT:    addl $8, %esp
; MCU-NEXT:    xorl %ebx, %edx
; MCU-NEXT:    xorl %ebp, %eax
; MCU-NEXT:    orl %edx, %eax
; MCU-NEXT:    movl $-1, %eax
; MCU-NEXT:    movl $-1, %edx
; MCU-NEXT:    jne .LBB14_2
; MCU-NEXT:  # BB#1: # %entry
; MCU-NEXT:    movl %esi, %eax
; MCU-NEXT:    movl %edi, %edx
; MCU-NEXT:  .LBB14_2: # %entry
; MCU-NEXT:    popl %esi
; MCU-NEXT:    popl %edi
; MCU-NEXT:    popl %ebx
; MCU-NEXT:    popl %ebp
; MCU-NEXT:    jmp _Znam # TAILCALL
entry:
  %A = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %count, i64 4)
  %B = extractvalue { i64, i1 } %A, 1
  %C = extractvalue { i64, i1 } %A, 0
  %D = select i1 %B, i64 -1, i64 %C
  %call = tail call noalias i8* @_Znam(i64 %D) nounwind noredzone
  ret i8* %call
}

declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) nounwind readnone

define i32 @test13(i32 %a, i32 %b) nounwind {
; GENERIC-LABEL: test13:
; GENERIC:       ## BB#0:
; GENERIC-NEXT:    cmpl %esi, %edi
; GENERIC-NEXT:    sbbl %eax, %eax
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test13:
; ATOM:       ## BB#0:
; ATOM-NEXT:    cmpl %esi, %edi
; ATOM-NEXT:    sbbl %eax, %eax
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
;
; MCU-LABEL: test13:
; MCU:       # BB#0:
; MCU-NEXT:    cmpl %edx, %eax
; MCU-NEXT:    sbbl %eax, %eax
; MCU-NEXT:    retl
  %c = icmp ult i32 %a, %b
  %d = sext i1 %c to i32
  ret i32 %d
}

define i32 @test14(i32 %a, i32 %b) nounwind {
; CHECK-LABEL: test14:
; CHECK:       ## BB#0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    setae %al
; CHECK-NEXT:    negl %eax
; CHECK-NEXT:    retq
;
; MCU-LABEL: test14:
; MCU:       # BB#0:
; MCU-NEXT:    xorl %ecx, %ecx
; MCU-NEXT:    cmpl %edx, %eax
; MCU-NEXT:    setae %cl
; MCU-NEXT:    negl %ecx
; MCU-NEXT:    movl %ecx, %eax
; MCU-NEXT:    retl
  %c = icmp uge i32 %a, %b
  %d = sext i1 %c to i32
  ret i32 %d
}

; rdar://10961709
define i32 @test15(i32 %x) nounwind {
; GENERIC-LABEL: test15:
; GENERIC:       ## BB#0: ## %entry
; GENERIC-NEXT:    negl %edi
; GENERIC-NEXT:    sbbl %eax, %eax
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test15:
; ATOM:       ## BB#0: ## %entry
; ATOM-NEXT:    negl %edi
; ATOM-NEXT:    sbbl %eax, %eax
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
;
; MCU-LABEL: test15:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    negl %eax
; MCU-NEXT:    sbbl %eax, %eax
; MCU-NEXT:    retl
entry:
  %cmp = icmp ne i32 %x, 0
  %sub = sext i1 %cmp to i32
  ret i32 %sub
}

define i64 @test16(i64 %x) nounwind uwtable readnone ssp {
; GENERIC-LABEL: test16:
; GENERIC:       ## BB#0: ## %entry
; GENERIC-NEXT:    negq %rdi
; GENERIC-NEXT:    sbbq %rax, %rax
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test16:
; ATOM:       ## BB#0: ## %entry
; ATOM-NEXT:    negq %rdi
; ATOM-NEXT:    sbbq %rax, %rax
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
;
; MCU-LABEL: test16:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    movl %eax, %ecx
; MCU-NEXT:    xorl %eax, %eax
; MCU-NEXT:    orl %edx, %ecx
; MCU-NEXT:    setne %al
; MCU-NEXT:    negl %eax
; MCU-NEXT:    movl %eax, %edx
; MCU-NEXT:    retl
entry:
  %cmp = icmp ne i64 %x, 0
  %conv1 = sext i1 %cmp to i64
  ret i64 %conv1
}

define i16 @test17(i16 %x) nounwind {
; GENERIC-LABEL: test17:
; GENERIC:       ## BB#0: ## %entry
; GENERIC-NEXT:    negw %di
; GENERIC-NEXT:    sbbl %eax, %eax
; GENERIC-NEXT:    ## kill: %AX<def> %AX<kill> %EAX<kill>
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test17:
; ATOM:       ## BB#0: ## %entry
; ATOM-NEXT:    negw %di
; ATOM-NEXT:    sbbl %eax, %eax
; ATOM-NEXT:    ## kill: %AX<def> %AX<kill> %EAX<kill>
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
;
; MCU-LABEL: test17:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    negw %ax
; MCU-NEXT:    sbbl %eax, %eax
; MCU-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; MCU-NEXT:    retl
entry:
  %cmp = icmp ne i16 %x, 0
  %sub = sext i1 %cmp to i16
  ret i16 %sub
}

define i8 @test18(i32 %x, i8 zeroext %a, i8 zeroext %b) nounwind {
; GENERIC-LABEL: test18:
; GENERIC:       ## BB#0:
; GENERIC-NEXT:    cmpl $15, %edi
; GENERIC-NEXT:    cmovgel %edx, %esi
; GENERIC-NEXT:    movl %esi, %eax
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: test18:
; ATOM:       ## BB#0:
; ATOM-NEXT:    cmpl $15, %edi
; ATOM-NEXT:    cmovgel %edx, %esi
; ATOM-NEXT:    movl %esi, %eax
; ATOM-NEXT:    nop
; ATOM-NEXT:    nop
; ATOM-NEXT:    retq
;
; MCU-LABEL: test18:
; MCU:       # BB#0:
; MCU-NEXT:    cmpl $15, %eax
; MCU-NEXT:    jl .LBB20_2
; MCU-NEXT:  # BB#1:
; MCU-NEXT:    movl %ecx, %edx
; MCU-NEXT:  .LBB20_2:
; MCU-NEXT:    movl %edx, %eax
; MCU-NEXT:    retl
  %cmp = icmp slt i32 %x, 15
  %sel = select i1 %cmp, i8 %a, i8 %b
  ret i8 %sel
}

define i32 @trunc_select_miscompile(i32 %a, i1 zeroext %cc) {
; CHECK-LABEL: trunc_select_miscompile:
; CHECK:       ## BB#0:
; CHECK-NEXT:    orb $2, %sil
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    shll %cl, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
;
; MCU-LABEL: trunc_select_miscompile:
; MCU:       # BB#0:
; MCU-NEXT:    orb $2, %dl
; MCU-NEXT:    movl %edx, %ecx
; MCU-NEXT:    shll %cl, %eax
; MCU-NEXT:    retl
  %tmp1 = select i1 %cc, i32 3, i32 2
  %tmp2 = shl i32 %a, %tmp1
  ret i32 %tmp2
}

; reproducer for pr29002
define void @clamp_i8(i32 %src, i8* %dst) {
; GENERIC-LABEL: clamp_i8:
; GENERIC:       ## BB#0:
; GENERIC-NEXT:    cmpl $127, %edi
; GENERIC-NEXT:    movl $127, %eax
; GENERIC-NEXT:    cmovlel %edi, %eax
; GENERIC-NEXT:    cmpl $-128, %eax
; GENERIC-NEXT:    movb $-128, %cl
; GENERIC-NEXT:    jl LBB22_2
; GENERIC-NEXT:  ## BB#1:
; GENERIC-NEXT:    movl %eax, %ecx
; GENERIC-NEXT:  LBB22_2:
; GENERIC-NEXT:    movb %cl, (%rsi)
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: clamp_i8:
; ATOM:       ## BB#0:
; ATOM-NEXT:    cmpl $127, %edi
; ATOM-NEXT:    movl $127, %eax
; ATOM-NEXT:    cmovlel %edi, %eax
; ATOM-NEXT:    movb $-128, %cl
; ATOM-NEXT:    cmpl $-128, %eax
; ATOM-NEXT:    jl LBB22_2
; ATOM-NEXT:  ## BB#1:
; ATOM-NEXT:    movl %eax, %ecx
; ATOM-NEXT:  LBB22_2:
; ATOM-NEXT:    movb %cl, (%rsi)
; ATOM-NEXT:    retq
;
; MCU-LABEL: clamp_i8:
; MCU:       # BB#0:
; MCU-NEXT:    cmpl $127, %eax
; MCU-NEXT:    movl $127, %ecx
; MCU-NEXT:    jg .LBB22_2
; MCU-NEXT:  # BB#1:
; MCU-NEXT:    movl %eax, %ecx
; MCU-NEXT:  .LBB22_2:
; MCU-NEXT:    cmpl $-128, %ecx
; MCU-NEXT:    movb $-128, %al
; MCU-NEXT:    jl .LBB22_4
; MCU-NEXT:  # BB#3:
; MCU-NEXT:    movl %ecx, %eax
; MCU-NEXT:  .LBB22_4:
; MCU-NEXT:    movb %al, (%edx)
; MCU-NEXT:    retl
  %cmp = icmp sgt i32 %src, 127
  %sel1 = select i1 %cmp, i32 127, i32 %src
  %cmp1 = icmp slt i32 %sel1, -128
  %sel2 = select i1 %cmp1, i32 -128, i32 %sel1
  %conv = trunc i32 %sel2 to i8
  store i8 %conv, i8* %dst, align 2
  ret void
}

; reproducer for pr29002
define void @clamp(i32 %src, i16* %dst) {
; GENERIC-LABEL: clamp:
; GENERIC:       ## BB#0:
; GENERIC-NEXT:    cmpl $32767, %edi ## imm = 0x7FFF
; GENERIC-NEXT:    movl $32767, %eax ## imm = 0x7FFF
; GENERIC-NEXT:    cmovlel %edi, %eax
; GENERIC-NEXT:    cmpl $-32768, %eax ## imm = 0x8000
; GENERIC-NEXT:    movw $-32768, %cx ## imm = 0x8000
; GENERIC-NEXT:    cmovgew %ax, %cx
; GENERIC-NEXT:    movw %cx, (%rsi)
; GENERIC-NEXT:    retq
;
; ATOM-LABEL: clamp:
; ATOM:       ## BB#0:
; ATOM-NEXT:    cmpl $32767, %edi ## imm = 0x7FFF
; ATOM-NEXT:    movl $32767, %eax ## imm = 0x7FFF
; ATOM-NEXT:    cmovlel %edi, %eax
; ATOM-NEXT:    movw $-32768, %cx ## imm = 0x8000
; ATOM-NEXT:    cmpl $-32768, %eax ## imm = 0x8000
; ATOM-NEXT:    cmovgew %ax, %cx
; ATOM-NEXT:    movw %cx, (%rsi)
; ATOM-NEXT:    retq
;
; MCU-LABEL: clamp:
; MCU:       # BB#0:
; MCU-NEXT:    cmpl $32767, %eax # imm = 0x7FFF
; MCU-NEXT:    movl $32767, %ecx # imm = 0x7FFF
; MCU-NEXT:    jg .LBB23_2
; MCU-NEXT:  # BB#1:
; MCU-NEXT:    movl %eax, %ecx
; MCU-NEXT:  .LBB23_2:
; MCU-NEXT:    cmpl $-32768, %ecx # imm = 0x8000
; MCU-NEXT:    movw $-32768, %ax # imm = 0x8000
; MCU-NEXT:    jl .LBB23_4
; MCU-NEXT:  # BB#3:
; MCU-NEXT:    movl %ecx, %eax
; MCU-NEXT:  .LBB23_4:
; MCU-NEXT:    movw %ax, (%edx)
; MCU-NEXT:    retl
  %cmp = icmp sgt i32 %src, 32767
  %sel1 = select i1 %cmp, i32 32767, i32 %src
  %cmp1 = icmp slt i32 %sel1, -32768
  %sel2 = select i1 %cmp1, i32 -32768, i32 %sel1
  %conv = trunc i32 %sel2 to i16
  store i16 %conv, i16* %dst, align 2
  ret void
}

define void @test19() {
; This is a massive reduction of an llvm-stress test case that generates
; interesting chains feeding setcc and eventually a f32 select operation. This
; is intended to exercise the SELECT formation in the DAG combine simplifying
; a simplified select_cc node. If it it regresses and is no longer triggering
; that code path, it can be deleted.
;
; CHECK-LABEL: test19:
; CHECK:       ## BB#0: ## %BB
; CHECK-NEXT:    movl $-1, %eax
; CHECK-NEXT:    movb $1, %cl
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB24_1: ## %CF
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    testb %cl, %cl
; CHECK-NEXT:    jne LBB24_1
; CHECK-NEXT:  ## BB#2: ## %CF250
; CHECK-NEXT:    ## in Loop: Header=BB24_1 Depth=1
; CHECK-NEXT:    jne LBB24_1
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB24_3: ## %CF242
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpl %eax, %eax
; CHECK-NEXT:    ucomiss %xmm0, %xmm0
; CHECK-NEXT:    jp LBB24_3
; CHECK-NEXT:  ## BB#4: ## %CF244
; CHECK-NEXT:    retq
;
; MCU-LABEL: test19:
; MCU:       # BB#0: # %BB
; MCU-NEXT:    movl $-1, %ecx
; MCU-NEXT:    movb $1, %al
; MCU-NEXT:    .p2align 4, 0x90
; MCU-NEXT:  .LBB24_1: # %CF
; MCU-NEXT:    # =>This Inner Loop Header: Depth=1
; MCU-NEXT:    testb %al, %al
; MCU-NEXT:    jne .LBB24_1
; MCU-NEXT:  # BB#2: # %CF250
; MCU-NEXT:    # in Loop: Header=BB24_1 Depth=1
; MCU-NEXT:    jne .LBB24_1
; MCU-NEXT:  # BB#3: # %CF242.preheader
; MCU-NEXT:    fldz
; MCU-NEXT:    .p2align 4, 0x90
; MCU-NEXT:  .LBB24_4: # %CF242
; MCU-NEXT:    # =>This Inner Loop Header: Depth=1
; MCU-NEXT:    cmpl %eax, %ecx
; MCU-NEXT:    fucom %st(0)
; MCU-NEXT:    fnstsw %ax
; MCU-NEXT:    # kill: %AH<def> %AH<kill> %AX<kill>
; MCU-NEXT:    sahf
; MCU-NEXT:    jp .LBB24_4
; MCU-NEXT:  # BB#5: # %CF244
; MCU-NEXT:    fstp %st(0)
; MCU-NEXT:    retl
BB:
  br label %CF

CF:
  %Cmp10 = icmp ule i8 undef, undef
  br i1 %Cmp10, label %CF, label %CF250

CF250:
  %E12 = extractelement <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, i32 2
  %Cmp32 = icmp ugt i1 %Cmp10, false
  br i1 %Cmp32, label %CF, label %CF242

CF242:
  %Cmp38 = icmp uge i32 %E12, undef
  %FC = uitofp i1 %Cmp38 to float
  %Sl59 = select i1 %Cmp32, float %FC, float undef
  %Cmp60 = fcmp ugt float undef, undef
  br i1 %Cmp60, label %CF242, label %CF244

CF244:
  %B122 = fadd float %Sl59, undef
  ret void
}

define i16 @select_xor_1(i16 %A, i8 %cond) {
; CHECK-LABEL: select_xor_1:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    xorl $43, %eax
; CHECK-NEXT:    testb $1, %sil
; CHECK-NEXT:    cmovnew %ax, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
;
; MCU-LABEL: select_xor_1:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    andl $1, %edx
; MCU-NEXT:    negl %edx
; MCU-NEXT:    andl $43, %edx
; MCU-NEXT:    xorl %edx, %eax
; MCU-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; MCU-NEXT:    retl
entry:
 %and = and i8 %cond, 1
 %cmp10 = icmp eq i8 %and, 0
 %0 = xor i16 %A, 43
 %1 = select i1 %cmp10, i16 %A, i16 %0
 ret i16 %1
}

define i32 @select_xor_2(i32 %A, i32 %B, i8 %cond) {
; CHECK-LABEL: select_xor_2:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    xorl %edi, %esi
; CHECK-NEXT:    testb $1, %dl
; CHECK-NEXT:    cmovel %edi, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
;
; MCU-LABEL: select_xor_2:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    andl $1, %ecx
; MCU-NEXT:    negl %ecx
; MCU-NEXT:    andl %edx, %ecx
; MCU-NEXT:    xorl %ecx, %eax
; MCU-NEXT:    retl
entry:
 %and = and i8 %cond, 1
 %cmp10 = icmp eq i8 %and, 0
 %0 = xor i32 %B, %A
 %1 = select i1 %cmp10, i32 %A, i32 %0
 ret i32 %1
}

define i32 @select_or(i32 %A, i32 %B, i8 %cond) {
; CHECK-LABEL: select_or:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    orl %edi, %esi
; CHECK-NEXT:    testb $1, %dl
; CHECK-NEXT:    cmovel %edi, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
;
; MCU-LABEL: select_or:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    andl $1, %ecx
; MCU-NEXT:    negl %ecx
; MCU-NEXT:    andl %edx, %ecx
; MCU-NEXT:    orl %ecx, %eax
; MCU-NEXT:    retl
entry:
 %and = and i8 %cond, 1
 %cmp10 = icmp eq i8 %and, 0
 %0 = or i32 %B, %A
 %1 = select i1 %cmp10, i32 %A, i32 %0
 ret i32 %1
}

define i32 @select_or_1(i32 %A, i32 %B, i32 %cond) {
; CHECK-LABEL: select_or_1:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    orl %edi, %esi
; CHECK-NEXT:    testb $1, %dl
; CHECK-NEXT:    cmovel %edi, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
;
; MCU-LABEL: select_or_1:
; MCU:       # BB#0: # %entry
; MCU-NEXT:    andl $1, %ecx
; MCU-NEXT:    negl %ecx
; MCU-NEXT:    andl %edx, %ecx
; MCU-NEXT:    orl %ecx, %eax
; MCU-NEXT:    retl
entry:
 %and = and i32 %cond, 1
 %cmp10 = icmp eq i32 %and, 0
 %0 = or i32 %B, %A
 %1 = select i1 %cmp10, i32 %A, i32 %0
 ret i32 %1
}
