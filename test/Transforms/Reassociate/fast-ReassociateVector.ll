; RUN: opt < %s -reassociate -S | FileCheck %s

; Check that a*c+b*c is turned into (a+b)*c

define <4 x float> @test1(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[TMP:%.*]] = fadd fast <4 x float> %b, %a
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <4 x float> [[TMP]], %c
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %mul = fmul fast <4 x float> %a, %c
  %mul1 = fmul fast <4 x float> %b, %c
  %add = fadd fast <4 x float> %mul, %mul1
  ret <4 x float> %add
}

; Check that a*c+b*c is turned into (a+b)*c - minimum FMF subset version

define <4 x float> @test1_reassoc(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: @test1_reassoc(
; CHECK-NEXT:    [[MUL:%.*]] = fmul reassoc <4 x float> %a, %c
; CHECK-NEXT:    [[MUL1:%.*]] = fmul reassoc <4 x float> %b, %c
; CHECK-NEXT:    [[ADD:%.*]] = fadd reassoc <4 x float> [[MUL]], [[MUL1]]
; CHECK-NEXT:    ret <4 x float> [[ADD]]
;
  %mul = fmul reassoc <4 x float> %a, %c
  %mul1 = fmul reassoc <4 x float> %b, %c
  %add = fadd reassoc <4 x float> %mul, %mul1
  ret <4 x float> %add
}

; Check that a*a*b+a*a*c is turned into a*(a*(b+c)).

define <2 x float> @test2(<2 x float> %a, <2 x float> %b, <2 x float> %c) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[TMP2:%.*]] = fadd fast <2 x float> %c, %b
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast <2 x float> %a, %a
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <2 x float> [[TMP3]], [[TMP2]]
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %t0 = fmul fast <2 x float> %a, %b
  %t1 = fmul fast <2 x float> %a, %t0
  %t2 = fmul fast <2 x float> %a, %c
  %t3 = fmul fast <2 x float> %a, %t2
  %t4 = fadd fast <2 x float> %t1, %t3
  ret <2 x float> %t4
}

; Check that a*a*b+a*a*c is turned into a*(a*(b+c)) - minimum FMF subset version

define <2 x float> @test2_reassoc(<2 x float> %a, <2 x float> %b, <2 x float> %c) {
; CHECK-LABEL: @test2_reassoc(
; CHECK-NEXT:    [[T0:%.*]] = fmul reassoc <2 x float> %a, %b
; CHECK-NEXT:    [[T1:%.*]] = fmul reassoc <2 x float> %a, [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = fmul reassoc <2 x float> %a, %c
; CHECK-NEXT:    [[T3:%.*]] = fmul reassoc <2 x float> %a, [[T2]]
; CHECK-NEXT:    [[T4:%.*]] = fadd reassoc <2 x float> [[T1]], [[T3]]
; CHECK-NEXT:    ret <2 x float> [[T4]]
;
  %t0 = fmul reassoc <2 x float> %a, %b
  %t1 = fmul reassoc <2 x float> %a, %t0
  %t2 = fmul reassoc <2 x float> %a, %c
  %t3 = fmul reassoc <2 x float> %a, %t2
  %t4 = fadd reassoc <2 x float> %t1, %t3
  ret <2 x float> %t4
}

; Check that a*b+a*c+d is turned into a*(b+c)+d.

define <2 x double> @test3(<2 x double> %a, <2 x double> %b, <2 x double> %c, <2 x double> %d) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[TMP:%.*]] = fadd fast <2 x double> %c, %b
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <2 x double> [[TMP]], %a
; CHECK-NEXT:    [[T3:%.*]] = fadd fast <2 x double> [[TMP1]], %d
; CHECK-NEXT:    ret <2 x double> [[T3]]
;
  %t0 = fmul fast <2 x double> %a, %b
  %t1 = fmul fast <2 x double> %a, %c
  %t2 = fadd fast <2 x double> %t1, %d
  %t3 = fadd fast <2 x double> %t0, %t2
  ret <2 x double> %t3
}

; Check that a*b+a*c+d is turned into a*(b+c)+d - minimum FMF subset version

