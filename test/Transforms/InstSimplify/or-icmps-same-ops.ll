; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

; There are 10 * 10 combinations of icmp predicates that can be OR'd together.
; The majority of these can be simplified to always true or just one of the icmps.

define i1 @eq_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_eq(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_ne(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_sge(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_sgt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_sle(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_slt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_uge(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_ugt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_ule(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @eq_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @eq_ult(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp eq i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @ne_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_eq(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_ne(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_sge(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_sgt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_sle(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_slt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_uge(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_ugt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_ule(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ne_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @ne_ult(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp ne i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @sge_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_eq(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_ne(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_sge(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_sgt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_sle(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_slt(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_uge(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_ugt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_ule(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sge_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @sge_ult(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sge i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @sgt_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_eq(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_ne(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_sge(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_sgt(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_sle(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_slt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_uge(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_ugt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_ule(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sgt_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt_ult(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sgt i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @sle_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_eq(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_ne(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_sge(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_sgt(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_sle(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_slt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_uge(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_ugt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_ule(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @sle_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @sle_ult(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp sle i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @slt_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_eq(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_ne(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_sge(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_sgt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_sle(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_slt(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_uge(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_ugt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_ule(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @slt_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @slt_ult(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp slt i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @uge_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_eq(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_ne(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_sge(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_sgt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_sle(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_slt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_uge(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_ugt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_ule(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @uge_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @uge_ult(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp uge i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @ugt_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_eq(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_ne(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_sge(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_sgt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_sle(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_slt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_uge(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp uge i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_ugt(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_ule(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ugt_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt_ult(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ugt i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @ule_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_eq(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_ne(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_sge(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_sgt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_sle(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_slt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_uge(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_ugt(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_ule(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ule_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @ule_ult(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP1]]
;
  %cmp1 = icmp ule i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

;

define i1 @ult_eq(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_eq(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp eq i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_ne(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_ne(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ne i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp ne i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_sge(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_sge(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sge i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp sge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_sgt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp sgt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_sle(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_sle(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sle i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp sle i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_slt(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_slt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp slt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_uge(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_uge(
; CHECK-NEXT:    ret i1 true
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp uge i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_ugt(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i8 %a, %b
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp ugt i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_ule(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_ule(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp ule i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define i1 @ult_ult(i8 %a, i8 %b) {
; CHECK-LABEL: @ult_ult(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i8 %a, %b
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp1 = icmp ult i8 %a, %b
  %cmp2 = icmp ult i8 %a, %b
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

; Check a couple of vector variants to make sure those work too.

define <2 x i1> @ult_uge_vec(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @ult_uge_vec(
; CHECK-NEXT:    ret <2 x i1> <i1 true, i1 true>
;
  %cmp1 = icmp ult <2 x i8> %a, %b
  %cmp2 = icmp uge <2 x i8> %a, %b
  %or = or <2 x i1> %cmp1, %cmp2
  ret <2 x i1> %or
}

define <2 x i1> @ult_ule_vec(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @ult_ule_vec(
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ule <2 x i8> %a, %b
; CHECK-NEXT:    ret <2 x i1> [[CMP2]]
;
  %cmp1 = icmp ult <2 x i8> %a, %b
  %cmp2 = icmp ule <2 x i8> %a, %b
  %or = or <2 x i1> %cmp1, %cmp2
  ret <2 x i1> %or
}

