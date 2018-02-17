; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

; Verify that we correctly fold horizontal binop even in the presence of UNDEFs.

define <4 x float> @test1_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test1_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test1_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 1
  %vecext10 = extractelement <4 x float> %b, i32 2
  %vecext11 = extractelement <4 x float> %b, i32 3
  %add12 = fadd float %vecext10, %vecext11
  %vecinit13 = insertelement <4 x float> %vecinit5, float %add12, i32 3
  ret <4 x float> %vecinit13
}

define <4 x float> @test2_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test2_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test2_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext6 = extractelement <4 x float> %b, i32 0
  %vecext7 = extractelement <4 x float> %b, i32 1
  %add8 = fadd float %vecext6, %vecext7
  %vecinit9 = insertelement <4 x float> %vecinit, float %add8, i32 2
  %vecext10 = extractelement <4 x float> %b, i32 2
  %vecext11 = extractelement <4 x float> %b, i32 3
  %add12 = fadd float %vecext10, %vecext11
  %vecinit13 = insertelement <4 x float> %vecinit9, float %add12, i32 3
  ret <4 x float> %vecinit13
}

define <4 x float> @test3_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test3_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test3_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 1
  %vecext6 = extractelement <4 x float> %b, i32 0
  %vecext7 = extractelement <4 x float> %b, i32 1
  %add8 = fadd float %vecext6, %vecext7
  %vecinit9 = insertelement <4 x float> %vecinit5, float %add8, i32 2
  ret <4 x float> %vecinit9
}

define <4 x float> @test4_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test4_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-NEXT:    addss %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test4_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  ret <4 x float> %vecinit
}

define <2 x double> @test5_undef(<2 x double> %a, <2 x double> %b) {
; SSE-LABEL: test5_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    movhlps {{.*#+}} xmm1 = xmm1[1,1]
; SSE-NEXT:    addsd %xmm0, %xmm1
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test5_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <2 x double> %a, i32 0
  %vecext1 = extractelement <2 x double> %a, i32 1
  %add = fadd double %vecext, %vecext1
  %vecinit = insertelement <2 x double> undef, double %add, i32 0
  ret <2 x double> %vecinit
}

define <4 x float> @test6_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test6_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test6_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 1
  ret <4 x float> %vecinit5
}

define <4 x float> @test7_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test7_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test7_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %b, i32 0
  %vecext1 = extractelement <4 x float> %b, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 2
  %vecext2 = extractelement <4 x float> %b, i32 2
  %vecext3 = extractelement <4 x float> %b, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 3
  ret <4 x float> %vecinit5
}