define <2 x double> @test3_reassoc(<2 x double> %a, <2 x double> %b, <2 x double> %c, <2 x double> %d) {
; CHECK-LABEL: @test3_reassoc(
; CHECK-NEXT:    [[T0:%.*]] = fmul reassoc <2 x double> %a, %b
; CHECK-NEXT:    [[T1:%.*]] = fmul reassoc <2 x double> %a, %c
; CHECK-NEXT:    [[T2:%.*]] = fadd reassoc <2 x double> [[T1]], %d
; CHECK-NEXT:    [[T3:%.*]] = fadd reassoc <2 x double> [[T0]], [[T2]]
; CHECK-NEXT:    ret <2 x double> [[T3]]
;
  %t0 = fmul reassoc <2 x double> %a, %b
  %t1 = fmul reassoc <2 x double> %a, %c
  %t2 = fadd reassoc <2 x double> %t1, %d
  %t3 = fadd reassoc <2 x double> %t0, %t2
  ret <2 x double> %t3
}

; No fast-math.

define <2 x float> @test4(<2 x float> %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[X:%.*]] = fadd <2 x float> %A, <float 1.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    [[Y:%.*]] = fadd <2 x float> %A, <float 1.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    [[R:%.*]] = fsub <2 x float> [[X]], [[Y]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %X = fadd <2 x float> %A, < float 1.000000e+00, float 1.000000e+00 >
  %Y = fadd <2 x float> %A, < float 1.000000e+00, float 1.000000e+00 >
  %R = fsub <2 x float> %X, %Y
  ret <2 x float> %R
}

; Check 47*X + 47*X -> 94*X.

define <2 x float> @test5(<2 x float> %X) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[FACTOR:%.*]] = fmul fast <2 x float> %X, <float 9.400000e+01, float 9.400000e+01>
; CHECK-NEXT:    ret <2 x float> [[FACTOR]]
;
  %Y = fmul fast <2 x float> %X, <float 4.700000e+01, float 4.700000e+01>
  %Z = fadd fast <2 x float> %Y, %Y
  ret <2 x float> %Z
}

; Check 47*X + 47*X -> 94*X - minimum FMF subset version

define <2 x float> @test5_reassoc(<2 x float> %X) {
; CHECK-LABEL: @test5_reassoc(
; CHECK-NEXT:    [[Y:%.*]] = fmul reassoc <2 x float> %X, <float 4.700000e+01, float 4.700000e+01>
; CHECK-NEXT:    [[Z:%.*]] = fadd reassoc <2 x float> [[Y]], [[Y]]
; CHECK-NEXT:    ret <2 x float> [[Z]]
;
  %Y = fmul reassoc <2 x float> %X, <float 4.700000e+01, float 4.700000e+01>
  %Z = fadd reassoc <2 x float> %Y, %Y
  ret <2 x float> %Z
}

; Check X+X+X -> 3*X.

define <2 x float> @test6(<2 x float> %X) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[FACTOR:%.*]] = fmul fast <2 x float> %X, <float 3.000000e+00, float 3.000000e+00>
; CHECK-NEXT:    ret <2 x float> [[FACTOR]]
;
  %Y = fadd fast <2 x float> %X ,%X
  %Z = fadd fast <2 x float> %Y, %X
  ret <2 x float> %Z
}

; Check X+X+X -> 3*X - minimum FMF subset version

define <2 x float> @test6_reassoc(<2 x float> %X) {
; CHECK-LABEL: @test6_reassoc(
; CHECK-NEXT:    [[Y:%.*]] = fadd reassoc <2 x float> %X, %X
; CHECK-NEXT:    [[Z:%.*]] = fadd reassoc <2 x float> %X, [[Y]]
; CHECK-NEXT:    ret <2 x float> [[Z]]
;
  %Y = fadd reassoc <2 x float> %X ,%X
  %Z = fadd reassoc <2 x float> %Y, %X
  ret <2 x float> %Z
}

; Check 127*W+50*W -> 177*W.

define <2 x double> @test7(<2 x double> %W) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <2 x double> %W, <double 1.770000e+02, double 1.770000e+02>
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %X = fmul fast <2 x double> %W, <double 127.0, double 127.0>
  %Y = fmul fast <2 x double> %W, <double 50.0, double 50.0>
  %Z = fadd fast <2 x double> %Y, %X
  ret <2 x double> %Z
}

; Check 127*W+50*W -> 177*W - minimum FMF subset version

define <2 x double> @test7_reassoc(<2 x double> %W) {
; CHECK-LABEL: @test7_reassoc(
; CHECK-NEXT:    [[X:%.*]] = fmul reassoc <2 x double> %W, <double 1.270000e+02, double 1.270000e+02>
; CHECK-NEXT:    [[Y:%.*]] = fmul reassoc <2 x double> %W, <double 5.000000e+01, double 5.000000e+01>
; CHECK-NEXT:    [[Z:%.*]] = fadd reassoc <2 x double> [[Y]], [[X]]
; CHECK-NEXT:    ret <2 x double> [[Z]]
;
  %X = fmul reassoc <2 x double> %W, <double 127.0, double 127.0>
  %Y = fmul reassoc <2 x double> %W, <double 50.0, double 50.0>
  %Z = fadd reassoc <2 x double> %Y, %X
  ret <2 x double> %Z
}

; Check X*12*12 -> X*144.

define <2 x float> @test8(<2 x float> %arg) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <2 x float> %arg, <float 1.440000e+02, float 1.440000e+02>
; CHECK-NEXT:    ret <2 x float> [[TMP2]]
;
  %tmp1 = fmul fast <2 x float> <float 1.200000e+01, float 1.200000e+01>, %arg
  %tmp2 = fmul fast <2 x float> %tmp1, <float 1.200000e+01, float 1.200000e+01>
  ret <2 x float> %tmp2
}

