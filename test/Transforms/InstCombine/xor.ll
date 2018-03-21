; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

@G1 = global i32 0
@G2 = global i32 0

define i1 @test0(i1 %A) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:    ret i1 %A
;
  %B = xor i1 %A, false
  ret i1 %B
}

define i32 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 %A
;
  %B = xor i32 %A, 0
  ret i32 %B
}

define i1 @test2(i1 %A) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i1 false
;
  %B = xor i1 %A, %A
  ret i1 %B
}

define i32 @test3(i32 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i32 0
;
  %B = xor i32 %A, %A
  ret i32 %B
}

define i32 @test4(i32 %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret i32 -1
;
  %NotA = xor i32 -1, %A
  %B = xor i32 %A, %NotA
  ret i32 %B
}

define i32 @test5(i32 %A) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 %A, -124
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %t1 = or i32 %A, 123
  %r = xor i32 %t1, 123
  ret i32 %r
}

define i8 @test6(i8 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i8 %A
;
  %B = xor i8 %A, 17
  %C = xor i8 %B, 17
  ret i8 %C
}

define i32 @test7(i32 %A, i32 %B) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[A1:%.*]] = and i32 %A, 7
; CHECK-NEXT:    [[B1:%.*]] = and i32 %B, 128
; CHECK-NEXT:    [[C11:%.*]] = or i32 [[A1]], [[B1]]
; CHECK-NEXT:    ret i32 [[C11]]
;
  %A1 = and i32 %A, 7
  %B1 = and i32 %B, 128
  %C1 = xor i32 %A1, %B1
  ret i32 %C1
}

define i8 @test8(i1 %c) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    br i1 %c, label %False, label %True
; CHECK:       True:
; CHECK-NEXT:    ret i8 1
; CHECK:       False:
; CHECK-NEXT:    ret i8 3
;
  %d = xor i1 %c, true
  br i1 %d, label %True, label %False

True:
  ret i8 1

False:
  ret i8 3
}

define i1 @test9(i8 %A) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 %A, 89
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = xor i8 %A, 123
  %C = icmp eq i8 %B, 34
  ret i1 %C
}

define <2 x i1> @test9vec(<2 x i8> %a) {
; CHECK-LABEL: @test9vec(
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i8> %a, <i8 89, i8 89>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = xor <2 x i8> %a, <i8 123, i8 123>
  %c = icmp eq <2 x i8> %b, <i8 34, i8 34>
  ret <2 x i1> %c
}

define i8 @test10(i8 %A) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[B:%.*]] = and i8 %A, 3
; CHECK-NEXT:    [[C1:%.*]] = or i8 [[B]], 4
; CHECK-NEXT:    ret i8 [[C1]]
;
  %B = and i8 %A, 3
  %C = xor i8 %B, 4
  ret i8 %C
}

define i8 @test11(i8 %A) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[B:%.*]] = and i8 %A, -13
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[B]], 8
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %B = or i8 %A, 12
  %C = xor i8 %B, 4
  ret i8 %C
}

define i1 @test12(i8 %A) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 %A, 4
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = xor i8 %A, 4
  %c = icmp ne i8 %B, 0
  ret i1 %c
}

define <2 x i1> @test12vec(<2 x i8> %a) {
; CHECK-LABEL: @test12vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i8> %a, <i8 4, i8 4>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = xor <2 x i8> %a, <i8 4, i8 4>
  %c = icmp ne <2 x i8> %b, zeroinitializer
  ret <2 x i1> %c
}

define i32 @test15(i32 %A) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[C:%.*]] = sub i32 0, %A
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = add i32 %A, -1
  %C = xor i32 %B, -1
  ret i32 %C
}

define <2 x i32> @test15vec(<2 x i32> %A) {
; CHECK-LABEL: @test15vec(
; CHECK-NEXT:    [[C:%.*]] = sub <2 x i32> zeroinitializer, [[A:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[C]]
;
  %B = add <2 x i32> %A, <i32 -1, i32 -1>
  %C = xor <2 x i32> %B, <i32 -1, i32 -1>
  ret <2 x i32> %C
}

define i32 @test16(i32 %A) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[C:%.*]] = sub i32 -124, %A
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = add i32 %A, 123
  %C = xor i32 %B, -1
  ret i32 %C
}

