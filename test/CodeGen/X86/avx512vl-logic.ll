; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl -mattr=+avx512vl | FileCheck %s --check-prefix=CHECK --check-prefix=KNL
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=skx -mattr=+avx512vl | FileCheck %s --check-prefix=CHECK --check-prefix=SKX

; 256-bit

define <8 x i32> @vpandd256(<8 x i32> %a, <8 x i32> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpandd256:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddd {{.*}}(%rip){1to8}, %ymm0, %ymm0
; CHECK-NEXT:    vpand %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <8 x i32> %a, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %x = and <8 x i32> %a2, %b
  ret <8 x i32> %x
}

define <8 x i32> @vpandnd256(<8 x i32> %a, <8 x i32> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpandnd256:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddd {{.*}}(%rip){1to8}, %ymm0, %ymm1
; CHECK-NEXT:    vpandn %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <8 x i32> %a, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %b2 = xor <8 x i32> %a, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %x = and <8 x i32> %a2, %b2
  ret <8 x i32> %x
}

define <8 x i32> @vpord256(<8 x i32> %a, <8 x i32> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpord256:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddd {{.*}}(%rip){1to8}, %ymm0, %ymm0
; CHECK-NEXT:    vpor %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <8 x i32> %a, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %x = or <8 x i32> %a2, %b
  ret <8 x i32> %x
}

define <8 x i32> @vpxord256(<8 x i32> %a, <8 x i32> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpxord256:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddd {{.*}}(%rip){1to8}, %ymm0, %ymm0
; CHECK-NEXT:    vpxor %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <8 x i32> %a, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %x = xor <8 x i32> %a2, %b
  ret <8 x i32> %x
}

define <4 x i64> @vpandq256(<4 x i64> %a, <4 x i64> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpandq256:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddq {{.*}}(%rip){1to4}, %ymm0, %ymm0
; CHECK-NEXT:    vpand %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <4 x i64> %a, <i64 1, i64 1, i64 1, i64 1>
  %x = and <4 x i64> %a2, %b
  ret <4 x i64> %x
}

define <4 x i64> @vpandnq256(<4 x i64> %a, <4 x i64> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpandnq256:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddq {{.*}}(%rip){1to4}, %ymm0, %ymm0
; CHECK-NEXT:    vpandn %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <4 x i64> %a, <i64 1, i64 1, i64 1, i64 1>
  %b2 = xor <4 x i64> %b, <i64 -1, i64 -1, i64 -1, i64 -1>
  %x = and <4 x i64> %a2, %b2
  ret <4 x i64> %x
}

define <4 x i64> @vporq256(<4 x i64> %a, <4 x i64> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vporq256:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddq {{.*}}(%rip){1to4}, %ymm0, %ymm0
; CHECK-NEXT:    vpor %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <4 x i64> %a, <i64 1, i64 1, i64 1, i64 1>
  %x = or <4 x i64> %a2, %b
  ret <4 x i64> %x
}

define <4 x i64> @vpxorq256(<4 x i64> %a, <4 x i64> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpxorq256:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddq {{.*}}(%rip){1to4}, %ymm0, %ymm0
; CHECK-NEXT:    vpxor %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <4 x i64> %a, <i64 1, i64 1, i64 1, i64 1>
  %x = xor <4 x i64> %a2, %b
  ret <4 x i64> %x
}

; 128-bit

