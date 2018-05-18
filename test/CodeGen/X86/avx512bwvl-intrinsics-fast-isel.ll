; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512vl | FileCheck %s --check-prefix=ALL --check-prefix=X32
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512vl | FileCheck %s --check-prefix=ALL --check-prefix=X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/avx512vlbw-builtins.c

define zeroext i16 @test_mm_test_epi8_mask(<2 x i64> %__A, <2 x i64> %__B) {
; X32-LABEL: test_mm_test_epi8_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vptestmb %xmm0, %xmm1, %k0
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzwl %ax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_test_epi8_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestmb %xmm0, %xmm1, %k0
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    retq
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <16 x i8>
  %1 = icmp ne <16 x i8> %0, zeroinitializer
  %2 = bitcast <16 x i1> %1 to i16
  ret i16 %2
}

define zeroext i16 @test_mm_mask_test_epi8_mask(i16 zeroext %__U, <2 x i64> %__A, <2 x i64> %__B) {
; X32-LABEL: test_mm_mask_test_epi8_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vptestmb %xmm0, %xmm1, %k0 {%k1}
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzwl %ax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_mask_test_epi8_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vptestmb %xmm0, %xmm1, %k0 {%k1}
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    retq
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <16 x i8>
  %1 = icmp ne <16 x i8> %0, zeroinitializer
  %2 = bitcast i16 %__U to <16 x i1>
  %3 = and <16 x i1> %1, %2
  %4 = bitcast <16 x i1> %3 to i16
  ret i16 %4
}

define i32 @test_mm256_test_epi8_mask(<4 x i64> %__A, <4 x i64> %__B) {
; X32-LABEL: test_mm256_test_epi8_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vptestmb %ymm0, %ymm1, %k0
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_test_epi8_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestmb %ymm0, %ymm1, %k0
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <32 x i8>
  %1 = icmp ne <32 x i8> %0, zeroinitializer
  %2 = bitcast <32 x i1> %1 to i32
  ret i32 %2
}

define i32 @test_mm256_mask_test_epi8_mask(i32 %__U, <4 x i64> %__A, <4 x i64> %__B) {
; X32-LABEL: test_mm256_mask_test_epi8_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vptestmb %ymm0, %ymm1, %k0 {%k1}
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_test_epi8_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vptestmb %ymm0, %ymm1, %k0 {%k1}
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <32 x i8>
  %1 = icmp ne <32 x i8> %0, zeroinitializer
  %2 = bitcast i32 %__U to <32 x i1>
  %3 = and <32 x i1> %1, %2
  %4 = bitcast <32 x i1> %3 to i32
  ret i32 %4
}

define zeroext i8 @test_mm_test_epi16_mask(<2 x i64> %__A, <2 x i64> %__B) {
; X32-LABEL: test_mm_test_epi16_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vptestmw %xmm0, %xmm1, %k0
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzbl %al, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_test_epi16_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestmw %xmm0, %xmm1, %k0
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    retq
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <8 x i16>
  %1 = icmp ne <8 x i16> %0, zeroinitializer
  %2 = bitcast <8 x i1> %1 to i8
  ret i8 %2
}

define zeroext i8 @test_mm_mask_test_epi16_mask(i8 zeroext %__U, <2 x i64> %__A, <2 x i64> %__B) {
; X32-LABEL: test_mm_mask_test_epi16_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    kmovd %eax, %k1
; X32-NEXT:    vptestmw %xmm0, %xmm1, %k0 {%k1}
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzbl %al, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_mask_test_epi16_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vptestmw %xmm0, %xmm1, %k0 {%k1}
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    retq
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <8 x i16>
  %1 = icmp ne <8 x i16> %0, zeroinitializer
  %2 = bitcast i8 %__U to <8 x i1>
  %3 = and <8 x i1> %1, %2
  %4 = bitcast <8 x i1> %3 to i8
  ret i8 %4
}

define zeroext i16 @test_mm256_test_epi16_mask(<4 x i64> %__A, <4 x i64> %__B) {
; X32-LABEL: test_mm256_test_epi16_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vptestmw %ymm0, %ymm1, %k0
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzwl %ax, %eax
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_test_epi16_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestmw %ymm0, %ymm1, %k0
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <16 x i16>
  %1 = icmp ne <16 x i16> %0, zeroinitializer
  %2 = bitcast <16 x i1> %1 to i16
  ret i16 %2
}

