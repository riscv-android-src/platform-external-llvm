; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @test_sext1(i32 %a, i32 %b) {
; CHECK-LABEL: @test_sext1(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCAX:%.*]] = sext i1 [[CCA]] to i32
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], i32 [[CCAX]], i32 0
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = sext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %r = select i1 %ccb, i32 %ccax, i32 0
  ret i32 %r
}

define i32 @test_sext2(i32 %a, i32 %b) {
; CHECK-LABEL: @test_sext2(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCAX:%.*]] = sext i1 [[CCA]] to i32
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], i32 -1, i32 [[CCAX]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = sext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %r = select i1 %ccb, i32 -1, i32 %ccax
  ret i32 %r
}

define i32 @test_sext3(i32 %a, i32 %b) {
; CHECK-LABEL: @test_sext3(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCAX:%.*]] = sext i1 [[CCA]] to i32
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], i32 0, i32 [[CCAX]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = sext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %r = select i1 %ccb, i32 0, i32 %ccax
  ret i32 %r
}

define i32 @test_sext4(i32 %a, i32 %b) {
; CHECK-LABEL: @test_sext4(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCAX:%.*]] = sext i1 [[CCA]] to i32
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], i32 [[CCAX]], i32 -1
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = sext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %r = select i1 %ccb, i32 %ccax, i32 -1
  ret i32 %r
}

define i32 @test_zext1(i32 %a, i32 %b) {
; CHECK-LABEL: @test_zext1(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCAX:%.*]] = zext i1 [[CCA]] to i32
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], i32 [[CCAX]], i32 0
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = zext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %r = select i1 %ccb, i32 %ccax, i32 0
  ret i32 %r
}

define i32 @test_zext2(i32 %a, i32 %b) {
; CHECK-LABEL: @test_zext2(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCAX:%.*]] = zext i1 [[CCA]] to i32
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], i32 1, i32 [[CCAX]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = zext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %r = select i1 %ccb, i32 1, i32 %ccax
  ret i32 %r
}

define i32 @test_zext3(i32 %a, i32 %b) {
; CHECK-LABEL: @test_zext3(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCAX:%.*]] = zext i1 [[CCA]] to i32
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], i32 0, i32 [[CCAX]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = zext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %r = select i1 %ccb, i32 0, i32 %ccax
  ret i32 %r
}

define i32 @test_zext4(i32 %a, i32 %b) {
; CHECK-LABEL: @test_zext4(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCAX:%.*]] = zext i1 [[CCA]] to i32
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], i32 [[CCAX]], i32 1
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = zext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %r = select i1 %ccb, i32 %ccax, i32 1
  ret i32 %r
}

define i32 @test_negative_sext(i1 %a, i1 %cc) {
; CHECK-LABEL: @test_negative_sext(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext i1 %a to i32
; CHECK-NEXT:    [[R:%.*]] = select i1 %cc, i32 [[A_EXT]], i32 1
; CHECK-NEXT:    ret i32 [[R]]
;
  %a.ext = sext i1 %a to i32
  %r = select i1 %cc, i32 %a.ext, i32 1
  ret i32 %r
}

define i32 @test_negative_zext(i1 %a, i1 %cc) {
; CHECK-LABEL: @test_negative_zext(
; CHECK-NEXT:    [[A_EXT:%.*]] = zext i1 %a to i32
; CHECK-NEXT:    [[R:%.*]] = select i1 %cc, i32 [[A_EXT]], i32 -1
; CHECK-NEXT:    ret i32 [[R]]
;
  %a.ext = zext i1 %a to i32
  %r = select i1 %cc, i32 %a.ext, i32 -1
  ret i32 %r
}

define i32 @test_bits_sext(i8 %a, i1 %cc) {
; CHECK-LABEL: @test_bits_sext(
; CHECK-NEXT:    [[A_EXT:%.*]] = sext i8 %a to i32
; CHECK-NEXT:    [[R:%.*]] = select i1 %cc, i32 [[A_EXT]], i32 -128
; CHECK-NEXT:    ret i32 [[R]]
;
  %a.ext = sext i8 %a to i32
  %r = select i1 %cc, i32 %a.ext, i32 -128
  ret i32 %r
}

define i32 @test_bits_zext(i8 %a, i1 %cc) {
; CHECK-LABEL: @test_bits_zext(
; CHECK-NEXT:    [[A_EXT:%.*]] = zext i8 %a to i32
; CHECK-NEXT:    [[R:%.*]] = select i1 %cc, i32 [[A_EXT]], i32 255
; CHECK-NEXT:    ret i32 [[R]]
;
  %a.ext = zext i8 %a to i32
  %r = select i1 %cc, i32 %a.ext, i32 255
  ret i32 %r
}

define i32 @test_op_op(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @test_op_op(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt i32 %a, 0
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %b, 0
; CHECK-NEXT:    [[CCC:%.*]] = icmp sgt i32 %c, 0
; CHECK-NEXT:    [[R_V:%.*]] = select i1 [[CCC]], i1 [[CCA]], i1 [[CCB]]
; CHECK-NEXT:    [[R:%.*]] = sext i1 [[R:%.*]].v to i32
; CHECK-NEXT:    ret i32 [[R]]
;
  %cca = icmp sgt i32 %a, 0
  %ccax = sext i1 %cca to i32
  %ccb = icmp sgt i32 %b, 0
  %ccbx = sext i1 %ccb to i32
  %ccc = icmp sgt i32 %c, 0
  %r = select i1 %ccc, i32 %ccax, i32 %ccbx
  ret i32 %r
}

define <2 x i32> @test_no_vectors1(<2 x i32> %a, <2 x i32> %b, <2 x i32> %c) {
; CHECK-LABEL: @test_no_vectors1(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt <2 x i32> %a, %b
; CHECK-NEXT:    [[CCAX:%.*]] = sext <2 x i1> [[CCA]] to <2 x i32>
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt <2 x i32> %b, %c
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[CCB]], <2 x i32> [[CCAX]], <2 x i32> zeroinitializer
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %cca = icmp sgt <2 x i32> %a, %b
  %ccax = sext <2 x i1> %cca to <2 x i32>
  %ccb = icmp sgt <2 x i32> %b, %c
  %r = select <2 x i1> %ccb, <2 x i32> %ccax, <2 x i32> <i32 0, i32 0>
  ret <2 x i32> %r
}

define <2 x i32> @test_no_vectors2(<2 x i32> %a, <2 x i32> %b, i32 %c) {
; CHECK-LABEL: @test_no_vectors2(
; CHECK-NEXT:    [[CCA:%.*]] = icmp sgt <2 x i32> %a, %b
; CHECK-NEXT:    [[CCAX:%.*]] = sext <2 x i1> [[CCA]] to <2 x i32>
; CHECK-NEXT:    [[CCB:%.*]] = icmp sgt i32 %c, 0
; CHECK-NEXT:    [[R:%.*]] = select i1 [[CCB]], <2 x i32> [[CCAX]], <2 x i32> zeroinitializer
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %cca = icmp sgt <2 x i32> %a, %b
  %ccax = sext <2 x i1> %cca to <2 x i32>
  %ccb = icmp sgt i32 %c, 0
  %r = select i1 %ccb, <2 x i32> %ccax, <2 x i32> <i32 0, i32 0>
  ret <2 x i32> %r
}
