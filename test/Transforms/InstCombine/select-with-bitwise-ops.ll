; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "n8:16:32:64"

define i32 @select_icmp_eq_and_1_0_or_2(i32 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_eq_and_1_0_or_2(
; CHECK-NEXT:    [[AND:%.*]] = shl i32 %x, 1
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[AND]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], %y
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %and = and i32 %x, 1
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 2
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

define i32 @select_icmp_eq_and_32_0_or_8(i32 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_eq_and_32_0_or_8(
; CHECK-NEXT:    [[AND:%.*]] = lshr i32 %x, 2
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[AND]], 8
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], %y
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %and = and i32 %x, 32
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 8
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

define i32 @select_icmp_ne_0_and_4096_or_4096(i32 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_ne_0_and_4096_or_4096(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 4096
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[AND]], 4096
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], %y
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %and = and i32 %x, 4096
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

define i32 @select_icmp_eq_and_4096_0_or_4096(i32 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_eq_and_4096_0_or_4096(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 4096
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[AND]], %y
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %and = and i32 %x, 4096
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

define i32 @select_icmp_eq_0_and_1_or_1(i64 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_eq_0_and_1_or_1(
; CHECK-NEXT:    [[X_TR:%.*]] = trunc i64 %x to i32
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X_TR]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], %y
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %and = and i64 %x, 1
  %cmp = icmp eq i64 %and, 0
  %or = or i32 %y, 1
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

define i32 @select_icmp_ne_0_and_4096_or_32(i32 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_ne_0_and_4096_or_32(
; CHECK-NEXT:    [[AND:%.*]] = lshr i32 %x, 7
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[AND]], 32
; CHECK-NEXT:    [[TMP2:%.*]] = xor i32 [[TMP1]], 32
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP2]], %y
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %and = and i32 %x, 4096
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 32
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

define i32 @select_icmp_ne_0_and_32_or_4096(i32 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_ne_0_and_32_or_4096(
; CHECK-NEXT:    [[AND:%.*]] = shl i32 %x, 7
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[AND]], 4096
; CHECK-NEXT:    [[TMP2:%.*]] = xor i32 [[TMP1]], 4096
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP2]], %y
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %and = and i32 %x, 32
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

define i8 @select_icmp_ne_0_and_1073741824_or_8(i32 %x, i8 %y) {
; CHECK-LABEL: @select_icmp_ne_0_and_1073741824_or_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 1073741824
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i8 %y, 8
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i8 [[OR]], i8 %y
; CHECK-NEXT:    ret i8 [[SELECT]]
;
  %and = and i32 %x, 1073741824
  %cmp = icmp ne i32 0, %and
  %or = or i8 %y, 8
  %select = select i1 %cmp, i8 %y, i8 %or
  ret i8 %select
}

