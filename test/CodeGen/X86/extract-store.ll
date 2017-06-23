; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2     | FileCheck %s --check-prefix=X32 --check-prefix=SSE-X32 --check-prefix=SSE2-X32
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2   | FileCheck %s --check-prefix=X64 --check-prefix=SSE-X64 --check-prefix=SSE2-X64
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse4.1   | FileCheck %s --check-prefix=X32 --check-prefix=SSE-X32 --check-prefix=SSE41-X32
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.1 | FileCheck %s --check-prefix=X64 --check-prefix=SSE-X64 --check-prefix=SSE41-X64
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx      | FileCheck %s --check-prefix=X32 --check-prefix=AVX-X32
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx    | FileCheck %s --check-prefix=X64 --check-prefix=AVX-X64
; RUN: llc < %s -O2 -mtriple=x86_64-linux-android -mattr=+mmx -enable-legalize-types-checking | FileCheck %s --check-prefix=X64 --check-prefix=SSE-X64 --check-prefix=SSE-F128
; RUN: llc < %s -O2 -mtriple=x86_64-linux-gnu -mattr=+mmx -enable-legalize-types-checking | FileCheck %s --check-prefix=X64 --check-prefix=SSE-X64 --check-prefix=SSE-F128

define void @extract_i8_0(i8* nocapture %dst, <16 x i8> %foo) nounwind {
; SSE2-X32-LABEL: extract_i8_0:
; SSE2-X32:       # BB#0:
; SSE2-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-X32-NEXT:    movd %xmm0, %ecx
; SSE2-X32-NEXT:    movb %cl, (%eax)
; SSE2-X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_i8_0:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    movd %xmm0, %eax
; SSE2-X64-NEXT:    movb %al, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X32-LABEL: extract_i8_0:
; SSE41-X32:       # BB#0:
; SSE41-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE41-X32-NEXT:    pextrb $0, %xmm0, (%eax)
; SSE41-X32-NEXT:    retl
;
; SSE41-X64-LABEL: extract_i8_0:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    pextrb $0, %xmm0, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i8_0:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vpextrb $0, %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i8_0:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vpextrb $0, %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_i8_0:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    movd %xmm0, %eax
; SSE-F128-NEXT:    movb %al, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <16 x i8> %foo, i32 0
  store i8 %vecext, i8* %dst, align 1
  ret void
}

define void @extract_i8_3(i8* nocapture %dst, <16 x i8> %foo) nounwind {
; SSE2-X32-LABEL: extract_i8_3:
; SSE2-X32:       # BB#0:
; SSE2-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-X32-NEXT:    movd %xmm0, %ecx
; SSE2-X32-NEXT:    shrl $24, %ecx
; SSE2-X32-NEXT:    movb %cl, (%eax)
; SSE2-X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_i8_3:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    movd %xmm0, %eax
; SSE2-X64-NEXT:    shrl $24, %eax
; SSE2-X64-NEXT:    movb %al, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X32-LABEL: extract_i8_3:
; SSE41-X32:       # BB#0:
; SSE41-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE41-X32-NEXT:    pextrb $3, %xmm0, (%eax)
; SSE41-X32-NEXT:    retl
;
; SSE41-X64-LABEL: extract_i8_3:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    pextrb $3, %xmm0, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i8_3:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vpextrb $3, %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i8_3:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vpextrb $3, %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_i8_3:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    movd %xmm0, %eax
; SSE-F128-NEXT:    shrl $24, %eax
; SSE-F128-NEXT:    movb %al, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <16 x i8> %foo, i32 3
  store i8 %vecext, i8* %dst, align 1
  ret void
}