define zeroext i16 @test_mm256_mask_test_epi16_mask(i16 zeroext %__U, <4 x i64> %__A, <4 x i64> %__B) {
; X32-LABEL: test_mm256_mask_test_epi16_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vptestmw %ymm0, %ymm1, %k0 {%k1}
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzwl %ax, %eax
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_test_epi16_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vptestmw %ymm0, %ymm1, %k0 {%k1}
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <16 x i16>
  %1 = icmp ne <16 x i16> %0, zeroinitializer
  %2 = bitcast i16 %__U to <16 x i1>
  %3 = and <16 x i1> %1, %2
  %4 = bitcast <16 x i1> %3 to i16
  ret i16 %4
}

define zeroext i16 @test_mm_testn_epi8_mask(<2 x i64> %__A, <2 x i64> %__B) {
; X32-LABEL: test_mm_testn_epi8_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vptestnmb %xmm0, %xmm1, %k0
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzwl %ax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_testn_epi8_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestnmb %xmm0, %xmm1, %k0
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    retq
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <16 x i8>
  %1 = icmp eq <16 x i8> %0, zeroinitializer
  %2 = bitcast <16 x i1> %1 to i16
  ret i16 %2
}

define zeroext i16 @test_mm_mask_testn_epi8_mask(i16 zeroext %__U, <2 x i64> %__A, <2 x i64> %__B) {
; X32-LABEL: test_mm_mask_testn_epi8_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vptestnmb %xmm0, %xmm1, %k0 {%k1}
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzwl %ax, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_mask_testn_epi8_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vptestnmb %xmm0, %xmm1, %k0 {%k1}
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    retq
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <16 x i8>
  %1 = icmp eq <16 x i8> %0, zeroinitializer
  %2 = bitcast i16 %__U to <16 x i1>
  %3 = and <16 x i1> %1, %2
  %4 = bitcast <16 x i1> %3 to i16
  ret i16 %4
}

define i32 @test_mm256_testn_epi8_mask(<4 x i64> %__A, <4 x i64> %__B) {
; X32-LABEL: test_mm256_testn_epi8_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vptestnmb %ymm0, %ymm1, %k0
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_testn_epi8_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestnmb %ymm0, %ymm1, %k0
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <32 x i8>
  %1 = icmp eq <32 x i8> %0, zeroinitializer
  %2 = bitcast <32 x i1> %1 to i32
  ret i32 %2
}

define i32 @test_mm256_mask_testn_epi8_mask(i32 %__U, <4 x i64> %__A, <4 x i64> %__B) {
; X32-LABEL: test_mm256_mask_testn_epi8_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vptestnmb %ymm0, %ymm1, %k0 {%k1}
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_testn_epi8_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vptestnmb %ymm0, %ymm1, %k0 {%k1}
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <32 x i8>
  %1 = icmp eq <32 x i8> %0, zeroinitializer
  %2 = bitcast i32 %__U to <32 x i1>
  %3 = and <32 x i1> %1, %2
  %4 = bitcast <32 x i1> %3 to i32
  ret i32 %4
}

define zeroext i8 @test_mm_testn_epi16_mask(<2 x i64> %__A, <2 x i64> %__B) {
; X32-LABEL: test_mm_testn_epi16_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vptestnmw %xmm0, %xmm1, %k0
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzbl %al, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_testn_epi16_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestnmw %xmm0, %xmm1, %k0
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    retq
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <8 x i16>
  %1 = icmp eq <8 x i16> %0, zeroinitializer
  %2 = bitcast <8 x i1> %1 to i8
  ret i8 %2
}

define zeroext i8 @test_mm_mask_testn_epi16_mask(i8 zeroext %__U, <2 x i64> %__A, <2 x i64> %__B) {
; X32-LABEL: test_mm_mask_testn_epi16_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    kmovd %eax, %k1
; X32-NEXT:    vptestnmw %xmm0, %xmm1, %k0 {%k1}
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzbl %al, %eax
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_mask_testn_epi16_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vptestnmw %xmm0, %xmm1, %k0 {%k1}
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    retq
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <8 x i16>
  %1 = icmp eq <8 x i16> %0, zeroinitializer
  %2 = bitcast i8 %__U to <8 x i1>
  %3 = and <8 x i1> %1, %2
  %4 = bitcast <8 x i1> %3 to i8
  ret i8 %4
}

