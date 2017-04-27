; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl -mattr=+avx512cd -mattr=+avx512vl| FileCheck %s

define <4 x i32> @test_int_x86_avx512_mask_vplzcnt_d_128(<4 x i32> %x0, <4 x i32> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_vplzcnt_d_128:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vplzcntd %xmm0, %xmm2
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vplzcntd %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vplzcntd %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpaddd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = call <4 x i32> @llvm.ctlz.v4i32(<4 x i32> %x0, i1 false)
  %2 = bitcast i8 %x2 to <8 x i1>
  %extract1 = shufflevector <8 x i1> %2, <8 x i1> %2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %3 = select <4 x i1> %extract1, <4 x i32> %1, <4 x i32> %x1
  %4 = call <4 x i32> @llvm.ctlz.v4i32(<4 x i32> %x0, i1 false)
  %5 = call <4 x i32> @llvm.ctlz.v4i32(<4 x i32> %x0, i1 false)
  %6 = bitcast i8 %x2 to <8 x i1>
  %extract = shufflevector <8 x i1> %6, <8 x i1> %6, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %7 = select <4 x i1> %extract, <4 x i32> %5, <4 x i32> zeroinitializer
  %res2 = add <4 x i32> %3, %4
  %res4 = add <4 x i32> %res2, %7
  ret <4 x i32> %res4
}
declare <4 x i32> @llvm.ctlz.v4i32(<4 x i32>, i1) #0

define <8 x i32> @test_int_x86_avx512_mask_vplzcnt_d_256(<8 x i32> %x0, <8 x i32> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_vplzcnt_d_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vplzcntd %ymm0, %ymm2
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vplzcntd %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vpaddd %ymm2, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %1 = call <8 x i32> @llvm.ctlz.v8i32(<8 x i32> %x0, i1 false)
  %2 = bitcast i8 %x2 to <8 x i1>
  %3 = select <8 x i1> %2, <8 x i32> %1, <8 x i32> %x1
  %4 = call <8 x i32> @llvm.ctlz.v8i32(<8 x i32> %x0, i1 false)
  %res2 = add <8 x i32> %3, %4
  ret <8 x i32> %res2
}
declare <8 x i32> @llvm.ctlz.v8i32(<8 x i32>, i1) #0

define <2 x i64> @test_int_x86_avx512_mask_vplzcnt_q_128(<2 x i64> %x0, <2 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_vplzcnt_q_128:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vplzcntq %xmm0, %xmm2
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vplzcntq %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vpaddq %xmm2, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %1 = call <2 x i64> @llvm.ctlz.v2i64(<2 x i64> %x0, i1 false)
  %2 = bitcast i8 %x2 to <8 x i1>
  %extract = shufflevector <8 x i1> %2, <8 x i1> %2, <2 x i32> <i32 0, i32 1>
  %3 = select <2 x i1> %extract, <2 x i64> %1, <2 x i64> %x1
  %4 = call <2 x i64> @llvm.ctlz.v2i64(<2 x i64> %x0, i1 false)
  %res2 = add <2 x i64> %3, %4
  ret <2 x i64> %res2
}
declare <2 x i64> @llvm.ctlz.v2i64(<2 x i64>, i1) #0

define <4 x i64> @test_int_x86_avx512_mask_vplzcnt_q_256(<4 x i64> %x0, <4 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_vplzcnt_q_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vplzcntq %ymm0, %ymm2
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vplzcntq %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vpaddq %ymm2, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %1 = call <4 x i64> @llvm.ctlz.v4i64(<4 x i64> %x0, i1 false)
  %2 = bitcast i8 %x2 to <8 x i1>
  %extract = shufflevector <8 x i1> %2, <8 x i1> %2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %3 = select <4 x i1> %extract, <4 x i64> %1, <4 x i64> %x1
  %4 = call <4 x i64> @llvm.ctlz.v4i64(<4 x i64> %x0, i1 false)
  %res2 = add <4 x i64> %3, %4
  ret <4 x i64> %res2
}
declare <4 x i64> @llvm.ctlz.v4i64(<4 x i64>, i1) #0

declare <4 x i32> @llvm.x86.avx512.mask.conflict.d.128(<4 x i32>, <4 x i32>, i8)

define <4 x i32>@test_int_x86_avx512_mask_vpconflict_d_128(<4 x i32> %x0, <4 x i32> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpconflict_d_128:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vpconflictd %xmm0, %xmm2 {%k1} {z}
; CHECK-NEXT:    vpconflictd %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vpconflictd %xmm0, %xmm0
; CHECK-NEXT:    vpaddd %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vpaddd %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.avx512.mask.conflict.d.128(<4 x i32> %x0, <4 x i32> %x1, i8 %x2)
  %res1 = call <4 x i32> @llvm.x86.avx512.mask.conflict.d.128(<4 x i32> %x0, <4 x i32> %x1, i8 -1)
  %res3 = call <4 x i32> @llvm.x86.avx512.mask.conflict.d.128(<4 x i32> %x0, <4 x i32> zeroinitializer, i8 %x2)
  %res2 = add <4 x i32> %res, %res1
  %res4 = add <4 x i32> %res2, %res3
  ret <4 x i32> %res4
}

