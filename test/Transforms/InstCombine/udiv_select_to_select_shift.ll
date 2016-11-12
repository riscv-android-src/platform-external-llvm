; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Test that this transform works:
; udiv X, (Select Cond, C1, C2) --> Select Cond, (shr X, C1), (shr X, C2)

define i64 @test(i64 %X, i1 %Cond ) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[QUOTIENT1:%.*]] = lshr i64 %X, 4
; CHECK-NEXT:    [[QUOTIENT2:%.*]] = lshr i64 %X, 3
; CHECK-NEXT:    [[SUM:%.*]] = add nuw nsw i64 [[QUOTIENT1]], [[QUOTIENT2]]
; CHECK-NEXT:    ret i64 [[SUM]]
;
  %divisor1 = select i1 %Cond, i64 16, i64 8
  %quotient1 = udiv i64 %X, %divisor1
  %divisor2 = select i1 %Cond, i64 8, i64 0
  %quotient2 = udiv i64 %X, %divisor2
  %sum = add i64 %quotient1, %quotient2
  ret i64 %sum
}