define <4 x i32> @vpandd128(<4 x i32> %a, <4 x i32> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpandd128:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddd {{.*}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <4 x i32> %a, <i32 1, i32 1, i32 1, i32 1>
  %x = and <4 x i32> %a2, %b
  ret <4 x i32> %x
}

define <4 x i32> @vpandnd128(<4 x i32> %a, <4 x i32> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpandnd128:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddd {{.*}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-NEXT:    vpandn %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <4 x i32> %a, <i32 1, i32 1, i32 1, i32 1>
  %b2 = xor <4 x i32> %b, <i32 -1, i32 -1, i32 -1, i32 -1>
  %x = and <4 x i32> %a2, %b2
  ret <4 x i32> %x
}

define <4 x i32> @vpord128(<4 x i32> %a, <4 x i32> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpord128:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddd {{.*}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <4 x i32> %a, <i32 1, i32 1, i32 1, i32 1>
  %x = or <4 x i32> %a2, %b
  ret <4 x i32> %x
}

define <4 x i32> @vpxord128(<4 x i32> %a, <4 x i32> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpxord128:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddd {{.*}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <4 x i32> %a, <i32 1, i32 1, i32 1, i32 1>
  %x = xor <4 x i32> %a2, %b
  ret <4 x i32> %x
}

define <2 x i64> @vpandq128(<2 x i64> %a, <2 x i64> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpandq128:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <2 x i64> %a, <i64 1, i64 1>
  %x = and <2 x i64> %a2, %b
  ret <2 x i64> %x
}

define <2 x i64> @vpandnq128(<2 x i64> %a, <2 x i64> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpandnq128:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vpandn %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <2 x i64> %a, <i64 1, i64 1>
  %b2 = xor <2 x i64> %b, <i64 -1, i64 -1>
  %x = and <2 x i64> %a2, %b2
  ret <2 x i64> %x
}

define <2 x i64> @vporq128(<2 x i64> %a, <2 x i64> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vporq128:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <2 x i64> %a, <i64 1, i64 1>
  %x = or <2 x i64> %a2, %b
  ret <2 x i64> %x
}

define <2 x i64> @vpxorq128(<2 x i64> %a, <2 x i64> %b) nounwind uwtable readnone ssp {
; CHECK-LABEL: vpxorq128:
; CHECK:       ## BB#0: ## %entry
; CHECK-NEXT:    vpaddq {{.*}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  ; Force the execution domain with an add.
  %a2 = add <2 x i64> %a, <i64 1, i64 1>
  %x = xor <2 x i64> %a2, %b
  ret <2 x i64> %x
}


define <4 x double> @test_mm256_mask_andnot_pd(<4 x double> %__W, i8 zeroext %__U, <4 x double> %__A, <4 x double> %__B) {
; KNL-LABEL: test_mm256_mask_andnot_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandnq %ymm2, %ymm1, %ymm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_mask_andnot_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandnpd %ymm2, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x double> %__A to <4 x i64>
  %neg.i.i = xor <4 x i64> %0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %1 = bitcast <4 x double> %__B to <4 x i64>
  %and.i.i = and <4 x i64> %1, %neg.i.i
  %2 = bitcast <4 x i64> %and.i.i to <4 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x double> %2, <4 x double> %__W
  ret <4 x double> %4
}

define <4 x double> @test_mm256_maskz_andnot_pd(i8 zeroext %__U, <4 x double> %__A, <4 x double> %__B) {
; KNL-LABEL: test_mm256_maskz_andnot_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandnq %ymm1, %ymm0, %ymm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_maskz_andnot_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandnpd %ymm1, %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x double> %__A to <4 x i64>
  %neg.i.i = xor <4 x i64> %0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %1 = bitcast <4 x double> %__B to <4 x i64>
  %and.i.i = and <4 x i64> %1, %neg.i.i
  %2 = bitcast <4 x i64> %and.i.i to <4 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x double> %2, <4 x double> zeroinitializer
  ret <4 x double> %4
}

define <2 x double> @test_mm_mask_andnot_pd(<2 x double> %__W, i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) {
; KNL-LABEL: test_mm_mask_andnot_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandnq %xmm2, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_mask_andnot_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandnpd %xmm2, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <2 x double> %__A to <2 x i64>
  %neg.i.i = xor <2 x i64> %0, <i64 -1, i64 -1>
  %1 = bitcast <2 x double> %__B to <2 x i64>
  %and.i.i = and <2 x i64> %1, %neg.i.i
  %2 = bitcast <2 x i64> %and.i.i to <2 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %4 = select <2 x i1> %extract.i, <2 x double> %2, <2 x double> %__W
  ret <2 x double> %4
}

define <2 x double> @test_mm_maskz_andnot_pd(i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) {
; KNL-LABEL: test_mm_maskz_andnot_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandnq %xmm1, %xmm0, %xmm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_maskz_andnot_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandnpd %xmm1, %xmm0, %xmm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <2 x double> %__A to <2 x i64>
  %neg.i.i = xor <2 x i64> %0, <i64 -1, i64 -1>
  %1 = bitcast <2 x double> %__B to <2 x i64>
  %and.i.i = and <2 x i64> %1, %neg.i.i
  %2 = bitcast <2 x i64> %and.i.i to <2 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %4 = select <2 x i1> %extract.i, <2 x double> %2, <2 x double> zeroinitializer
  ret <2 x double> %4
}

define <8 x float> @test_mm256_mask_andnot_ps(<8 x float> %__W, i8 zeroext %__U, <8 x float> %__A, <8 x float> %__B) {
; KNL-LABEL: test_mm256_mask_andnot_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandnd %ymm2, %ymm1, %ymm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_mask_andnot_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandnps %ymm2, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <8 x float> %__A to <8 x i32>
  %neg.i.i = xor <8 x i32> %0, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %1 = bitcast <8 x float> %__B to <8 x i32>
  %and.i.i = and <8 x i32> %1, %neg.i.i
  %2 = bitcast <8 x i32> %and.i.i to <8 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %4 = select <8 x i1> %3, <8 x float> %2, <8 x float> %__W
  ret <8 x float> %4
}

define <8 x float> @test_mm256_maskz_andnot_ps(i8 zeroext %__U, <8 x float> %__A, <8 x float> %__B) {
; KNL-LABEL: test_mm256_maskz_andnot_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandnd %ymm1, %ymm0, %ymm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_maskz_andnot_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandnps %ymm1, %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <8 x float> %__A to <8 x i32>
  %neg.i.i = xor <8 x i32> %0, <i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1, i32 -1>
  %1 = bitcast <8 x float> %__B to <8 x i32>
  %and.i.i = and <8 x i32> %1, %neg.i.i
  %2 = bitcast <8 x i32> %and.i.i to <8 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %4 = select <8 x i1> %3, <8 x float> %2, <8 x float> zeroinitializer
  ret <8 x float> %4
}

define <4 x float> @test_mm_mask_andnot_ps(<4 x float> %__W, i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) {
; KNL-LABEL: test_mm_mask_andnot_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandnd %xmm2, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_mask_andnot_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandnps %xmm2, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x float> %__A to <4 x i32>
  %neg.i.i = xor <4 x i32> %0, <i32 -1, i32 -1, i32 -1, i32 -1>
  %1 = bitcast <4 x float> %__B to <4 x i32>
  %and.i.i = and <4 x i32> %1, %neg.i.i
  %2 = bitcast <4 x i32> %and.i.i to <4 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x float> %2, <4 x float> %__W
  ret <4 x float> %4
}

define <4 x float> @test_mm_maskz_andnot_ps(i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) {
; KNL-LABEL: test_mm_maskz_andnot_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandnd %xmm1, %xmm0, %xmm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_maskz_andnot_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandnps %xmm1, %xmm0, %xmm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x float> %__A to <4 x i32>
  %neg.i.i = xor <4 x i32> %0, <i32 -1, i32 -1, i32 -1, i32 -1>
  %1 = bitcast <4 x float> %__B to <4 x i32>
  %and.i.i = and <4 x i32> %1, %neg.i.i
  %2 = bitcast <4 x i32> %and.i.i to <4 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x float> %2, <4 x float> zeroinitializer
  ret <4 x float> %4
}

define <4 x double> @test_mm256_mask_and_pd(<4 x double> %__W, i8 zeroext %__U, <4 x double> %__A, <4 x double> %__B) {
; KNL-LABEL: test_mm256_mask_and_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandq %ymm1, %ymm2, %ymm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_mask_and_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandpd %ymm1, %ymm2, %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x double> %__A to <4 x i64>
  %1 = bitcast <4 x double> %__B to <4 x i64>
  %and.i.i = and <4 x i64> %1, %0
  %2 = bitcast <4 x i64> %and.i.i to <4 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x double> %2, <4 x double> %__W
  ret <4 x double> %4
}

define <4 x double> @test_mm256_maskz_and_pd(i8 zeroext %__U, <4 x double> %__A, <4 x double> %__B) {
; KNL-LABEL: test_mm256_maskz_and_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandq %ymm0, %ymm1, %ymm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_maskz_and_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandpd %ymm0, %ymm1, %ymm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x double> %__A to <4 x i64>
  %1 = bitcast <4 x double> %__B to <4 x i64>
  %and.i.i = and <4 x i64> %1, %0
  %2 = bitcast <4 x i64> %and.i.i to <4 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x double> %2, <4 x double> zeroinitializer
  ret <4 x double> %4
}

define <2 x double> @test_mm_mask_and_pd(<2 x double> %__W, i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) {
; KNL-LABEL: test_mm_mask_and_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandq %xmm1, %xmm2, %xmm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_mask_and_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandpd %xmm1, %xmm2, %xmm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <2 x double> %__A to <2 x i64>
  %1 = bitcast <2 x double> %__B to <2 x i64>
  %and.i.i = and <2 x i64> %1, %0
  %2 = bitcast <2 x i64> %and.i.i to <2 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %4 = select <2 x i1> %extract.i, <2 x double> %2, <2 x double> %__W
  ret <2 x double> %4
}

define <2 x double> @test_mm_maskz_and_pd(i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) {
; KNL-LABEL: test_mm_maskz_and_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandq %xmm0, %xmm1, %xmm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_maskz_and_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandpd %xmm0, %xmm1, %xmm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <2 x double> %__A to <2 x i64>
  %1 = bitcast <2 x double> %__B to <2 x i64>
  %and.i.i = and <2 x i64> %1, %0
  %2 = bitcast <2 x i64> %and.i.i to <2 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %4 = select <2 x i1> %extract.i, <2 x double> %2, <2 x double> zeroinitializer
  ret <2 x double> %4
}

define <8 x float> @test_mm256_mask_and_ps(<8 x float> %__W, i8 zeroext %__U, <8 x float> %__A, <8 x float> %__B) {
; KNL-LABEL: test_mm256_mask_and_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandd %ymm1, %ymm2, %ymm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_mask_and_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandps %ymm1, %ymm2, %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <8 x float> %__A to <8 x i32>
  %1 = bitcast <8 x float> %__B to <8 x i32>
  %and.i.i = and <8 x i32> %1, %0
  %2 = bitcast <8 x i32> %and.i.i to <8 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %4 = select <8 x i1> %3, <8 x float> %2, <8 x float> %__W
  ret <8 x float> %4
}

define <8 x float> @test_mm256_maskz_and_ps(i8 zeroext %__U, <8 x float> %__A, <8 x float> %__B) {
; KNL-LABEL: test_mm256_maskz_and_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandd %ymm0, %ymm1, %ymm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_maskz_and_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandps %ymm0, %ymm1, %ymm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <8 x float> %__A to <8 x i32>
  %1 = bitcast <8 x float> %__B to <8 x i32>
  %and.i.i = and <8 x i32> %1, %0
  %2 = bitcast <8 x i32> %and.i.i to <8 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %4 = select <8 x i1> %3, <8 x float> %2, <8 x float> zeroinitializer
  ret <8 x float> %4
}

define <4 x float> @test_mm_mask_and_ps(<4 x float> %__W, i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) {
; KNL-LABEL: test_mm_mask_and_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandd %xmm1, %xmm2, %xmm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_mask_and_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandps %xmm1, %xmm2, %xmm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x float> %__A to <4 x i32>
  %1 = bitcast <4 x float> %__B to <4 x i32>
  %and.i.i = and <4 x i32> %1, %0
  %2 = bitcast <4 x i32> %and.i.i to <4 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x float> %2, <4 x float> %__W
  ret <4 x float> %4
}

define <4 x float> @test_mm_maskz_and_ps(i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) {
; KNL-LABEL: test_mm_maskz_and_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpandd %xmm0, %xmm1, %xmm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_maskz_and_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vandps %xmm0, %xmm1, %xmm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x float> %__A to <4 x i32>
  %1 = bitcast <4 x float> %__B to <4 x i32>
  %and.i.i = and <4 x i32> %1, %0
  %2 = bitcast <4 x i32> %and.i.i to <4 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x float> %2, <4 x float> zeroinitializer
  ret <4 x float> %4
}

define <4 x double> @test_mm256_mask_xor_pd(<4 x double> %__W, i8 zeroext %__U, <4 x double> %__A, <4 x double> %__B) {
; KNL-LABEL: test_mm256_mask_xor_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxorq %ymm2, %ymm1, %ymm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_mask_xor_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorpd %ymm2, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x double> %__A to <4 x i64>
  %1 = bitcast <4 x double> %__B to <4 x i64>
  %xor.i.i = xor <4 x i64> %0, %1
  %2 = bitcast <4 x i64> %xor.i.i to <4 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x double> %2, <4 x double> %__W
  ret <4 x double> %4
}

define <4 x double> @test_mm256_maskz_xor_pd(i8 zeroext %__U, <4 x double> %__A, <4 x double> %__B) {
; KNL-LABEL: test_mm256_maskz_xor_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxorq %ymm1, %ymm0, %ymm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_maskz_xor_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorpd %ymm1, %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x double> %__A to <4 x i64>
  %1 = bitcast <4 x double> %__B to <4 x i64>
  %xor.i.i = xor <4 x i64> %0, %1
  %2 = bitcast <4 x i64> %xor.i.i to <4 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x double> %2, <4 x double> zeroinitializer
  ret <4 x double> %4
}

define <2 x double> @test_mm_mask_xor_pd(<2 x double> %__W, i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) {
; KNL-LABEL: test_mm_mask_xor_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxorq %xmm2, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_mask_xor_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorpd %xmm2, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <2 x double> %__A to <2 x i64>
  %1 = bitcast <2 x double> %__B to <2 x i64>
  %xor.i.i = xor <2 x i64> %0, %1
  %2 = bitcast <2 x i64> %xor.i.i to <2 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %4 = select <2 x i1> %extract.i, <2 x double> %2, <2 x double> %__W
  ret <2 x double> %4
}

define <2 x double> @test_mm_maskz_xor_pd(i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) {
; KNL-LABEL: test_mm_maskz_xor_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxorq %xmm1, %xmm0, %xmm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_maskz_xor_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorpd %xmm1, %xmm0, %xmm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <2 x double> %__A to <2 x i64>
  %1 = bitcast <2 x double> %__B to <2 x i64>
  %xor.i.i = xor <2 x i64> %0, %1
  %2 = bitcast <2 x i64> %xor.i.i to <2 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %4 = select <2 x i1> %extract.i, <2 x double> %2, <2 x double> zeroinitializer
  ret <2 x double> %4
}

define <8 x float> @test_mm256_mask_xor_ps(<8 x float> %__W, i8 zeroext %__U, <8 x float> %__A, <8 x float> %__B) {
; KNL-LABEL: test_mm256_mask_xor_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxord %ymm2, %ymm1, %ymm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_mask_xor_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorps %ymm2, %ymm1, %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <8 x float> %__A to <8 x i32>
  %1 = bitcast <8 x float> %__B to <8 x i32>
  %xor.i.i = xor <8 x i32> %0, %1
  %2 = bitcast <8 x i32> %xor.i.i to <8 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %4 = select <8 x i1> %3, <8 x float> %2, <8 x float> %__W
  ret <8 x float> %4
}

define <8 x float> @test_mm256_maskz_xor_ps(i8 zeroext %__U, <8 x float> %__A, <8 x float> %__B) {
; KNL-LABEL: test_mm256_maskz_xor_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxord %ymm1, %ymm0, %ymm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_maskz_xor_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorps %ymm1, %ymm0, %ymm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <8 x float> %__A to <8 x i32>
  %1 = bitcast <8 x float> %__B to <8 x i32>
  %xor.i.i = xor <8 x i32> %0, %1
  %2 = bitcast <8 x i32> %xor.i.i to <8 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %4 = select <8 x i1> %3, <8 x float> %2, <8 x float> zeroinitializer
  ret <8 x float> %4
}

define <4 x float> @test_mm_mask_xor_ps(<4 x float> %__W, i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) {
; KNL-LABEL: test_mm_mask_xor_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxord %xmm2, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_mask_xor_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorps %xmm2, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x float> %__A to <4 x i32>
  %1 = bitcast <4 x float> %__B to <4 x i32>
  %xor.i.i = xor <4 x i32> %0, %1
  %2 = bitcast <4 x i32> %xor.i.i to <4 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x float> %2, <4 x float> %__W
  ret <4 x float> %4
}

define <4 x float> @test_mm_maskz_xor_ps(i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) {
; KNL-LABEL: test_mm_maskz_xor_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxord %xmm1, %xmm0, %xmm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_maskz_xor_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorps %xmm1, %xmm0, %xmm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x float> %__A to <4 x i32>
  %1 = bitcast <4 x float> %__B to <4 x i32>
  %xor.i.i = xor <4 x i32> %0, %1
  %2 = bitcast <4 x i32> %xor.i.i to <4 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x float> %2, <4 x float> zeroinitializer
  ret <4 x float> %4
}

define <4 x double> @test_mm256_mask_or_pd(<4 x double> %__W, i8 zeroext %__U, <4 x double> %__A, <4 x double> %__B) {
; KNL-LABEL: test_mm256_mask_or_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vporq %ymm1, %ymm2, %ymm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_mask_or_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vorpd %ymm1, %ymm2, %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x double> %__A to <4 x i64>
  %1 = bitcast <4 x double> %__B to <4 x i64>
  %or.i.i = or <4 x i64> %1, %0
  %2 = bitcast <4 x i64> %or.i.i to <4 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x double> %2, <4 x double> %__W
  ret <4 x double> %4
}

define <4 x double> @test_mm256_maskz_or_pd(i8 zeroext %__U, <4 x double> %__A, <4 x double> %__B) {
; KNL-LABEL: test_mm256_maskz_or_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vporq %ymm0, %ymm1, %ymm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_maskz_or_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vorpd %ymm0, %ymm1, %ymm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x double> %__A to <4 x i64>
  %1 = bitcast <4 x double> %__B to <4 x i64>
  %or.i.i = or <4 x i64> %1, %0
  %2 = bitcast <4 x i64> %or.i.i to <4 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x double> %2, <4 x double> zeroinitializer
  ret <4 x double> %4
}

define <2 x double> @test_mm_mask_or_pd(<2 x double> %__W, i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) {
; KNL-LABEL: test_mm_mask_or_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vporq %xmm1, %xmm2, %xmm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_mask_or_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vorpd %xmm1, %xmm2, %xmm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <2 x double> %__A to <2 x i64>
  %1 = bitcast <2 x double> %__B to <2 x i64>
  %or.i.i = or <2 x i64> %1, %0
  %2 = bitcast <2 x i64> %or.i.i to <2 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %4 = select <2 x i1> %extract.i, <2 x double> %2, <2 x double> %__W
  ret <2 x double> %4
}

define <2 x double> @test_mm_maskz_or_pd(i8 zeroext %__U, <2 x double> %__A, <2 x double> %__B) {
; KNL-LABEL: test_mm_maskz_or_pd:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vporq %xmm0, %xmm1, %xmm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_maskz_or_pd:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vorpd %xmm0, %xmm1, %xmm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <2 x double> %__A to <2 x i64>
  %1 = bitcast <2 x double> %__B to <2 x i64>
  %or.i.i = or <2 x i64> %1, %0
  %2 = bitcast <2 x i64> %or.i.i to <2 x double>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %4 = select <2 x i1> %extract.i, <2 x double> %2, <2 x double> zeroinitializer
  ret <2 x double> %4
}

define <8 x float> @test_mm256_mask_or_ps(<8 x float> %__W, i8 zeroext %__U, <8 x float> %__A, <8 x float> %__B) {
; KNL-LABEL: test_mm256_mask_or_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpord %ymm1, %ymm2, %ymm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_mask_or_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vorps %ymm1, %ymm2, %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <8 x float> %__A to <8 x i32>
  %1 = bitcast <8 x float> %__B to <8 x i32>
  %or.i.i = or <8 x i32> %1, %0
  %2 = bitcast <8 x i32> %or.i.i to <8 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %4 = select <8 x i1> %3, <8 x float> %2, <8 x float> %__W
  ret <8 x float> %4
}

define <8 x float> @test_mm256_maskz_or_ps(i8 zeroext %__U, <8 x float> %__A, <8 x float> %__B) {
; KNL-LABEL: test_mm256_maskz_or_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpord %ymm0, %ymm1, %ymm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm256_maskz_or_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vorps %ymm0, %ymm1, %ymm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <8 x float> %__A to <8 x i32>
  %1 = bitcast <8 x float> %__B to <8 x i32>
  %or.i.i = or <8 x i32> %1, %0
  %2 = bitcast <8 x i32> %or.i.i to <8 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %4 = select <8 x i1> %3, <8 x float> %2, <8 x float> zeroinitializer
  ret <8 x float> %4
}

define <4 x float> @test_mm_mask_or_ps(<4 x float> %__W, i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) {
; KNL-LABEL: test_mm_mask_or_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpord %xmm1, %xmm2, %xmm0 {%k1}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_mask_or_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vorps %xmm1, %xmm2, %xmm0 {%k1}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x float> %__A to <4 x i32>
  %1 = bitcast <4 x float> %__B to <4 x i32>
  %or.i.i = or <4 x i32> %1, %0
  %2 = bitcast <4 x i32> %or.i.i to <4 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x float> %2, <4 x float> %__W
  ret <4 x float> %4
}

define <4 x float> @test_mm_maskz_or_ps(i8 zeroext %__U, <4 x float> %__A, <4 x float> %__B) {
; KNL-LABEL: test_mm_maskz_or_ps:
; KNL:       ## BB#0: ## %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpord %xmm0, %xmm1, %xmm0 {%k1} {z}
; KNL-NEXT:    retq
;
; SKX-LABEL: test_mm_maskz_or_ps:
; SKX:       ## BB#0: ## %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vorps %xmm0, %xmm1, %xmm0 {%k1} {z}
; SKX-NEXT:    retq
entry:
  %0 = bitcast <4 x float> %__A to <4 x i32>
  %1 = bitcast <4 x float> %__B to <4 x i32>
  %or.i.i = or <4 x i32> %1, %0
  %2 = bitcast <4 x i32> %or.i.i to <4 x float>
  %3 = bitcast i8 %__U to <8 x i1>
  %extract.i = shufflevector <8 x i1> %3, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = select <4 x i1> %extract.i, <4 x float> %2, <4 x float> zeroinitializer
  ret <4 x float> %4
}