define zeroext i16 @test_mm256_testn_epi16_mask(<4 x i64> %__A, <4 x i64> %__B) {
; X32-LABEL: test_mm256_testn_epi16_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vptestnmw %ymm0, %ymm1, %k0
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzwl %ax, %eax
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_testn_epi16_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vptestnmw %ymm0, %ymm1, %k0
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <16 x i16>
  %1 = icmp eq <16 x i16> %0, zeroinitializer
  %2 = bitcast <16 x i1> %1 to i16
  ret i16 %2
}

define zeroext i16 @test_mm256_mask_testn_epi16_mask(i16 zeroext %__U, <4 x i64> %__A, <4 x i64> %__B) {
; X32-LABEL: test_mm256_mask_testn_epi16_mask:
; X32:       # %bb.0: # %entry
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vptestnmw %ymm0, %ymm1, %k0 {%k1}
; X32-NEXT:    kmovd %k0, %eax
; X32-NEXT:    movzwl %ax, %eax
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_testn_epi16_mask:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vptestnmw %ymm0, %ymm1, %k0 {%k1}
; X64-NEXT:    kmovd %k0, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <16 x i16>
  %1 = icmp eq <16 x i16> %0, zeroinitializer
  %2 = bitcast i16 %__U to <16 x i1>
  %3 = and <16 x i1> %1, %2
  %4 = bitcast <16 x i1> %3 to i16
  ret i16 %4
}

define <2 x i64> @test_mm_mask_set1_epi8(<2 x i64> %__O, i16 zeroext %__M, i8 signext %__A) local_unnamed_addr #0 {
; X32-LABEL: test_mm_mask_set1_epi8:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastb %eax, %xmm0 {%k1}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_mask_set1_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastb %esi, %xmm0 {%k1}
; X64-NEXT:    retq
entry:
  %vecinit.i.i = insertelement <16 x i8> undef, i8 %__A, i32 0
  %vecinit15.i.i = shufflevector <16 x i8> %vecinit.i.i, <16 x i8> undef, <16 x i32> zeroinitializer
  %0 = bitcast <2 x i64> %__O to <16 x i8>
  %1 = bitcast i16 %__M to <16 x i1>
  %2 = select <16 x i1> %1, <16 x i8> %vecinit15.i.i, <16 x i8> %0
  %3 = bitcast <16 x i8> %2 to <2 x i64>
  ret <2 x i64> %3
}

define <2 x i64> @test_mm_maskz_set1_epi8(i16 zeroext %__M, i8 signext %__A)  {
; X32-LABEL: test_mm_maskz_set1_epi8:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastb %eax, %xmm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_maskz_set1_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastb %esi, %xmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %vecinit.i.i = insertelement <16 x i8> undef, i8 %__A, i32 0
  %vecinit15.i.i = shufflevector <16 x i8> %vecinit.i.i, <16 x i8> undef, <16 x i32> zeroinitializer
  %0 = bitcast i16 %__M to <16 x i1>
  %1 = select <16 x i1> %0, <16 x i8> %vecinit15.i.i, <16 x i8> zeroinitializer
  %2 = bitcast <16 x i8> %1 to <2 x i64>
  ret <2 x i64> %2
}

define <4 x i64> @test_mm256_mask_set1_epi8(<4 x i64> %__O, i32 %__M, i8 signext %__A){
; X32-LABEL: test_mm256_mask_set1_epi8:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastb %eax, %ymm0 {%k1}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_set1_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastb %esi, %ymm0 {%k1}
; X64-NEXT:    retq
entry:
  %vecinit.i.i = insertelement <32 x i8> undef, i8 %__A, i32 0
  %vecinit31.i.i = shufflevector <32 x i8> %vecinit.i.i, <32 x i8> undef, <32 x i32> zeroinitializer
  %0 = bitcast <4 x i64> %__O to <32 x i8>
  %1 = bitcast i32 %__M to <32 x i1>
  %2 = select <32 x i1> %1, <32 x i8> %vecinit31.i.i, <32 x i8> %0
  %3 = bitcast <32 x i8> %2 to <4 x i64>
  ret <4 x i64> %3
}

