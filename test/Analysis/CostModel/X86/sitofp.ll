; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE2
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mattr=+avx  | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX2
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mattr=+avx512f | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512F
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=CHECK,AVX512,AVX512DQ
;
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mcpu=slm | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mcpu=goldmont | FileCheck %s --check-prefixes=CHECK,SSE,SSE42
; RUN: opt < %s -mtriple=x86_64-apple-darwin -cost-model -analyze -mcpu=btver2 | FileCheck %s --check-prefixes=CHECK,AVX,AVX1

define i32 @sitofp_i8_double() {
; SSE-LABEL: 'sitofp_i8_double'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i8_f64 = sitofp i8 undef to double
; SSE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %cvt_v2i8_v2f64 = sitofp <2 x i8> undef to <2 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %cvt_v4i8_v4f64 = sitofp <4 x i8> undef to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %cvt_v8i8_v8f64 = sitofp <8 x i8> undef to <8 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'sitofp_i8_double'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i8_f64 = sitofp i8 undef to double
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %cvt_v2i8_v2f64 = sitofp <2 x i8> undef to <2 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v4i8_v4f64 = sitofp <4 x i8> undef to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %cvt_v8i8_v8f64 = sitofp <8 x i8> undef to <8 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'sitofp_i8_double'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i8_f64 = sitofp i8 undef to double
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %cvt_v2i8_v2f64 = sitofp <2 x i8> undef to <2 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v4i8_v4f64 = sitofp <4 x i8> undef to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %cvt_v8i8_v8f64 = sitofp <8 x i8> undef to <8 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %cvt_i8_f64 = sitofp i8 undef to double
  %cvt_v2i8_v2f64 = sitofp <2 x i8> undef to <2 x double>
  %cvt_v4i8_v4f64 = sitofp <4 x i8> undef to <4 x double>
  %cvt_v8i8_v8f64 = sitofp <8 x i8> undef to <8 x double>
  ret i32 undef
}

define i32 @sitofp_i16_double() {
; SSE-LABEL: 'sitofp_i16_double'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i16_f64 = sitofp i16 undef to double
; SSE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %cvt_v2i16_v2f64 = sitofp <2 x i16> undef to <2 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %cvt_v4i16_v4f64 = sitofp <4 x i16> undef to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %cvt_v8i16_v8f64 = sitofp <8 x i16> undef to <8 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'sitofp_i16_double'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i16_f64 = sitofp i16 undef to double
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %cvt_v2i16_v2f64 = sitofp <2 x i16> undef to <2 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v4i16_v4f64 = sitofp <4 x i16> undef to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %cvt_v8i16_v8f64 = sitofp <8 x i16> undef to <8 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'sitofp_i16_double'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i16_f64 = sitofp i16 undef to double
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %cvt_v2i16_v2f64 = sitofp <2 x i16> undef to <2 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v4i16_v4f64 = sitofp <4 x i16> undef to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %cvt_v8i16_v8f64 = sitofp <8 x i16> undef to <8 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %cvt_i16_f64 = sitofp i16 undef to double
  %cvt_v2i16_v2f64 = sitofp <2 x i16> undef to <2 x double>
  %cvt_v4i16_v4f64 = sitofp <4 x i16> undef to <4 x double>
  %cvt_v8i16_v8f64 = sitofp <8 x i16> undef to <8 x double>
  ret i32 undef
}

define i32 @sitofp_i32_double() {
; SSE-LABEL: 'sitofp_i32_double'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i32_f64 = sitofp i32 undef to double
; SSE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %cvt_v2i32_v2f64 = sitofp <2 x i32> undef to <2 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %cvt_v4i32_v4f64 = sitofp <4 x i32> undef to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %cvt_v8i32_v8f64 = sitofp <8 x i32> undef to <8 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'sitofp_i32_double'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i32_f64 = sitofp i32 undef to double
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %cvt_v2i32_v2f64 = sitofp <2 x i32> undef to <2 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v4i32_v4f64 = sitofp <4 x i32> undef to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v8i32_v8f64 = sitofp <8 x i32> undef to <8 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'sitofp_i32_double'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i32_f64 = sitofp i32 undef to double
; AVX512-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %cvt_v2i32_v2f64 = sitofp <2 x i32> undef to <2 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v4i32_v4f64 = sitofp <4 x i32> undef to <4 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v8i32_v8f64 = sitofp <8 x i32> undef to <8 x double>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %cvt_i32_f64 = sitofp i32 undef to double
  %cvt_v2i32_v2f64 = sitofp <2 x i32> undef to <2 x double>
  %cvt_v4i32_v4f64 = sitofp <4 x i32> undef to <4 x double>
  %cvt_v8i32_v8f64 = sitofp <8 x i32> undef to <8 x double>
  ret i32 undef
}