define <4 x float> @test8_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test8_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-NEXT:    addss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    movhlps {{.*#+}} xmm2 = xmm2[1,1]
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-NEXT:    addss %xmm2, %xmm0
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test8_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX-NEXT:    vaddss %xmm1, %xmm0, %xmm1
; AVX-NEXT:    vpermilpd {{.*#+}} xmm2 = xmm0[1,0]
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; AVX-NEXT:    vaddss %xmm0, %xmm2, %xmm0
; AVX-NEXT:    vinsertps {{.*#+}} xmm0 = xmm1[0,1],xmm0[0],xmm1[3]
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %a, i32 2
  %vecext3 = extractelement <4 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 2
  ret <4 x float> %vecinit5
}

define <4 x float> @test9_undef(<4 x float> %a, <4 x float> %b) {
; SSE-LABEL: test9_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test9_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <4 x float> %a, i32 0
  %vecext1 = extractelement <4 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <4 x float> undef, float %add, i32 0
  %vecext2 = extractelement <4 x float> %b, i32 2
  %vecext3 = extractelement <4 x float> %b, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <4 x float> %vecinit, float %add4, i32 3
  ret <4 x float> %vecinit5
}

define <8 x float> @test10_undef(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: test10_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test10_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %ymm1, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vecext = extractelement <8 x float> %a, i32 0
  %vecext1 = extractelement <8 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <8 x float> undef, float %add, i32 0
  %vecext2 = extractelement <8 x float> %b, i32 2
  %vecext3 = extractelement <8 x float> %b, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <8 x float> %vecinit, float %add4, i32 3
  ret <8 x float> %vecinit5
}

define <8 x float> @test11_undef(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: test11_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    movshdup {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-NEXT:    addss %xmm1, %xmm0
; SSE-NEXT:    movshdup {{.*#+}} xmm1 = xmm3[1,1,3,3]
; SSE-NEXT:    addss %xmm3, %xmm1
; SSE-NEXT:    movddup {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: test11_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vecext = extractelement <8 x float> %a, i32 0
  %vecext1 = extractelement <8 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <8 x float> undef, float %add, i32 0
  %vecext2 = extractelement <8 x float> %b, i32 4
  %vecext3 = extractelement <8 x float> %b, i32 5
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <8 x float> %vecinit, float %add4, i32 6
  ret <8 x float> %vecinit5
}

define <8 x float> @test12_undef(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: test12_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test12_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vhaddps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vecext = extractelement <8 x float> %a, i32 0
  %vecext1 = extractelement <8 x float> %a, i32 1
  %add = fadd float %vecext, %vecext1
  %vecinit = insertelement <8 x float> undef, float %add, i32 0
  %vecext2 = extractelement <8 x float> %a, i32 2
  %vecext3 = extractelement <8 x float> %a, i32 3
  %add4 = fadd float %vecext2, %vecext3
  %vecinit5 = insertelement <8 x float> %vecinit, float %add4, i32 1
  ret <8 x float> %vecinit5
}

define <8 x float> @test13_undef(<8 x float> %a, <8 x float> %b) {
; SSE-LABEL: test13_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    haddps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test13_undef:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vhaddps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %vecext = extractelement <8 x float> %a, i32 0
  %vecext1 = extractelement <8 x float> %a, i32 1
  %add1 = fadd float %vecext, %vecext1
  %vecinit1 = insertelement <8 x float> undef, float %add1, i32 0
  %vecext2 = extractelement <8 x float> %a, i32 2
  %vecext3 = extractelement <8 x float> %a, i32 3
  %add2 = fadd float %vecext2, %vecext3
  %vecinit2 = insertelement <8 x float> %vecinit1, float %add2, i32 1
  %vecext4 = extractelement <8 x float> %a, i32 4
  %vecext5 = extractelement <8 x float> %a, i32 5
  %add3 = fadd float %vecext4, %vecext5
  %vecinit3 = insertelement <8 x float> %vecinit2, float %add3, i32 2
  %vecext6 = extractelement <8 x float> %a, i32 6
  %vecext7 = extractelement <8 x float> %a, i32 7
  %add4 = fadd float %vecext6, %vecext7
  %vecinit4 = insertelement <8 x float> %vecinit3, float %add4, i32 3
  ret <8 x float> %vecinit4
}

define <8 x i32> @test14_undef(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: test14_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    phaddd %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: test14_undef:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vphaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test14_undef:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vphaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %vecext = extractelement <8 x i32> %a, i32 0
  %vecext1 = extractelement <8 x i32> %a, i32 1
  %add = add i32 %vecext, %vecext1
  %vecinit = insertelement <8 x i32> undef, i32 %add, i32 0
  %vecext2 = extractelement <8 x i32> %b, i32 2
  %vecext3 = extractelement <8 x i32> %b, i32 3
  %add4 = add i32 %vecext2, %vecext3
  %vecinit5 = insertelement <8 x i32> %vecinit, i32 %add4, i32 3
  ret <8 x i32> %vecinit5
}

; On AVX2, the following sequence can be folded into a single horizontal add.
; If the Subtarget doesn't support AVX2, then we avoid emitting two packed
; integer horizontal adds instead of two scalar adds followed by vector inserts.
define <8 x i32> @test15_undef(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: test15_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    movd %xmm0, %eax
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,2,3]
; SSE-NEXT:    movd %xmm0, %ecx
; SSE-NEXT:    addl %eax, %ecx
; SSE-NEXT:    movd %xmm3, %eax
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm3[1,1,2,3]
; SSE-NEXT:    movd %xmm0, %edx
; SSE-NEXT:    addl %eax, %edx
; SSE-NEXT:    movd %ecx, %xmm0
; SSE-NEXT:    movd %edx, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,1,0,1]
; SSE-NEXT:    retq
;
; AVX1-LABEL: test15_undef:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    vpextrd $1, %xmm0, %ecx
; AVX1-NEXT:    addl %eax, %ecx
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm0
; AVX1-NEXT:    vmovd %xmm0, %eax
; AVX1-NEXT:    vpextrd $1, %xmm0, %edx
; AVX1-NEXT:    addl %eax, %edx
; AVX1-NEXT:    vmovd %ecx, %xmm0
; AVX1-NEXT:    vmovd %edx, %xmm1
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,1,0,1]
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test15_undef:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %vecext = extractelement <8 x i32> %a, i32 0
  %vecext1 = extractelement <8 x i32> %a, i32 1
  %add = add i32 %vecext, %vecext1
  %vecinit = insertelement <8 x i32> undef, i32 %add, i32 0
  %vecext2 = extractelement <8 x i32> %b, i32 4
  %vecext3 = extractelement <8 x i32> %b, i32 5
  %add4 = add i32 %vecext2, %vecext3
  %vecinit5 = insertelement <8 x i32> %vecinit, i32 %add4, i32 6
  ret <8 x i32> %vecinit5
}

define <8 x i32> @test16_undef(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: test16_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    phaddd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: test16_undef:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vphaddd %xmm0, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test16_undef:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vphaddd %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %vecext = extractelement <8 x i32> %a, i32 0
  %vecext1 = extractelement <8 x i32> %a, i32 1
  %add = add i32 %vecext, %vecext1
  %vecinit = insertelement <8 x i32> undef, i32 %add, i32 0
  %vecext2 = extractelement <8 x i32> %a, i32 2
  %vecext3 = extractelement <8 x i32> %a, i32 3
  %add4 = add i32 %vecext2, %vecext3
  %vecinit5 = insertelement <8 x i32> %vecinit, i32 %add4, i32 1
  ret <8 x i32> %vecinit5
}

define <8 x i32> @test17_undef(<8 x i32> %a, <8 x i32> %b) {
; SSE-LABEL: test17_undef:
; SSE:       # %bb.0:
; SSE-NEXT:    phaddd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: test17_undef:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vphaddd %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test17_undef:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vphaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %vecext = extractelement <8 x i32> %a, i32 0
  %vecext1 = extractelement <8 x i32> %a, i32 1
  %add1 = add i32 %vecext, %vecext1
  %vecinit1 = insertelement <8 x i32> undef, i32 %add1, i32 0
  %vecext2 = extractelement <8 x i32> %a, i32 2
  %vecext3 = extractelement <8 x i32> %a, i32 3
  %add2 = add i32 %vecext2, %vecext3
  %vecinit2 = insertelement <8 x i32> %vecinit1, i32 %add2, i32 1
  %vecext4 = extractelement <8 x i32> %a, i32 4
  %vecext5 = extractelement <8 x i32> %a, i32 5
  %add3 = add i32 %vecext4, %vecext5
  %vecinit3 = insertelement <8 x i32> %vecinit2, i32 %add3, i32 2
  %vecext6 = extractelement <8 x i32> %a, i32 6
  %vecext7 = extractelement <8 x i32> %a, i32 7
  %add4 = add i32 %vecext6, %vecext7
  %vecinit4 = insertelement <8 x i32> %vecinit3, i32 %add4, i32 3
  ret <8 x i32> %vecinit4
}