define void @extract_i8_15(i8* nocapture %dst, <16 x i8> %foo) nounwind {
; SSE2-X32-LABEL: extract_i8_15:
; SSE2-X32:       # BB#0:
; SSE2-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-X32-NEXT:    pextrw $7, %xmm0, %ecx
; SSE2-X32-NEXT:    movb %ch, (%eax)
; SSE2-X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_i8_15:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    pextrw $7, %xmm0, %eax
; SSE2-X64-NEXT:    movb %ah, (%rdi) # NOREX
; SSE2-X64-NEXT:    retq
;
; SSE41-X32-LABEL: extract_i8_15:
; SSE41-X32:       # BB#0:
; SSE41-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE41-X32-NEXT:    pextrb $15, %xmm0, (%eax)
; SSE41-X32-NEXT:    retl
;
; SSE41-X64-LABEL: extract_i8_15:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    pextrb $15, %xmm0, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i8_15:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vpextrb $15, %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i8_15:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vpextrb $15, %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_i8_15:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    pextrw $7, %xmm0, %eax
; SSE-F128-NEXT:    movb %ah, (%rdi) # NOREX
; SSE-F128-NEXT:    retq
  %vecext = extractelement <16 x i8> %foo, i32 15
  store i8 %vecext, i8* %dst, align 1
  ret void
}

define void @extract_i16_0(i16* nocapture %dst, <8 x i16> %foo) nounwind {
; SSE2-X32-LABEL: extract_i16_0:
; SSE2-X32:       # BB#0:
; SSE2-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-X32-NEXT:    movd %xmm0, %ecx
; SSE2-X32-NEXT:    movw %cx, (%eax)
; SSE2-X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_i16_0:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    movd %xmm0, %eax
; SSE2-X64-NEXT:    movw %ax, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X32-LABEL: extract_i16_0:
; SSE41-X32:       # BB#0:
; SSE41-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE41-X32-NEXT:    pextrw $0, %xmm0, (%eax)
; SSE41-X32-NEXT:    retl
;
; SSE41-X64-LABEL: extract_i16_0:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    pextrw $0, %xmm0, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i16_0:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vpextrw $0, %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i16_0:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vpextrw $0, %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_i16_0:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    movd %xmm0, %eax
; SSE-F128-NEXT:    movw %ax, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <8 x i16> %foo, i32 0
  store i16 %vecext, i16* %dst, align 1
  ret void
}

define void @extract_i16_7(i16* nocapture %dst, <8 x i16> %foo) nounwind {
; SSE2-X32-LABEL: extract_i16_7:
; SSE2-X32:       # BB#0:
; SSE2-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-X32-NEXT:    pextrw $7, %xmm0, %ecx
; SSE2-X32-NEXT:    movw %cx, (%eax)
; SSE2-X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_i16_7:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    pextrw $7, %xmm0, %eax
; SSE2-X64-NEXT:    movw %ax, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X32-LABEL: extract_i16_7:
; SSE41-X32:       # BB#0:
; SSE41-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE41-X32-NEXT:    pextrw $7, %xmm0, (%eax)
; SSE41-X32-NEXT:    retl
;
; SSE41-X64-LABEL: extract_i16_7:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    pextrw $7, %xmm0, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i16_7:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vpextrw $7, %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i16_7:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vpextrw $7, %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_i16_7:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    pextrw $7, %xmm0, %eax
; SSE-F128-NEXT:    movw %ax, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <8 x i16> %foo, i32 7
  store i16 %vecext, i16* %dst, align 1
  ret void
}

define void @extract_i32_0(i32* nocapture %dst, <4 x i32> %foo) nounwind {
; SSE-X32-LABEL: extract_i32_0:
; SSE-X32:       # BB#0:
; SSE-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X32-NEXT:    movss %xmm0, (%eax)
; SSE-X32-NEXT:    retl
;
; SSE-X64-LABEL: extract_i32_0:
; SSE-X64:       # BB#0:
; SSE-X64-NEXT:    movss %xmm0, (%rdi)
; SSE-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i32_0:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vmovss %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i32_0:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vmovss %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
  %vecext = extractelement <4 x i32> %foo, i32 0
  store i32 %vecext, i32* %dst, align 1
  ret void
}

