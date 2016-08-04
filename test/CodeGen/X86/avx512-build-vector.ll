; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=x86-64 -mtriple=x86_64-apple-darwin -mcpu=knl | FileCheck %s

define <16 x i32> @test2(<16 x i32> %x) {
; CHECK-LABEL: test2:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1
; CHECK-NEXT:    vpaddd %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
   %res = add <16 x i32><i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>, %x
   ret <16 x i32>%res
}

define <16 x float> @test3(<4 x float> %a) {
; CHECK-LABEL: test3:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm0[1,0]
; CHECK-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vmovss {{.*#+}} xmm0 = xmm0[0],xmm2[1,2,3]
; CHECK-NEXT:    vmovss {{.*#+}} xmm1 = xmm1[0],xmm2[1,2,3]
; CHECK-NEXT:    vshufps {{.*#+}} xmm0 = xmm1[1,0],xmm0[0,1]
; CHECK-NEXT:    vinsertf128 $1, %xmm0, %ymm2, %ymm0
; CHECK-NEXT:    vxorps %ymm1, %ymm1, %ymm1
; CHECK-NEXT:    vinsertf64x4 $1, %ymm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %b = extractelement <4 x float> %a, i32 2
  %c = insertelement <16 x float> <float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float undef, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00, float 0.000000e+00>, float %b, i32 5
  %b1 = extractelement <4 x float> %a, i32 0
  %c1 = insertelement <16 x float> %c, float %b1, i32 6
  ret <16 x float>%c1
}