define <2 x i32> @test16vec(<2 x i32> %A) {
; CHECK-LABEL: @test16vec(
; CHECK-NEXT:    [[C:%.*]] = sub <2 x i32> <i32 -124, i32 -124>, [[A:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[C]]
;
  %B = add <2 x i32> %A, <i32 123, i32 123>
  %C = xor <2 x i32> %B, <i32 -1, i32 -1>
  ret <2 x i32> %C
}

define i32 @test17(i32 %A) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[C:%.*]] = add i32 %A, -124
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = sub i32 123, %A
  %C = xor i32 %B, -1
  ret i32 %C
}

define <2 x i32> @test17vec(<2 x i32> %A) {
; CHECK-LABEL: @test17vec(
; CHECK-NEXT:    [[C:%.*]] = add <2 x i32> [[A:%.*]], <i32 -124, i32 -124>
; CHECK-NEXT:    ret <2 x i32> [[C]]
;
  %B = sub <2 x i32> <i32 123, i32 123>, %A
  %C = xor <2 x i32> %B, <i32 -1, i32 -1>
  ret <2 x i32> %C
}

define i32 @test18(i32 %A) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[C:%.*]] = add i32 %A, 124
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = xor i32 %A, -1
  %C = sub i32 123, %B
  ret i32 %C
}

define i32 @test19(i32 %A, i32 %B) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    ret i32 %B
;
  %C = xor i32 %A, %B
  %D = xor i32 %C, %A
  ret i32 %D
}

define void @test20(i32 %A, i32 %B) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    store i32 %B, i32* @G1, align 4
; CHECK-NEXT:    store i32 %A, i32* @G2, align 4
; CHECK-NEXT:    ret void
;
  %t2 = xor i32 %B, %A
  %t5 = xor i32 %t2, %B
  %t8 = xor i32 %t5, %t2
  store i32 %t8, i32* @G1
  store i32 %t5, i32* @G2
  ret void
}

define i32 @test21(i1 %C, i32 %A, i32 %B) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    [[D:%.*]] = select i1 %C, i32 %B, i32 %A
; CHECK-NEXT:    ret i32 [[D]]
;
  %C2 = xor i1 %C, true
  %D = select i1 %C2, i32 %A, i32 %B
  ret i32 %D
}

define i32 @test22(i1 %X) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    [[Z:%.*]] = zext i1 %X to i32
; CHECK-NEXT:    ret i32 [[Z]]
;
  %Y = xor i1 %X, true
  %Z = zext i1 %Y to i32
  %Q = xor i32 %Z, 1
  ret i32 %Q
}

; Look through a zext between xors.

