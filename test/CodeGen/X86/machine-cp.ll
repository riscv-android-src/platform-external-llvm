; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-macosx -mattr=+sse2 -verify-machineinstrs | FileCheck %s

; After tail duplication, two copies in an early exit BB can be cancelled out.
; rdar://10640363
define i32 @t1(i32 %a, i32 %b) nounwind  {
; CHECK-LABEL: t1:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    testl %esi, %esi
; CHECK-NEXT:    je LBB0_1
; CHECK-NEXT:  ## %bb.2: ## %while.body.preheader
; CHECK-NEXT:    movl %esi, %edx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB0_3: ## %while.body
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl %edx, %ecx
; CHECK-NEXT:    cltd
; CHECK-NEXT:    idivl %ecx
; CHECK-NEXT:    testl %edx, %edx
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    jne LBB0_3
; CHECK-NEXT:  ## %bb.4: ## %while.end
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  LBB0_1:
; CHECK-NEXT:    retq
entry:
  %cmp1 = icmp eq i32 %b, 0
  br i1 %cmp1, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %while.body
  %a.addr.03 = phi i32 [ %b.addr.02, %while.body ], [ %a, %entry ]
  %b.addr.02 = phi i32 [ %rem, %while.body ], [ %b, %entry ]
  %rem = srem i32 %a.addr.03, %b.addr.02
  %cmp = icmp eq i32 %rem, 0
  br i1 %cmp, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %entry
  %a.addr.0.lcssa = phi i32 [ %a, %entry ], [ %b.addr.02, %while.body ]
  ret i32 %a.addr.0.lcssa
}

; Two movdqa (from phi-elimination) in the entry BB cancels out.
; rdar://10428165
define <8 x i16> @t2(<8 x i16> %T0, <8 x i16> %T1) nounwind readnone {
; CHECK-LABEL: t2:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,1,2,3]
; CHECK-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,1,1,2,4,5,6,7]
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; CHECK-NEXT:    retq
entry:
  %tmp8 = shufflevector <8 x i16> %T0, <8 x i16> %T1, <8 x i32> < i32 undef, i32 undef, i32 7, i32 2, i32 8, i32 undef, i32 undef , i32 undef >
  ret <8 x i16> %tmp8
}

define i32 @t3(i64 %a, i64 %b) nounwind  {
; CHECK-LABEL: t3:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    testq %rsi, %rsi
; CHECK-NEXT:    je LBB2_1
; CHECK-NEXT:  ## %bb.2: ## %while.body.preheader
; CHECK-NEXT:    movq %rsi, %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB2_3: ## %while.body
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    cqto
; CHECK-NEXT:    idivq %rcx
; CHECK-NEXT:    testq %rdx, %rdx
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    jne LBB2_3
; CHECK-NEXT:  ## %bb.4: ## %while.end
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    retq
; CHECK-NEXT:  LBB2_1:
; CHECK-NEXT:    retq
entry:
  %cmp1 = icmp eq i64 %b, 0
  br i1 %cmp1, label %while.end, label %while.body

while.body:                                       ; preds = %entry, %while.body
  %a.addr.03 = phi i64 [ %b.addr.02, %while.body ], [ %a, %entry ]
  %b.addr.02 = phi i64 [ %rem, %while.body ], [ %b, %entry ]
  %rem = srem i64 %a.addr.03, %b.addr.02
  %cmp = icmp eq i64 %rem, 0
  br i1 %cmp, label %while.end, label %while.body

while.end:                                        ; preds = %while.body, %entry
  %a.addr.0.lcssa = phi i64 [ %a, %entry ], [ %b.addr.02, %while.body ]
  %t = trunc i64 %a.addr.0.lcssa to i32
  ret i32 %t
}

