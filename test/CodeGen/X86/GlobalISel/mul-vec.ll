; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-linux-gnu -mcpu=skx -global-isel -verify-machineinstrs < %s -o - | FileCheck %s --check-prefix=SKX

define <8 x i16> @test_mul_v8i16(<8 x i16> %arg1, <8 x i16> %arg2) {
; SKX-LABEL: test_mul_v8i16:
; SKX:       # BB#0:
; SKX-NEXT:    vpmullw %xmm1, %xmm0, %xmm0
; SKX-NEXT:    retq
  %ret = mul <8 x i16> %arg1, %arg2
  ret <8 x i16> %ret
}

define <4 x i32> @test_mul_v4i32(<4 x i32> %arg1, <4 x i32> %arg2) {
; SKX-LABEL: test_mul_v4i32:
; SKX:       # BB#0:
; SKX-NEXT:    vpmulld %xmm1, %xmm0, %xmm0
; SKX-NEXT:    retq
  %ret = mul <4 x i32> %arg1, %arg2
  ret <4 x i32> %ret
}

define <2 x i64> @test_mul_v2i64(<2 x i64> %arg1, <2 x i64> %arg2) {
; SKX-LABEL: test_mul_v2i64:
; SKX:       # BB#0:
; SKX-NEXT:    vpmullq %xmm1, %xmm0, %xmm0
; SKX-NEXT:    retq
  %ret = mul <2 x i64> %arg1, %arg2
  ret <2 x i64> %ret
}

define <16 x i16> @test_mul_v16i16(<16 x i16> %arg1, <16 x i16> %arg2) {
; SKX-LABEL: test_mul_v16i16:
; SKX:       # BB#0:
; SKX-NEXT:    vpmullw %ymm1, %ymm0, %ymm0
; SKX-NEXT:    retq
  %ret = mul <16 x i16> %arg1, %arg2
  ret <16 x i16> %ret
}

define <8 x i32> @test_mul_v8i32(<8 x i32> %arg1, <8 x i32> %arg2) {
; SKX-LABEL: test_mul_v8i32:
; SKX:       # BB#0:
; SKX-NEXT:    vpmulld %ymm1, %ymm0, %ymm0
; SKX-NEXT:    retq
  %ret = mul <8 x i32> %arg1, %arg2
  ret <8 x i32> %ret
}

define <4 x i64> @test_mul_v4i64(<4 x i64> %arg1, <4 x i64> %arg2) {
; SKX-LABEL: test_mul_v4i64:
; SKX:       # BB#0:
; SKX-NEXT:    vpmullq %ymm1, %ymm0, %ymm0
; SKX-NEXT:    retq
  %ret = mul <4 x i64> %arg1, %arg2
  ret <4 x i64> %ret
}

define <32 x i16> @test_mul_v32i16(<32 x i16> %arg1, <32 x i16> %arg2) {
; SKX-LABEL: test_mul_v32i16:
; SKX:       # BB#0:
; SKX-NEXT:    vpmullw %zmm1, %zmm0, %zmm0
; SKX-NEXT:    retq
  %ret = mul <32 x i16> %arg1, %arg2
  ret <32 x i16> %ret
}

define <16 x i32> @test_mul_v16i32(<16 x i32> %arg1, <16 x i32> %arg2) {
; SKX-LABEL: test_mul_v16i32:
; SKX:       # BB#0:
; SKX-NEXT:    vpmulld %zmm1, %zmm0, %zmm0
; SKX-NEXT:    retq
  %ret = mul <16 x i32> %arg1, %arg2
  ret <16 x i32> %ret
}

define <8 x i64> @test_mul_v8i64(<8 x i64> %arg1, <8 x i64> %arg2) {
; SKX-LABEL: test_mul_v8i64:
; SKX:       # BB#0:
; SKX-NEXT:    vpmullq %zmm1, %zmm0, %zmm0
; SKX-NEXT:    retq
  %ret = mul <8 x i64> %arg1, %arg2
  ret <8 x i64> %ret
}