define void @extract_i32_3(i32* nocapture %dst, <4 x i32> %foo) nounwind {
; SSE2-X32-LABEL: extract_i32_3:
; SSE2-X32:       # BB#0:
; SSE2-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-X32-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-X32-NEXT:    movd %xmm0, (%eax)
; SSE2-X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_i32_3:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-X64-NEXT:    movd %xmm0, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X32-LABEL: extract_i32_3:
; SSE41-X32:       # BB#0:
; SSE41-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE41-X32-NEXT:    pextrd $3, %xmm0, (%eax)
; SSE41-X32-NEXT:    retl
;
; SSE41-X64-LABEL: extract_i32_3:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    pextrd $3, %xmm0, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i32_3:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vpextrd $3, %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i32_3:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vpextrd $3, %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_i32_3:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-F128-NEXT:    movd %xmm0, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <4 x i32> %foo, i32 3
  store i32 %vecext, i32* %dst, align 1
  ret void
}

define void @extract_i64_0(i64* nocapture %dst, <2 x i64> %foo) nounwind {
; SSE-X32-LABEL: extract_i64_0:
; SSE-X32:       # BB#0:
; SSE-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X32-NEXT:    movlps %xmm0, (%eax)
; SSE-X32-NEXT:    retl
;
; SSE-X64-LABEL: extract_i64_0:
; SSE-X64:       # BB#0:
; SSE-X64-NEXT:    movlps %xmm0, (%rdi)
; SSE-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i64_0:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vmovlps %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i64_0:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vmovlps %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
  %vecext = extractelement <2 x i64> %foo, i32 0
  store i64 %vecext, i64* %dst, align 1
  ret void
}

