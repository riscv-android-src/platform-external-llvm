; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX2

; fold (udiv x, 1) -> x
define i32 @combine_udiv_by_one(i32 %x) {
; CHECK-LABEL: combine_udiv_by_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %1 = udiv i32 %x, 1
  ret i32 %1
}

define <4 x i32> @combine_vec_udiv_by_one(<4 x i32> %x) {
; CHECK-LABEL: combine_vec_udiv_by_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  %1 = udiv <4 x i32> %x, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %1
}

; TODO fold (udiv x, -1) -> select((icmp eq x, -1), 1, 0)
define i32 @combine_udiv_by_negone(i32 %x) {
; CHECK-LABEL: combine_udiv_by_negone:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    movq %rcx, %rax
; CHECK-NEXT:    shlq $31, %rax
; CHECK-NEXT:    addq %rcx, %rax
; CHECK-NEXT:    shrq $63, %rax
; CHECK-NEXT:    # kill: def $eax killed $eax killed $rax
; CHECK-NEXT:    retq
  %1 = udiv i32 %x, -1
  ret i32 %1
}

define <4 x i32> @combine_vec_udiv_by_negone(<4 x i32> %x) {
; SSE-LABEL: combine_vec_udiv_by_negone:
; SSE:       # %bb.0:
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [2147483649,2147483649,2147483649,2147483649]
; SSE-NEXT:    pmuludq %xmm2, %xmm1
; SSE-NEXT:    pmuludq %xmm2, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; SSE-NEXT:    psrld $31, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_udiv_by_negone:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [2147483649,2147483649,2147483649,2147483649]
; AVX1-NEXT:    vpmuludq %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpmuludq %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; AVX1-NEXT:    vpsrld $31, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_udiv_by_negone:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [2147483649,2147483649,2147483649,2147483649]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm2 = xmm1[1,1,3,3]
; AVX2-NEXT:    vpshufd {{.*#+}} xmm3 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpmuludq %xmm2, %xmm3, %xmm2
; AVX2-NEXT:    vpmuludq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[1,1,3,3]
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm2[1],xmm0[2],xmm2[3]
; AVX2-NEXT:    vpsrld $31, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = udiv <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %1
}

; fold (udiv x, INT_MIN) -> (srl x, 31)
define i32 @combine_udiv_by_minsigned(i32 %x) {
; CHECK-LABEL: combine_udiv_by_minsigned:
; CHECK:       # %bb.0:
; CHECK-NEXT:    shrl $31, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %1 = udiv i32 %x, -2147483648
  ret i32 %1
}

define <4 x i32> @combine_vec_udiv_by_minsigned(<4 x i32> %x) {
; SSE-LABEL: combine_vec_udiv_by_minsigned:
; SSE:       # %bb.0:
; SSE-NEXT:    psrld $31, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_udiv_by_minsigned:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsrld $31, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = udiv <4 x i32> %x, <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 -2147483648>
  ret <4 x i32> %1
}

; TODO fold (udiv x, x) -> 1
define i32 @combine_udiv_dupe(i32 %x) {
; CHECK-LABEL: combine_udiv_dupe:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    divl %edi
; CHECK-NEXT:    retq
  %1 = udiv i32 %x, %x
  ret i32 %1
}

define <4 x i32> @combine_vec_udiv_dupe(<4 x i32> %x) {
; SSE-LABEL: combine_vec_udiv_dupe:
; SSE:       # %bb.0:
; SSE-NEXT:    pextrd $1, %xmm0, %eax
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    divl %eax
; SSE-NEXT:    movl %eax, %ecx
; SSE-NEXT:    movd %xmm0, %eax
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    divl %eax
; SSE-NEXT:    movd %eax, %xmm1
; SSE-NEXT:    pinsrd $1, %ecx, %xmm1
; SSE-NEXT:    pextrd $2, %xmm0, %eax
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    divl %eax
; SSE-NEXT:    pinsrd $2, %eax, %xmm1
; SSE-NEXT:    pextrd $3, %xmm0, %eax
; SSE-NEXT:    xorl %edx, %edx
; SSE-NEXT:    divl %eax
; SSE-NEXT:    pinsrd $3, %eax, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_udiv_dupe:
; AVX:       # %bb.0:
; AVX-NEXT:    vpextrd $1, %xmm0, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    divl %eax
; AVX-NEXT:    movl %eax, %ecx
; AVX-NEXT:    vmovd %xmm0, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    divl %eax
; AVX-NEXT:    vmovd %eax, %xmm1
; AVX-NEXT:    vpinsrd $1, %ecx, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $2, %xmm0, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    divl %eax
; AVX-NEXT:    vpinsrd $2, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrd $3, %xmm0, %eax
; AVX-NEXT:    xorl %edx, %edx
; AVX-NEXT:    divl %eax
; AVX-NEXT:    vpinsrd $3, %eax, %xmm1, %xmm0
; AVX-NEXT:    retq
  %1 = udiv <4 x i32> %x, %x
  ret <4 x i32> %1
}

; fold (udiv x, (1 << c)) -> x >>u c
define <4 x i32> @combine_vec_udiv_by_pow2a(<4 x i32> %x) {
; SSE-LABEL: combine_vec_udiv_by_pow2a:
; SSE:       # %bb.0:
; SSE-NEXT:    psrld $2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: combine_vec_udiv_by_pow2a:
; AVX:       # %bb.0:
; AVX-NEXT:    vpsrld $2, %xmm0, %xmm0
; AVX-NEXT:    retq
  %1 = udiv <4 x i32> %x, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_udiv_by_pow2b(<4 x i32> %x) {
; SSE-LABEL: combine_vec_udiv_by_pow2b:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrld $3, %xmm1
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm0[0,1,2,3],xmm1[4,5,6,7]
; SSE-NEXT:    psrld $4, %xmm0
; SSE-NEXT:    psrld $2, %xmm2
; SSE-NEXT:    pblendw {{.*#+}} xmm2 = xmm2[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,3],xmm1[4,5],xmm2[6,7]
; SSE-NEXT:    movdqa %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_udiv_by_pow2b:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrld $4, %xmm0, %xmm1
; AVX1-NEXT:    vpsrld $2, %xmm0, %xmm2
; AVX1-NEXT:    vpblendw {{.*#+}} xmm1 = xmm2[0,1,2,3],xmm1[4,5,6,7]
; AVX1-NEXT:    vpsrld $3, %xmm0, %xmm2
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_udiv_by_pow2b:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlvd {{.*}}(%rip), %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = udiv <4 x i32> %x, <i32 1, i32 4, i32 8, i32 16>
  ret <4 x i32> %1
}

define <4 x i32> @combine_vec_udiv_by_pow2c(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_udiv_by_pow2c:
; SSE:       # %bb.0:
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm1[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrld %xmm2, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,3,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm2[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm5
; SSE-NEXT:    psrld %xmm4, %xmm5
; SSE-NEXT:    pblendw {{.*#+}} xmm5 = xmm3[0,1,2,3],xmm5[4,5,6,7]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,1,1,1,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrld %xmm1, %xmm3
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm2[0,1,1,1,4,5,6,7]
; SSE-NEXT:    psrld %xmm1, %xmm0
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm3[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm5[2,3],xmm0[4,5],xmm5[6,7]
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_udiv_by_pow2c:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpsrldq {{.*#+}} xmm2 = xmm1[12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; AVX1-NEXT:    vpsrld %xmm2, %xmm0, %xmm2
; AVX1-NEXT:    vpsrlq $32, %xmm1, %xmm3
; AVX1-NEXT:    vpsrld %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpunpckhdq {{.*#+}} xmm3 = xmm1[2],xmm3[2],xmm1[3],xmm3[3]
; AVX1-NEXT:    vpsrld %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; AVX1-NEXT:    vpsrld %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm3[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_udiv_by_pow2c:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = shl <4 x i32> <i32 1, i32 1, i32 1, i32 1>, %y
  %2 = udiv <4 x i32> %x, %1
  ret <4 x i32> %2
}

; fold (udiv x, (shl c, y)) -> x >>u (log2(c)+y) iff c is power of 2
define <4 x i32> @combine_vec_udiv_by_shl_pow2a(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_udiv_by_shl_pow2a:
; SSE:       # %bb.0:
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm1
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm1[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrld %xmm2, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,3,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm2[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm5
; SSE-NEXT:    psrld %xmm4, %xmm5
; SSE-NEXT:    pblendw {{.*#+}} xmm5 = xmm3[0,1,2,3],xmm5[4,5,6,7]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,1,1,1,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrld %xmm1, %xmm3
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm2[0,1,1,1,4,5,6,7]
; SSE-NEXT:    psrld %xmm1, %xmm0
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm3[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm5[2,3],xmm0[4,5],xmm5[6,7]
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_udiv_by_shl_pow2a:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpaddd {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpsrldq {{.*#+}} xmm2 = xmm1[12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; AVX1-NEXT:    vpsrld %xmm2, %xmm0, %xmm2
; AVX1-NEXT:    vpsrlq $32, %xmm1, %xmm3
; AVX1-NEXT:    vpsrld %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpunpckhdq {{.*#+}} xmm3 = xmm1[2],xmm3[2],xmm1[3],xmm3[3]
; AVX1-NEXT:    vpsrld %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; AVX1-NEXT:    vpsrld %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm3[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_udiv_by_shl_pow2a:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [2,2,2,2]
; AVX2-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = shl <4 x i32> <i32 4, i32 4, i32 4, i32 4>, %y
  %2 = udiv <4 x i32> %x, %1
  ret <4 x i32> %2
}

define <4 x i32> @combine_vec_udiv_by_shl_pow2b(<4 x i32> %x, <4 x i32> %y) {
; SSE-LABEL: combine_vec_udiv_by_shl_pow2b:
; SSE:       # %bb.0:
; SSE-NEXT:    paddd {{.*}}(%rip), %xmm1
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm1[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrld %xmm2, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[2,3,0,1]
; SSE-NEXT:    pshuflw {{.*#+}} xmm4 = xmm2[2,3,3,3,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm5
; SSE-NEXT:    psrld %xmm4, %xmm5
; SSE-NEXT:    pblendw {{.*#+}} xmm5 = xmm3[0,1,2,3],xmm5[4,5,6,7]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,1,1,1,4,5,6,7]
; SSE-NEXT:    movdqa %xmm0, %xmm3
; SSE-NEXT:    psrld %xmm1, %xmm3
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm2[0,1,1,1,4,5,6,7]
; SSE-NEXT:    psrld %xmm1, %xmm0
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm3[0,1,2,3],xmm0[4,5,6,7]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1],xmm5[2,3],xmm0[4,5],xmm5[6,7]
; SSE-NEXT:    retq
;
; AVX1-LABEL: combine_vec_udiv_by_shl_pow2b:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpaddd {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vpsrldq {{.*#+}} xmm2 = xmm1[12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero
; AVX1-NEXT:    vpsrld %xmm2, %xmm0, %xmm2
; AVX1-NEXT:    vpsrlq $32, %xmm1, %xmm3
; AVX1-NEXT:    vpsrld %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpblendw {{.*#+}} xmm2 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; AVX1-NEXT:    vpxor %xmm3, %xmm3, %xmm3
; AVX1-NEXT:    vpunpckhdq {{.*#+}} xmm3 = xmm1[2],xmm3[2],xmm1[3],xmm3[3]
; AVX1-NEXT:    vpsrld %xmm3, %xmm0, %xmm3
; AVX1-NEXT:    vpmovzxdq {{.*#+}} xmm1 = xmm1[0],zero,xmm1[1],zero
; AVX1-NEXT:    vpsrld %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm3[4,5,6,7]
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm2[2,3],xmm0[4,5],xmm2[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: combine_vec_udiv_by_shl_pow2b:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpaddd {{.*}}(%rip), %xmm1, %xmm1
; AVX2-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %1 = shl <4 x i32> <i32 1, i32 4, i32 8, i32 16>, %y
  %2 = udiv <4 x i32> %x, %1
  ret <4 x i32> %2
}
