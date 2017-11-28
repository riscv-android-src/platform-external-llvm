; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin | FileCheck %s

; This test comes from PR27136
; We should hoist loop constant invariant

define zeroext i1 @search(i32 %needle, i32* nocapture readonly %haystack, i32 %count) {
; CHECK-LABEL: search:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    testl %edx, %edx
; CHECK-NEXT:    jle LBB0_1
; CHECK-NEXT:  ## BB#4: ## %for.body.preheader
; CHECK-NEXT:    movslq %edx, %rax
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB0_5: ## %for.body
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpl %edi, (%rsi,%rcx,4)
; CHECK-NEXT:    je LBB0_6
; CHECK-NEXT:  ## BB#2: ## %for.cond
; CHECK-NEXT:    ## in Loop: Header=BB0_5 Depth=1
; CHECK-NEXT:    incq %rcx
; CHECK-NEXT:    cmpq %rax, %rcx
; CHECK-NEXT:    jl LBB0_5
;            ### FIXME: BB#3 and LBB0_1 should be merged
; CHECK-NEXT:  ## BB#3:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    ## kill: %al<def> %al<kill> %eax<kill>
; CHECK-NEXT:    retq
; CHECK-NEXT:  LBB0_1:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    ## kill: %al<def> %al<kill> %eax<kill>
; CHECK-NEXT:    retq
; CHECK-NEXT:  LBB0_6:
; CHECK-NEXT:    movb $1, %al
; CHECK-NEXT:    ## kill: %al<def> %al<kill> %eax<kill>
; CHECK-NEXT:    retq
entry:
  %cmp5 = icmp sgt i32 %count, 0
  br i1 %cmp5, label %for.body.preheader, label %cleanup

for.body.preheader:                               ; preds = %entry
  %0 = sext i32 %count to i64
  br label %for.body

for.cond:                                         ; preds = %for.body
  %cmp = icmp slt i64 %indvars.iv.next, %0
  br i1 %cmp, label %for.body, label %cleanup.loopexit

for.body:                                         ; preds = %for.body.preheader, %for.cond
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.cond ]
  %arrayidx = getelementptr inbounds i32, i32* %haystack, i64 %indvars.iv
  %1 = load i32, i32* %arrayidx, align 4
  %cmp1 = icmp eq i32 %1, %needle
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  br i1 %cmp1, label %cleanup.loopexit, label %for.cond

cleanup.loopexit:                                 ; preds = %for.cond, %for.body
  %.ph = phi i1 [ false, %for.cond ], [ true, %for.body ]
  br label %cleanup

cleanup:                                          ; preds = %cleanup.loopexit, %entry
  %2 = phi i1 [ false, %entry ], [ %.ph, %cleanup.loopexit ]
  ret i1 %2
}
