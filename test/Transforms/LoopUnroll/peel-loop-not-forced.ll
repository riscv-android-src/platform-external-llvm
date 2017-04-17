; RUN: opt < %s -S -loop-unroll -unroll-threshold=8 | FileCheck %s

define i32 @invariant_backedge_1(i32 %a, i32 %b) {
; CHECK-LABEL: @invariant_backedge_1
; CHECK-NOT:     %plus = phi
; CHECK:       loop.peel:
; CHECK:       loop:
; CHECK:         %i = phi
; CHECK:         %sum = phi
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop ]
  %sum = phi i32 [ 0, %entry ], [ %incsum, %loop ]
  %plus = phi i32 [ %a, %entry ], [ %b, %loop ]

  %incsum = add i32 %sum, %plus
  %inc = add i32 %i, 1
  %cmp = icmp slt i32 %i, 1000

  br i1 %cmp, label %loop, label %exit

exit:
  ret i32 %sum
}

; Peeling should fail due to method size.
define i32 @invariant_backedge_2(i32 %a, i32 %b) {
; CHECK-LABEL: @invariant_backedge_2
; CHECK-NOT:   loop.peel:
; CHECK:       loop:
; CHECK:         %i = phi
; CHECK:         %sum = phi
; CHECK:         %plus = phi
entry:
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop ]
  %sum = phi i32 [ 0, %entry ], [ %incsum2, %loop ]
  %plus = phi i32 [ %a, %entry ], [ %b, %loop ]

  %incsum = add i32 %sum, %plus
  %incsum2 = add i32 %incsum, %plus
  %inc = add i32 %i, 1
  %cmp = icmp slt i32 %i, 1000

  br i1 %cmp, label %loop, label %exit

exit:
  ret i32 %sum
}