; Check X*12*12 -> X*144 - minimum FMF subset version

define <2 x float> @test8_reassoc(<2 x float> %arg) {
; CHECK-LABEL: @test8_reassoc(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul reassoc <2 x float> %arg, <float 1.200000e+01, float 1.200000e+01>
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc <2 x float> [[TMP1]], <float 1.200000e+01, float 1.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[TMP2]]
;
  %tmp1 = fmul reassoc <2 x float> <float 1.200000e+01, float 1.200000e+01>, %arg
  %tmp2 = fmul reassoc <2 x float> %tmp1, <float 1.200000e+01, float 1.200000e+01>
  ret <2 x float> %tmp2
}

; Check (b+(a+1234))+-a -> b+1234.

define <2 x double> @test9(<2 x double> %b, <2 x double> %a) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub fast <2 x double> zeroinitializer, %a
; CHECK-NEXT:    [[TMP2:%.*]] = fadd fast <2 x double> %b, <double 1.234000e+03, double 1.234000e+03>
; CHECK-NEXT:    ret <2 x double> [[TMP2]]
;
  %1 = fadd fast <2 x double> %a, <double 1.234000e+03, double 1.234000e+03>
  %2 = fadd fast <2 x double> %b, %1
  %3 = fsub fast <2 x double> <double 0.000000e+00, double 0.000000e+00>, %a
  %4 = fadd fast <2 x double> %2, %3
  ret <2 x double> %4
}

; Check (b+(a+1234))+-a -> b+1234 - minimum FMF subset version

define <2 x double> @test9_reassoc(<2 x double> %b, <2 x double> %a) {
; CHECK-LABEL: @test9_reassoc(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc <2 x double> %a, <double 1.234000e+03, double 1.234000e+03>
; CHECK-NEXT:    [[TMP2:%.*]] = fadd reassoc <2 x double> %b, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fsub reassoc <2 x double> zeroinitializer, %a
; CHECK-NEXT:    [[TMP4:%.*]] = fadd reassoc <2 x double> [[TMP3]], [[TMP2]]
; CHECK-NEXT:    ret <2 x double> [[TMP4]]
;
  %1 = fadd reassoc <2 x double> %a, <double 1.234000e+03, double 1.234000e+03>
  %2 = fadd reassoc <2 x double> %b, %1
  %3 = fsub reassoc <2 x double> <double 0.000000e+00, double 0.000000e+00>, %a
  %4 = fadd reassoc <2 x double> %2, %3
  ret <2 x double> %4
}

; Check -(-(z*40)*a) -> a*40*z.

define <2 x float> @test10(<2 x float> %a, <2 x float> %b, <2 x float> %z) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub fast <2 x float> zeroinitializer, zeroinitializer
; CHECK-NEXT:    [[E:%.*]] = fmul fast <2 x float> %a, <float 4.000000e+01, float 4.000000e+01>
; CHECK-NEXT:    [[F:%.*]] = fmul fast <2 x float> [[E]], %z
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %d = fmul fast <2 x float> %z, <float 4.000000e+01, float 4.000000e+01>
  %c = fsub fast <2 x float> <float 0.000000e+00, float 0.000000e+00>, %d
  %e = fmul fast <2 x float> %a, %c
  %f = fsub fast <2 x float> <float 0.000000e+00, float 0.000000e+00>, %e
  ret <2 x float> %f
}

; Check -(-(z*40)*a) -> a*40*z - minimum FMF subset version

define <2 x float> @test10_reassoc(<2 x float> %a, <2 x float> %b, <2 x float> %z) {
; CHECK-LABEL: @test10_reassoc(
; CHECK-NEXT:    [[D:%.*]] = fmul reassoc <2 x float> %z, <float 4.000000e+01, float 4.000000e+01>
; CHECK-NEXT:    [[C:%.*]] = fsub reassoc <2 x float> zeroinitializer, [[D]]
; CHECK-NEXT:    [[E:%.*]] = fmul reassoc <2 x float> %a, [[C]]
; CHECK-NEXT:    [[F:%.*]] = fsub reassoc <2 x float> zeroinitializer, [[E]]
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %d = fmul reassoc <2 x float> %z, <float 4.000000e+01, float 4.000000e+01>
  %c = fsub reassoc <2 x float> <float 0.000000e+00, float 0.000000e+00>, %d
  %e = fmul reassoc <2 x float> %a, %c
  %f = fsub reassoc <2 x float> <float 0.000000e+00, float 0.000000e+00>, %e
  ret <2 x float> %f
}

; Check x*y+y*x -> x*y*2.

define <2 x double> @test11(<2 x double> %x, <2 x double> %y) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[FACTOR:%.*]] = fmul fast <2 x double> %x, <double 2.000000e+00, double 2.000000e+00>
; CHECK-NEXT:    [[TMP1:%.*]] = fmul fast <2 x double> [[FACTOR]], %y
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = fmul fast <2 x double> %x, %y
  %2 = fmul fast <2 x double> %y, %x
  %3 = fadd fast <2 x double> %1, %2
  ret <2 x double> %3
}

