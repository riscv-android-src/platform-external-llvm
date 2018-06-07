; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

; %r = shl nuw i8 C, %x
; As per langref: If the nuw keyword is present, then the shift produces
;                 a poison value if it shifts out any non-zero bits.
; Thus, if the sign bit is set on C, then %x can only be 0, which means that
; %r can only be C.

define i8 @shl_nuw (i8 %x) {
; CHECK-LABEL: @shl_nuw(
; CHECK-NEXT:    ret i8 -1
;
  %ret = shl nuw i8 -1, %x
  ; nuw here means that %x can only be 0
  ret i8 %ret
}

define i8 @shl_nuw_nsw (i8 %x) {
; CHECK-LABEL: @shl_nuw_nsw(
; CHECK-NEXT:    ret i8 -1
;
  %ret = shl nuw nsw i8 -1, %x
  ; nuw here means that %x can only be 0
  ret i8 %ret
}

define i8 @shl_128 (i8 %x) {
; CHECK-LABEL: @shl_128(
; CHECK-NEXT:    ret i8 -128
;
  %ret = shl nuw i8 128, %x
  ; 128 == 1<<7 == just the sign bit is set
  ret i8 %ret
}

; ============================================================================ ;
; Positive tests with value range known
; ============================================================================ ;

declare void @llvm.assume(i1 %cond);

define i8 @knownbits_negative(i8 %x, i8 %y) {
; CHECK-LABEL: @knownbits_negative(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %cmp = icmp slt i8 %x, 0
  tail call void @llvm.assume(i1 %cmp)
  %ret = shl nuw i8 %x, %y
  ret i8 %ret
}

define i8 @knownbits_negativeorzero(i8 %x, i8 %y) {
; CHECK-LABEL: @knownbits_negativeorzero(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], 1
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %cmp = icmp slt i8 %x, 1
  tail call void @llvm.assume(i1 %cmp)
  %ret = shl nuw i8 %x, %y
  ret i8 %ret
}

; ============================================================================ ;
; Vectors
; ============================================================================ ;

define <2 x i8> @shl_vec(<2 x i8> %x) {
; CHECK-LABEL: @shl_vec(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %ret = shl nuw <2 x i8> <i8 -1, i8 -1>, %x
  ret <2 x i8> %ret
}

define <3 x i8> @shl_vec_undef(<3 x i8> %x) {
; CHECK-LABEL: @shl_vec_undef(
; CHECK-NEXT:    ret <3 x i8> <i8 -1, i8 undef, i8 -1>
;
  %ret = shl nuw <3 x i8> <i8 -1, i8 undef, i8 -1>, %x
  ret <3 x i8> %ret
}

define <2 x i8> @shl_vec_nonsplat(<2 x i8> %x) {
; CHECK-LABEL: @shl_vec_nonsplat(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -2>
;
  %ret = shl nuw <2 x i8> <i8 -1, i8 -2>, %x
  ret <2 x i8> %ret
}

; ============================================================================ ;
; Negative tests. Should not be folded.
; ============================================================================ ;

define i8 @shl_127 (i8 %x) {
; CHECK-LABEL: @shl_127(
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 127, [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %ret = shl nuw i8 127, %x
  ; 127 == (1<<7)-1 == all bits except the sign bit are set.
  ret i8 %ret
}

define i8 @bad_shl (i8 %x) {
; CHECK-LABEL: @bad_shl(
; CHECK-NEXT:    [[RET:%.*]] = shl i8 -1, [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %ret = shl i8 -1, %x ; need nuw
  ret i8 %ret
}

define i8 @bad_nsw (i8 %x) {
; CHECK-LABEL: @bad_nsw(
; CHECK-NEXT:    [[RET:%.*]] = shl nsw i8 -1, [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %ret = shl nsw i8 -1, %x ; need nuw
  ret i8 %ret
}

; First `shl` operand is not `-1` constant

define i8 @bad_shl0(i8 %shlop1, i8 %x) {
; CHECK-LABEL: @bad_shl0(
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[SHLOP1:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %ret = shl nuw i8 %shlop1, %x
  ret i8 %ret
}

; Bad shl nuw constant

define i8 @bad_shl1(i8 %x) {
; CHECK-LABEL: @bad_shl1(
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 1, [[X:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %ret = shl nuw i8 1, %x ; not -1
  ret i8 %ret
}

define <2 x i8> @bad_shl_vec_nonsplat(<2 x i8> %x) {
; CHECK-LABEL: @bad_shl_vec_nonsplat(
; CHECK-NEXT:    [[RET:%.*]] = shl nuw <2 x i8> <i8 -1, i8 1>, [[X:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[RET]]
;
  %ret = shl nuw <2 x i8> <i8 -1, i8 1>, %x
  ret <2 x i8> %ret
}

; Bad known bits

define i8 @bad_knownbits(i8 %x, i8 %y) {
; CHECK-LABEL: @bad_knownbits(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], 2
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %cmp = icmp slt i8 %x, 2
  tail call void @llvm.assume(i1 %cmp)
  %ret = shl nuw i8 %x, %y
  ret i8 %ret
}

define i8 @bad_knownbits_minusoneormore(i8 %x, i8 %y) {
; CHECK-LABEL: @bad_knownbits_minusoneormore(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[X:%.*]], -2
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %cmp = icmp sgt i8 %x, -2
  tail call void @llvm.assume(i1 %cmp)
  %ret = shl nuw i8 %x, %y
  ret i8 %ret
}

define i8 @bad_knownbits_zeroorpositive(i8 %x, i8 %y) {
; CHECK-LABEL: @bad_knownbits_zeroorpositive(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[X:%.*]], -1
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %cmp = icmp sgt i8 %x, -1
  tail call void @llvm.assume(i1 %cmp)
  %ret = shl nuw i8 %x, %y
  ret i8 %ret
}

define i8 @bad_knownbits_positive(i8 %x, i8 %y) {
; CHECK-LABEL: @bad_knownbits_positive(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[X:%.*]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[RET:%.*]] = shl nuw i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[RET]]
;
  %cmp = icmp sgt i8 %x, 0
  tail call void @llvm.assume(i1 %cmp)
  %ret = shl nuw i8 %x, %y
  ret i8 %ret
}
