; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-linux-gnu -mattr=+sse2,-avx | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-pc-linux -mattr=+sse2,-avx | FileCheck %s --check-prefix=X64

define <2 x i64> @t1(i64 %x) nounwind  {
; X32-LABEL: t1:
; X32:       # BB#0:
; X32-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; X32-NEXT:    retl
;
; X64-LABEL: t1:
; X64:       # BB#0:
; X64-NEXT:    movd %rdi, %xmm0
; X64-NEXT:    retq
  %tmp8 = insertelement <2 x i64> zeroinitializer, i64 %x, i32 0
  ret <2 x i64> %tmp8
}