define i32 @select_icmp_ne_0_and_8_or_1073741824(i8 %x, i32 %y) {
; CHECK-LABEL: @select_icmp_ne_0_and_8_or_1073741824(
; CHECK-NEXT:    [[AND:%.*]] = and i8 %x, 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 %y, 1073741824
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32 [[OR]], i32 %y
; CHECK-NEXT:    ret i32 [[SELECT]]
;
  %and = and i8 %x, 8
  %cmp = icmp ne i8 0, %and
  %or = or i32 %y, 1073741824
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

; We can't combine here, because the cmp is scalar and the or vector.
; Just make sure we don't assert.
define <2 x i32> @select_icmp_eq_and_1_0_or_vector_of_2s(i32 %x, <2 x i32> %y) {
; CHECK-LABEL: @select_icmp_eq_and_1_0_or_vector_of_2s(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or <2 x i32> %y, <i32 2, i32 2>
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], <2 x i32> %y, <2 x i32> [[OR]]
; CHECK-NEXT:    ret <2 x i32> [[SELECT]]
;
  %and = and i32 %x, 1
  %cmp = icmp eq i32 %and, 0
  %or = or <2 x i32> %y, <i32 2, i32 2>
  %select = select i1 %cmp, <2 x i32> %y, <2 x i32> %or
  ret <2 x i32> %select
}

define i32 @select_icmp_and_8_ne_0_xor_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_ne_0_xor_8(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %x, -9
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %xor = xor i32 %x, 8
  %x.xor = select i1 %cmp, i32 %x, i32 %xor
  ret i32 %x.xor
}

define i32 @select_icmp_and_8_eq_0_xor_8(i32 %x) {
; CHECK-LABEL: @select_icmp_and_8_eq_0_xor_8(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 %x, 8
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %xor = xor i32 %x, 8
  %xor.x = select i1 %cmp, i32 %xor, i32 %x
  ret i32 %xor.x
}

define i64 @select_icmp_x_and_8_eq_0_y_xor_8(i32 %x, i64 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_eq_0_y_xor_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[XOR:%.*]] = xor i64 %y, 8
; CHECK-NEXT:    [[Y_XOR:%.*]] = select i1 [[CMP]], i64 %y, i64 [[XOR]]
; CHECK-NEXT:    ret i64 [[Y_XOR]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %xor = xor i64 %y, 8
  %y.xor = select i1 %cmp, i64 %y, i64 %xor
  ret i64 %y.xor
}

define i64 @select_icmp_x_and_8_ne_0_y_xor_8(i32 %x, i64 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_ne_0_y_xor_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 8
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[XOR:%.*]] = xor i64 %y, 8
; CHECK-NEXT:    [[XOR_Y:%.*]] = select i1 [[CMP]], i64 [[XOR]], i64 %y
; CHECK-NEXT:    ret i64 [[XOR_Y]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %xor = xor i64 %y, 8
  %xor.y = select i1 %cmp, i64 %xor, i64 %y
  ret i64 %xor.y
}

define i64 @select_icmp_x_and_8_ne_0_y_or_8(i32 %x, i64 %y) {
; CHECK-LABEL: @select_icmp_x_and_8_ne_0_y_or_8(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 8
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[AND]], 8
; CHECK-NEXT:    [[TMP2:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    [[TMP3:%.*]] = or i64 [[TMP2]], %y
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %and = and i32 %x, 8
  %cmp = icmp eq i32 %and, 0
  %or = or i64 %y, 8
  %or.y = select i1 %cmp, i64 %or, i64 %y
  ret i64 %or.y
}

define i32 @select_icmp_and_2147483648_ne_0_xor_2147483648(i32 %x) {
; CHECK-LABEL: @select_icmp_and_2147483648_ne_0_xor_2147483648(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %x, 2147483647
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %and = and i32 %x, 2147483648
  %cmp = icmp eq i32 %and, 0
  %xor = xor i32 %x, 2147483648
  %x.xor = select i1 %cmp, i32 %x, i32 %xor
  ret i32 %x.xor
}

define i32 @select_icmp_and_2147483648_eq_0_xor_2147483648(i32 %x) {
; CHECK-LABEL: @select_icmp_and_2147483648_eq_0_xor_2147483648(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 %x, -2147483648
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %and = and i32 %x, 2147483648
  %cmp = icmp eq i32 %and, 0
  %xor = xor i32 %x, 2147483648
  %xor.x = select i1 %cmp, i32 %xor, i32 %x
  ret i32 %xor.x
}

define i32 @select_icmp_x_and_2147483648_ne_0_or_2147483648(i32 %x) {
; CHECK-LABEL: @select_icmp_x_and_2147483648_ne_0_or_2147483648(
; CHECK-NEXT:    [[OR:%.*]] = or i32 %x, -2147483648
; CHECK-NEXT:    ret i32 [[OR]]
;
  %and = and i32 %x, 2147483648
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %x, 2147483648
  %or.x = select i1 %cmp, i32 %or, i32 %x
  ret i32 %or.x
}

define i32 @test65(i64 %x) {
; CHECK-LABEL: @test65(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[X:%.*]], 3
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[TMP1]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = xor i32 [[TMP3]], 42
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %1 = and i64 %x, 16
  %2 = icmp ne i64 %1, 0
  %3 = select i1 %2, i32 40, i32 42
  ret i32 %3
}

define <2 x i32> @test65vec(<2 x i64> %x) {
; CHECK-LABEL: @test65vec(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i64> [[X:%.*]], <i64 3, i64 3>
; CHECK-NEXT:    [[TMP2:%.*]] = trunc <2 x i64> [[TMP1]] to <2 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i32> [[TMP2]], <i32 2, i32 2>
; CHECK-NEXT:    [[TMP4:%.*]] = xor <2 x i32> [[TMP3]], <i32 42, i32 42>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %1 = and <2 x i64> %x, <i64 16, i64 16>
  %2 = icmp ne <2 x i64> %1, zeroinitializer
  %3 = select <2 x i1> %2, <2 x i32> <i32 40, i32 40>, <2 x i32> <i32 42, i32 42>
  ret <2 x i32> %3
}

define i32 @test66(i64 %x) {
; CHECK-LABEL: @test66(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[X:%.*]], 31
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[TMP1]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = xor i32 [[TMP3]], 42
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %1 = and i64 %x, 4294967296
  %2 = icmp ne i64 %1, 0
  %3 = select i1 %2, i32 40, i32 42
  ret i32 %3
}

define <2 x i32> @test66vec(<2 x i64> %x) {
; CHECK-LABEL: @test66vec(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i64> [[X:%.*]], <i64 31, i64 31>
; CHECK-NEXT:    [[TMP2:%.*]] = trunc <2 x i64> [[TMP1]] to <2 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i32> [[TMP2]], <i32 2, i32 2>
; CHECK-NEXT:    [[TMP4:%.*]] = xor <2 x i32> [[TMP3]], <i32 42, i32 42>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %1 = and <2 x i64> %x, <i64 4294967296, i64 4294967296>
  %2 = icmp ne <2 x i64> %1, zeroinitializer
  %3 = select <2 x i1> %2, <2 x i32> <i32 40, i32 40>, <2 x i32> <i32 42, i32 42>
  ret <2 x i32> %3
}

; Make sure we don't try to optimize a scalar 'and' with a vector select.
define <2 x i32> @test66vec_scalar_and(i64 %x) {
; CHECK-LABEL: @test66vec_scalar_and(
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[X:%.*]], 4294967296
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i64 [[TMP1]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP2]], <2 x i32> <i32 42, i32 42>, <2 x i32> <i32 40, i32 40>
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %1 = and i64 %x, 4294967296
  %2 = icmp ne i64 %1, 0
  %3 = select i1 %2, <2 x i32> <i32 40, i32 40>, <2 x i32> <i32 42, i32 42>
  ret <2 x i32> %3
}

define i32 @test67(i16 %x) {
; CHECK-LABEL: @test67(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i16 %x, 1
; CHECK-NEXT:    [[TMP2:%.*]] = and i16 [[TMP1]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = xor i16 [[TMP2]], 42
; CHECK-NEXT:    [[TMP4:%.*]] = zext i16 [[TMP3]] to i32
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %1 = and i16 %x, 4
  %2 = icmp ne i16 %1, 0
  %3 = select i1 %2, i32 40, i32 42
  ret i32 %3
}

define <2 x i32> @test67vec(<2 x i16> %x) {
; CHECK-LABEL: @test67vec(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i16> [[X:%.*]], <i16 1, i16 1>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i16> [[TMP1]], <i16 2, i16 2>
; CHECK-NEXT:    [[TMP3:%.*]] = xor <2 x i16> [[TMP2]], <i16 42, i16 42>
; CHECK-NEXT:    [[TMP4:%.*]] = zext <2 x i16> [[TMP3]] to <2 x i32>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %1 = and <2 x i16> %x, <i16 4, i16 4>
  %2 = icmp ne <2 x i16> %1, zeroinitializer
  %3 = select <2 x i1> %2, <2 x i32> <i32 40, i32 40>, <2 x i32> <i32 42, i32 42>
  ret <2 x i32> %3
}

define i32 @test68(i32 %x, i32 %y) {
; CHECK-LABEL: @test68(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 6
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = or i32 [[TMP2]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %and = and i32 %x, 128
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 2
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

define i32 @test69(i32 %x, i32 %y) {
; CHECK-LABEL: @test69(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[X:%.*]], 6
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = xor i32 [[TMP2]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = or i32 [[TMP3]], [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[TMP4]]
;
  %and = and i32 %x, 128
  %cmp = icmp ne i32 %and, 0
  %or = or i32 %y, 2
  %select = select i1 %cmp, i32 %y, i32 %or
  ret i32 %select
}

; TODO: we should be able to remove this select
define i8 @test70(i8 %x, i8 %y) {
; CHECK-LABEL: @test70(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[Y:%.*]], 2
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i8 [[OR]], i8 [[Y]]
; CHECK-NEXT:    ret i8 [[SELECT]]
;
  %cmp = icmp slt i8 %x, 0
  %or = or i8 %y, 2
  %select = select i1 %cmp, i8 %or, i8 %y
  ret i8 %select
}

define i32 @shift_no_xor_multiuse_or(i32 %x, i32 %y) {
; CHECK-LABEL: @shift_no_xor_multiuse_or(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 2
; CHECK-NEXT:    [[AND:%.*]] = shl i32 [[X:%.*]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[AND]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], [[Y]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[TMP2]], [[OR]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %and = and i32 %x, 1
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 2
  %select = select i1 %cmp, i32 %y, i32 %or
  %res = mul i32 %select, %or ; to bump up use count of the Or
  ret i32 %res
}

define i32 @no_shift_no_xor_multiuse_or(i32 %x, i32 %y) {
; CHECK-LABEL: @no_shift_no_xor_multiuse_or(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 4096
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 4096
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[AND]], [[Y]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[TMP1]], [[OR]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %and = and i32 %x, 4096
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  %res = mul i32 %select, %or ; to bump up use count of the Or
  ret i32 %res
}

define i32 @no_shift_xor_multiuse_or(i32 %x, i32 %y) {
; CHECK-LABEL: @no_shift_xor_multiuse_or(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 4096
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 4096
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[AND]], 4096
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], [[Y]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[TMP2]], [[OR]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %and = and i32 %x, 4096
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  %res = mul i32 %select, %or ; to bump up use count of the Or
  ret i32 %res
}

define i32 @shift_xor_multiuse_or(i32 %x, i32 %y) {
; CHECK-LABEL: @shift_xor_multiuse_or(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 4096
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 %y, 2048
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32 [[OR]], i32 %y
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[SELECT]], [[OR]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %and = and i32 %x, 4096
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 2048
  %select = select i1 %cmp, i32 %y, i32 %or
  %res = mul i32 %select, %or ; to bump up use count of the Or
  ret i32 %res
}

define i32 @shift_no_xor_multiuse_cmp(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: @shift_no_xor_multiuse_cmp(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = shl nuw nsw i32 [[AND]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP]], i32 [[Z:%.*]], i32 [[W:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[TMP2]], [[SELECT2]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %and = and i32 %x, 1
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 2
  %select = select i1 %cmp, i32 %y, i32 %or
  %select2 = select i1 %cmp, i32 %z, i32 %w ; to bump up use count of the cmp
  %res = mul i32 %select, %select2
  ret i32 %res
}

define i32 @no_shift_no_xor_multiuse_cmp(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: @no_shift_no_xor_multiuse_cmp(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 4096
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[AND]], [[Y:%.*]]
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP]], i32 [[Z:%.*]], i32 [[W:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[TMP1]], [[SELECT2]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %and = and i32 %x, 4096
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  %select2 = select i1 %cmp, i32 %z, i32 %w ; to bump up use count of the cmp
  %res = mul i32 %select, %select2
  ret i32 %res
}

define i32 @no_shift_xor_multiuse_cmp(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: @no_shift_xor_multiuse_cmp(
; CHECK-NEXT:    [[AND:%.*]] = and i32 %x, 4096
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[AND]], 4096
; CHECK-NEXT:    [[TMP2:%.*]] = or i32 [[TMP1]], %y
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP]], i32 %w, i32 %z
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[TMP2]], [[SELECT2]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %and = and i32 %x, 4096
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  %select2 = select i1 %cmp, i32 %z, i32 %w ; to bump up use count of the cmp
  %res = mul i32 %select, %select2
  ret i32 %res
}

define i32 @shift_xor_multiuse_cmp(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: @shift_xor_multiuse_cmp(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 4096
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 2048
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32 [[Y]], i32 [[OR]]
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP]], i32 [[Z:%.*]], i32 [[W:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[SELECT]], [[SELECT2]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %and = and i32 %x, 4096
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 2048
  %select = select i1 %cmp, i32 %y, i32 %or
  %select2 = select i1 %cmp, i32 %z, i32 %w ; to bump up use count of the cmp
  %res = mul i32 %select, %select2
  ret i32 %res
}

define i32 @shift_no_xor_multiuse_cmp_or(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: @shift_no_xor_multiuse_cmp_or(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 2
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32 [[Y]], i32 [[OR]]
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP]], i32 [[Z:%.*]], i32 [[W:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[SELECT]], [[SELECT2]]
; CHECK-NEXT:    [[RES2:%.*]] = mul i32 [[RES]], [[OR]]
; CHECK-NEXT:    ret i32 [[RES2]]
;
  %and = and i32 %x, 1
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 2
  %select = select i1 %cmp, i32 %y, i32 %or
  %select2 = select i1 %cmp, i32 %z, i32 %w ; to bump up use count of the cmp
  %res = mul i32 %select, %select2
  %res2 = mul i32 %res, %or ; to bump up the use count of the or
  ret i32 %res2
}

define i32 @no_shift_no_xor_multiuse_cmp_or(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: @no_shift_no_xor_multiuse_cmp_or(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 4096
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 4096
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[AND]], [[Y]]
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP]], i32 [[Z:%.*]], i32 [[W:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[TMP1]], [[SELECT2]]
; CHECK-NEXT:    [[RES2:%.*]] = mul i32 [[RES]], [[OR]]
; CHECK-NEXT:    ret i32 [[RES2]]
;
  %and = and i32 %x, 4096
  %cmp = icmp eq i32 %and, 0
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  %select2 = select i1 %cmp, i32 %z, i32 %w ; to bump up use count of the cmp
  %res = mul i32 %select, %select2
  %res2 = mul i32 %res, %or ; to bump up the use count of the or
  ret i32 %res2
}

define i32 @no_shift_xor_multiuse_cmp_or(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: @no_shift_xor_multiuse_cmp_or(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 4096
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 4096
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32 [[Y]], i32 [[OR]]
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP]], i32 [[Z:%.*]], i32 [[W:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[SELECT]], [[SELECT2]]
; CHECK-NEXT:    [[RES2:%.*]] = mul i32 [[RES]], [[OR]]
; CHECK-NEXT:    ret i32 [[RES2]]
;
  %and = and i32 %x, 4096
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 4096
  %select = select i1 %cmp, i32 %y, i32 %or
  %select2 = select i1 %cmp, i32 %z, i32 %w ; to bump up use count of the cmp
  %res = mul i32 %select, %select2
  %res2 = mul i32 %res, %or ; to bump up the use count of the or
  ret i32 %res2
}

define i32 @shift_xor_multiuse_cmp_or(i32 %x, i32 %y, i32 %z, i32 %w) {
; CHECK-LABEL: @shift_xor_multiuse_cmp_or(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 4096
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i32 [[AND]], 0
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 2048
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32 [[Y]], i32 [[OR]]
; CHECK-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP]], i32 [[Z:%.*]], i32 [[W:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[SELECT]], [[SELECT2]]
; CHECK-NEXT:    [[RES2:%.*]] = mul i32 [[RES]], [[OR]]
; CHECK-NEXT:    ret i32 [[RES2]]
;
  %and = and i32 %x, 4096
  %cmp = icmp ne i32 0, %and
  %or = or i32 %y, 2048
  %select = select i1 %cmp, i32 %y, i32 %or
  %select2 = select i1 %cmp, i32 %z, i32 %w ; to bump up use count of the cmp
  %res = mul i32 %select, %select2
  %res2 = mul i32 %res, %or ; to bump up the use count of the or
  ret i32 %res2
}