define <4 x i64> @test_mm256_maskz_set1_epi8(i32 %__M, i8 signext %__A)  {
; X32-LABEL: test_mm256_maskz_set1_epi8:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastb %eax, %ymm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_maskz_set1_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastb %esi, %ymm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %vecinit.i.i = insertelement <32 x i8> undef, i8 %__A, i32 0
  %vecinit31.i.i = shufflevector <32 x i8> %vecinit.i.i, <32 x i8> undef, <32 x i32> zeroinitializer
  %0 = bitcast i32 %__M to <32 x i1>
  %1 = select <32 x i1> %0, <32 x i8> %vecinit31.i.i, <32 x i8> zeroinitializer
  %2 = bitcast <32 x i8> %1 to <4 x i64>
  ret <4 x i64> %2
}

define <4 x i64> @test_mm256_mask_set1_epi16(<4 x i64> %__O, i16 zeroext %__M, i16 signext %__A)  {
; X32-LABEL: test_mm256_mask_set1_epi16:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastw %eax, %ymm0 {%k1}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_set1_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastw %esi, %ymm0 {%k1}
; X64-NEXT:    retq
entry:
  %vecinit.i.i = insertelement <16 x i16> undef, i16 %__A, i32 0
  %vecinit15.i.i = shufflevector <16 x i16> %vecinit.i.i, <16 x i16> undef, <16 x i32> zeroinitializer
  %0 = bitcast <4 x i64> %__O to <16 x i16>
  %1 = bitcast i16 %__M to <16 x i1>
  %2 = select <16 x i1> %1, <16 x i16> %vecinit15.i.i, <16 x i16> %0
  %3 = bitcast <16 x i16> %2 to <4 x i64>
  ret <4 x i64> %3
}

define <4 x i64> @test_mm256_maskz_set1_epi16(i16 zeroext %__M, i16 signext %__A) {
; X32-LABEL: test_mm256_maskz_set1_epi16:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastw %eax, %ymm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_maskz_set1_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastw %esi, %ymm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %vecinit.i.i = insertelement <16 x i16> undef, i16 %__A, i32 0
  %vecinit15.i.i = shufflevector <16 x i16> %vecinit.i.i, <16 x i16> undef, <16 x i32> zeroinitializer
  %0 = bitcast i16 %__M to <16 x i1>
  %1 = select <16 x i1> %0, <16 x i16> %vecinit15.i.i, <16 x i16> zeroinitializer
  %2 = bitcast <16 x i16> %1 to <4 x i64>
  ret <4 x i64> %2
}

define <2 x i64> @test_mm_mask_set1_epi16(<2 x i64> %__O, i8 zeroext %__M, i16 signext %__A) {
; X32-LABEL: test_mm_mask_set1_epi16:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X32-NEXT:    kmovd %ecx, %k1
; X32-NEXT:    vpbroadcastw %eax, %xmm0 {%k1}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_mask_set1_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastw %esi, %xmm0 {%k1}
; X64-NEXT:    retq
entry:
  %vecinit.i.i = insertelement <8 x i16> undef, i16 %__A, i32 0
  %vecinit7.i.i = shufflevector <8 x i16> %vecinit.i.i, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = bitcast <2 x i64> %__O to <8 x i16>
  %1 = bitcast i8 %__M to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i16> %vecinit7.i.i, <8 x i16> %0
  %3 = bitcast <8 x i16> %2 to <2 x i64>
  ret <2 x i64> %3
}

define <2 x i64> @test_mm_maskz_set1_epi16(i8 zeroext %__M, i16 signext %__A) {
; X32-LABEL: test_mm_maskz_set1_epi16:
; X32:       # %bb.0: # %entry
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X32-NEXT:    kmovd %ecx, %k1
; X32-NEXT:    vpbroadcastw %eax, %xmm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_maskz_set1_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastw %esi, %xmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %vecinit.i.i = insertelement <8 x i16> undef, i16 %__A, i32 0
  %vecinit7.i.i = shufflevector <8 x i16> %vecinit.i.i, <8 x i16> undef, <8 x i32> zeroinitializer
  %0 = bitcast i8 %__M to <8 x i1>
  %1 = select <8 x i1> %0, <8 x i16> %vecinit7.i.i, <8 x i16> zeroinitializer
  %2 = bitcast <8 x i16> %1 to <2 x i64>
  ret <2 x i64> %2
}