define i32 @fold_zext_xor_sandwich(i1 %X) {
; CHECK-LABEL: @fold_zext_xor_sandwich(
; CHECK-NEXT:    [[Z:%.*]] = zext i1 %X to i32
; CHECK-NEXT:    [[Q:%.*]] = xor i32 [[Z]], 3
; CHECK-NEXT:    ret i32 [[Q]]
;
  %Y = xor i1 %X, true
  %Z = zext i1 %Y to i32
  %Q = xor i32 %Z, 2
  ret i32 %Q
}

define <2 x i32> @fold_zext_xor_sandwich_vec(<2 x i1> %X) {
; CHECK-LABEL: @fold_zext_xor_sandwich_vec(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i1> %X to <2 x i32>
; CHECK-NEXT:    [[Q:%.*]] = xor <2 x i32> [[Z]], <i32 3, i32 3>
; CHECK-NEXT:    ret <2 x i32> [[Q]]
;
  %Y = xor <2 x i1> %X, <i1 true, i1 true>
  %Z = zext <2 x i1> %Y to <2 x i32>
  %Q = xor <2 x i32> %Z, <i32 2, i32 2>
  ret <2 x i32> %Q
}

define i1 @test23(i32 %a, i32 %b) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    [[T4:%.*]] = icmp eq i32 %b, 0
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t2 = xor i32 %b, %a
  %t4 = icmp eq i32 %t2, %a
  ret i1 %t4
}

define i1 @test24(i32 %c, i32 %d) {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    [[T4:%.*]] = icmp ne i32 %d, 0
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t2 = xor i32 %d, %c
  %t4 = icmp ne i32 %t2, %c
  ret i1 %t4
}

define i32 @test25(i32 %g, i32 %h) {
; CHECK-LABEL: @test25(
; CHECK-NEXT:    [[T4:%.*]] = and i32 %h, %g
; CHECK-NEXT:    ret i32 [[T4]]
;
  %h2 = xor i32 %h, -1
  %t2 = and i32 %h2, %g
  %t4 = xor i32 %t2, %g
  ret i32 %t4
}

define i32 @test26(i32 %a, i32 %b) {
; CHECK-LABEL: @test26(
; CHECK-NEXT:    [[T4:%.*]] = and i32 %b, %a
; CHECK-NEXT:    ret i32 [[T4]]
;
  %b2 = xor i32 %b, -1
  %t2 = xor i32 %a, %b2
  %t4 = and i32 %t2, %a
  ret i32 %t4
}

define i32 @test27(i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @test27(
; CHECK-NEXT:    [[T6:%.*]] = icmp eq i32 %b, %c
; CHECK-NEXT:    [[T7:%.*]] = zext i1 [[T6]] to i32
; CHECK-NEXT:    ret i32 [[T7]]
;
  %t2 = xor i32 %d, %b
  %t5 = xor i32 %d, %c
  %t6 = icmp eq i32 %t2, %t5
  %t7 = zext i1 %t6 to i32
  ret i32 %t7
}

define i32 @test28(i32 %indvar) {
; CHECK-LABEL: @test28(
; CHECK-NEXT:    [[T214:%.*]] = add i32 %indvar, 1
; CHECK-NEXT:    ret i32 [[T214]]
;
  %t7 = add i32 %indvar, -2147483647
  %t214 = xor i32 %t7, -2147483648
  ret i32 %t214
}

define <2 x i32> @test28vec(<2 x i32> %indvar) {
; CHECK-LABEL: @test28vec(
; CHECK-NEXT:    [[T214:%.*]] = add <2 x i32> [[INDVAR:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    ret <2 x i32> [[T214]]
;
  %t7 = add <2 x i32> %indvar, <i32 -2147483647, i32 -2147483647>
  %t214 = xor <2 x i32> %t7, <i32 -2147483648, i32 -2147483648>
  ret <2 x i32> %t214
}

define i32 @test28_sub(i32 %indvar) {
; CHECK-LABEL: @test28_sub(
; CHECK-NEXT:    [[T214:%.*]] = sub i32 1, [[INDVAR:%.*]]
; CHECK-NEXT:    ret i32 [[T214]]
;
  %t7 = sub i32 -2147483647, %indvar
  %t214 = xor i32 %t7, -2147483648
  ret i32 %t214
}

define <2 x i32> @test28_subvec(<2 x i32> %indvar) {
; CHECK-LABEL: @test28_subvec(
; CHECK-NEXT:    [[T214:%.*]] = sub <2 x i32> <i32 1, i32 1>, [[INDVAR:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[T214]]
;
  %t7 = sub <2 x i32> <i32 -2147483647, i32 -2147483647>, %indvar
  %t214 = xor <2 x i32> %t7, <i32 -2147483648, i32 -2147483648>
  ret <2 x i32> %t214
}

define i32 @test29(i1 %C) {
; CHECK-LABEL: @test29(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[C:%.*]], i32 915, i32 113
; CHECK-NEXT:    ret i32 [[V]]
;
  %A = select i1 %C, i32 1000, i32 10
  %V = xor i32 %A, 123
  ret i32 %V
}

define <2 x i32> @test29vec(i1 %C) {
; CHECK-LABEL: @test29vec(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[C:%.*]], <2 x i32> <i32 915, i32 915>, <2 x i32> <i32 113, i32 113>
; CHECK-NEXT:    ret <2 x i32> [[V]]
;
  %A = select i1 %C, <2 x i32> <i32 1000, i32 1000>, <2 x i32> <i32 10, i32 10>
  %V = xor <2 x i32> %A, <i32 123, i32 123>
  ret <2 x i32> %V
}

define <2 x i32> @test29vec2(i1 %C) {
; CHECK-LABEL: @test29vec2(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[C:%.*]], <2 x i32> <i32 915, i32 2185>, <2 x i32> <i32 113, i32 339>
; CHECK-NEXT:    ret <2 x i32> [[V]]
;
  %A = select i1 %C, <2 x i32> <i32 1000, i32 2500>, <2 x i32> <i32 10, i32 30>
  %V = xor <2 x i32> %A, <i32 123, i32 333>
  ret <2 x i32> %V
}

define i32 @test30(i1 %which) {
; CHECK-LABEL: @test30(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ 915, [[ENTRY:%.*]] ], [ 113, [[DELAY]] ]
; CHECK-NEXT:    ret i32 [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi i32 [ 1000, %entry ], [ 10, %delay ]
  %value = xor i32 %A, 123
  ret i32 %value
}

define <2 x i32> @test30vec(i1 %which) {
; CHECK-LABEL: @test30vec(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi <2 x i32> [ <i32 915, i32 915>, [[ENTRY:%.*]] ], [ <i32 113, i32 113>, [[DELAY]] ]
; CHECK-NEXT:    ret <2 x i32> [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi <2 x i32> [ <i32 1000, i32 1000>, %entry ], [ <i32 10, i32 10>, %delay ]
  %value = xor <2 x i32> %A, <i32 123, i32 123>
  ret <2 x i32> %value
}

define <2 x i32> @test30vec2(i1 %which) {
; CHECK-LABEL: @test30vec2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi <2 x i32> [ <i32 915, i32 2185>, [[ENTRY:%.*]] ], [ <i32 113, i32 339>, [[DELAY]] ]
; CHECK-NEXT:    ret <2 x i32> [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi <2 x i32> [ <i32 1000, i32 2500>, %entry ], [ <i32 10, i32 30>, %delay ]
  %value = xor <2 x i32> %A, <i32 123, i32 333>
  ret <2 x i32> %value
}

define i32 @test31(i32 %A, i32 %B) {
; CHECK-LABEL: @test31(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[B:%.*]], -1
; CHECK-NEXT:    [[XOR:%.*]] = and i32 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = or i32 %A, %B
  %xor = xor i32 %B, %and
  ret i32 %xor
}

define i32 @test32(i32 %A, i32 %B) {
; CHECK-LABEL: @test32(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[B:%.*]], -1
; CHECK-NEXT:    [[XOR:%.*]] = and i32 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = or i32 %B, %A
  %xor = xor i32 %B, %and
  ret i32 %xor
}

define i32 @test33(i32 %A, i32 %B) {
; CHECK-LABEL: @test33(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[B:%.*]], -1
; CHECK-NEXT:    [[XOR:%.*]] = and i32 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = or i32 %A, %B
  %xor = xor i32 %and, %B
  ret i32 %xor
}

define i32 @test34(i32 %A, i32 %B) {
; CHECK-LABEL: @test34(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[B:%.*]], -1
; CHECK-NEXT:    [[XOR:%.*]] = and i32 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = or i32 %B, %A
  %xor = xor i32 %and, %B
  ret i32 %xor
}

define i32 @test35(i32 %A, i32 %B) {
; CHECK-LABEL: @test35(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[XOR:%.*]] = and i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %A, %B
  %xor = xor i32 %B, %and
  ret i32 %xor
}

define i32 @test36(i32 %A, i32 %B) {
; CHECK-LABEL: @test36(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[XOR:%.*]] = and i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %B, %A
  %xor = xor i32 %B, %and
  ret i32 %xor
}

define i32 @test37(i32 %A, i32 %B) {
; CHECK-LABEL: @test37(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[XOR:%.*]] = and i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %A, %B
  %xor = xor i32 %and, %B
  ret i32 %xor
}

define i32 @test38(i32 %A, i32 %B) {
; CHECK-LABEL: @test38(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A:%.*]], -1
; CHECK-NEXT:    [[XOR:%.*]] = and i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[XOR]]
;
  %and = and i32 %B, %A
  %xor = xor i32 %and, %B
  ret i32 %xor
}