declare <8 x i32> @llvm.x86.avx512.mask.conflict.d.256(<8 x i32>, <8 x i32>, i8)

define <8 x i32>@test_int_x86_avx512_mask_vpconflict_d_256(<8 x i32> %x0, <8 x i32> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpconflict_d_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vpconflictd %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vpconflictd %ymm0, %ymm0
; CHECK-NEXT:    vpaddd %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <8 x i32> @llvm.x86.avx512.mask.conflict.d.256(<8 x i32> %x0, <8 x i32> %x1, i8 %x2)
  %res1 = call <8 x i32> @llvm.x86.avx512.mask.conflict.d.256(<8 x i32> %x0, <8 x i32> %x1, i8 -1)
  %res2 = add <8 x i32> %res, %res1
  ret <8 x i32> %res2
}

declare <2 x i64> @llvm.x86.avx512.mask.conflict.q.128(<2 x i64>, <2 x i64>, i8)

define <2 x i64>@test_int_x86_avx512_mask_vpconflict_q_128(<2 x i64> %x0, <2 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpconflict_q_128:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vpconflictq %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vpconflictq %xmm0, %xmm0
; CHECK-NEXT:    vpaddq %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.avx512.mask.conflict.q.128(<2 x i64> %x0, <2 x i64> %x1, i8 %x2)
  %res1 = call <2 x i64> @llvm.x86.avx512.mask.conflict.q.128(<2 x i64> %x0, <2 x i64> %x1, i8 -1)
  %res2 = add <2 x i64> %res, %res1
  ret <2 x i64> %res2
}

declare <4 x i64> @llvm.x86.avx512.mask.conflict.q.256(<4 x i64>, <4 x i64>, i8)

define <4 x i64>@test_int_x86_avx512_mask_vpconflict_q_256(<4 x i64> %x0, <4 x i64> %x1, i8 %x2) {
; CHECK-LABEL: test_int_x86_avx512_mask_vpconflict_q_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k1
; CHECK-NEXT:    vpconflictq %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vpconflictq %ymm0, %ymm0
; CHECK-NEXT:    vpaddq %ymm0, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <4 x i64> @llvm.x86.avx512.mask.conflict.q.256(<4 x i64> %x0, <4 x i64> %x1, i8 %x2)
  %res1 = call <4 x i64> @llvm.x86.avx512.mask.conflict.q.256(<4 x i64> %x0, <4 x i64> %x1, i8 -1)
  %res2 = add <4 x i64> %res, %res1
  ret <4 x i64> %res2
}

define <8 x i32> @test_x86_vbroadcastmw_256(i16 %a0) {
; CHECK-LABEL: test_x86_vbroadcastmw_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k0
; CHECK-NEXT:    vpbroadcastmw2d %k0, %ymm0
; CHECK-NEXT:    retq
  %res = call <8 x i32> @llvm.x86.avx512.broadcastmw.256(i16 %a0) ;
  ret <8 x i32> %res
}
declare <8 x i32> @llvm.x86.avx512.broadcastmw.256(i16)

define <4 x i32> @test_x86_vbroadcastmw_128(i16 %a0) {
; CHECK-LABEL: test_x86_vbroadcastmw_128:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k0
; CHECK-NEXT:    vpbroadcastmw2d %k0, %xmm0
; CHECK-NEXT:    retq
  %res = call <4 x i32> @llvm.x86.avx512.broadcastmw.128(i16 %a0) ;
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.avx512.broadcastmw.128(i16)

define <4 x i64> @test_x86_broadcastmb_256(i8 %a0) {
; CHECK-LABEL: test_x86_broadcastmb_256:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k0
; CHECK-NEXT:    vpbroadcastmb2q %k0, %ymm0
; CHECK-NEXT:    retq
  %res = call <4 x i64> @llvm.x86.avx512.broadcastmb.256(i8 %a0) ;
  ret <4 x i64> %res
}
declare <4 x i64> @llvm.x86.avx512.broadcastmb.256(i8)

define <2 x i64> @test_x86_broadcastmb_128(i8 %a0) {
; CHECK-LABEL: test_x86_broadcastmb_128:
; CHECK:       ## BB#0:
; CHECK-NEXT:    kmovw %edi, %k0
; CHECK-NEXT:    vpbroadcastmb2q %k0, %xmm0
; CHECK-NEXT:    retq
  %res = call <2 x i64> @llvm.x86.avx512.broadcastmb.128(i8 %a0) ;
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.avx512.broadcastmb.128(i8)