define <2 x i64> @test_mm_broadcastb_epi8(<2 x i64> %a0) {
; X32-LABEL: test_mm_broadcastb_epi8:
; X32:       # %bb.0:
; X32-NEXT:    vpbroadcastb %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_broadcastb_epi8:
; X64:       # %bb.0:
; X64-NEXT:    vpbroadcastb %xmm0, %xmm0
; X64-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res0 = shufflevector <16 x i8> %arg0, <16 x i8> undef, <16 x i32> zeroinitializer
  %res1 = bitcast <16 x i8> %res0 to <2 x i64>
  ret <2 x i64> %res1
}

define <2 x i64> @test_mm_mask_broadcastb_epi8(<2 x i64> %a0, i16 %a1, <2 x i64> %a2) {
; X32-LABEL: test_mm_mask_broadcastb_epi8:
; X32:       # %bb.0:
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastb %xmm1, %xmm0 {%k1}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_mask_broadcastb_epi8:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastb %xmm1, %xmm0 {%k1}
; X64-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %arg1 = bitcast i16 %a1 to <16 x i1>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res0 = shufflevector <16 x i8> %arg2, <16 x i8> undef, <16 x i32> zeroinitializer
  %res1 = select <16 x i1> %arg1, <16 x i8> %res0, <16 x i8> %arg0
  %res2 = bitcast <16 x i8> %res1 to <2 x i64>
  ret <2 x i64> %res2
}

define <2 x i64> @test_mm_maskz_broadcastb_epi8(i16 %a0, <2 x i64> %a1) {
; X32-LABEL: test_mm_maskz_broadcastb_epi8:
; X32:       # %bb.0:
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastb %xmm0, %xmm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_maskz_broadcastb_epi8:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastb %xmm0, %xmm0 {%k1} {z}
; X64-NEXT:    retq
  %arg0 = bitcast i16 %a0 to <16 x i1>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res0 = shufflevector <16 x i8> %arg1, <16 x i8> undef, <16 x i32> zeroinitializer
  %res1 = select <16 x i1> %arg0, <16 x i8> %res0, <16 x i8> zeroinitializer
  %res2 = bitcast <16 x i8> %res1 to <2 x i64>
  ret <2 x i64> %res2
}

define <4 x i64> @test_mm256_broadcastb_epi8(<2 x i64> %a0) {
; X32-LABEL: test_mm256_broadcastb_epi8:
; X32:       # %bb.0:
; X32-NEXT:    vpbroadcastb %xmm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_broadcastb_epi8:
; X64:       # %bb.0:
; X64-NEXT:    vpbroadcastb %xmm0, %ymm0
; X64-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <16 x i8>
  %res0 = shufflevector <16 x i8> %arg0, <16 x i8> undef, <32 x i32> zeroinitializer
  %res1 = bitcast <32 x i8> %res0 to <4 x i64>
  ret <4 x i64> %res1
}

define <4 x i64> @test_mm256_mask_broadcastb_epi8(<4 x i64> %a0, i32 %a1, <2 x i64> %a2) {
; X32-LABEL: test_mm256_mask_broadcastb_epi8:
; X32:       # %bb.0:
; X32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastb %xmm1, %ymm0 {%k1}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_broadcastb_epi8:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastb %xmm1, %ymm0 {%k1}
; X64-NEXT:    retq
  %arg0 = bitcast <4 x i64> %a0 to <32 x i8>
  %arg1 = bitcast i32 %a1 to <32 x i1>
  %arg2 = bitcast <2 x i64> %a2 to <16 x i8>
  %res0 = shufflevector <16 x i8> %arg2, <16 x i8> undef, <32 x i32> zeroinitializer
  %res1 = select <32 x i1> %arg1, <32 x i8> %res0, <32 x i8> %arg0
  %res2 = bitcast <32 x i8> %res1 to <4 x i64>
  ret <4 x i64> %res2
}