define void @extract_i64_1(i64* nocapture %dst, <2 x i64> %foo) nounwind {
; SSE-X32-LABEL: extract_i64_1:
; SSE-X32:       # BB#0:
; SSE-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X32-NEXT:    psrldq {{.*#+}} xmm0 = xmm0[8,9,10,11,12,13,14,15],zero,zero,zero,zero,zero,zero,zero,zero
; SSE-X32-NEXT:    movq %xmm0, (%eax)
; SSE-X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_i64_1:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; SSE2-X64-NEXT:    movq %xmm0, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X64-LABEL: extract_i64_1:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    pextrq $1, %xmm0, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_i64_1:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; AVX-X32-NEXT:    vmovq %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_i64_1:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vpextrq $1, %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_i64_1:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; SSE-F128-NEXT:    movq %xmm0, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <2 x i64> %foo, i32 1
  store i64 %vecext, i64* %dst, align 1
  ret void
}

define void @extract_f32_0(float* nocapture %dst, <4 x float> %foo) nounwind {
; SSE-X32-LABEL: extract_f32_0:
; SSE-X32:       # BB#0:
; SSE-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X32-NEXT:    movss %xmm0, (%eax)
; SSE-X32-NEXT:    retl
;
; SSE-X64-LABEL: extract_f32_0:
; SSE-X64:       # BB#0:
; SSE-X64-NEXT:    movss %xmm0, (%rdi)
; SSE-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_f32_0:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vmovss %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_f32_0:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vmovss %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
  %vecext = extractelement <4 x float> %foo, i32 0
  store float %vecext, float* %dst, align 1
  ret void
}

define void @extract_f32_3(float* nocapture %dst, <4 x float> %foo) nounwind {
; SSE2-X32-LABEL: extract_f32_3:
; SSE2-X32:       # BB#0:
; SSE2-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE2-X32-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-X32-NEXT:    movss %xmm0, (%eax)
; SSE2-X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_f32_3:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE2-X64-NEXT:    movss %xmm0, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X32-LABEL: extract_f32_3:
; SSE41-X32:       # BB#0:
; SSE41-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE41-X32-NEXT:    extractps $3, %xmm0, (%eax)
; SSE41-X32-NEXT:    retl
;
; SSE41-X64-LABEL: extract_f32_3:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    extractps $3, %xmm0, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_f32_3:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vextractps $3, %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_f32_3:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vextractps $3, %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_f32_3:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; SSE-F128-NEXT:    movss %xmm0, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <4 x float> %foo, i32 3
  store float %vecext, float* %dst, align 1
  ret void
}

define void @extract_f64_0(double* nocapture %dst, <2 x double> %foo) nounwind {
; SSE-X32-LABEL: extract_f64_0:
; SSE-X32:       # BB#0:
; SSE-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X32-NEXT:    movlps %xmm0, (%eax)
; SSE-X32-NEXT:    retl
;
; SSE-X64-LABEL: extract_f64_0:
; SSE-X64:       # BB#0:
; SSE-X64-NEXT:    movlps %xmm0, (%rdi)
; SSE-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_f64_0:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vmovlps %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_f64_0:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vmovlps %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
  %vecext = extractelement <2 x double> %foo, i32 0
  store double %vecext, double* %dst, align 1
  ret void
}

define void @extract_f64_1(double* nocapture %dst, <2 x double> %foo) nounwind {
; SSE-X32-LABEL: extract_f64_1:
; SSE-X32:       # BB#0:
; SSE-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE-X32-NEXT:    movhpd %xmm0, (%eax)
; SSE-X32-NEXT:    retl
;
; SSE-X64-LABEL: extract_f64_1:
; SSE-X64:       # BB#0:
; SSE-X64-NEXT:    movhpd %xmm0, (%rdi)
; SSE-X64-NEXT:    retq
;
; AVX-X32-LABEL: extract_f64_1:
; AVX-X32:       # BB#0:
; AVX-X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; AVX-X32-NEXT:    vmovhpd %xmm0, (%eax)
; AVX-X32-NEXT:    retl
;
; AVX-X64-LABEL: extract_f64_1:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    vmovhpd %xmm0, (%rdi)
; AVX-X64-NEXT:    retq
  %vecext = extractelement <2 x double> %foo, i32 1
  store double %vecext, double* %dst, align 1
  ret void
}

define void @extract_f128_0(fp128* nocapture %dst, <2 x fp128> %foo) nounwind {
; X32-LABEL: extract_f128_0:
; X32:       # BB#0:
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X32-NEXT:    movl %esi, 12(%edi)
; X32-NEXT:    movl %edx, 8(%edi)
; X32-NEXT:    movl %ecx, 4(%edi)
; X32-NEXT:    movl %eax, (%edi)
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_f128_0:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    movq %rdx, 8(%rdi)
; SSE2-X64-NEXT:    movq %rsi, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X64-LABEL: extract_f128_0:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    movq %rdx, 8(%rdi)
; SSE41-X64-NEXT:    movq %rsi, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X64-LABEL: extract_f128_0:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    movq %rdx, 8(%rdi)
; AVX-X64-NEXT:    movq %rsi, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_f128_0:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    movaps %xmm0, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <2 x fp128> %foo, i32 0
  store fp128 %vecext, fp128* %dst, align 1
  ret void
}

define void @extract_f128_1(fp128* nocapture %dst, <2 x fp128> %foo) nounwind {
; X32-LABEL: extract_f128_1:
; X32:       # BB#0:
; X32-NEXT:    pushl %edi
; X32-NEXT:    pushl %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X32-NEXT:    movl %esi, 12(%edi)
; X32-NEXT:    movl %edx, 8(%edi)
; X32-NEXT:    movl %ecx, 4(%edi)
; X32-NEXT:    movl %eax, (%edi)
; X32-NEXT:    popl %esi
; X32-NEXT:    popl %edi
; X32-NEXT:    retl
;
; SSE2-X64-LABEL: extract_f128_1:
; SSE2-X64:       # BB#0:
; SSE2-X64-NEXT:    movq %r8, 8(%rdi)
; SSE2-X64-NEXT:    movq %rcx, (%rdi)
; SSE2-X64-NEXT:    retq
;
; SSE41-X64-LABEL: extract_f128_1:
; SSE41-X64:       # BB#0:
; SSE41-X64-NEXT:    movq %r8, 8(%rdi)
; SSE41-X64-NEXT:    movq %rcx, (%rdi)
; SSE41-X64-NEXT:    retq
;
; AVX-X64-LABEL: extract_f128_1:
; AVX-X64:       # BB#0:
; AVX-X64-NEXT:    movq %r8, 8(%rdi)
; AVX-X64-NEXT:    movq %rcx, (%rdi)
; AVX-X64-NEXT:    retq
;
; SSE-F128-LABEL: extract_f128_1:
; SSE-F128:       # BB#0:
; SSE-F128-NEXT:    movaps %xmm1, (%rdi)
; SSE-F128-NEXT:    retq
  %vecext = extractelement <2 x fp128> %foo, i32 1
  store fp128 %vecext, fp128* %dst, align 1
  ret void
}

define void @extract_i8_undef(i8* nocapture %dst, <16 x i8> %foo) nounwind {
; X32-LABEL: extract_i8_undef:
; X32:       # BB#0:
; X32-NEXT:    retl
;
; X64-LABEL: extract_i8_undef:
; X64:       # BB#0:
; X64-NEXT:    retq
  %vecext = extractelement <16 x i8> %foo, i32 16 ; undef
  store i8 %vecext, i8* %dst, align 1
  ret void
}

define void @extract_i16_undef(i16* nocapture %dst, <8 x i16> %foo) nounwind {
; X32-LABEL: extract_i16_undef:
; X32:       # BB#0:
; X32-NEXT:    retl
;
; X64-LABEL: extract_i16_undef:
; X64:       # BB#0:
; X64-NEXT:    retq
  %vecext = extractelement <8 x i16> %foo, i32 9 ; undef
  store i16 %vecext, i16* %dst, align 1
  ret void
}

define void @extract_i32_undef(i32* nocapture %dst, <4 x i32> %foo) nounwind {
; X32-LABEL: extract_i32_undef:
; X32:       # BB#0:
; X32-NEXT:    retl
;
; X64-LABEL: extract_i32_undef:
; X64:       # BB#0:
; X64-NEXT:    retq
  %vecext = extractelement <4 x i32> %foo, i32 6 ; undef
  store i32 %vecext, i32* %dst, align 1
  ret void
}

define void @extract_i64_undef(i64* nocapture %dst, <2 x i64> %foo) nounwind {
; X32-LABEL: extract_i64_undef:
; X32:       # BB#0:
; X32-NEXT:    retl
;
; X64-LABEL: extract_i64_undef:
; X64:       # BB#0:
; X64-NEXT:    retq
  %vecext = extractelement <2 x i64> %foo, i32 2 ; undef
  store i64 %vecext, i64* %dst, align 1
  ret void
}

define void @extract_f32_undef(float* nocapture %dst, <4 x float> %foo) nounwind {
; X32-LABEL: extract_f32_undef:
; X32:       # BB#0:
; X32-NEXT:    retl
;
; X64-LABEL: extract_f32_undef:
; X64:       # BB#0:
; X64-NEXT:    retq
  %vecext = extractelement <4 x float> %foo, i32 6 ; undef
  store float %vecext, float* %dst, align 1
  ret void
}

define void @extract_f64_undef(double* nocapture %dst, <2 x double> %foo) nounwind {
; X32-LABEL: extract_f64_undef:
; X32:       # BB#0:
; X32-NEXT:    retl
;
; X64-LABEL: extract_f64_undef:
; X64:       # BB#0:
; X64-NEXT:    retq
  %vecext = extractelement <2 x double> %foo, i32 2 ; undef
  store double %vecext, double* %dst, align 1
  ret void
}

define void @extract_f128_undef(fp128* nocapture %dst, <2 x fp128> %foo) nounwind {
; X32-LABEL: extract_f128_undef:
; X32:       # BB#0:
; X32-NEXT:    retl
;
; X64-LABEL: extract_f128_undef:
; X64:       # BB#0:
; X64-NEXT:    retq
  %vecext = extractelement <2 x fp128> %foo, i32 2 ; undef
  store fp128 %vecext, fp128* %dst, align 1
  ret void
}