define i32 @sitofp_i64_double() {
; SSE-LABEL: 'sitofp_i64_double'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i64_f64 = sitofp i64 undef to double
; SSE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %cvt_v2i64_v2f64 = sitofp <2 x i64> undef to <2 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 40 for instruction: %cvt_v4i64_v4f64 = sitofp <4 x i64> undef to <4 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 80 for instruction: %cvt_v8i64_v8f64 = sitofp <8 x i64> undef to <8 x double>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'sitofp_i64_double'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i64_f64 = sitofp i64 undef to double
; AVX-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %cvt_v2i64_v2f64 = sitofp <2 x i64> undef to <2 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 13 for instruction: %cvt_v4i64_v4f64 = sitofp <4 x i64> undef to <4 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 27 for instruction: %cvt_v8i64_v8f64 = sitofp <8 x i64> undef to <8 x double>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512F-LABEL: 'sitofp_i64_double'
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i64_f64 = sitofp i64 undef to double
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %cvt_v2i64_v2f64 = sitofp <2 x i64> undef to <2 x double>
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 13 for instruction: %cvt_v4i64_v4f64 = sitofp <4 x i64> undef to <4 x double>
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %cvt_v8i64_v8f64 = sitofp <8 x i64> undef to <8 x double>
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512DQ-LABEL: 'sitofp_i64_double'
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i64_f64 = sitofp i64 undef to double
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v2i64_v2f64 = sitofp <2 x i64> undef to <2 x double>
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v4i64_v4f64 = sitofp <4 x i64> undef to <4 x double>
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v8i64_v8f64 = sitofp <8 x i64> undef to <8 x double>
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %cvt_i64_f64 = sitofp i64 undef to double
  %cvt_v2i64_v2f64 = sitofp <2 x i64> undef to <2 x double>
  %cvt_v4i64_v4f64 = sitofp <4 x i64> undef to <4 x double>
  %cvt_v8i64_v8f64 = sitofp <8 x i64> undef to <8 x double>
  ret i32 undef
}

define i32 @sitofp_i8_float() {
; SSE-LABEL: 'sitofp_i8_float'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i8_f32 = sitofp i8 undef to float
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %cvt_v4i8_v4f32 = sitofp <4 x i8> undef to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %cvt_v8i8_v8f32 = sitofp <8 x i8> undef to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %cvt_v16i8_v16f32 = sitofp <16 x i8> undef to <16 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'sitofp_i8_float'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i8_f32 = sitofp i8 undef to float
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v4i8_v4f32 = sitofp <4 x i8> undef to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %cvt_v8i8_v8f32 = sitofp <8 x i8> undef to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 17 for instruction: %cvt_v16i8_v16f32 = sitofp <16 x i8> undef to <16 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'sitofp_i8_float'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i8_f32 = sitofp i8 undef to float
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v4i8_v4f32 = sitofp <4 x i8> undef to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %cvt_v8i8_v8f32 = sitofp <8 x i8> undef to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %cvt_v16i8_v16f32 = sitofp <16 x i8> undef to <16 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %cvt_i8_f32 = sitofp i8 undef to float
  %cvt_v4i8_v4f32 = sitofp <4 x i8> undef to <4 x float>
  %cvt_v8i8_v8f32 = sitofp <8 x i8> undef to <8 x float>
  %cvt_v16i8_v16f32 = sitofp <16 x i8> undef to <16 x float>
  ret i32 undef
}

define i32 @sitofp_i16_float() {
; SSE-LABEL: 'sitofp_i16_float'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i16_f32 = sitofp i16 undef to float
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %cvt_v4i16_v4f32 = sitofp <4 x i16> undef to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %cvt_v8i16_v8f32 = sitofp <8 x i16> undef to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 30 for instruction: %cvt_v16i16_v16f32 = sitofp <16 x i16> undef to <16 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'sitofp_i16_float'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i16_f32 = sitofp i16 undef to float
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v4i16_v4f32 = sitofp <4 x i16> undef to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %cvt_v8i16_v8f32 = sitofp <8 x i16> undef to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %cvt_v16i16_v16f32 = sitofp <16 x i16> undef to <16 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'sitofp_i16_float'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i16_f32 = sitofp i16 undef to float
; AVX512-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v4i16_v4f32 = sitofp <4 x i16> undef to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %cvt_v8i16_v8f32 = sitofp <8 x i16> undef to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %cvt_v16i16_v16f32 = sitofp <16 x i16> undef to <16 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %cvt_i16_f32 = sitofp i16 undef to float
  %cvt_v4i16_v4f32 = sitofp <4 x i16> undef to <4 x float>
  %cvt_v8i16_v8f32 = sitofp <8 x i16> undef to <8 x float>
  %cvt_v16i16_v16f32 = sitofp <16 x i16> undef to <16 x float>
  ret i32 undef
}