define <4 x i64> @test_mm256_maskz_broadcastb_epi8(i32 %a0, <2 x i64> %a1) {
; X32-LABEL: test_mm256_maskz_broadcastb_epi8:
; X32:       # %bb.0:
; X32-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastb %xmm0, %ymm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_maskz_broadcastb_epi8:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastb %xmm0, %ymm0 {%k1} {z}
; X64-NEXT:    retq
  %arg0 = bitcast i32 %a0 to <32 x i1>
  %arg1 = bitcast <2 x i64> %a1 to <16 x i8>
  %res0 = shufflevector <16 x i8> %arg1, <16 x i8> undef, <32 x i32> zeroinitializer
  %res1 = select <32 x i1> %arg0, <32 x i8> %res0, <32 x i8> zeroinitializer
  %res2 = bitcast <32 x i8> %res1 to <4 x i64>
  ret <4 x i64> %res2
}

define <2 x i64> @test_mm_broadcastw_epi16(<2 x i64> %a0) {
; X32-LABEL: test_mm_broadcastw_epi16:
; X32:       # %bb.0:
; X32-NEXT:    vpbroadcastw %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_broadcastw_epi16:
; X64:       # %bb.0:
; X64-NEXT:    vpbroadcastw %xmm0, %xmm0
; X64-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res0 = shufflevector <8 x i16> %arg0, <8 x i16> undef, <8 x i32> zeroinitializer
  %res1 = bitcast <8 x i16> %res0 to <2 x i64>
  ret <2 x i64> %res1
}

define <2 x i64> @test_mm_mask_broadcastw_epi16(<2 x i64> %a0, i8 %a1, <2 x i64> %a2) {
; X32-LABEL: test_mm_mask_broadcastw_epi16:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    kmovd %eax, %k1
; X32-NEXT:    vpbroadcastw %xmm1, %xmm0 {%k1}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_mask_broadcastw_epi16:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastw %xmm1, %xmm0 {%k1}
; X64-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %arg1 = bitcast i8 %a1 to <8 x i1>
  %arg2 = bitcast <2 x i64> %a2 to <8 x i16>
  %res0 = shufflevector <8 x i16> %arg2, <8 x i16> undef, <8 x i32> zeroinitializer
  %res1 = select <8 x i1> %arg1, <8 x i16> %res0, <8 x i16> %arg0
  %res2 = bitcast <8 x i16> %res1 to <2 x i64>
  ret <2 x i64> %res2
}

define <2 x i64> @test_mm_maskz_broadcastw_epi16(i8 %a0, <2 x i64> %a1) {
; X32-LABEL: test_mm_maskz_broadcastw_epi16:
; X32:       # %bb.0:
; X32-NEXT:    movb {{[0-9]+}}(%esp), %al
; X32-NEXT:    kmovd %eax, %k1
; X32-NEXT:    vpbroadcastw %xmm0, %xmm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm_maskz_broadcastw_epi16:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastw %xmm0, %xmm0 {%k1} {z}
; X64-NEXT:    retq
  %arg0 = bitcast i8 %a0 to <8 x i1>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %res0 = shufflevector <8 x i16> %arg1, <8 x i16> undef, <8 x i32> zeroinitializer
  %res1 = select <8 x i1> %arg0, <8 x i16> %res0, <8 x i16> zeroinitializer
  %res2 = bitcast <8 x i16> %res1 to <2 x i64>
  ret <2 x i64> %res2
}

define <4 x i64> @test_mm256_broadcastw_epi16(<2 x i64> %a0) {
; X32-LABEL: test_mm256_broadcastw_epi16:
; X32:       # %bb.0:
; X32-NEXT:    vpbroadcastw %xmm0, %ymm0
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_broadcastw_epi16:
; X64:       # %bb.0:
; X64-NEXT:    vpbroadcastw %xmm0, %ymm0
; X64-NEXT:    retq
  %arg0 = bitcast <2 x i64> %a0 to <8 x i16>
  %res0 = shufflevector <8 x i16> %arg0, <8 x i16> undef, <16 x i32> zeroinitializer
  %res1 = bitcast <16 x i16> %res0 to <4 x i64>
  ret <4 x i64> %res1
}