; Check that copy propagation does not kill thing like:
; dst = copy src <-- do not kill that.
; ... = op1 undef dst
; ... = op2 dst <-- this is used here.
define <16 x float> @foo(<16 x float> %x) {
; CHECK-LABEL: foo:
; CHECK:       ## %bb.0: ## %bb
; CHECK-NEXT:    xorps %xmm8, %xmm8
; CHECK-NEXT:    cvttps2dq %xmm3, %xmm9
; CHECK-NEXT:    movaps %xmm3, %xmm13
; CHECK-NEXT:    cmpltps %xmm8, %xmm13
; CHECK-NEXT:    movaps {{.*#+}} xmm7 = [1,1,1,1]
; CHECK-NEXT:    movaps %xmm13, %xmm3
; CHECK-NEXT:    andps %xmm7, %xmm3
; CHECK-NEXT:    cvttps2dq %xmm2, %xmm10
; CHECK-NEXT:    movaps %xmm2, %xmm5
; CHECK-NEXT:    cmpltps %xmm8, %xmm5
; CHECK-NEXT:    movaps %xmm5, %xmm2
; CHECK-NEXT:    andps %xmm7, %xmm2
; CHECK-NEXT:    cvttps2dq %xmm1, %xmm11
; CHECK-NEXT:    movaps %xmm1, %xmm4
; CHECK-NEXT:    cmpltps %xmm8, %xmm4
; CHECK-NEXT:    movaps %xmm4, %xmm1
; CHECK-NEXT:    andps %xmm7, %xmm1
; CHECK-NEXT:    cvttps2dq %xmm0, %xmm12
; CHECK-NEXT:    movaps %xmm0, %xmm6
; CHECK-NEXT:    cmpltps %xmm8, %xmm6
; CHECK-NEXT:    andps %xmm6, %xmm7
; CHECK-NEXT:    orps {{.*}}(%rip), %xmm6
; CHECK-NEXT:    movaps {{.*#+}} xmm14 = [5,6,7,8]
; CHECK-NEXT:    orps %xmm14, %xmm4
; CHECK-NEXT:    movaps {{.*#+}} xmm15 = [9,10,11,12]
; CHECK-NEXT:    orps %xmm15, %xmm5
; CHECK-NEXT:    movaps {{.*#+}} xmm8 = [13,14,15,16]
; CHECK-NEXT:    orps %xmm8, %xmm13
; CHECK-NEXT:    cvtdq2ps %xmm12, %xmm0
; CHECK-NEXT:    cvtdq2ps %xmm11, %xmm11
; CHECK-NEXT:    cvtdq2ps %xmm10, %xmm10
; CHECK-NEXT:    cvtdq2ps %xmm9, %xmm9
; CHECK-NEXT:    andps %xmm8, %xmm9
; CHECK-NEXT:    andps %xmm15, %xmm10
; CHECK-NEXT:    andps %xmm14, %xmm11
; CHECK-NEXT:    andps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    xorps %xmm7, %xmm0
; CHECK-NEXT:    andps %xmm6, %xmm0
; CHECK-NEXT:    xorps %xmm1, %xmm11
; CHECK-NEXT:    andps %xmm4, %xmm11
; CHECK-NEXT:    xorps %xmm2, %xmm10
; CHECK-NEXT:    andps %xmm5, %xmm10
; CHECK-NEXT:    xorps %xmm3, %xmm9
; CHECK-NEXT:    andps %xmm13, %xmm9
; CHECK-NEXT:    xorps %xmm7, %xmm0
; CHECK-NEXT:    xorps %xmm11, %xmm1
; CHECK-NEXT:    xorps %xmm10, %xmm2
; CHECK-NEXT:    xorps %xmm9, %xmm3
; CHECK-NEXT:    retq
bb:
  %v3 = icmp slt <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>, zeroinitializer
  %v14 = zext <16 x i1> %v3 to <16 x i32>
  %v16 = fcmp olt <16 x float> %x, zeroinitializer
  %v17 = sext <16 x i1> %v16 to <16 x i32>
  %v18 = zext <16 x i1> %v16 to <16 x i32>
  %v19 = xor <16 x i32> %v14, %v18
  %v20 = or <16 x i32> %v17, <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16>
  %v21 = fptosi <16 x float> %x to <16 x i32>
  %v22 = sitofp <16 x i32> %v21 to <16 x float>
  %v69 = fcmp ogt <16 x float> %v22, zeroinitializer
  %v75 = and <16 x i1> %v69, %v3
  %v77 = bitcast <16 x float> %v22 to <16 x i32>
  %v79 = sext <16 x i1> %v75 to <16 x i32>
  %v80 = and <16 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16>, %v79
  %v81 = xor <16 x i32> %v77, %v80
  %v82 = and <16 x i32> <i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16>, %v81
  %v83 = xor <16 x i32> %v19, %v82
  %v84 = and <16 x i32> %v83, %v20
  %v85 = xor <16 x i32> %v19, %v84
  %v86 = bitcast <16 x i32> %v85 to <16 x float>
  ret <16 x float> %v86
}