define i32 @sitofp_i32_float() {
; SSE-LABEL: 'sitofp_i32_float'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i32_f32 = sitofp i32 undef to float
; SSE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %cvt_v4i32_v4f32 = sitofp <4 x i32> undef to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %cvt_v8i32_v8f32 = sitofp <8 x i32> undef to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %cvt_v16i32_v16f32 = sitofp <16 x i32> undef to <16 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'sitofp_i32_float'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i32_f32 = sitofp i32 undef to float
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v4i32_v4f32 = sitofp <4 x i32> undef to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v8i32_v8f32 = sitofp <8 x i32> undef to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v16i32_v16f32 = sitofp <16 x i32> undef to <16 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512-LABEL: 'sitofp_i32_float'
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i32_f32 = sitofp i32 undef to float
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v4i32_v4f32 = sitofp <4 x i32> undef to <4 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v8i32_v8f32 = sitofp <8 x i32> undef to <8 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v16i32_v16f32 = sitofp <16 x i32> undef to <16 x float>
; AVX512-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %cvt_i32_f32 = sitofp i32 undef to float
  %cvt_v4i32_v4f32 = sitofp <4 x i32> undef to <4 x float>
  %cvt_v8i32_v8f32 = sitofp <8 x i32> undef to <8 x float>
  %cvt_v16i32_v16f32 = sitofp <16 x i32> undef to <16 x float>
  ret i32 undef
}

define i32 @sitofp_i64_float() {
; SSE-LABEL: 'sitofp_i64_float'
; SSE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i64_f32 = sitofp i64 undef to float
; SSE-NEXT:  Cost Model: Found an estimated cost of 15 for instruction: %cvt_v2i64_v2f32 = sitofp <2 x i64> undef to <2 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 30 for instruction: %cvt_v4i64_v4f32 = sitofp <4 x i64> undef to <4 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 60 for instruction: %cvt_v8i64_v8f32 = sitofp <8 x i64> undef to <8 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 120 for instruction: %cvt_v16i64_v16f32 = sitofp <16 x i64> undef to <16 x float>
; SSE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX-LABEL: 'sitofp_i64_float'
; AVX-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i64_f32 = sitofp i64 undef to float
; AVX-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %cvt_v2i64_v2f32 = sitofp <2 x i64> undef to <2 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %cvt_v4i64_v4f32 = sitofp <4 x i64> undef to <4 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 21 for instruction: %cvt_v8i64_v8f32 = sitofp <8 x i64> undef to <8 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 43 for instruction: %cvt_v16i64_v16f32 = sitofp <16 x i64> undef to <16 x float>
; AVX-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512F-LABEL: 'sitofp_i64_float'
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i64_f32 = sitofp i64 undef to float
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %cvt_v2i64_v2f32 = sitofp <2 x i64> undef to <2 x float>
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %cvt_v4i64_v4f32 = sitofp <4 x i64> undef to <4 x float>
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 22 for instruction: %cvt_v8i64_v8f32 = sitofp <8 x i64> undef to <8 x float>
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 45 for instruction: %cvt_v16i64_v16f32 = sitofp <16 x i64> undef to <16 x float>
; AVX512F-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; AVX512DQ-LABEL: 'sitofp_i64_float'
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_i64_f32 = sitofp i64 undef to float
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v2i64_v2f32 = sitofp <2 x i64> undef to <2 x float>
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v4i64_v4f32 = sitofp <4 x i64> undef to <4 x float>
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %cvt_v8i64_v8f32 = sitofp <8 x i64> undef to <8 x float>
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %cvt_v16i64_v16f32 = sitofp <16 x i64> undef to <16 x float>
; AVX512DQ-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %cvt_i64_f32 = sitofp i64 undef to float
  %cvt_v2i64_v2f32 = sitofp <2 x i64> undef to <2 x float>
  %cvt_v4i64_v4f32 = sitofp <4 x i64> undef to <4 x float>
  %cvt_v8i64_v8f32 = sitofp <8 x i64> undef to <8 x float>
  %cvt_v16i64_v16f32 = sitofp <16 x i64> undef to <16 x float>
  ret i32 undef
}
