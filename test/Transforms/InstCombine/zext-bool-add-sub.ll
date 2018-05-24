; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; rdar://11748024

define i32 @a(i1 zeroext %x, i1 zeroext %y) {
; CHECK-LABEL: @a(
; CHECK-NEXT:    [[CONV3_NEG:%.*]] = sext i1 [[Y:%.*]] to i32
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[X:%.*]], i32 2, i32 1
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[SUB]], [[CONV3_NEG]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %conv = zext i1 %x to i32
  %conv3 = zext i1 %y to i32
  %conv3.neg = sub i32 0, %conv3
  %sub = add i32 %conv, 1
  %add = add i32 %sub, %conv3.neg
  ret i32 %add
}

define i32 @PR30273_select(i1 %a, i1 %b) {
; CHECK-LABEL: @PR30273_select(
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i1 [[A:%.*]] to i32
; CHECK-NEXT:    [[SEL1:%.*]] = select i1 [[A]], i32 2, i32 1
; CHECK-NEXT:    [[SEL2:%.*]] = select i1 [[B:%.*]], i32 [[SEL1]], i32 [[ZEXT]]
; CHECK-NEXT:    ret i32 [[SEL2]]
;
  %zext = zext i1 %a to i32
  %sel1 = select i1 %a, i32 2, i32 1
  %sel2 = select i1 %b, i32 %sel1, i32 %zext
  ret i32 %sel2
}

define i32 @PR30273_zext_add(i1 %a, i1 %b) {
; CHECK-LABEL: @PR30273_zext_add(
; CHECK-NEXT:    [[CONV:%.*]] = zext i1 [[A:%.*]] to i32
; CHECK-NEXT:    [[CONV3:%.*]] = zext i1 [[B:%.*]] to i32
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i32 [[CONV3]], [[CONV]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %conv = zext i1 %a to i32
  %conv3 = zext i1 %b to i32
  %add = add nuw nsw i32 %conv3, %conv
  ret i32 %add
}

define i32 @PR30273_three_bools(i1 %x, i1 %y, i1 %z) {
; CHECK-LABEL: @PR30273_three_bools(
; CHECK-NEXT:    [[FROMBOOL:%.*]] = zext i1 [[X:%.*]] to i32
; CHECK-NEXT:    [[ADD1:%.*]] = select i1 [[X]], i32 2, i32 1
; CHECK-NEXT:    [[SEL1:%.*]] = select i1 [[Y:%.*]], i32 [[ADD1]], i32 [[FROMBOOL]]
; CHECK-NEXT:    [[ADD2:%.*]] = zext i1 [[Z:%.*]] to i32
; CHECK-NEXT:    [[SEL2:%.*]] = add nuw nsw i32 [[SEL1]], [[ADD2]]
; CHECK-NEXT:    ret i32 [[SEL2]]
;
  %frombool = zext i1 %x to i32
  %add1 = add nsw i32 %frombool, 1
  %sel1 = select i1 %y, i32 %add1, i32 %frombool
  %add2 = add nsw i32 %sel1, 1
  %sel2 = select i1 %z, i32 %add2, i32 %sel1
  ret i32 %sel2
}

define i32 @zext_add_scalar(i1 %x) {
; CHECK-LABEL: @zext_add_scalar(
; CHECK-NEXT:    [[ADD:%.*]] = select i1 [[X:%.*]], i32 43, i32 42
; CHECK-NEXT:    ret i32 [[ADD]]
;
  %zext = zext i1 %x to i32
  %add = add i32 %zext, 42
  ret i32 %add
}

define <2 x i32> @zext_add_vec_splat(<2 x i1> %x) {
; CHECK-LABEL: @zext_add_vec_splat(
; CHECK-NEXT:    [[ADD:%.*]] = select <2 x i1> [[X:%.*]], <2 x i32> <i32 43, i32 43>, <2 x i32> <i32 42, i32 42>
; CHECK-NEXT:    ret <2 x i32> [[ADD]]
;
  %zext = zext <2 x i1> %x to <2 x i32>
  %add = add <2 x i32> %zext, <i32 42, i32 42>
  ret <2 x i32> %add
}

define <2 x i32> @zext_add_vec(<2 x i1> %x) {
; CHECK-LABEL: @zext_add_vec(
; CHECK-NEXT:    [[ADD:%.*]] = select <2 x i1> [[X:%.*]], <2 x i32> <i32 43, i32 24>, <2 x i32> <i32 42, i32 23>
; CHECK-NEXT:    ret <2 x i32> [[ADD]]
;
  %zext = zext <2 x i1> %x to <2 x i32>
  %add = add <2 x i32> %zext, <i32 42, i32 23>
  ret <2 x i32> %add
}

declare void @use(i64)

define i64 @zext_negate(i1 %A) {
; CHECK-LABEL: @zext_negate(
; CHECK-NEXT:    [[SUB:%.*]] = sext i1 [[A:%.*]] to i64
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = zext i1 %A to i64
  %sub = sub i64 0, %ext
  ret i64 %sub
}

define i64 @zext_negate_extra_use(i1 %A) {
; CHECK-LABEL: @zext_negate_extra_use(
; CHECK-NEXT:    [[EXT:%.*]] = zext i1 [[A:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sext i1 [[A]] to i64
; CHECK-NEXT:    call void @use(i64 [[EXT]])
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = zext i1 %A to i64
  %sub = sub i64 0, %ext
  call void @use(i64 %ext)
  ret i64 %sub
}

define <2 x i64> @zext_negate_vec(<2 x i1> %A) {
; CHECK-LABEL: @zext_negate_vec(
; CHECK-NEXT:    [[SUB:%.*]] = sext <2 x i1> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %ext = zext <2 x i1> %A to <2 x i64>
  %sub = sub <2 x i64> zeroinitializer, %ext
  ret <2 x i64> %sub
}

define <2 x i64> @zext_negate_vec_undef_elt(<2 x i1> %A) {
; CHECK-LABEL: @zext_negate_vec_undef_elt(
; CHECK-NEXT:    [[SUB:%.*]] = sext <2 x i1> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %ext = zext <2 x i1> %A to <2 x i64>
  %sub = sub <2 x i64> <i64 0, i64 undef>, %ext
  ret <2 x i64> %sub
}

define i64 @zext_sub_const(i1 %A) {
; CHECK-LABEL: @zext_sub_const(
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[A:%.*]], i64 41, i64 42
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = zext i1 %A to i64
  %sub = sub i64 42, %ext
  ret i64 %sub
}

define i64 @zext_sub_const_extra_use(i1 %A) {
; CHECK-LABEL: @zext_sub_const_extra_use(
; CHECK-NEXT:    [[EXT:%.*]] = zext i1 [[A:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[A]], i64 41, i64 42
; CHECK-NEXT:    call void @use(i64 [[EXT]])
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = zext i1 %A to i64
  %sub = sub i64 42, %ext
  call void @use(i64 %ext)
  ret i64 %sub
}

define <2 x i64> @zext_sub_const_vec(<2 x i1> %A) {
; CHECK-LABEL: @zext_sub_const_vec(
; CHECK-NEXT:    [[SUB:%.*]] = select <2 x i1> [[A:%.*]], <2 x i64> <i64 41, i64 2>, <2 x i64> <i64 42, i64 3>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %ext = zext <2 x i1> %A to <2 x i64>
  %sub = sub <2 x i64> <i64 42, i64 3>, %ext
  ret <2 x i64> %sub
}

define <2 x i64> @zext_sub_const_vec_undef_elt(<2 x i1> %A) {
; CHECK-LABEL: @zext_sub_const_vec_undef_elt(
; CHECK-NEXT:    [[SUB:%.*]] = select <2 x i1> [[A:%.*]], <2 x i64> <i64 41, i64 undef>, <2 x i64> <i64 42, i64 undef>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %ext = zext <2 x i1> %A to <2 x i64>
  %sub = sub <2 x i64> <i64 42, i64 undef>, %ext
  ret <2 x i64> %sub
}

define i64 @sext_negate(i1 %A) {
; CHECK-LABEL: @sext_negate(
; CHECK-NEXT:    [[SUB:%.*]] = zext i1 [[A:%.*]] to i64
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = sext i1 %A to i64
  %sub = sub i64 0, %ext
  ret i64 %sub
}

define i64 @sext_negate_extra_use(i1 %A) {
; CHECK-LABEL: @sext_negate_extra_use(
; CHECK-NEXT:    [[EXT:%.*]] = sext i1 [[A:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = zext i1 [[A]] to i64
; CHECK-NEXT:    call void @use(i64 [[EXT]])
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = sext i1 %A to i64
  %sub = sub i64 0, %ext
  call void @use(i64 %ext)
  ret i64 %sub
}

define <2 x i64> @sext_negate_vec(<2 x i1> %A) {
; CHECK-LABEL: @sext_negate_vec(
; CHECK-NEXT:    [[SUB:%.*]] = zext <2 x i1> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %ext = sext <2 x i1> %A to <2 x i64>
  %sub = sub <2 x i64> zeroinitializer, %ext
  ret <2 x i64> %sub
}

define <2 x i64> @sext_negate_vec_undef_elt(<2 x i1> %A) {
; CHECK-LABEL: @sext_negate_vec_undef_elt(
; CHECK-NEXT:    [[TMP1:%.*]] = zext <2 x i1> [[A:%.*]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[TMP1]]
;
  %ext = sext <2 x i1> %A to <2 x i64>
  %sub = sub <2 x i64> <i64 0, i64 undef>, %ext
  ret <2 x i64> %sub
}

define i64 @sext_sub_const(i1 %A) {
; CHECK-LABEL: @sext_sub_const(
; CHECK-NEXT:    [[SUB:%.*]] = select i1 [[A:%.*]], i64 43, i64 42
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = sext i1 %A to i64
  %sub = sub i64 42, %ext
  ret i64 %sub
}

; FIXME: This doesn't correspond to the zext pattern above. We should have a select.

define i64 @sext_sub_const_extra_use(i1 %A) {
; CHECK-LABEL: @sext_sub_const_extra_use(
; CHECK-NEXT:    [[EXT:%.*]] = sext i1 [[A:%.*]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i64 42, [[EXT]]
; CHECK-NEXT:    call void @use(i64 [[EXT]])
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ext = sext i1 %A to i64
  %sub = sub i64 42, %ext
  call void @use(i64 %ext)
  ret i64 %sub
}

define <2 x i64> @sext_sub_const_vec(<2 x i1> %A) {
; CHECK-LABEL: @sext_sub_const_vec(
; CHECK-NEXT:    [[SUB:%.*]] = select <2 x i1> [[A:%.*]], <2 x i64> <i64 43, i64 4>, <2 x i64> <i64 42, i64 3>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %ext = sext <2 x i1> %A to <2 x i64>
  %sub = sub <2 x i64> <i64 42, i64 3>, %ext
  ret <2 x i64> %sub
}

define <2 x i64> @sext_sub_const_vec_undef_elt(<2 x i1> %A) {
; CHECK-LABEL: @sext_sub_const_vec_undef_elt(
; CHECK-NEXT:    [[SUB:%.*]] = select <2 x i1> [[A:%.*]], <2 x i64> <i64 undef, i64 43>, <2 x i64> <i64 undef, i64 42>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %ext = sext <2 x i1> %A to <2 x i64>
  %sub = sub <2 x i64> <i64 undef, i64 42>, %ext
  ret <2 x i64> %sub
}

define i8 @sext_sub(i8 %x, i1 %y) {
; CHECK-LABEL: @sext_sub(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i1 [[Y:%.*]] to i8
; CHECK-NEXT:    [[SUB:%.*]] = add i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[SUB]]
;
  %sext = sext i1 %y to i8
  %sub = sub i8 %x, %sext
  ret i8 %sub
}

; Vectors get the same transform.

define <2 x i8> @sext_sub_vec(<2 x i8> %x, <2 x i1> %y) {
; CHECK-LABEL: @sext_sub_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = zext <2 x i1> [[Y:%.*]] to <2 x i8>
; CHECK-NEXT:    [[SUB:%.*]] = add <2 x i8> [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[SUB]]
;
  %sext = sext <2 x i1> %y to <2 x i8>
  %sub = sub <2 x i8> %x, %sext
  ret <2 x i8> %sub
}

; NSW is preserved.

define <2 x i8> @sext_sub_vec_nsw(<2 x i8> %x, <2 x i1> %y) {
; CHECK-LABEL: @sext_sub_vec_nsw(
; CHECK-NEXT:    [[TMP1:%.*]] = zext <2 x i1> [[Y:%.*]] to <2 x i8>
; CHECK-NEXT:    [[SUB:%.*]] = add nsw <2 x i8> [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[SUB]]
;
  %sext = sext <2 x i1> %y to <2 x i8>
  %sub = sub nsw <2 x i8> %x, %sext
  ret <2 x i8> %sub
}

; We favor the canonical zext+add over keeping the NUW.

define i8 @sext_sub_nuw(i8 %x, i1 %y) {
; CHECK-LABEL: @sext_sub_nuw(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i1 [[Y:%.*]] to i8
; CHECK-NEXT:    [[SUB:%.*]] = add i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[SUB]]
;
  %sext = sext i1 %y to i8
  %sub = sub nuw i8 %x, %sext
  ret i8 %sub
}