define <4 x i64> @test_mm256_mask_broadcastw_epi16(<4 x i64> %a0, i16 %a1, <2 x i64> %a2) {
; X32-LABEL: test_mm256_mask_broadcastw_epi16:
; X32:       # %bb.0:
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastw %xmm1, %ymm0 {%k1}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_broadcastw_epi16:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastw %xmm1, %ymm0 {%k1}
; X64-NEXT:    retq
  %arg0 = bitcast <4 x i64> %a0 to <16 x i16>
  %arg1 = bitcast i16 %a1 to <16 x i1>
  %arg2 = bitcast <2 x i64> %a2 to <8 x i16>
  %res0 = shufflevector <8 x i16> %arg2, <8 x i16> undef, <16 x i32> zeroinitializer
  %res1 = select <16 x i1> %arg1, <16 x i16> %res0, <16 x i16> %arg0
  %res2 = bitcast <16 x i16> %res1 to <4 x i64>
  ret <4 x i64> %res2
}

define <4 x i64> @test_mm256_maskz_broadcastw_epi16(i16 %a0, <2 x i64> %a1) {
; X32-LABEL: test_mm256_maskz_broadcastw_epi16:
; X32:       # %bb.0:
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpbroadcastw %xmm0, %ymm0 {%k1} {z}
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_maskz_broadcastw_epi16:
; X64:       # %bb.0:
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpbroadcastw %xmm0, %ymm0 {%k1} {z}
; X64-NEXT:    retq
  %arg0 = bitcast i16 %a0 to <16 x i1>
  %arg1 = bitcast <2 x i64> %a1 to <8 x i16>
  %res0 = shufflevector <8 x i16> %arg1, <8 x i16> undef, <16 x i32> zeroinitializer
  %res1 = select <16 x i1> %arg0, <16 x i16> %res0, <16 x i16> zeroinitializer
  %res2 = bitcast <16 x i16> %res1 to <4 x i64>
  ret <4 x i64> %res2
}

define <2 x i64> @test_mm256_cvtepi16_epi8(<4 x i64> %__A) {
; X32-LABEL: test_mm256_cvtepi16_epi8:
; X32:       # %bb.0: # %entry
; X32-NEXT:    vpmovwb %ymm0, %xmm0
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_cvtepi16_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    vpmovwb %ymm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %0 = bitcast <4 x i64> %__A to <16 x i16>
  %conv.i = trunc <16 x i16> %0 to <16 x i8>
  %1 = bitcast <16 x i8> %conv.i to <2 x i64>
  ret <2 x i64> %1
}

define <2 x i64> @test_mm256_mask_cvtepi16_epi8(<2 x i64> %__O, i16 zeroext %__M, <4 x i64> %__A) {
; X32-LABEL: test_mm256_mask_cvtepi16_epi8:
; X32:       # %bb.0: # %entry
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpmovwb %ymm1, %xmm0 {%k1}
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_mask_cvtepi16_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpmovwb %ymm1, %xmm0 {%k1}
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %0 = bitcast <4 x i64> %__A to <16 x i16>
  %conv.i.i = trunc <16 x i16> %0 to <16 x i8>
  %1 = bitcast <2 x i64> %__O to <16 x i8>
  %2 = bitcast i16 %__M to <16 x i1>
  %3 = select <16 x i1> %2, <16 x i8> %conv.i.i, <16 x i8> %1
  %4 = bitcast <16 x i8> %3 to <2 x i64>
  ret <2 x i64> %4
}

define <2 x i64> @test_mm256_maskz_cvtepi16_epi8(i16 zeroext %__M, <4 x i64> %__A) {
; X32-LABEL: test_mm256_maskz_cvtepi16_epi8:
; X32:       # %bb.0: # %entry
; X32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X32-NEXT:    vpmovwb %ymm0, %xmm0 {%k1} {z}
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: test_mm256_maskz_cvtepi16_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpmovwb %ymm0, %xmm0 {%k1} {z}
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %0 = bitcast <4 x i64> %__A to <16 x i16>
  %conv.i.i = trunc <16 x i16> %0 to <16 x i8>
  %1 = bitcast i16 %__M to <16 x i1>
  %2 = select <16 x i1> %1, <16 x i8> %conv.i.i, <16 x i8> zeroinitializer
  %3 = bitcast <16 x i8> %2 to <2 x i64>
  ret <2 x i64> %3
}

!0 = !{i32 1}