; Check x*y+y*x -> x*y*2 - minimum FMF subset version

define <2 x double> @test11_reassoc(<2 x double> %x, <2 x double> %y) {
; CHECK-LABEL: @test11_reassoc(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul reassoc <2 x double> %x, %y
; CHECK-NEXT:    [[TMP2:%.*]] = fmul reassoc <2 x double> %x, %y
; CHECK-NEXT:    [[TMP3:%.*]] = fadd reassoc <2 x double> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x double> [[TMP3]]
;
  %1 = fmul reassoc <2 x double> %x, %y
  %2 = fmul reassoc <2 x double> %y, %x
  %3 = fadd reassoc <2 x double> %1, %2
  ret <2 x double> %3
}

; FIXME: shifts should be converted to mul to assist further reassociation.

define <2 x i64> @test12(<2 x i64> %b, <2 x i64> %c) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[MUL:%.*]] = mul <2 x i64> %c, %b
; CHECK-NEXT:    [[SHL:%.*]] = shl <2 x i64> [[MUL]], <i64 5, i64 5>
; CHECK-NEXT:    ret <2 x i64> [[SHL]]
;
  %mul = mul <2 x i64> %c, %b
  %shl = shl <2 x i64> %mul, <i64 5, i64 5>
  ret <2 x i64> %shl
}

; FIXME: expressions with a negative const should be canonicalized to assist
; further reassociation.
; We would expect (-5*b)+a -> a-(5*b) but only the constant operand is commuted.

define <4 x float> @test13(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast <4 x float> %b, <float -5.000000e+00, float -5.000000e+00, float -5.000000e+00, float -5.000000e+00>
; CHECK-NEXT:    [[ADD:%.*]] = fadd fast <4 x float> [[MUL]], %a
; CHECK-NEXT:    ret <4 x float> [[ADD]]
;
  %mul = fmul fast <4 x float> <float -5.000000e+00, float -5.000000e+00, float -5.000000e+00, float -5.000000e+00>, %b
  %add = fadd fast <4 x float> %mul, %a
  ret <4 x float> %add
}

; Break up subtract to assist further reassociation.
; Check a+b-c -> a+b+-c.

define <2 x i64> @test14(<2 x i64> %a, <2 x i64> %b, <2 x i64> %c) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[ADD:%.*]] = add <2 x i64> %b, %a
; CHECK-NEXT:    [[C_NEG:%.*]] = sub <2 x i64> zeroinitializer, %c
; CHECK-NEXT:    [[SUB:%.*]] = add <2 x i64> [[ADD]], [[C_NEG]]
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %add = add <2 x i64> %b, %a
  %sub = sub <2 x i64> %add, %c
  ret <2 x i64> %sub
}

define <2 x i32> @test15(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i32> %y, %x
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %tmp1 = and <2 x i32> %x, %y
  %tmp2 = and <2 x i32> %y, %x
  %tmp3 = and <2 x i32> %tmp1, %tmp2
  ret <2 x i32> %tmp3
}

define <2 x i32> @test16(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[TMP3:%.*]] = or <2 x i32> %y, %x
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %tmp1 = or <2 x i32> %x, %y
  %tmp2 = or <2 x i32> %y, %x
  %tmp3 = or <2 x i32> %tmp1, %tmp2
  ret <2 x i32> %tmp3
}

define <2 x i32> @test17(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    ret <2 x i32> zeroinitializer
;
  %tmp1 = xor <2 x i32> %x, %y
  %tmp2 = xor <2 x i32> %y, %x
  %tmp3 = xor <2 x i32> %tmp1, %tmp2
  ret <2 x i32> %tmp3
}

define <2 x i32> @test18(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[TMP5:%.*]] = xor <2 x i32> %y, %x
; CHECK-NEXT:    ret <2 x i32> [[TMP5]]
;
  %tmp1 = xor <2 x i32> %x, %y
  %tmp2 = xor <2 x i32> %y, %x
  %tmp3 = xor <2 x i32> %x, %y
  %tmp4 = xor <2 x i32> %tmp1, %tmp2
  %tmp5 = xor <2 x i32> %tmp4, %tmp3
  ret <2 x i32> %tmp5
}
