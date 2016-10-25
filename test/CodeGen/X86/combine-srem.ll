; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX

; fold (srem undef, x) -> 0
define <4 x i32> @combine_vec_srem_undef0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_undef0:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_undef0:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = srem <4 x i32> undef, %x
  ret <4 x i32> %1
}

; fold (srem x, undef) -> undef
define <4 x i32> @combine_vec_srem_undef1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_undef1:
; SSE:       # BB#0:
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_undef1:
; AVX:       # BB#0:
; AVX-NEXT:    retq
  %1 = srem <4 x i32> %x, undef
  ret <4 x i32> %1
}

; fold (srem x, y) -> (urem x, y) iff x and y are positive
define <4 x i32> @combine_vec_srem_by_pos0(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pos0:
; SSE:       # BB#0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_by_pos0:
; AVX:       # BB#0:
; AVX-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %2 = srem <4 x i32> %1, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_srem_by_pos1(<4 x i32> %x) {
; SSE-LABEL: combine_vec_srem_by_pos1:
; SSE:       # BB#0:
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    pextrd $3, %xmm0, %eax
; SSE-NEXT:    andl $15, %eax
; SSE-NEXT:    movd %eax, %xmm1
; SSE-NEXT:    pextrd $2, %xmm0, %eax
; SSE-NEXT:    andl $7, %eax
; SSE-NEXT:    movd %eax, %xmm2
; SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[0,1,0,1]
; SSE-NEXT:    pextrd $1, %xmm0, %eax
; SSE-NEXT:    andl $3, %eax
; SSE-NEXT:    movd %eax, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,0,2,3]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_srem_by_pos1:
; AVX:       # BB#0:
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpextrd $3, %xmm0, %eax
; AVX-NEXT:    andl $15, %eax
; AVX-NEXT:    vmovd %eax, %xmm1
; AVX-NEXT:    vpextrd $2, %xmm0, %eax
; AVX-NEXT:    andl $7, %eax
; AVX-NEXT:    vmovd %eax, %xmm2
; AVX-NEXT:    vpunpckldq {{.*#+}} xmm1 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; AVX-NEXT:    vpbroadcastq %xmm1, %xmm1
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    andl $3, %eax
; AVX-NEXT:    vmovd %eax, %xmm0
; AVX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,0,2,3]
; AVX-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3]
; AVX-NEXT:    retq
  %1 = and <4 x i32> %x, <i32 255, i32 255, i32 255, i32 255>
  %2 = srem <4 x i32> %1, <i32 1, i32 4, i32 8, i32 16>
  ret <4 x i32> %2
}
