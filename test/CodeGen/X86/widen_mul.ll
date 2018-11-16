; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -x86-experimental-vector-widening-legalization -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -x86-experimental-vector-widening-legalization -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE --check-prefix=SSE41
; RUN: llc < %s -x86-experimental-vector-widening-legalization -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -x86-experimental-vector-widening-legalization -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -x86-experimental-vector-widening-legalization -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX --check-prefix=AVX512 --check-prefix=AVX512BW

; Test multiplies of various narrow types.

define <2 x i8> @mul_v2i8(<2 x i8> %x, <2 x i8> %y) {
; SSE2-LABEL: mul_v2i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm3 = xmm3[8],xmm0[8],xmm3[9],xmm0[9],xmm3[10],xmm0[10],xmm3[11],xmm0[11],xmm3[12],xmm0[12],xmm3[13],xmm0[13],xmm3[14],xmm0[14],xmm3[15],xmm0[15]
; SSE2-NEXT:    pmullw %xmm2, %xmm3
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm2, %xmm3
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    pmullw %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    packuswb %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: mul_v2i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm3 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; SSE41-NEXT:    punpckhbw {{.*#+}} xmm1 = xmm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm2 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE41-NEXT:    punpckhbw {{.*#+}} xmm0 = xmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE41-NEXT:    pmullw %xmm1, %xmm0
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [255,255,255,255,255,255,255,255]
; SSE41-NEXT:    pand %xmm1, %xmm0
; SSE41-NEXT:    pmullw %xmm3, %xmm2
; SSE41-NEXT:    pand %xmm1, %xmm2
; SSE41-NEXT:    packuswb %xmm0, %xmm2
; SSE41-NEXT:    movdqa %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; AVX2-LABEL: mul_v2i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX2-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX2-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: mul_v2i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX512F-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX512F-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mul_v2i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX512BW-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX512BW-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX512BW-NEXT:    vpmovwb %zmm0, %ymm0
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %res = mul <2 x i8> %x, %y
  ret <2 x i8> %res
}

define <4 x i8> @mul_v4i8(<4 x i8> %x, <4 x i8> %y) {
; SSE2-LABEL: mul_v4i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm3 = xmm3[8],xmm0[8],xmm3[9],xmm0[9],xmm3[10],xmm0[10],xmm3[11],xmm0[11],xmm3[12],xmm0[12],xmm3[13],xmm0[13],xmm3[14],xmm0[14],xmm3[15],xmm0[15]
; SSE2-NEXT:    pmullw %xmm2, %xmm3
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm2, %xmm3
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    pmullw %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    packuswb %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: mul_v4i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm3 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; SSE41-NEXT:    punpckhbw {{.*#+}} xmm1 = xmm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm2 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE41-NEXT:    punpckhbw {{.*#+}} xmm0 = xmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE41-NEXT:    pmullw %xmm1, %xmm0
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [255,255,255,255,255,255,255,255]
; SSE41-NEXT:    pand %xmm1, %xmm0
; SSE41-NEXT:    pmullw %xmm3, %xmm2
; SSE41-NEXT:    pand %xmm1, %xmm2
; SSE41-NEXT:    packuswb %xmm0, %xmm2
; SSE41-NEXT:    movdqa %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; AVX2-LABEL: mul_v4i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX2-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX2-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: mul_v4i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX512F-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX512F-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mul_v4i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX512BW-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX512BW-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX512BW-NEXT:    vpmovwb %zmm0, %ymm0
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %res = mul <4 x i8> %x, %y
  ret <4 x i8> %res
}

define <8 x i8> @mul_v8i8(<8 x i8> %x, <8 x i8> %y) {
; SSE2-LABEL: mul_v8i8:
; SSE2:       # %bb.0:
; SSE2-NEXT:    movdqa %xmm1, %xmm2
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm2 = xmm2[8],xmm0[8],xmm2[9],xmm0[9],xmm2[10],xmm0[10],xmm2[11],xmm0[11],xmm2[12],xmm0[12],xmm2[13],xmm0[13],xmm2[14],xmm0[14],xmm2[15],xmm0[15]
; SSE2-NEXT:    movdqa %xmm0, %xmm3
; SSE2-NEXT:    punpckhbw {{.*#+}} xmm3 = xmm3[8],xmm0[8],xmm3[9],xmm0[9],xmm3[10],xmm0[10],xmm3[11],xmm0[11],xmm3[12],xmm0[12],xmm3[13],xmm0[13],xmm3[14],xmm0[14],xmm3[15],xmm0[15]
; SSE2-NEXT:    pmullw %xmm2, %xmm3
; SSE2-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255]
; SSE2-NEXT:    pand %xmm2, %xmm3
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE2-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; SSE2-NEXT:    pmullw %xmm1, %xmm0
; SSE2-NEXT:    pand %xmm2, %xmm0
; SSE2-NEXT:    packuswb %xmm3, %xmm0
; SSE2-NEXT:    retq
;
; SSE41-LABEL: mul_v8i8:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm3 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
; SSE41-NEXT:    punpckhbw {{.*#+}} xmm1 = xmm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE41-NEXT:    pmovzxbw {{.*#+}} xmm2 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; SSE41-NEXT:    punpckhbw {{.*#+}} xmm0 = xmm0[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15]
; SSE41-NEXT:    pmullw %xmm1, %xmm0
; SSE41-NEXT:    movdqa {{.*#+}} xmm1 = [255,255,255,255,255,255,255,255]
; SSE41-NEXT:    pand %xmm1, %xmm0
; SSE41-NEXT:    pmullw %xmm3, %xmm2
; SSE41-NEXT:    pand %xmm1, %xmm2
; SSE41-NEXT:    packuswb %xmm0, %xmm2
; SSE41-NEXT:    movdqa %xmm2, %xmm0
; SSE41-NEXT:    retq
;
; AVX2-LABEL: mul_v8i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX2-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX2-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: mul_v8i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX512F-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX512F-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovzxwd {{.*#+}} zmm0 = ymm0[0],zero,ymm0[1],zero,ymm0[2],zero,ymm0[3],zero,ymm0[4],zero,ymm0[5],zero,ymm0[6],zero,ymm0[7],zero,ymm0[8],zero,ymm0[9],zero,ymm0[10],zero,ymm0[11],zero,ymm0[12],zero,ymm0[13],zero,ymm0[14],zero,ymm0[15],zero
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: mul_v8i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpmovzxbw {{.*#+}} ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero,xmm1[8],zero,xmm1[9],zero,xmm1[10],zero,xmm1[11],zero,xmm1[12],zero,xmm1[13],zero,xmm1[14],zero,xmm1[15],zero
; AVX512BW-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; AVX512BW-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; AVX512BW-NEXT:    vpmovwb %zmm0, %ymm0
; AVX512BW-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %res = mul <8 x i8> %x, %y
  ret <8 x i8> %res
}

define <2 x i16> @mul_v2i16(<2 x i16> %x, <2 x i16> %y) {
; SSE-LABEL: mul_v2i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmullw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: mul_v2i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = mul <2 x i16> %x, %y
  ret <2 x i16> %res
}

define <4 x i16> @mul_v4i16(<4 x i16> %x, <4 x i16> %y) {
; SSE-LABEL: mul_v4i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pmullw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: mul_v4i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = mul <4 x i16> %x, %y
  ret <4 x i16> %res
}

define <2 x i32> @mul_v2i32(<2 x i32> %x, <2 x i32> %y) {
; SSE2-LABEL: mul_v2i32:
; SSE2:       # %bb.0:
; SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm1, %xmm0
; SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; SSE2-NEXT:    pmuludq %xmm2, %xmm1
; SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE2-NEXT:    retq
;
; SSE41-LABEL: mul_v2i32:
; SSE41:       # %bb.0:
; SSE41-NEXT:    pmulld %xmm1, %xmm0
; SSE41-NEXT:    retq
;
; AVX-LABEL: mul_v2i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %res = mul <2 x i32> %x, %y
  ret <2 x i32> %res
}
