; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

define float @fadd_undef_op0(float %x) {
; CHECK-LABEL: @fadd_undef_op0(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fadd float undef, %x
  ret float %r
}

define float @fadd_undef_op1(float %x) {
; CHECK-LABEL: @fadd_undef_op1(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fadd float %x, undef
  ret float %r
}

define float @fsub_undef_op0(float %x) {
; CHECK-LABEL: @fsub_undef_op0(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fsub float undef, %x
  ret float %r
}

define float @fsub_undef_op1(float %x) {
; CHECK-LABEL: @fsub_undef_op1(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fsub float %x, undef
  ret float %r
}

define float @fmul_undef_op0(float %x) {
; CHECK-LABEL: @fmul_undef_op0(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fmul float undef, %x
  ret float %r
}

define float @fmul_undef_op1(float %x) {
; CHECK-LABEL: @fmul_undef_op1(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fmul float %x, undef
  ret float %r
}

define float @fdiv_undef_op0(float %x) {
; CHECK-LABEL: @fdiv_undef_op0(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fdiv float undef, %x
  ret float %r
}

define float @fdiv_undef_op1(float %x) {
; CHECK-LABEL: @fdiv_undef_op1(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fdiv float %x, undef
  ret float %r
}

define float @frem_undef_op0(float %x) {
; CHECK-LABEL: @frem_undef_op0(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = frem float undef, %x
  ret float %r
}

define float @frem_undef_op1(float %x) {
; CHECK-LABEL: @frem_undef_op1(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = frem float %x, undef
  ret float %r
}

; Repeat all tests with fast-math-flags. Alternate 'nnan' and 'fast' for more coverage.

define float @fadd_undef_op0_nnan(float %x) {
; CHECK-LABEL: @fadd_undef_op0_nnan(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fadd nnan float undef, %x
  ret float %r
}

define float @fadd_undef_op1_fast(float %x) {
; CHECK-LABEL: @fadd_undef_op1_fast(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fadd fast float %x, undef
  ret float %r
}

define float @fsub_undef_op0_fast(float %x) {
; CHECK-LABEL: @fsub_undef_op0_fast(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fsub fast float undef, %x
  ret float %r
}

define float @fsub_undef_op1_nnan(float %x) {
; CHECK-LABEL: @fsub_undef_op1_nnan(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fsub nnan float %x, undef
  ret float %r
}

define float @fmul_undef_op0_nnan(float %x) {
; CHECK-LABEL: @fmul_undef_op0_nnan(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fmul nnan float undef, %x
  ret float %r
}

define float @fmul_undef_op1_fast(float %x) {
; CHECK-LABEL: @fmul_undef_op1_fast(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fmul fast float %x, undef
  ret float %r
}

define float @fdiv_undef_op0_fast(float %x) {
; CHECK-LABEL: @fdiv_undef_op0_fast(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fdiv fast float undef, %x
  ret float %r
}

define float @fdiv_undef_op1_nnan(float %x) {
; CHECK-LABEL: @fdiv_undef_op1_nnan(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fdiv nnan float %x, undef
  ret float %r
}

define float @frem_undef_op0_nnan(float %x) {
; CHECK-LABEL: @frem_undef_op0_nnan(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = frem nnan float undef, %x
  ret float %r
}

define float @frem_undef_op1_fast(float %x) {
; CHECK-LABEL: @frem_undef_op1_fast(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = frem fast float %x, undef
  ret float %r
}

; Constant folding - undef undef.

define double @fadd_undef_undef(double %x) {
; CHECK-LABEL: @fadd_undef_undef(
; CHECK-NEXT:    ret double undef
;
  %r = fadd double undef, undef
  ret double %r
}

define double @fsub_undef_undef(double %x) {
; CHECK-LABEL: @fsub_undef_undef(
; CHECK-NEXT:    ret double undef
;
  %r = fsub double undef, undef
  ret double %r
}

define double @fmul_undef_undef(double %x) {
; CHECK-LABEL: @fmul_undef_undef(
; CHECK-NEXT:    ret double undef
;
  %r = fmul double undef, undef
  ret double %r
}

define double @fdiv_undef_undef(double %x) {
; CHECK-LABEL: @fdiv_undef_undef(
; CHECK-NEXT:    ret double undef
;
  %r = fdiv double undef, undef
  ret double %r
}

define double @frem_undef_undef(double %x) {
; CHECK-LABEL: @frem_undef_undef(
; CHECK-NEXT:    ret double undef
;
  %r = frem double undef, undef
  ret double %r
}

; Constant folding.

define float @fadd_undef_op0_nnan_constant(float %x) {
; CHECK-LABEL: @fadd_undef_op0_nnan_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fadd nnan float undef, 1.0
  ret float %r
}

define float @fadd_undef_op1_constant(float %x) {
; CHECK-LABEL: @fadd_undef_op1_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fadd float 2.0, undef
  ret float %r
}

define float @fsub_undef_op0_fast_constant(float %x) {
; CHECK-LABEL: @fsub_undef_op0_fast_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fsub fast float undef, 3.0
  ret float %r
}

define float @fsub_undef_op1_constant(float %x) {
; CHECK-LABEL: @fsub_undef_op1_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fsub float 4.0, undef
  ret float %r
}

define float @fmul_undef_op0_nnan_constant(float %x) {
; CHECK-LABEL: @fmul_undef_op0_nnan_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fmul nnan float undef, 5.0
  ret float %r
}

define float @fmul_undef_op1_constant(float %x) {
; CHECK-LABEL: @fmul_undef_op1_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fmul float 6.0, undef
  ret float %r
}

define float @fdiv_undef_op0_fast_constant(float %x) {
; CHECK-LABEL: @fdiv_undef_op0_fast_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fdiv fast float undef, 7.0
  ret float %r
}

define float @fdiv_undef_op1_constant(float %x) {
; CHECK-LABEL: @fdiv_undef_op1_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = fdiv float 8.0, undef
  ret float %r
}

define float @frem_undef_op0_nnan_constant(float %x) {
; CHECK-LABEL: @frem_undef_op0_nnan_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = frem nnan float undef, 9.0
  ret float %r
}

define float @frem_undef_op1_constant(float %x) {
; CHECK-LABEL: @frem_undef_op1_constant(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %r = frem float 10.0, undef
  ret float %r
}

; Constant folding - special constants: NaN.

define double @fadd_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @fadd_undef_op0_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fadd double undef, 0x7FF8000000000000
  ret double %r
}

define double @fadd_undef_op1_fast_constant_nan(double %x) {
; CHECK-LABEL: @fadd_undef_op1_fast_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fadd fast double 0xFFF0000000000001, undef
  ret double %r
}

define double @fsub_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @fsub_undef_op0_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fsub double undef, 0xFFF8000000000010
  ret double %r
}

define double @fsub_undef_op1_nnan_constant_nan(double %x) {
; CHECK-LABEL: @fsub_undef_op1_nnan_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fsub nnan double 0x7FF0000000000011, undef
  ret double %r
}

define double @fmul_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @fmul_undef_op0_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fmul double undef, 0x7FF8000000000100
  ret double %r
}

define double @fmul_undef_op1_fast_constant_nan(double %x) {
; CHECK-LABEL: @fmul_undef_op1_fast_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fmul fast double 0xFFF0000000000101, undef
  ret double %r
}

define double @fdiv_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @fdiv_undef_op0_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fdiv double undef, 0xFFF8000000000110
  ret double %r
}

define double @fdiv_undef_op1_nnan_constant_nan(double %x) {
; CHECK-LABEL: @fdiv_undef_op1_nnan_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fdiv nnan double 0x7FF0000000000111, undef
  ret double %r
}

define double @frem_undef_op0_constant_nan(double %x) {
; CHECK-LABEL: @frem_undef_op0_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = frem double undef, 0x7FF8000000001000
  ret double %r
}

define double @frem_undef_op1_fast_constant_nan(double %x) {
; CHECK-LABEL: @frem_undef_op1_fast_constant_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = frem fast double 0xFFF0000000001001, undef
  ret double %r
}

; Constant folding - special constants: Inf.

define double @fadd_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @fadd_undef_op0_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fadd double undef, 0x7FF0000000000000
  ret double %r
}

define double @fadd_undef_op1_fast_constant_inf(double %x) {
; CHECK-LABEL: @fadd_undef_op1_fast_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fadd fast double 0xFFF0000000000000, undef
  ret double %r
}

define double @fsub_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @fsub_undef_op0_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fsub double undef, 0xFFF0000000000000
  ret double %r
}

define double @fsub_undef_op1_ninf_constant_inf(double %x) {
; CHECK-LABEL: @fsub_undef_op1_ninf_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fsub ninf double 0x7FF0000000000000, undef
  ret double %r
}

define double @fmul_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @fmul_undef_op0_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fmul double undef, 0x7FF0000000000000
  ret double %r
}

define double @fmul_undef_op1_fast_constant_inf(double %x) {
; CHECK-LABEL: @fmul_undef_op1_fast_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fmul fast double 0xFFF0000000000000, undef
  ret double %r
}

define double @fdiv_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @fdiv_undef_op0_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fdiv double undef, 0xFFF0000000000000
  ret double %r
}

define double @fdiv_undef_op1_ninf_constant_inf(double %x) {
; CHECK-LABEL: @fdiv_undef_op1_ninf_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = fdiv ninf double 0x7FF0000000000000, undef
  ret double %r
}

define double @frem_undef_op0_constant_inf(double %x) {
; CHECK-LABEL: @frem_undef_op0_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = frem double undef, 0x7FF0000000000000
  ret double %r
}

define double @frem_undef_op1_fast_constant_inf(double %x) {
; CHECK-LABEL: @frem_undef_op1_fast_constant_inf(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %r = frem fast double 0xFFF0000000000000, undef
  ret double %r
}

