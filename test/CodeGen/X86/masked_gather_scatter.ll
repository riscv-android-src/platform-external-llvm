; RUN: llc -mtriple=x86_64-unknown-linux-gnu  -mattr=+avx512f < %s | FileCheck %s --check-prefix=KNL_64
; RUN: llc -mtriple=i386-unknown-linux-gnu  -mattr=+avx512f < %s | FileCheck %s --check-prefix=KNL_32
; RUN: llc -mtriple=x86_64-unknown-linux-gnu  -mattr=+avx512vl -mattr=+avx512dq < %s | FileCheck %s --check-prefix=SKX
; RUN: llc -mtriple=i386-unknown-linux-gnu  -mattr=+avx512vl -mattr=+avx512dq < %s | FileCheck %s --check-prefix=SKX_32
; RUN: opt -mtriple=x86_64-apple-darwin -codegenprepare -mcpu=corei7-avx -S < %s | FileCheck %s -check-prefix=SCALAR
; RUN: llc -O0 -mtriple=x86_64-unknown-linux-gnu -mcpu=skx < %s -o /dev/null

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"


; SCALAR-LABEL: test1
; SCALAR:      extractelement <16 x float*>
; SCALAR-NEXT: load float
; SCALAR-NEXT: insertelement <16 x float>
; SCALAR-NEXT: extractelement <16 x float*>
; SCALAR-NEXT: load float

define <16 x float> @test1(float* %base, <16 x i32> %ind) {
; KNL_64-LABEL: test1:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kxnorw %k0, %k0, %k1
; KNL_64-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test1:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    kxnorw %k0, %k0, %k1
; KNL_32-NEXT:    vgatherdps (%eax,%zmm0,4), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test1:
; SKX:       # BB#0:
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq

  %broadcast.splatinsert = insertelement <16 x float*> undef, float* %base, i32 0
  %broadcast.splat = shufflevector <16 x float*> %broadcast.splatinsert, <16 x float*> undef, <16 x i32> zeroinitializer

  %sext_ind = sext <16 x i32> %ind to <16 x i64>
  %gep.random = getelementptr float, <16 x float*> %broadcast.splat, <16 x i64> %sext_ind

  %res = call <16 x float> @llvm.masked.gather.v16f32(<16 x float*> %gep.random, i32 4, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <16 x float> undef)
  ret <16 x float>%res
}

declare <16 x i32> @llvm.masked.gather.v16i32(<16 x i32*>, i32, <16 x i1>, <16 x i32>)
declare <16 x float> @llvm.masked.gather.v16f32(<16 x float*>, i32, <16 x i1>, <16 x float>)
declare <8 x i32> @llvm.masked.gather.v8i32(<8 x i32*> , i32, <8 x i1> , <8 x i32> )


; SCALAR-LABEL: test2
; SCALAR:      extractelement <16 x float*>
; SCALAR-NEXT: load float
; SCALAR-NEXT: insertelement <16 x float>
; SCALAR-NEXT: br label %else
; SCALAR: else:
; SCALAR-NEXT:  %res.phi.else = phi
; SCALAR-NEXT:  %Mask1 = extractelement <16 x i1> %imask, i32 1
; SCALAR-NEXT:  %ToLoad1 = icmp eq i1 %Mask1, true
; SCALAR-NEXT:  br i1 %ToLoad1, label %cond.load1, label %else2

define <16 x float> @test2(float* %base, <16 x i32> %ind, i16 %mask) {
; KNL_64-LABEL: test2:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kmovw %esi, %k1
; KNL_64-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test2:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; KNL_32-NEXT:    vgatherdps (%eax,%zmm0,4), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test2:
; SKX:       # BB#0:
; SKX-NEXT:    kmovw %esi, %k1
; SKX-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq

  %broadcast.splatinsert = insertelement <16 x float*> undef, float* %base, i32 0
  %broadcast.splat = shufflevector <16 x float*> %broadcast.splatinsert, <16 x float*> undef, <16 x i32> zeroinitializer

  %sext_ind = sext <16 x i32> %ind to <16 x i64>
  %gep.random = getelementptr float, <16 x float*> %broadcast.splat, <16 x i64> %sext_ind
  %imask = bitcast i16 %mask to <16 x i1>
  %res = call <16 x float> @llvm.masked.gather.v16f32(<16 x float*> %gep.random, i32 4, <16 x i1> %imask, <16 x float>undef)
  ret <16 x float> %res
}

define <16 x i32> @test3(i32* %base, <16 x i32> %ind, i16 %mask) {
; KNL_64-LABEL: test3:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kmovw %esi, %k1
; KNL_64-NEXT:    vpgatherdd (%rdi,%zmm0,4), %zmm1 {%k1}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test3:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; KNL_32-NEXT:    vpgatherdd (%eax,%zmm0,4), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test3:
; SKX:       # BB#0:
; SKX-NEXT:    kmovw %esi, %k1
; SKX-NEXT:    vpgatherdd (%rdi,%zmm0,4), %zmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq

  %broadcast.splatinsert = insertelement <16 x i32*> undef, i32* %base, i32 0
  %broadcast.splat = shufflevector <16 x i32*> %broadcast.splatinsert, <16 x i32*> undef, <16 x i32> zeroinitializer

  %sext_ind = sext <16 x i32> %ind to <16 x i64>
  %gep.random = getelementptr i32, <16 x i32*> %broadcast.splat, <16 x i64> %sext_ind
  %imask = bitcast i16 %mask to <16 x i1>
  %res = call <16 x i32> @llvm.masked.gather.v16i32(<16 x i32*> %gep.random, i32 4, <16 x i1> %imask, <16 x i32>undef)
  ret <16 x i32> %res
}


define <16 x i32> @test4(i32* %base, <16 x i32> %ind, i16 %mask) {
; KNL_64-LABEL: test4:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kmovw %esi, %k1
; KNL_64-NEXT:    kmovw %k1, %k2
; KNL_64-NEXT:    vpgatherdd (%rdi,%zmm0,4), %zmm1 {%k2}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm2
; KNL_64-NEXT:    vpgatherdd (%rdi,%zmm0,4), %zmm2 {%k1}
; KNL_64-NEXT:    vpaddd %zmm2, %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test4:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; KNL_32-NEXT:    kmovw %k1, %k2
; KNL_32-NEXT:    vpgatherdd (%eax,%zmm0,4), %zmm1 {%k2}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm2
; KNL_32-NEXT:    vpgatherdd (%eax,%zmm0,4), %zmm2 {%k1}
; KNL_32-NEXT:    vpaddd %zmm2, %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test4:
; SKX:       # BB#0:
; SKX-NEXT:    kmovw %esi, %k1
; SKX-NEXT:    kmovw %k1, %k2
; SKX-NEXT:    vpgatherdd (%rdi,%zmm0,4), %zmm1 {%k2}
; SKX-NEXT:    vmovaps %zmm1, %zmm2
; SKX-NEXT:    vpgatherdd (%rdi,%zmm0,4), %zmm2 {%k1}
; SKX-NEXT:    vpaddd %zmm2, %zmm1, %zmm0
; SKX-NEXT:    retq

  %broadcast.splatinsert = insertelement <16 x i32*> undef, i32* %base, i32 0
  %broadcast.splat = shufflevector <16 x i32*> %broadcast.splatinsert, <16 x i32*> undef, <16 x i32> zeroinitializer

  %gep.random = getelementptr i32, <16 x i32*> %broadcast.splat, <16 x i32> %ind
  %imask = bitcast i16 %mask to <16 x i1>
  %gt1 = call <16 x i32> @llvm.masked.gather.v16i32(<16 x i32*> %gep.random, i32 4, <16 x i1> %imask, <16 x i32>undef)
  %gt2 = call <16 x i32> @llvm.masked.gather.v16i32(<16 x i32*> %gep.random, i32 4, <16 x i1> %imask, <16 x i32>%gt1)
  %res = add <16 x i32> %gt1, %gt2
  ret <16 x i32> %res
}


; SCALAR-LABEL: test5
; SCALAR:        %Mask0 = extractelement <16 x i1> %imask, i32 0
; SCALAR-NEXT:   %ToStore0 = icmp eq i1 %Mask0, true
; SCALAR-NEXT:   br i1 %ToStore0, label %cond.store, label %else
; SCALAR: cond.store:
; SCALAR-NEXT:  %Elt0 = extractelement <16 x i32> %val, i32 0
; SCALAR-NEXT:  %Ptr0 = extractelement <16 x i32*> %gep.random, i32 0
; SCALAR-NEXT:  store i32 %Elt0, i32* %Ptr0, align 4
; SCALAR-NEXT:  br label %else
; SCALAR: else:
; SCALAR-NEXT: %Mask1 = extractelement <16 x i1> %imask, i32 1
; SCALAR-NEXT:  %ToStore1 = icmp eq i1 %Mask1, true
; SCALAR-NEXT:  br i1 %ToStore1, label %cond.store1, label %else2

define void @test5(i32* %base, <16 x i32> %ind, i16 %mask, <16 x i32>%val) {
; KNL_64-LABEL: test5:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kmovw %esi, %k1
; KNL_64-NEXT:    kmovw %k1, %k2
; KNL_64-NEXT:    vpscatterdd %zmm1, (%rdi,%zmm0,4) {%k2}
; KNL_64-NEXT:    vpscatterdd %zmm1, (%rdi,%zmm0,4) {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test5:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; KNL_32-NEXT:    kmovw %k1, %k2
; KNL_32-NEXT:    vpscatterdd %zmm1, (%eax,%zmm0,4) {%k2}
; KNL_32-NEXT:    vpscatterdd %zmm1, (%eax,%zmm0,4) {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test5:
; SKX:       # BB#0:
; SKX-NEXT:    kmovw %esi, %k1
; SKX-NEXT:    kmovw %k1, %k2
; SKX-NEXT:    vpscatterdd %zmm1, (%rdi,%zmm0,4) {%k2}
; SKX-NEXT:    vpscatterdd %zmm1, (%rdi,%zmm0,4) {%k1}
; SKX-NEXT:    retq

  %broadcast.splatinsert = insertelement <16 x i32*> undef, i32* %base, i32 0
  %broadcast.splat = shufflevector <16 x i32*> %broadcast.splatinsert, <16 x i32*> undef, <16 x i32> zeroinitializer

  %gep.random = getelementptr i32, <16 x i32*> %broadcast.splat, <16 x i32> %ind
  %imask = bitcast i16 %mask to <16 x i1>
  call void @llvm.masked.scatter.v16i32(<16 x i32>%val, <16 x i32*> %gep.random, i32 4, <16 x i1> %imask)
  call void @llvm.masked.scatter.v16i32(<16 x i32>%val, <16 x i32*> %gep.random, i32 4, <16 x i1> %imask)
  ret void
}

declare void @llvm.masked.scatter.v8i32(<8 x i32> , <8 x i32*> , i32 , <8 x i1> )
declare void @llvm.masked.scatter.v16i32(<16 x i32> , <16 x i32*> , i32 , <16 x i1> )


; SCALAR-LABEL: test6
; SCALAR:        store i32 %Elt0, i32* %Ptr01, align 4
; SCALAR-NEXT:   %Elt1 = extractelement <8 x i32> %a1, i32 1
; SCALAR-NEXT:   %Ptr12 = extractelement <8 x i32*> %ptr, i32 1
; SCALAR-NEXT:   store i32 %Elt1, i32* %Ptr12, align 4
; SCALAR-NEXT:   %Elt2 = extractelement <8 x i32> %a1, i32 2
; SCALAR-NEXT:   %Ptr23 = extractelement <8 x i32*> %ptr, i32 2
; SCALAR-NEXT:   store i32 %Elt2, i32* %Ptr23, align 4

define <8 x i32> @test6(<8 x i32>%a1, <8 x i32*> %ptr) {
; KNL_64-LABEL: test6:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kxnorw %k0, %k0, %k1
; KNL_64-NEXT:    kxnorw %k0, %k0, %k2
; KNL_64-NEXT:    vpgatherqd (,%zmm1), %ymm2 {%k2}
; KNL_64-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k1}
; KNL_64-NEXT:    vmovaps %zmm2, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test6:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    kxnorw %k0, %k0, %k1
; KNL_32-NEXT:    vpmovsxdq %ymm1, %zmm2
; KNL_32-NEXT:    kxnorw %k0, %k0, %k2
; KNL_32-NEXT:    vpgatherqd (,%zmm2), %ymm1 {%k2}
; KNL_32-NEXT:    vpscatterqd %ymm0, (,%zmm2) {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test6:
; SKX:       # BB#0:
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    kxnorw %k0, %k0, %k2
; SKX-NEXT:    vpgatherqd (,%zmm1), %ymm2 {%k2}
; SKX-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k1}
; SKX-NEXT:    vmovaps %zmm2, %zmm0
; SKX-NEXT:    retq

  %a = call <8 x i32> @llvm.masked.gather.v8i32(<8 x i32*> %ptr, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)

  call void @llvm.masked.scatter.v8i32(<8 x i32> %a1, <8 x i32*> %ptr, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>)
  ret <8 x i32>%a
}

define <8 x i32> @test7(i32* %base, <8 x i32> %ind, i8 %mask) {
;
; KNL_64-LABEL: test7:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kmovw %esi, %k1
; KNL_64-NEXT:    vpmovsxdq %ymm0, %zmm0
; KNL_64-NEXT:    kmovw %k1, %k2
; KNL_64-NEXT:    vpgatherqd (%rdi,%zmm0,4), %ymm1 {%k2}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm2
; KNL_64-NEXT:    vpgatherqd (%rdi,%zmm0,4), %ymm2 {%k1}
; KNL_64-NEXT:    vpaddd %ymm2, %ymm1, %ymm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test7:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    movzbl {{[0-9]+}}(%esp), %ecx
; KNL_32-NEXT:    kmovw %ecx, %k1
; KNL_32-NEXT:    vpmovsxdq %ymm0, %zmm0
; KNL_32-NEXT:    kmovw %k1, %k2
; KNL_32-NEXT:    vpgatherqd (%eax,%zmm0,4), %ymm1 {%k2}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm2
; KNL_32-NEXT:    vpgatherqd (%eax,%zmm0,4), %ymm2 {%k1}
; KNL_32-NEXT:    vpaddd %ymm2, %ymm1, %ymm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test7:
; SKX:       # BB#0:
; SKX-NEXT:    kmovb %esi, %k1
; SKX-NEXT:    kmovw %k1, %k2
; SKX-NEXT:    vpgatherdd (%rdi,%ymm0,4), %ymm1 {%k2}
; SKX-NEXT:    vmovaps %zmm1, %zmm2
; SKX-NEXT:    vpgatherdd (%rdi,%ymm0,4), %ymm2 {%k1}
; SKX-NEXT:    vpaddd %ymm2, %ymm1, %ymm0
; SKX-NEXT:    retq

  %broadcast.splatinsert = insertelement <8 x i32*> undef, i32* %base, i32 0
  %broadcast.splat = shufflevector <8 x i32*> %broadcast.splatinsert, <8 x i32*> undef, <8 x i32> zeroinitializer

  %gep.random = getelementptr i32, <8 x i32*> %broadcast.splat, <8 x i32> %ind
  %imask = bitcast i8 %mask to <8 x i1>
  %gt1 = call <8 x i32> @llvm.masked.gather.v8i32(<8 x i32*> %gep.random, i32 4, <8 x i1> %imask, <8 x i32>undef)
  %gt2 = call <8 x i32> @llvm.masked.gather.v8i32(<8 x i32*> %gep.random, i32 4, <8 x i1> %imask, <8 x i32>%gt1)
  %res = add <8 x i32> %gt1, %gt2
  ret <8 x i32> %res
}

; No uniform base in this case, index <8 x i64> contains addresses,
; each gather call will be split into two
define <16 x i32> @test8(<16 x i32*> %ptr.random, <16 x i32> %ind, i16 %mask) {
; KNL_64-LABEL: test8:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kmovw %edi, %k1
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    kmovw %k2, %k3
; KNL_64-NEXT:    vpgatherqd (,%zmm1), %ymm2 {%k3}
; KNL_64-NEXT:    kmovw %k1, %k3
; KNL_64-NEXT:    vpgatherqd (,%zmm0), %ymm3 {%k3}
; KNL_64-NEXT:    vinserti64x4 $1, %ymm2, %zmm3, %zmm4
; KNL_64-NEXT:    vpgatherqd (,%zmm1), %ymm2 {%k2}
; KNL_64-NEXT:    vpgatherqd (,%zmm0), %ymm3 {%k1}
; KNL_64-NEXT:    vinserti64x4 $1, %ymm2, %zmm3, %zmm0
; KNL_64-NEXT:    vpaddd %zmm0, %zmm4, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test8:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; KNL_32-NEXT:    kmovw %k1, %k2
; KNL_32-NEXT:    vpgatherdd (,%zmm0), %zmm1 {%k2}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm2
; KNL_32-NEXT:    vpgatherdd (,%zmm0), %zmm2 {%k1}
; KNL_32-NEXT:    vpaddd %zmm2, %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test8:
; SKX:       # BB#0:
; SKX-NEXT:    kmovw %edi, %k1
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    kmovw %k2, %k3
; SKX-NEXT:    vpgatherqd (,%zmm1), %ymm2 {%k3}
; SKX-NEXT:    kmovw %k1, %k3
; SKX-NEXT:    vpgatherqd (,%zmm0), %ymm3 {%k3}
; SKX-NEXT:    vinserti32x8 $1, %ymm2, %zmm3, %zmm4
; SKX-NEXT:    vpgatherqd (,%zmm1), %ymm2 {%k2}
; SKX-NEXT:    vpgatherqd (,%zmm0), %ymm3 {%k1}
; SKX-NEXT:    vinserti32x8 $1, %ymm2, %zmm3, %zmm0
; SKX-NEXT:    vpaddd %zmm0, %zmm4, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test8:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; SKX_32-NEXT:    kmovw %k1, %k2
; SKX_32-NEXT:    vpgatherdd (,%zmm0), %zmm1 {%k2}
; SKX_32-NEXT:    vmovaps %zmm1, %zmm2
; SKX_32-NEXT:    vpgatherdd (,%zmm0), %zmm2 {%k1}
; SKX_32-NEXT:    vpaddd %zmm2, %zmm1, %zmm0
; SKX_32-NEXT:    retl

  %imask = bitcast i16 %mask to <16 x i1>
  %gt1 = call <16 x i32> @llvm.masked.gather.v16i32(<16 x i32*> %ptr.random, i32 4, <16 x i1> %imask, <16 x i32>undef)
  %gt2 = call <16 x i32> @llvm.masked.gather.v16i32(<16 x i32*> %ptr.random, i32 4, <16 x i1> %imask, <16 x i32>%gt1)
  %res = add <16 x i32> %gt1, %gt2
  ret <16 x i32> %res
}

%struct.RT = type { i8, [10 x [20 x i32]], i8 }
%struct.ST = type { i32, double, %struct.RT }

; Masked gather for agregate types
; Test9 and Test10 should give the same result (scalar and vector indices in GEP)


define <8 x i32> @test9(%struct.ST* %base, <8 x i64> %ind1, <8 x i32>%ind5) {
; KNL_64-LABEL: test9:
; KNL_64:       # BB#0: # %entry
; KNL_64-NEXT:    vpbroadcastq %rdi, %zmm2
; KNL_64-NEXT:    vpmovsxdq %ymm1, %zmm1
; KNL_64-NEXT:    vpbroadcastq {{.*}}(%rip), %zmm3
; KNL_64-NEXT:    vpmuludq %zmm3, %zmm1, %zmm4
; KNL_64-NEXT:    vpsrlq $32, %zmm1, %zmm1
; KNL_64-NEXT:    vpmuludq %zmm3, %zmm1, %zmm1
; KNL_64-NEXT:    vpsllq $32, %zmm1, %zmm1
; KNL_64-NEXT:    vpaddq %zmm1, %zmm4, %zmm1
; KNL_64-NEXT:    vpbroadcastq {{.*}}(%rip), %zmm3
; KNL_64-NEXT:    vpmuludq %zmm3, %zmm0, %zmm4
; KNL_64-NEXT:    vpsrlq $32, %zmm0, %zmm0
; KNL_64-NEXT:    vpmuludq %zmm3, %zmm0, %zmm0
; KNL_64-NEXT:    vpsllq $32, %zmm0, %zmm0
; KNL_64-NEXT:    vpaddq %zmm0, %zmm4, %zmm0
; KNL_64-NEXT:    vpaddq %zmm0, %zmm2, %zmm0
; KNL_64-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; KNL_64-NEXT:    vpaddq {{.*}}(%rip){1to8}, %zmm0, %zmm1
; KNL_64-NEXT:    kxnorw %k0, %k0, %k1
; KNL_64-NEXT:    vpgatherqd (,%zmm1), %ymm0 {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test9:
; KNL_32:       # BB#0: # %entry
; KNL_32-NEXT:    vpbroadcastd {{[0-9]+}}(%esp), %ymm2
; KNL_32-NEXT:    vpbroadcastd .LCPI8_0, %ymm3
; KNL_32-NEXT:    vpmulld %ymm3, %ymm1, %ymm1
; KNL_32-NEXT:    vpmovqd %zmm0, %ymm0
; KNL_32-NEXT:    vpbroadcastd .LCPI8_1, %ymm3
; KNL_32-NEXT:    vpmulld %ymm3, %ymm0, %ymm0
; KNL_32-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; KNL_32-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; KNL_32-NEXT:    vpbroadcastd .LCPI8_2, %ymm1
; KNL_32-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; KNL_32-NEXT:    vpmovsxdq %ymm0, %zmm1
; KNL_32-NEXT:    kxnorw %k0, %k0, %k1
; KNL_32-NEXT:    vpgatherqd (,%zmm1), %ymm0 {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test9:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    vpbroadcastq %rdi, %zmm2
; SKX-NEXT:    vpmullq {{.*}}(%rip){1to8}, %zmm0, %zmm0
; SKX-NEXT:    vpaddq %zmm0, %zmm2, %zmm0
; SKX-NEXT:    vpmovsxdq %ymm1, %zmm1
; SKX-NEXT:    vpmullq {{.*}}(%rip){1to8}, %zmm1, %zmm1
; SKX-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; SKX-NEXT:    vpaddq {{.*}}(%rip){1to8}, %zmm0, %zmm1
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    vpgatherqd (,%zmm1), %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %broadcast.splatinsert = insertelement <8 x %struct.ST*> undef, %struct.ST* %base, i32 0
  %broadcast.splat = shufflevector <8 x %struct.ST*> %broadcast.splatinsert, <8 x %struct.ST*> undef, <8 x i32> zeroinitializer

  %arrayidx = getelementptr  %struct.ST, <8 x %struct.ST*> %broadcast.splat, <8 x i64> %ind1, <8 x i32> <i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2>, <8 x i32><i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>, <8 x i32> %ind5, <8 x i64> <i64 13, i64 13, i64 13, i64 13, i64 13, i64 13, i64 13, i64 13>
  %res = call <8 x i32 >  @llvm.masked.gather.v8i32(<8 x i32*>%arrayidx, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)
  ret <8 x i32> %res
}

define <8 x i32> @test10(%struct.ST* %base, <8 x i64> %i1, <8 x i32>%ind5) {
; KNL_64-LABEL: test10:
; KNL_64:       # BB#0: # %entry
; KNL_64-NEXT:    vpbroadcastq %rdi, %zmm2
; KNL_64-NEXT:    vpmovsxdq %ymm1, %zmm1
; KNL_64-NEXT:    vpbroadcastq {{.*}}(%rip), %zmm3
; KNL_64-NEXT:    vpmuludq %zmm3, %zmm1, %zmm4
; KNL_64-NEXT:    vpsrlq $32, %zmm1, %zmm1
; KNL_64-NEXT:    vpmuludq %zmm3, %zmm1, %zmm1
; KNL_64-NEXT:    vpsllq $32, %zmm1, %zmm1
; KNL_64-NEXT:    vpaddq %zmm1, %zmm4, %zmm1
; KNL_64-NEXT:    vpbroadcastq {{.*}}(%rip), %zmm3
; KNL_64-NEXT:    vpmuludq %zmm3, %zmm0, %zmm4
; KNL_64-NEXT:    vpsrlq $32, %zmm0, %zmm0
; KNL_64-NEXT:    vpmuludq %zmm3, %zmm0, %zmm0
; KNL_64-NEXT:    vpsllq $32, %zmm0, %zmm0
; KNL_64-NEXT:    vpaddq %zmm0, %zmm4, %zmm0
; KNL_64-NEXT:    vpaddq %zmm0, %zmm2, %zmm0
; KNL_64-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; KNL_64-NEXT:    vpaddq {{.*}}(%rip){1to8}, %zmm0, %zmm1
; KNL_64-NEXT:    kxnorw %k0, %k0, %k1
; KNL_64-NEXT:    vpgatherqd (,%zmm1), %ymm0 {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test10:
; KNL_32:       # BB#0: # %entry
; KNL_32-NEXT:    vpbroadcastd {{[0-9]+}}(%esp), %ymm2
; KNL_32-NEXT:    vpbroadcastd .LCPI9_0, %ymm3
; KNL_32-NEXT:    vpmulld %ymm3, %ymm1, %ymm1
; KNL_32-NEXT:    vpmovqd %zmm0, %ymm0
; KNL_32-NEXT:    vpbroadcastd .LCPI9_1, %ymm3
; KNL_32-NEXT:    vpmulld %ymm3, %ymm0, %ymm0
; KNL_32-NEXT:    vpaddd %ymm0, %ymm2, %ymm0
; KNL_32-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; KNL_32-NEXT:    vpbroadcastd .LCPI9_2, %ymm1
; KNL_32-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; KNL_32-NEXT:    vpmovsxdq %ymm0, %zmm1
; KNL_32-NEXT:    kxnorw %k0, %k0, %k1
; KNL_32-NEXT:    vpgatherqd (,%zmm1), %ymm0 {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test10:
; SKX:       # BB#0: # %entry
; SKX-NEXT:    vpbroadcastq %rdi, %zmm2
; SKX-NEXT:    vpmullq {{.*}}(%rip){1to8}, %zmm0, %zmm0
; SKX-NEXT:    vpaddq %zmm0, %zmm2, %zmm0
; SKX-NEXT:    vpmovsxdq %ymm1, %zmm1
; SKX-NEXT:    vpmullq {{.*}}(%rip){1to8}, %zmm1, %zmm1
; SKX-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; SKX-NEXT:    vpaddq {{.*}}(%rip){1to8}, %zmm0, %zmm1
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    vpgatherqd (,%zmm1), %ymm0 {%k1}
; SKX-NEXT:    retq
entry:
  %broadcast.splatinsert = insertelement <8 x %struct.ST*> undef, %struct.ST* %base, i32 0
  %broadcast.splat = shufflevector <8 x %struct.ST*> %broadcast.splatinsert, <8 x %struct.ST*> undef, <8 x i32> zeroinitializer

  %arrayidx = getelementptr  %struct.ST, <8 x %struct.ST*> %broadcast.splat, <8 x i64> %i1, i32 2, i32 1, <8 x i32> %ind5, i64 13
  %res = call <8 x i32 >  @llvm.masked.gather.v8i32(<8 x i32*>%arrayidx, i32 4, <8 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <8 x i32> undef)
  ret <8 x i32> %res
}

; Splat index in GEP, requires broadcast
define <16 x float> @test11(float* %base, i32 %ind) {
; KNL_64-LABEL: test11:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpbroadcastd %esi, %zmm1
; KNL_64-NEXT:    kxnorw %k0, %k0, %k1
; KNL_64-NEXT:    vgatherdps (%rdi,%zmm1,4), %zmm0 {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test11:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpbroadcastd {{[0-9]+}}(%esp), %zmm1
; KNL_32-NEXT:    kxnorw %k0, %k0, %k1
; KNL_32-NEXT:    vgatherdps (%eax,%zmm1,4), %zmm0 {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test11:
; SKX:       # BB#0:
; SKX-NEXT:    vpbroadcastd %esi, %zmm1
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    vgatherdps (%rdi,%zmm1,4), %zmm0 {%k1}
; SKX-NEXT:    retq

  %broadcast.splatinsert = insertelement <16 x float*> undef, float* %base, i32 0
  %broadcast.splat = shufflevector <16 x float*> %broadcast.splatinsert, <16 x float*> undef, <16 x i32> zeroinitializer

  %gep.random = getelementptr float, <16 x float*> %broadcast.splat, i32 %ind

  %res = call <16 x float> @llvm.masked.gather.v16f32(<16 x float*> %gep.random, i32 4, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <16 x float> undef)
  ret <16 x float>%res
}

; We are checking the uniform base here. It is taken directly from input to vgatherdps
define <16 x float> @test12(float* %base, <16 x i32> %ind) {
; KNL_64-LABEL: test12:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kxnorw %k0, %k0, %k1
; KNL_64-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test12:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    kxnorw %k0, %k0, %k1
; KNL_32-NEXT:    vgatherdps (%eax,%zmm0,4), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test12:
; SKX:       # BB#0:
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq

  %sext_ind = sext <16 x i32> %ind to <16 x i64>
  %gep.random = getelementptr float, float *%base, <16 x i64> %sext_ind

  %res = call <16 x float> @llvm.masked.gather.v16f32(<16 x float*> %gep.random, i32 4, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <16 x float> undef)
  ret <16 x float>%res
}

; The same as the previous, but the mask is undefined
define <16 x float> @test13(float* %base, <16 x i32> %ind) {
; KNL_64-LABEL: test13:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test13:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vgatherdps (%eax,%zmm0,4), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test13:
; SKX:       # BB#0:
; SKX-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq

  %sext_ind = sext <16 x i32> %ind to <16 x i64>
  %gep.random = getelementptr float, float *%base, <16 x i64> %sext_ind

  %res = call <16 x float> @llvm.masked.gather.v16f32(<16 x float*> %gep.random, i32 4, <16 x i1> undef, <16 x float> undef)
  ret <16 x float>%res
}

; The base pointer is not splat, can't find unform base
define <16 x float> @test14(float* %base, i32 %ind, <16 x float*> %vec) {
; KNL_64-LABEL: test14:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpinsrq $1, %rdi, %xmm0, %xmm1
; KNL_64-NEXT:    vinserti32x4 $0, %xmm1, %zmm0, %zmm0
; KNL_64-NEXT:    vpbroadcastq %xmm0, %zmm0
; KNL_64-NEXT:    vmovd %esi, %xmm1
; KNL_64-NEXT:    vpbroadcastd %xmm1, %ymm1
; KNL_64-NEXT:    vpmovsxdq %ymm1, %zmm1
; KNL_64-NEXT:    vpsllq $2, %zmm1, %zmm1
; KNL_64-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; KNL_64-NEXT:    kshiftrw $8, %k0, %k1
; KNL_64-NEXT:    vgatherqps (,%zmm0), %ymm1 {%k1}
; KNL_64-NEXT:    vgatherqps (,%zmm0), %ymm2 {%k1}
; KNL_64-NEXT:    vinsertf64x4 $1, %ymm1, %zmm2, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test14:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    vpinsrd $1, {{[0-9]+}}(%esp), %xmm0, %xmm1
; KNL_32-NEXT:    vinserti32x4 $0, %xmm1, %zmm0, %zmm0
; KNL_32-NEXT:    vpbroadcastd %xmm0, %zmm0
; KNL_32-NEXT:    vpslld $2, {{[0-9]+}}(%esp){1to16}, %zmm1
; KNL_32-NEXT:    vpaddd %zmm1, %zmm0, %zmm1
; KNL_32-NEXT:    vgatherdps (,%zmm1), %zmm0 {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test14:
; SKX:       # BB#0:
; SKX-NEXT:    vpinsrq $1, %rdi, %xmm0, %xmm1
; SKX-NEXT:    vinserti64x2 $0, %xmm1, %zmm0, %zmm0
; SKX-NEXT:    vpbroadcastq %xmm0, %zmm0
; SKX-NEXT:    vpbroadcastd %esi, %ymm1
; SKX-NEXT:    vpmovsxdq %ymm1, %zmm1
; SKX-NEXT:    vpsllq $2, %zmm1, %zmm1
; SKX-NEXT:    vpaddq %zmm1, %zmm0, %zmm0
; SKX-NEXT:    kshiftrw $8, %k0, %k1
; SKX-NEXT:    vgatherqps (,%zmm0), %ymm1 {%k1}
; SKX-NEXT:    vgatherqps (,%zmm0), %ymm2 {%k1}
; SKX-NEXT:    vinsertf32x8 $1, %ymm1, %zmm2, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test14:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpinsrd $1, {{[0-9]+}}(%esp), %xmm0, %xmm1
; SKX_32-NEXT:    vinserti32x4 $0, %xmm1, %zmm0, %zmm0
; SKX_32-NEXT:    vpbroadcastd %xmm0, %zmm0
; SKX_32-NEXT:    vpslld $2, {{[0-9]+}}(%esp){1to16}, %zmm1
; SKX_32-NEXT:    vpaddd %zmm1, %zmm0, %zmm1
; SKX_32-NEXT:    vgatherdps (,%zmm1), %zmm0 {%k1}
; SKX_32-NEXT:    retl

  %broadcast.splatinsert = insertelement <16 x float*> %vec, float* %base, i32 1
  %broadcast.splat = shufflevector <16 x float*> %broadcast.splatinsert, <16 x float*> undef, <16 x i32> zeroinitializer

  %gep.random = getelementptr float, <16 x float*> %broadcast.splat, i32 %ind

  %res = call <16 x float> @llvm.masked.gather.v16f32(<16 x float*> %gep.random, i32 4, <16 x i1> undef, <16 x float> undef)
  ret <16 x float>%res
}

declare <4 x float> @llvm.masked.gather.v4f32(<4 x float*>, i32, <4 x i1>, <4 x float>)
declare <4 x double> @llvm.masked.gather.v4f64(<4 x double*>, i32, <4 x i1>, <4 x double>)
declare <2 x double> @llvm.masked.gather.v2f64(<2 x double*>, i32, <2 x i1>, <2 x double>)

; Gather smaller than existing instruction
define <4 x float> @test15(float* %base, <4 x i32> %ind, <4 x i1> %mask) {
;
; KNL_64-LABEL: test15:
; KNL_64:       # BB#0:
; KNL_64:         vpxor %ymm2, %ymm2, %ymm2
; KNL_64-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0,1,2,3],ymm2[4,5,6,7]
; KNL_64-NEXT:    vpmovsxdq %ymm0, %zmm2
; KNL_64-NEXT:    vpslld $31, %ymm1, %ymm0
; KNL_64-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL_64-NEXT:    vgatherqps (%rdi,%zmm2,4), %ymm0 {%k1}
; KNL_64-NEXT:    # kill
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test15:
; KNL_32:       # BB#0:
; KNL_32:         vpxor %ymm2, %ymm2, %ymm2
; KNL_32-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0,1,2,3],ymm2[4,5,6,7]
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpmovsxdq %ymm0, %zmm2
; KNL_32-NEXT:    vpslld $31, %ymm1, %ymm0
; KNL_32-NEXT:    vptestmd %zmm0, %zmm0, %k1
; KNL_32-NEXT:    vgatherqps (%eax,%zmm2,4), %ymm0 {%k1}
; KNL_32-NEXT:    # kill
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test15:
; SKX:       # BB#0:
; SKX-NEXT:    vpslld $31, %xmm1, %xmm1
; SKX-NEXT:    vptestmd %xmm1, %xmm1, %k1
; SKX-NEXT:    vgatherdps (%rdi,%xmm0,4), %xmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test15:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpslld $31, %xmm1, %xmm1
; SKX_32-NEXT:    vptestmd %xmm1, %xmm1, %k1
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    vgatherdps (%eax,%xmm0,4), %xmm1 {%k1}
; SKX_32-NEXT:    vmovaps %zmm1, %zmm0
; SKX_32-NEXT:    retl

  %sext_ind = sext <4 x i32> %ind to <4 x i64>
  %gep.random = getelementptr float, float* %base, <4 x i64> %sext_ind
  %res = call <4 x float> @llvm.masked.gather.v4f32(<4 x float*> %gep.random, i32 4, <4 x i1> %mask, <4 x float> undef)
  ret <4 x float>%res
}

; Gather smaller than existing instruction
define <4 x double> @test16(double* %base, <4 x i32> %ind, <4 x i1> %mask, <4 x double> %src0) {
;
; KNL_64-LABEL: test16:
; KNL_64:       # BB#0:
; KNL_64:         vpslld $31, %xmm1, %xmm1
; KNL_64-NEXT:    vpsrad $31, %xmm1, %xmm1
; KNL_64-NEXT:    vpmovsxdq %xmm1, %ymm1
; KNL_64-NEXT:    vpxord %zmm3, %zmm3, %zmm3
; KNL_64-NEXT:    vinserti64x4 $0, %ymm1, %zmm3, %zmm1
; KNL_64-NEXT:    vpmovsxdq %ymm0, %zmm0
; KNL_64-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL_64-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_64-NEXT:    vgatherqpd (%rdi,%zmm0,8), %zmm2 {%k1}
; KNL_64-NEXT:    vmovaps %zmm2, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test16:
; KNL_32:       # BB#0:
; KNL_32:         vpslld $31, %xmm1, %xmm1
; KNL_32-NEXT:    vpsrad $31, %xmm1, %xmm1
; KNL_32-NEXT:    vpmovsxdq %xmm1, %ymm1
; KNL_32-NEXT:    vpxord %zmm3, %zmm3, %zmm3
; KNL_32-NEXT:    vinserti64x4 $0, %ymm1, %zmm3, %zmm1
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpmovsxdq %ymm0, %zmm0
; KNL_32-NEXT:    vpsllvq .LCPI15_0, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vgatherqpd (%eax,%zmm0,8), %zmm2 {%k1}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test16:
; SKX:       # BB#0:
; SKX-NEXT:    vpslld $31, %xmm1, %xmm1
; SKX-NEXT:    vptestmd %xmm1, %xmm1, %k1
; SKX-NEXT:    vgatherdpd (%rdi,%xmm0,8), %ymm2 {%k1}
; SKX-NEXT:    vmovaps %zmm2, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test16:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpslld $31, %xmm1, %xmm1
; SKX_32-NEXT:    vptestmd %xmm1, %xmm1, %k1
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    vgatherdpd (%eax,%xmm0,8), %ymm2 {%k1}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    retl

  %sext_ind = sext <4 x i32> %ind to <4 x i64>
  %gep.random = getelementptr double, double* %base, <4 x i64> %sext_ind
  %res = call <4 x double> @llvm.masked.gather.v4f64(<4 x double*> %gep.random, i32 4, <4 x i1> %mask, <4 x double> %src0)
  ret <4 x double>%res
}

define <2 x double> @test17(double* %base, <2 x i32> %ind, <2 x i1> %mask, <2 x double> %src0) {
;
; KNL_64-LABEL: test17:
; KNL_64:       # BB#0:
; KNL_64:         vpxord %zmm3, %zmm3, %zmm3
; KNL_64-NEXT:    vinserti32x4 $0, %xmm1, %zmm3, %zmm1
; KNL_64-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL_64-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_64-NEXT:    vgatherqpd (%rdi,%zmm0,8), %zmm2 {%k1}
; KNL_64-NEXT:    vmovaps %zmm2, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test17:
; KNL_32:       # BB#0:
; KNL_32:         vpxord %zmm3, %zmm3, %zmm3
; KNL_32-NEXT:    vinserti32x4 $0, %xmm1, %zmm3, %zmm1
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpsllvq .LCPI16_0, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vgatherqpd (%eax,%zmm0,8), %zmm2 {%k1}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test17:
; SKX:       # BB#0:
; SKX-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX-NEXT:    vptestmq %xmm1, %xmm1, %k1
; SKX-NEXT:    vgatherqpd (%rdi,%xmm0,8), %xmm2 {%k1}
; SKX-NEXT:    vmovaps %zmm2, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test17:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX_32-NEXT:    vptestmq %xmm1, %xmm1, %k1
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    vgatherqpd (%eax,%xmm0,8), %xmm2 {%k1}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    retl

  %sext_ind = sext <2 x i32> %ind to <2 x i64>
  %gep.random = getelementptr double, double* %base, <2 x i64> %sext_ind
  %res = call <2 x double> @llvm.masked.gather.v2f64(<2 x double*> %gep.random, i32 4, <2 x i1> %mask, <2 x double> %src0)
  ret <2 x double>%res
}

declare void @llvm.masked.scatter.v4i32(<4 x i32> , <4 x i32*> , i32 , <4 x i1> )
declare void @llvm.masked.scatter.v4f64(<4 x double> , <4 x double*> , i32 , <4 x i1> )
declare void @llvm.masked.scatter.v2i64(<2 x i64> , <2 x i64*> , i32 , <2 x i1> )
declare void @llvm.masked.scatter.v2i32(<2 x i32> , <2 x i32*> , i32 , <2 x i1> )
declare void @llvm.masked.scatter.v2f32(<2 x float> , <2 x float*> , i32 , <2 x i1> )

define void @test18(<4 x i32>%a1, <4 x i32*> %ptr, <4 x i1>%mask) {
;
; KNL_64-LABEL: test18:
; KNL_64:       # BB#0:
; KNL_64:         vpxor %ymm3, %ymm3, %ymm3
; KNL_64-NEXT:    vpblendd {{.*#+}} ymm2 = ymm2[0,1,2,3],ymm3[4,5,6,7]
; KNL_64-NEXT:    vpslld $31, %ymm2, %ymm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test18:
; KNL_32:       # BB#0:
; KNL_32:         vpxor %ymm3, %ymm3, %ymm3
; KNL_32-NEXT:    vpblendd {{.*#+}} ymm2 = ymm2[0,1,2,3],ymm3[4,5,6,7]
; KNL_32-NEXT:    vpmovsxdq %ymm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %ymm2, %ymm2
; KNL_32-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_32-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test18:
; SKX:       # BB#0:
; SKX-NEXT:    vpslld $31, %xmm2, %xmm2
; SKX-NEXT:    vptestmd %xmm2, %xmm2, %k1
; SKX-NEXT:    vpscatterqd %xmm0, (,%ymm1) {%k1}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test18:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpslld $31, %xmm2, %xmm2
; SKX_32-NEXT:    vptestmd %xmm2, %xmm2, %k1
; SKX_32-NEXT:    vpscatterdd %xmm0, (,%xmm1) {%k1}
; SKX_32-NEXT:    retl
  call void @llvm.masked.scatter.v4i32(<4 x i32> %a1, <4 x i32*> %ptr, i32 4, <4 x i1> %mask)
  ret void
}

define void @test19(<4 x double>%a1, double* %ptr, <4 x i1>%mask, <4 x i64> %ind) {
;
; KNL_64-LABEL: test19:
; KNL_64:       # BB#0:
; KNL_64:         vpslld $31, %xmm1, %xmm1
; KNL_64-NEXT:    vpsrad $31, %xmm1, %xmm1
; KNL_64-NEXT:    vpmovsxdq %xmm1, %ymm1
; KNL_64-NEXT:    vpxord %zmm3, %zmm3, %zmm3
; KNL_64-NEXT:    vinserti64x4 $0, %ymm1, %zmm3, %zmm1
; KNL_64-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL_64-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_64-NEXT:    vscatterqpd %zmm0, (%rdi,%zmm2,8) {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test19:
; KNL_32:       # BB#0:
; KNL_32:         vpslld $31, %xmm1, %xmm1
; KNL_32-NEXT:    vpsrad $31, %xmm1, %xmm1
; KNL_32-NEXT:    vpmovsxdq %xmm1, %ymm1
; KNL_32-NEXT:    vpxord %zmm3, %zmm3, %zmm3
; KNL_32-NEXT:    vinserti64x4 $0, %ymm1, %zmm3, %zmm1
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpsllvq .LCPI18_0, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vscatterqpd %zmm0, (%eax,%zmm2,8) {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test19:
; SKX:       # BB#0:
; SKX-NEXT:    vpslld $31, %xmm1, %xmm1
; SKX-NEXT:    vptestmd %xmm1, %xmm1, %k1
; SKX-NEXT:    vscatterqpd %ymm0, (%rdi,%ymm2,8) {%k1}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test19:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpslld $31, %xmm1, %xmm1
; SKX_32-NEXT:    vptestmd %xmm1, %xmm1, %k1
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    vscatterqpd %ymm0, (%eax,%ymm2,8) {%k1}
; SKX_32-NEXT:    retl
  %gep = getelementptr double, double* %ptr, <4 x i64> %ind
  call void @llvm.masked.scatter.v4f64(<4 x double> %a1, <4 x double*> %gep, i32 8, <4 x i1> %mask)
  ret void
}

; Data type requires widening
define void @test20(<2 x float>%a1, <2 x float*> %ptr, <2 x i1> %mask) {
;
; KNL_64-LABEL: test20:
; KNL_64:       # BB#0:
; KNL_64:         vpshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; KNL_64-NEXT:    vmovq {{.*#+}} xmm2 = xmm2[0],zero
; KNL_64-NEXT:    vpxor %ymm3, %ymm3, %ymm3
; KNL_64-NEXT:    vpblendd {{.*#+}} ymm2 = ymm2[0,1,2,3],ymm3[4,5,6,7]
; KNL_64-NEXT:    vpslld $31, %ymm2, %ymm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    vscatterqps %ymm0, (,%zmm1) {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test20:
; KNL_32:       # BB#0:
; KNL_32:         vpshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; KNL_32-NEXT:    vmovq {{.*#+}} xmm2 = xmm2[0],zero
; KNL_32-NEXT:    vpxor %ymm3, %ymm3, %ymm3
; KNL_32-NEXT:    vpblendd {{.*#+}} ymm2 = ymm2[0,1,2,3],ymm3[4,5,6,7]
; KNL_32-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; KNL_32-NEXT:    vpmovsxdq %ymm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %ymm2, %ymm2
; KNL_32-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_32-NEXT:    vscatterqps %ymm0, (,%zmm1) {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test20:
; SKX:       # BB#0:
; SKX:         vpsllq $63, %xmm2, %xmm2
; SKX-NEXT:    vptestmq %xmm2, %xmm2, %k0
; SKX-NEXT:    kshiftlb $6, %k0, %k0
; SKX-NEXT:    kshiftrb $6, %k0, %k1
; SKX-NEXT:    vscatterqps %xmm0, (,%ymm1) {%k1}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test20:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SKX_32-NEXT:    vpsllq $63, %xmm2, %xmm2
; SKX_32-NEXT:    vptestmq %xmm2, %xmm2, %k0
; SKX_32-NEXT:    kshiftlb $6, %k0, %k0
; SKX_32-NEXT:    kshiftrb $6, %k0, %k1
; SKX_32-NEXT:    vscatterdps %xmm0, (,%xmm1) {%k1}
; SKX_32-NEXT:    retl
  call void @llvm.masked.scatter.v2f32(<2 x float> %a1, <2 x float*> %ptr, i32 4, <2 x i1> %mask)
  ret void
}

; Data type requires promotion
define void @test21(<2 x i32>%a1, <2 x i32*> %ptr, <2 x i1>%mask) {
;
; KNL_64-LABEL: test21:
; KNL_64:       # BB#0:
; KNL_64:         vpxord %zmm3, %zmm3, %zmm3
; KNL_64-NEXT:    vinserti32x4 $0, %xmm2, %zmm3, %zmm2
; KNL_64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL_64-NEXT:    vpsllq $63, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmq %zmm2, %zmm2, %k1
; KNL_64-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test21:
; KNL_32:       # BB#0:
; KNL_32:         vpxord %zmm3, %zmm3, %zmm3
; KNL_32-NEXT:    vinserti32x4 $0, %xmm2, %zmm3, %zmm2
; KNL_32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL_32-NEXT:    vpsllvq .LCPI20_0, %zmm2, %zmm2
; KNL_32-NEXT:    vptestmq %zmm2, %zmm2, %k1
; KNL_32-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test21:
; SKX:       # BB#0:
; SKX:         vpsllq $63, %xmm2, %xmm2
; SKX-NEXT:    vptestmq %xmm2, %xmm2, %k0
; SKX-NEXT:    kshiftlb $6, %k0, %k0
; SKX-NEXT:    kshiftrb $6, %k0, %k1
; SKX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SKX-NEXT:    vpscatterqd %xmm0, (,%ymm1) {%k1}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test21:
; SKX_32:       # BB#0:
; SKX_32:         vpsllq $63, %xmm2, %xmm2
; SKX_32-NEXT:    vptestmq %xmm2, %xmm2, %k0
; SKX_32-NEXT:    kshiftlb $6, %k0, %k0
; SKX_32-NEXT:    kshiftrb $6, %k0, %k1
; SKX_32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SKX_32-NEXT:    vpscatterqd %xmm0, (,%ymm1) {%k1}
; SKX_32-NEXT:    retl
  call void @llvm.masked.scatter.v2i32(<2 x i32> %a1, <2 x i32*> %ptr, i32 4, <2 x i1> %mask)
  ret void
}

; The result type requires widening
declare <2 x float> @llvm.masked.gather.v2f32(<2 x float*>, i32, <2 x i1>, <2 x float>)

define <2 x float> @test22(float* %base, <2 x i32> %ind, <2 x i1> %mask, <2 x float> %src0) {
;
;
; KNL_64-LABEL: test22:
; KNL_64:       # BB#0:
; KNL_64:         vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; KNL_64-NEXT:    vmovq {{.*#+}} xmm1 = xmm1[0],zero
; KNL_64-NEXT:    vpxor %ymm3, %ymm3, %ymm3
; KNL_64-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0,1,2,3],ymm3[4,5,6,7]
; KNL_64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL_64-NEXT:    vpmovsxdq %ymm0, %zmm0
; KNL_64-NEXT:    vpslld $31, %ymm1, %ymm1
; KNL_64-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_64-NEXT:    vgatherqps (%rdi,%zmm0,4), %ymm2 {%k1}
; KNL_64-NEXT:    vmovaps %zmm2, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test22:
; KNL_32:       # BB#0:
; KNL_32:         vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; KNL_32-NEXT:    vmovq {{.*#+}} xmm1 = xmm1[0],zero
; KNL_32-NEXT:    vpxor %ymm3, %ymm3, %ymm3
; KNL_32-NEXT:    vpblendd {{.*#+}} ymm1 = ymm1[0,1,2,3],ymm3[4,5,6,7]
; KNL_32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpmovsxdq %ymm0, %zmm0
; KNL_32-NEXT:    vpslld $31, %ymm1, %ymm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vgatherqps (%eax,%zmm0,4), %ymm2 {%k1}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test22:
; SKX:       # BB#0:
; SKX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SKX-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX-NEXT:    vptestmq %xmm1, %xmm1, %k0
; SKX-NEXT:    kshiftlb $6, %k0, %k0
; SKX-NEXT:    kshiftrb $6, %k0, %k1
; SKX-NEXT:    vgatherdps (%rdi,%xmm0,4), %xmm2 {%k1}
; SKX-NEXT:    vmovaps %zmm2, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test22:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SKX_32-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX_32-NEXT:    vptestmq %xmm1, %xmm1, %k0
; SKX_32-NEXT:    kshiftlb $6, %k0, %k0
; SKX_32-NEXT:    kshiftrb $6, %k0, %k1
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    vgatherdps (%eax,%xmm0,4), %xmm2 {%k1}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    retl
  %sext_ind = sext <2 x i32> %ind to <2 x i64>
  %gep.random = getelementptr float, float* %base, <2 x i64> %sext_ind
  %res = call <2 x float> @llvm.masked.gather.v2f32(<2 x float*> %gep.random, i32 4, <2 x i1> %mask, <2 x float> %src0)
  ret <2 x float>%res
}

declare <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*>, i32, <2 x i1>, <2 x i32>)
declare <2 x i64> @llvm.masked.gather.v2i64(<2 x i64*>, i32, <2 x i1>, <2 x i64>)

define <2 x i32> @test23(i32* %base, <2 x i32> %ind, <2 x i1> %mask, <2 x i32> %src0) {
;
; KNL_64-LABEL: test23:
; KNL_64:       # BB#0:
; KNL_64:         vpxord %zmm3, %zmm3, %zmm3
; KNL_64-NEXT:    vinserti32x4 $0, %xmm1, %zmm3, %zmm1
; KNL_64-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL_64-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_64-NEXT:    vpgatherqq (%rdi,%zmm0,8), %zmm2 {%k1}
; KNL_64-NEXT:    vmovaps %zmm2, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test23:
; KNL_32:       # BB#0:
; KNL_32:         vpxord %zmm3, %zmm3, %zmm3
; KNL_32-NEXT:    vinserti32x4 $0, %xmm1, %zmm3, %zmm1
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpsllvq .LCPI22_0, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vpgatherqq (%eax,%zmm0,8), %zmm2 {%k1}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test23:
; SKX:       # BB#0:
; SKX-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX-NEXT:    vptestmq %xmm1, %xmm1, %k1
; SKX-NEXT:    vpgatherqq (%rdi,%xmm0,8), %xmm2 {%k1}
; SKX-NEXT:    vmovaps %zmm2, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test23:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX_32-NEXT:    vptestmq %xmm1, %xmm1, %k1
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    vpgatherqq (%eax,%xmm0,8), %xmm2 {%k1}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    retl
  %sext_ind = sext <2 x i32> %ind to <2 x i64>
  %gep.random = getelementptr i32, i32* %base, <2 x i64> %sext_ind
  %res = call <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*> %gep.random, i32 4, <2 x i1> %mask, <2 x i32> %src0)
  ret <2 x i32>%res
}

define <2 x i32> @test24(i32* %base, <2 x i32> %ind) {
; KNL_64-LABEL: test24:
; KNL_64:       # BB#0:
; KNL_64:         movb $3, %al
; KNL_64-NEXT:    kmovw %eax, %k1
; KNL_64-NEXT:    vpgatherqq (%rdi,%zmm0,8), %zmm1 {%k1}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test24:
; KNL_32:       # BB#0:
; KNL_32:         movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpxord %zmm1, %zmm1, %zmm1
; KNL_32-NEXT:    vinserti32x4 $0, .LCPI23_0, %zmm1, %zmm1
; KNL_32-NEXT:    vpsllvq .LCPI23_1, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vpgatherqq (%eax,%zmm0,8), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test24:
; SKX:       # BB#0:
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    vpgatherqq (%rdi,%xmm0,8), %xmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test24:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    kxnorw %k0, %k0, %k1
; SKX_32-NEXT:    vpgatherqq (%eax,%xmm0,8), %xmm1 {%k1}
; SKX_32-NEXT:    vmovaps %zmm1, %zmm0
; SKX_32-NEXT:    retl
  %sext_ind = sext <2 x i32> %ind to <2 x i64>
  %gep.random = getelementptr i32, i32* %base, <2 x i64> %sext_ind
  %res = call <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*> %gep.random, i32 4, <2 x i1> <i1 true, i1 true>, <2 x i32> undef)
  ret <2 x i32>%res
}

define <2 x i64> @test25(i64* %base, <2 x i32> %ind, <2 x i1> %mask, <2 x i64> %src0) {
;
; KNL_64-LABEL: test25:
; KNL_64:       # BB#0:
; KNL_64:         vpxord %zmm3, %zmm3, %zmm3
; KNL_64-NEXT:    vinserti32x4 $0, %xmm1, %zmm3, %zmm1
; KNL_64-NEXT:    vpsllq $63, %zmm1, %zmm1
; KNL_64-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_64-NEXT:    vpgatherqq (%rdi,%zmm0,8), %zmm2 {%k1}
; KNL_64-NEXT:    vmovaps %zmm2, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test25:
; KNL_32:       # BB#0:
; KNL_32:         vpxord %zmm3, %zmm3, %zmm3
; KNL_32-NEXT:    vinserti32x4 $0, %xmm1, %zmm3, %zmm1
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpsllvq .LCPI24_0, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmq %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vpgatherqq (%eax,%zmm0,8), %zmm2 {%k1}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test25:
; SKX:       # BB#0:
; SKX-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX-NEXT:    vptestmq %xmm1, %xmm1, %k1
; SKX-NEXT:    vpgatherqq (%rdi,%xmm0,8), %xmm2 {%k1}
; SKX-NEXT:    vmovaps %zmm2, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test25:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpsllq $63, %xmm1, %xmm1
; SKX_32-NEXT:    vptestmq %xmm1, %xmm1, %k1
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    vpgatherqq (%eax,%xmm0,8), %xmm2 {%k1}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    retl
  %sext_ind = sext <2 x i32> %ind to <2 x i64>
  %gep.random = getelementptr i64, i64* %base, <2 x i64> %sext_ind
  %res = call <2 x i64> @llvm.masked.gather.v2i64(<2 x i64*> %gep.random, i32 8, <2 x i1> %mask, <2 x i64> %src0)
  ret <2 x i64>%res
}

define <2 x i64> @test26(i64* %base, <2 x i32> %ind, <2 x i64> %src0) {
;
; KNL_64-LABEL: test26:
; KNL_64:       # BB#0:
; KNL_64:         movb $3, %al
; KNL_64-NEXT:    kmovw %eax, %k1
; KNL_64-NEXT:    vpgatherqq (%rdi,%zmm0,8), %zmm1 {%k1}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test26:
; KNL_32:       # BB#0:
; KNL_32:         movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; KNL_32-NEXT:    vinserti32x4 $0, .LCPI25_0, %zmm2, %zmm2
; KNL_32-NEXT:    vpsllvq .LCPI25_1, %zmm2, %zmm2
; KNL_32-NEXT:    vptestmq %zmm2, %zmm2, %k1
; KNL_32-NEXT:    vpgatherqq (%eax,%zmm0,8), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test26:
; SKX:       # BB#0:
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    vpgatherqq (%rdi,%xmm0,8), %xmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test26:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SKX_32-NEXT:    kxnorw %k0, %k0, %k1
; SKX_32-NEXT:    vpgatherqq (%eax,%xmm0,8), %xmm1 {%k1}
; SKX_32-NEXT:    vmovaps %zmm1, %zmm0
; SKX_32-NEXT:    retl
  %sext_ind = sext <2 x i32> %ind to <2 x i64>
  %gep.random = getelementptr i64, i64* %base, <2 x i64> %sext_ind
  %res = call <2 x i64> @llvm.masked.gather.v2i64(<2 x i64*> %gep.random, i32 8, <2 x i1> <i1 true, i1 true>, <2 x i64> %src0)
  ret <2 x i64>%res
}

; Result type requires widening; all-ones mask
define <2 x float> @test27(float* %base, <2 x i32> %ind) {
;
; KNL_64-LABEL: test27:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL_64-NEXT:    vpmovsxdq %ymm0, %zmm1
; KNL_64-NEXT:    movb $3, %al
; KNL_64-NEXT:    kmovw %eax, %k1
; KNL_64-NEXT:    vgatherqps (%rdi,%zmm1,4), %ymm0 {%k1}
; KNL_64-NEXT:    # kill
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test27:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    vpmovsxdq %ymm0, %zmm1
; KNL_32-NEXT:    movb $3, %cl
; KNL_32-NEXT:    kmovw %ecx, %k1
; KNL_32-NEXT:    vgatherqps (%eax,%zmm1,4), %ymm0 {%k1}
; KNL_32-NEXT:    # kill
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test27:
; SKX:       # BB#0:
; SKX-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[0,2,2,3]
; SKX-NEXT:    movb $3, %al
; SKX-NEXT:    kmovb %eax, %k1
; SKX-NEXT:    vgatherdps (%rdi,%xmm1,4), %xmm0 {%k1}
; SKX-NEXT:    retq
  %sext_ind = sext <2 x i32> %ind to <2 x i64>
  %gep.random = getelementptr float, float* %base, <2 x i64> %sext_ind
  %res = call <2 x float> @llvm.masked.gather.v2f32(<2 x float*> %gep.random, i32 4, <2 x i1> <i1 true, i1 true>, <2 x float> undef)
  ret <2 x float>%res
}

; Data type requires promotion, mask is all-ones
define void @test28(<2 x i32>%a1, <2 x i32*> %ptr) {
;
;
; KNL_64-LABEL: test28:
; KNL_64:       # BB#0:
; KNL_64:         vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL_64-NEXT:    movb $3, %al
; KNL_64-NEXT:    kmovw %eax, %k1
; KNL_64-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k1}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test28:
; KNL_32:       # BB#0:
; KNL_32:         vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL_32-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; KNL_32-NEXT:    vinserti32x4 $0, .LCPI27_0, %zmm2, %zmm2
; KNL_32-NEXT:    vpsllvq .LCPI27_1, %zmm2, %zmm2
; KNL_32-NEXT:    vptestmq %zmm2, %zmm2, %k1
; KNL_32-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test28:
; SKX:       # BB#0:
; SKX:         vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SKX-NEXT:    movb $3, %al
; SKX-NEXT:    kmovb %eax, %k1
; SKX-NEXT:    vpscatterqd %xmm0, (,%ymm1) {%k1}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test28:
; SKX_32:       # BB#0:
; SKX_32:         vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SKX_32-NEXT:    movb $3, %al
; SKX_32-NEXT:    kmovb %eax, %k1
; SKX_32-NEXT:    vpscatterqd %xmm0, (,%ymm1) {%k1}
; SKX_32-NEXT:    retl
  call void @llvm.masked.scatter.v2i32(<2 x i32> %a1, <2 x i32*> %ptr, i32 4, <2 x i1> <i1 true, i1 true>)
  ret void
}


; SCALAR-LABEL: test29
; SCALAR:      extractelement <16 x float*>
; SCALAR-NEXT: load float
; SCALAR-NEXT: insertelement <16 x float>
; SCALAR-NEXT: extractelement <16 x float*>
; SCALAR-NEXT: load float

define <16 x float> @test29(float* %base, <16 x i32> %ind) {
; KNL_64-LABEL: test29:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    movw $44, %ax
; KNL_64-NEXT:    kmovw %eax, %k1
; KNL_64-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; KNL_64-NEXT:    vmovaps %zmm1, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test29:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    movw $44, %cx
; KNL_32-NEXT:    kmovw %ecx, %k1
; KNL_32-NEXT:    vgatherdps (%eax,%zmm0,4), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test29:
; SKX:       # BB#0:
; SKX-NEXT:    movw $44, %ax
; SKX-NEXT:    kmovw %eax, %k1
; SKX-NEXT:    vgatherdps (%rdi,%zmm0,4), %zmm1 {%k1}
; SKX-NEXT:    vmovaps %zmm1, %zmm0
; SKX-NEXT:    retq

  %broadcast.splatinsert = insertelement <16 x float*> undef, float* %base, i32 0
  %broadcast.splat = shufflevector <16 x float*> %broadcast.splatinsert, <16 x float*> undef, <16 x i32> zeroinitializer

  %sext_ind = sext <16 x i32> %ind to <16 x i64>
  %gep.random = getelementptr float, <16 x float*> %broadcast.splat, <16 x i64> %sext_ind

  %res = call <16 x float> @llvm.masked.gather.v16f32(<16 x float*> %gep.random, i32 4, <16 x i1> <i1 false, i1 false, i1 true, i1 true, i1 false, i1 true, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <16 x float> undef)
  ret <16 x float>%res
}

; Check non-power-of-2 case. It should be scalarized.
declare <3 x i32> @llvm.masked.gather.v3i32(<3 x i32*>, i32, <3 x i1>, <3 x i32>)
define <3 x i32> @test30(<3 x i32*> %base, <3 x i32> %ind, <3 x i1> %mask, <3 x i32> %src0) {
; KNL_64-LABEL: test30:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    andl $1, %edx
; KNL_64-NEXT:    andl $1, %esi
; KNL_64-NEXT:    movl %edi, %eax
; KNL_64-NEXT:    andl $1, %eax
; KNL_64-NEXT:    vpmovsxdq %xmm1, %ymm1
; KNL_64-NEXT:    vpsllq $2, %ymm1, %ymm1
; KNL_64-NEXT:    vpaddq %ymm1, %ymm0, %ymm1
; KNL_64-NEXT:    # implicit-def: %XMM0
; KNL_64-NEXT:    testb $1, %dil
; KNL_64-NEXT:    je .LBB29_2
; KNL_64-NEXT:  # BB#1: # %cond.load
; KNL_64-NEXT:    vmovq %xmm1, %rcx
; KNL_64-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; KNL_64-NEXT:  .LBB29_2: # %else
; KNL_64-NEXT:    testb %sil, %sil
; KNL_64-NEXT:    je .LBB29_4
; KNL_64-NEXT:  # BB#3: # %cond.load1
; KNL_64-NEXT:    vpextrq $1, %xmm1, %rcx
; KNL_64-NEXT:    vpinsrd $1, (%rcx), %xmm0, %xmm0
; KNL_64-NEXT:  .LBB29_4: # %else2
; KNL_64-NEXT:    testb %dl, %dl
; KNL_64-NEXT:    je .LBB29_6
; KNL_64-NEXT:  # BB#5: # %cond.load4
; KNL_64-NEXT:    vextracti128 $1, %ymm1, %xmm1
; KNL_64-NEXT:    vmovq %xmm1, %rcx
; KNL_64-NEXT:    vpinsrd $2, (%rcx), %xmm0, %xmm0
; KNL_64-NEXT:  .LBB29_6: # %else5
; KNL_64-NEXT:    vmovd %eax, %xmm1
; KNL_64-NEXT:    vpinsrd $1, %esi, %xmm1, %xmm1
; KNL_64-NEXT:    vpinsrd $2, %edx, %xmm1, %xmm1
; KNL_64-NEXT:    vpslld $31, %xmm1, %xmm1
; KNL_64-NEXT:    vblendvps %xmm1, %xmm0, %xmm2, %xmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test30:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    pushl %ebx
; KNL_32-NEXT:  .Ltmp0:
; KNL_32-NEXT:    .cfi_def_cfa_offset 8
; KNL_32-NEXT:    pushl %esi
; KNL_32-NEXT:  .Ltmp1:
; KNL_32-NEXT:    .cfi_def_cfa_offset 12
; KNL_32-NEXT:  .Ltmp2:
; KNL_32-NEXT:    .cfi_offset %esi, -12
; KNL_32-NEXT:  .Ltmp3:
; KNL_32-NEXT:    .cfi_offset %ebx, -8
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; KNL_32-NEXT:    andl $1, %eax
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; KNL_32-NEXT:    andl $1, %ecx
; KNL_32-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; KNL_32-NEXT:    movl %ebx, %edx
; KNL_32-NEXT:    andl $1, %edx
; KNL_32-NEXT:    vpslld $2, %xmm1, %xmm1
; KNL_32-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; KNL_32-NEXT:    # implicit-def: %XMM0
; KNL_32-NEXT:    testb $1, %bl
; KNL_32-NEXT:    je .LBB29_2
; KNL_32-NEXT:  # BB#1: # %cond.load
; KNL_32-NEXT:    vmovd %xmm1, %esi
; KNL_32-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; KNL_32-NEXT:  .LBB29_2: # %else
; KNL_32-NEXT:    testb %cl, %cl
; KNL_32-NEXT:    je .LBB29_4
; KNL_32-NEXT:  # BB#3: # %cond.load1
; KNL_32-NEXT:    vpextrd $1, %xmm1, %esi
; KNL_32-NEXT:    vpinsrd $1, (%esi), %xmm0, %xmm0
; KNL_32-NEXT:  .LBB29_4: # %else2
; KNL_32-NEXT:    testb %al, %al
; KNL_32-NEXT:    je .LBB29_6
; KNL_32-NEXT:  # BB#5: # %cond.load4
; KNL_32-NEXT:    vpextrd $2, %xmm1, %esi
; KNL_32-NEXT:    vpinsrd $2, (%esi), %xmm0, %xmm0
; KNL_32-NEXT:  .LBB29_6: # %else5
; KNL_32-NEXT:    vmovd %edx, %xmm1
; KNL_32-NEXT:    vpinsrd $1, %ecx, %xmm1, %xmm1
; KNL_32-NEXT:    vpinsrd $2, %eax, %xmm1, %xmm1
; KNL_32-NEXT:    vpslld $31, %xmm1, %xmm1
; KNL_32-NEXT:    vblendvps %xmm1, %xmm0, %xmm2, %xmm0
; KNL_32-NEXT:    popl %esi
; KNL_32-NEXT:    popl %ebx
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test30:
; SKX:       # BB#0:
; SKX-NEXT:    vpslld $31, %xmm2, %xmm2
; SKX-NEXT:    vptestmd %xmm2, %xmm2, %k1
; SKX-NEXT:    kmovb %k1, -{{[0-9]+}}(%rsp)
; SKX-NEXT:    vpmovsxdq %xmm1, %ymm1
; SKX-NEXT:    vpsllq $2, %ymm1, %ymm1
; SKX-NEXT:    vpaddq %ymm1, %ymm0, %ymm1
; SKX-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; SKX-NEXT:    # implicit-def: %XMM0
; SKX-NEXT:    testb %al, %al
; SKX-NEXT:    je .LBB29_2
; SKX-NEXT:  # BB#1: # %cond.load
; SKX-NEXT:    vmovq %xmm1, %rax
; SKX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SKX-NEXT:  .LBB29_2: # %else
; SKX-NEXT:    kmovb %k1, -{{[0-9]+}}(%rsp)
; SKX-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; SKX-NEXT:    testb %al, %al
; SKX-NEXT:    je .LBB29_4
; SKX-NEXT:  # BB#3: # %cond.load1
; SKX-NEXT:    vpextrq $1, %xmm1, %rax
; SKX-NEXT:    vpinsrd $1, (%rax), %xmm0, %xmm0
; SKX-NEXT:  .LBB29_4: # %else2
; SKX-NEXT:    kmovb %k1, -{{[0-9]+}}(%rsp)
; SKX-NEXT:    movb -{{[0-9]+}}(%rsp), %al
; SKX-NEXT:    testb %al, %al
; SKX-NEXT:    je .LBB29_6
; SKX-NEXT:  # BB#5: # %cond.load4
; SKX-NEXT:    vextracti64x2 $1, %ymm1, %xmm1
; SKX-NEXT:    vmovq %xmm1, %rax
; SKX-NEXT:    vpinsrd $2, (%rax), %xmm0, %xmm0
; SKX-NEXT:  .LBB29_6: # %else5
; SKX-NEXT:    vpblendmd %xmm0, %xmm3, %xmm0 {%k1}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test30:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    subl $12, %esp
; SKX_32-NEXT:  .Ltmp0:
; SKX_32-NEXT:    .cfi_def_cfa_offset 16
; SKX_32-NEXT:    vpslld $31, %xmm2, %xmm2
; SKX_32-NEXT:    vptestmd %xmm2, %xmm2, %k1
; SKX_32-NEXT:    kmovb %k1, {{[0-9]+}}(%esp)
; SKX_32-NEXT:    vpslld $2, %xmm1, %xmm1
; SKX_32-NEXT:    vpaddd %xmm1, %xmm0, %xmm1
; SKX_32-NEXT:    movb {{[0-9]+}}(%esp), %al
; SKX_32-NEXT:    # implicit-def: %XMM0
; SKX_32-NEXT:    testb %al, %al
; SKX_32-NEXT:    je .LBB29_2
; SKX_32-NEXT:  # BB#1: # %cond.load
; SKX_32-NEXT:    vmovd %xmm1, %eax
; SKX_32-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SKX_32-NEXT:  .LBB29_2: # %else
; SKX_32-NEXT:    kmovb %k1, {{[0-9]+}}(%esp)
; SKX_32-NEXT:    movb {{[0-9]+}}(%esp), %al
; SKX_32-NEXT:    testb %al, %al
; SKX_32-NEXT:    je .LBB29_4
; SKX_32-NEXT:  # BB#3: # %cond.load1
; SKX_32-NEXT:    vpextrd $1, %xmm1, %eax
; SKX_32-NEXT:    vpinsrd $1, (%eax), %xmm0, %xmm0
; SKX_32-NEXT:  .LBB29_4: # %else2
; SKX_32-NEXT:    vmovdqa32 {{[0-9]+}}(%esp), %xmm2
; SKX_32-NEXT:    kmovb %k1, (%esp)
; SKX_32-NEXT:    movb (%esp), %al
; SKX_32-NEXT:    testb %al, %al
; SKX_32-NEXT:    je .LBB29_6
; SKX_32-NEXT:  # BB#5: # %cond.load4
; SKX_32-NEXT:    vpextrd $2, %xmm1, %eax
; SKX_32-NEXT:    vpinsrd $2, (%eax), %xmm0, %xmm0
; SKX_32-NEXT:  .LBB29_6: # %else5
; SKX_32-NEXT:    vpblendmd %xmm0, %xmm2, %xmm0 {%k1}
; SKX_32-NEXT:    addl $12, %esp
; SKX_32-NEXT:    retl

  %sext_ind = sext <3 x i32> %ind to <3 x i64>
  %gep.random = getelementptr i32, <3 x i32*> %base, <3 x i64> %sext_ind
  %res = call <3 x i32> @llvm.masked.gather.v3i32(<3 x i32*> %gep.random, i32 4, <3 x i1> %mask, <3 x i32> %src0)
  ret <3 x i32>%res
}

declare <16 x float*> @llvm.masked.gather.v16p0f32(<16 x float**>, i32, <16 x i1>, <16 x float*>)

; KNL-LABEL: test31
; KNL: vpgatherqq
; KNL: vpgatherqq
define <16 x float*> @test31(<16 x float**> %ptrs) {
; KNL_64-LABEL: test31:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    kxnorw %k0, %k0, %k1
; KNL_64-NEXT:    kxnorw %k0, %k0, %k2
; KNL_64-NEXT:    vpgatherqq (,%zmm0), %zmm2 {%k2}
; KNL_64-NEXT:    kshiftrw $8, %k1, %k1
; KNL_64-NEXT:    vpgatherqq (,%zmm1), %zmm3 {%k1}
; KNL_64-NEXT:    vmovaps %zmm2, %zmm0
; KNL_64-NEXT:    vmovaps %zmm3, %zmm1
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test31:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    kxnorw %k0, %k0, %k1
; KNL_32-NEXT:    vpgatherdd (,%zmm0), %zmm1 {%k1}
; KNL_32-NEXT:    vmovaps %zmm1, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test31:
; SKX:       # BB#0:
; SKX-NEXT:    kxnorw %k0, %k0, %k1
; SKX-NEXT:    kxnorw %k0, %k0, %k2
; SKX-NEXT:    vpgatherqq (,%zmm0), %zmm2 {%k2}
; SKX-NEXT:    kshiftrw $8, %k1, %k1
; SKX-NEXT:    vpgatherqq (,%zmm1), %zmm3 {%k1}
; SKX-NEXT:    vmovaps %zmm2, %zmm0
; SKX-NEXT:    vmovaps %zmm3, %zmm1
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test31:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    kxnorw %k0, %k0, %k1
; SKX_32-NEXT:    vpgatherdd (,%zmm0), %zmm1 {%k1}
; SKX_32-NEXT:    vmovaps %zmm1, %zmm0
; SKX_32-NEXT:    retl

  %res = call <16 x float*> @llvm.masked.gather.v16p0f32(<16 x float**> %ptrs, i32 4, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, <16 x float*> undef)
  ret <16 x float*>%res
}

define <16 x i32> @test_gather_16i32(<16 x i32*> %ptrs, <16 x i1> %mask, <16 x i32> %src0)  {
; KNL_64-LABEL: test_gather_16i32:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL_64-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    vextracti64x4 $1, %zmm3, %ymm2
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    vpgatherqd (,%zmm1), %ymm2 {%k2}
; KNL_64-NEXT:    vpgatherqd (,%zmm0), %ymm3 {%k1}
; KNL_64-NEXT:    vinserti64x4 $1, %ymm2, %zmm3, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test_gather_16i32:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vpgatherdd (,%zmm0), %zmm2 {%k1}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test_gather_16i32:
; SKX:       # BB#0:
; SKX-NEXT:    vpmovsxbd %xmm2, %zmm2
; SKX-NEXT:    vpslld $31, %zmm2, %zmm2
; SKX-NEXT:    vptestmd %zmm2, %zmm2, %k1
; SKX-NEXT:    vextracti32x8 $1, %zmm3, %ymm2
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    vpgatherqd (,%zmm1), %ymm2 {%k2}
; SKX-NEXT:    vpgatherqd (,%zmm0), %ymm3 {%k1}
; SKX-NEXT:    vinserti32x8 $1, %ymm2, %zmm3, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test_gather_16i32:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; SKX_32-NEXT:    vpslld $31, %zmm1, %zmm1
; SKX_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; SKX_32-NEXT:    vpgatherdd (,%zmm0), %zmm2 {%k1}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    retl
  %res = call <16 x i32> @llvm.masked.gather.v16i32(<16 x i32*> %ptrs, i32 4, <16 x i1> %mask, <16 x i32> %src0)
  ret <16 x i32> %res
}
define <16 x i64> @test_gather_16i64(<16 x i64*> %ptrs, <16 x i1> %mask, <16 x i64> %src0)  {
; KNL_64-LABEL: test_gather_16i64:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL_64-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    vpgatherqq (,%zmm0), %zmm3 {%k1}
; KNL_64-NEXT:    vpgatherqq (,%zmm1), %zmm4 {%k2}
; KNL_64-NEXT:    vmovaps %zmm3, %zmm0
; KNL_64-NEXT:    vmovaps %zmm4, %zmm1
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test_gather_16i64:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    pushl %ebp
; KNL_32-NEXT:  .Ltmp4:
; KNL_32-NEXT:    .cfi_def_cfa_offset 8
; KNL_32-NEXT:  .Ltmp5:
; KNL_32-NEXT:    .cfi_offset %ebp, -8
; KNL_32-NEXT:    movl %esp, %ebp
; KNL_32-NEXT:  .Ltmp6:
; KNL_32-NEXT:    .cfi_def_cfa_register %ebp
; KNL_32-NEXT:    andl $-64, %esp
; KNL_32-NEXT:    subl $64, %esp
; KNL_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vmovdqa64 8(%ebp), %zmm1
; KNL_32-NEXT:    kshiftrw $8, %k1, %k2
; KNL_32-NEXT:    vpgatherdq (,%ymm0), %zmm2 {%k1}
; KNL_32-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; KNL_32-NEXT:    vpgatherdq (,%ymm0), %zmm1 {%k2}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    movl %ebp, %esp
; KNL_32-NEXT:    popl %ebp
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test_gather_16i64:
; SKX:       # BB#0:
; SKX-NEXT:    vpmovsxbd %xmm2, %zmm2
; SKX-NEXT:    vpslld $31, %zmm2, %zmm2
; SKX-NEXT:    vptestmd %zmm2, %zmm2, %k1
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    vpgatherqq (,%zmm0), %zmm3 {%k1}
; SKX-NEXT:    vpgatherqq (,%zmm1), %zmm4 {%k2}
; SKX-NEXT:    vmovaps %zmm3, %zmm0
; SKX-NEXT:    vmovaps %zmm4, %zmm1
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test_gather_16i64:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    pushl %ebp
; SKX_32-NEXT:  .Ltmp1:
; SKX_32-NEXT:    .cfi_def_cfa_offset 8
; SKX_32-NEXT:  .Ltmp2:
; SKX_32-NEXT:    .cfi_offset %ebp, -8
; SKX_32-NEXT:    movl %esp, %ebp
; SKX_32-NEXT:  .Ltmp3:
; SKX_32-NEXT:    .cfi_def_cfa_register %ebp
; SKX_32-NEXT:    andl $-64, %esp
; SKX_32-NEXT:    subl $64, %esp
; SKX_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; SKX_32-NEXT:    vpslld $31, %zmm1, %zmm1
; SKX_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; SKX_32-NEXT:    vmovdqa64 8(%ebp), %zmm1
; SKX_32-NEXT:    kshiftrw $8, %k1, %k2
; SKX_32-NEXT:    vpgatherdq (,%ymm0), %zmm2 {%k1}
; SKX_32-NEXT:    vextracti32x8 $1, %zmm0, %ymm0
; SKX_32-NEXT:    vpgatherdq (,%ymm0), %zmm1 {%k2}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    movl %ebp, %esp
; SKX_32-NEXT:    popl %ebp
; SKX_32-NEXT:    retl
  %res = call <16 x i64> @llvm.masked.gather.v16i64(<16 x i64*> %ptrs, i32 4, <16 x i1> %mask, <16 x i64> %src0)
  ret <16 x i64> %res
}
declare <16 x i64> @llvm.masked.gather.v16i64(<16 x i64*> %ptrs, i32, <16 x i1> %mask, <16 x i64> %src0)
define <16 x float> @test_gather_16f32(<16 x float*> %ptrs, <16 x i1> %mask, <16 x float> %src0)  {
; KNL_64-LABEL: test_gather_16f32:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL_64-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    vextractf64x4 $1, %zmm3, %ymm2
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    vgatherqps (,%zmm1), %ymm2 {%k2}
; KNL_64-NEXT:    vgatherqps (,%zmm0), %ymm3 {%k1}
; KNL_64-NEXT:    vinsertf64x4 $1, %ymm2, %zmm3, %zmm0
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test_gather_16f32:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vgatherdps (,%zmm0), %zmm2 {%k1}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test_gather_16f32:
; SKX:       # BB#0:
; SKX-NEXT:    vpmovsxbd %xmm2, %zmm2
; SKX-NEXT:    vpslld $31, %zmm2, %zmm2
; SKX-NEXT:    vptestmd %zmm2, %zmm2, %k1
; SKX-NEXT:    vextractf32x8 $1, %zmm3, %ymm2
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    vgatherqps (,%zmm1), %ymm2 {%k2}
; SKX-NEXT:    vgatherqps (,%zmm0), %ymm3 {%k1}
; SKX-NEXT:    vinsertf32x8 $1, %ymm2, %zmm3, %zmm0
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test_gather_16f32:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; SKX_32-NEXT:    vpslld $31, %zmm1, %zmm1
; SKX_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; SKX_32-NEXT:    vgatherdps (,%zmm0), %zmm2 {%k1}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    retl
  %res = call <16 x float> @llvm.masked.gather.v16f32(<16 x float*> %ptrs, i32 4, <16 x i1> %mask, <16 x float> %src0)
  ret <16 x float> %res
}
define <16 x double> @test_gather_16f64(<16 x double*> %ptrs, <16 x i1> %mask, <16 x double> %src0)  {
; KNL_64-LABEL: test_gather_16f64:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL_64-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    vgatherqpd (,%zmm0), %zmm3 {%k1}
; KNL_64-NEXT:    vgatherqpd (,%zmm1), %zmm4 {%k2}
; KNL_64-NEXT:    vmovaps %zmm3, %zmm0
; KNL_64-NEXT:    vmovaps %zmm4, %zmm1
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test_gather_16f64:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    pushl %ebp
; KNL_32-NEXT:  .Ltmp7:
; KNL_32-NEXT:    .cfi_def_cfa_offset 8
; KNL_32-NEXT:  .Ltmp8:
; KNL_32-NEXT:    .cfi_offset %ebp, -8
; KNL_32-NEXT:    movl %esp, %ebp
; KNL_32-NEXT:  .Ltmp9:
; KNL_32-NEXT:    .cfi_def_cfa_register %ebp
; KNL_32-NEXT:    andl $-64, %esp
; KNL_32-NEXT:    subl $64, %esp
; KNL_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vmovapd 8(%ebp), %zmm1
; KNL_32-NEXT:    kshiftrw $8, %k1, %k2
; KNL_32-NEXT:    vgatherdpd (,%ymm0), %zmm2 {%k1}
; KNL_32-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; KNL_32-NEXT:    vgatherdpd (,%ymm0), %zmm1 {%k2}
; KNL_32-NEXT:    vmovaps %zmm2, %zmm0
; KNL_32-NEXT:    movl %ebp, %esp
; KNL_32-NEXT:    popl %ebp
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test_gather_16f64:
; SKX:       # BB#0:
; SKX-NEXT:    vpmovsxbd %xmm2, %zmm2
; SKX-NEXT:    vpslld $31, %zmm2, %zmm2
; SKX-NEXT:    vptestmd %zmm2, %zmm2, %k1
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    vgatherqpd (,%zmm0), %zmm3 {%k1}
; SKX-NEXT:    vgatherqpd (,%zmm1), %zmm4 {%k2}
; SKX-NEXT:    vmovaps %zmm3, %zmm0
; SKX-NEXT:    vmovaps %zmm4, %zmm1
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test_gather_16f64:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    pushl %ebp
; SKX_32-NEXT:  .Ltmp4:
; SKX_32-NEXT:    .cfi_def_cfa_offset 8
; SKX_32-NEXT:  .Ltmp5:
; SKX_32-NEXT:    .cfi_offset %ebp, -8
; SKX_32-NEXT:    movl %esp, %ebp
; SKX_32-NEXT:  .Ltmp6:
; SKX_32-NEXT:    .cfi_def_cfa_register %ebp
; SKX_32-NEXT:    andl $-64, %esp
; SKX_32-NEXT:    subl $64, %esp
; SKX_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; SKX_32-NEXT:    vpslld $31, %zmm1, %zmm1
; SKX_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; SKX_32-NEXT:    vmovapd 8(%ebp), %zmm1
; SKX_32-NEXT:    kshiftrw $8, %k1, %k2
; SKX_32-NEXT:    vgatherdpd (,%ymm0), %zmm2 {%k1}
; SKX_32-NEXT:    vextracti32x8 $1, %zmm0, %ymm0
; SKX_32-NEXT:    vgatherdpd (,%ymm0), %zmm1 {%k2}
; SKX_32-NEXT:    vmovaps %zmm2, %zmm0
; SKX_32-NEXT:    movl %ebp, %esp
; SKX_32-NEXT:    popl %ebp
; SKX_32-NEXT:    retl
  %res = call <16 x double> @llvm.masked.gather.v16f64(<16 x double*> %ptrs, i32 4, <16 x i1> %mask, <16 x double> %src0)
  ret <16 x double> %res
}
declare <16 x double> @llvm.masked.gather.v16f64(<16 x double*> %ptrs, i32, <16 x i1> %mask, <16 x double> %src0)
define void @test_scatter_16i32(<16 x i32*> %ptrs, <16 x i1> %mask, <16 x i32> %src0)  {
; KNL_64-LABEL: test_scatter_16i32:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL_64-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    vpscatterqd %ymm3, (,%zmm0) {%k1}
; KNL_64-NEXT:    vextracti64x4 $1, %zmm3, %ymm0
; KNL_64-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k2}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test_scatter_16i32:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vpscatterdd %zmm2, (,%zmm0) {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test_scatter_16i32:
; SKX:       # BB#0:
; SKX-NEXT:    vpmovsxbd %xmm2, %zmm2
; SKX-NEXT:    vpslld $31, %zmm2, %zmm2
; SKX-NEXT:    vptestmd %zmm2, %zmm2, %k1
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    vpscatterqd %ymm3, (,%zmm0) {%k1}
; SKX-NEXT:    vextracti32x8 $1, %zmm3, %ymm0
; SKX-NEXT:    vpscatterqd %ymm0, (,%zmm1) {%k2}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test_scatter_16i32:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; SKX_32-NEXT:    vpslld $31, %zmm1, %zmm1
; SKX_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; SKX_32-NEXT:    vpscatterdd %zmm2, (,%zmm0) {%k1}
; SKX_32-NEXT:    retl
  call void @llvm.masked.scatter.v16i32(<16 x i32> %src0, <16 x i32*> %ptrs, i32 4, <16 x i1> %mask)
  ret void
}
define void @test_scatter_16i64(<16 x i64*> %ptrs, <16 x i1> %mask, <16 x i64> %src0)  {
; KNL_64-LABEL: test_scatter_16i64:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL_64-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    vpscatterqq %zmm3, (,%zmm0) {%k1}
; KNL_64-NEXT:    vpscatterqq %zmm4, (,%zmm1) {%k2}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test_scatter_16i64:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    pushl %ebp
; KNL_32-NEXT:  .Ltmp10:
; KNL_32-NEXT:    .cfi_def_cfa_offset 8
; KNL_32-NEXT:  .Ltmp11:
; KNL_32-NEXT:    .cfi_offset %ebp, -8
; KNL_32-NEXT:    movl %esp, %ebp
; KNL_32-NEXT:  .Ltmp12:
; KNL_32-NEXT:    .cfi_def_cfa_register %ebp
; KNL_32-NEXT:    andl $-64, %esp
; KNL_32-NEXT:    subl $64, %esp
; KNL_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vmovdqa64 8(%ebp), %zmm1
; KNL_32-NEXT:    kshiftrw $8, %k1, %k2
; KNL_32-NEXT:    vpscatterdq %zmm2, (,%ymm0) {%k1}
; KNL_32-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; KNL_32-NEXT:    vpscatterdq %zmm1, (,%ymm0) {%k2}
; KNL_32-NEXT:    movl %ebp, %esp
; KNL_32-NEXT:    popl %ebp
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test_scatter_16i64:
; SKX:       # BB#0:
; SKX-NEXT:    vpmovsxbd %xmm2, %zmm2
; SKX-NEXT:    vpslld $31, %zmm2, %zmm2
; SKX-NEXT:    vptestmd %zmm2, %zmm2, %k1
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    vpscatterqq %zmm3, (,%zmm0) {%k1}
; SKX-NEXT:    vpscatterqq %zmm4, (,%zmm1) {%k2}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test_scatter_16i64:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    pushl %ebp
; SKX_32-NEXT:  .Ltmp7:
; SKX_32-NEXT:    .cfi_def_cfa_offset 8
; SKX_32-NEXT:  .Ltmp8:
; SKX_32-NEXT:    .cfi_offset %ebp, -8
; SKX_32-NEXT:    movl %esp, %ebp
; SKX_32-NEXT:  .Ltmp9:
; SKX_32-NEXT:    .cfi_def_cfa_register %ebp
; SKX_32-NEXT:    andl $-64, %esp
; SKX_32-NEXT:    subl $64, %esp
; SKX_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; SKX_32-NEXT:    vpslld $31, %zmm1, %zmm1
; SKX_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; SKX_32-NEXT:    vmovdqa64 8(%ebp), %zmm1
; SKX_32-NEXT:    kshiftrw $8, %k1, %k2
; SKX_32-NEXT:    vpscatterdq %zmm2, (,%ymm0) {%k1}
; SKX_32-NEXT:    vextracti32x8 $1, %zmm0, %ymm0
; SKX_32-NEXT:    vpscatterdq %zmm1, (,%ymm0) {%k2}
; SKX_32-NEXT:    movl %ebp, %esp
; SKX_32-NEXT:    popl %ebp
; SKX_32-NEXT:    retl
  call void @llvm.masked.scatter.v16i64(<16 x i64> %src0, <16 x i64*> %ptrs, i32 4, <16 x i1> %mask)
  ret void
}
declare void @llvm.masked.scatter.v16i64(<16 x i64> %src0, <16 x i64*> %ptrs, i32, <16 x i1> %mask)
define void @test_scatter_16f32(<16 x float*> %ptrs, <16 x i1> %mask, <16 x float> %src0)  {
; KNL_64-LABEL: test_scatter_16f32:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL_64-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    vscatterqps %ymm3, (,%zmm0) {%k1}
; KNL_64-NEXT:    vextractf64x4 $1, %zmm3, %ymm0
; KNL_64-NEXT:    vscatterqps %ymm0, (,%zmm1) {%k2}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test_scatter_16f32:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vscatterdps %zmm2, (,%zmm0) {%k1}
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test_scatter_16f32:
; SKX:       # BB#0:
; SKX-NEXT:    vpmovsxbd %xmm2, %zmm2
; SKX-NEXT:    vpslld $31, %zmm2, %zmm2
; SKX-NEXT:    vptestmd %zmm2, %zmm2, %k1
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    vscatterqps %ymm3, (,%zmm0) {%k1}
; SKX-NEXT:    vextractf32x8 $1, %zmm3, %ymm0
; SKX-NEXT:    vscatterqps %ymm0, (,%zmm1) {%k2}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test_scatter_16f32:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; SKX_32-NEXT:    vpslld $31, %zmm1, %zmm1
; SKX_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; SKX_32-NEXT:    vscatterdps %zmm2, (,%zmm0) {%k1}
; SKX_32-NEXT:    retl
  call void @llvm.masked.scatter.v16f32(<16 x float> %src0, <16 x float*> %ptrs, i32 4, <16 x i1> %mask)
  ret void
}
declare void @llvm.masked.scatter.v16f32(<16 x float> %src0, <16 x float*> %ptrs, i32, <16 x i1> %mask)
define void @test_scatter_16f64(<16 x double*> %ptrs, <16 x i1> %mask, <16 x double> %src0)  {
; KNL_64-LABEL: test_scatter_16f64:
; KNL_64:       # BB#0:
; KNL_64-NEXT:    vpmovsxbd %xmm2, %zmm2
; KNL_64-NEXT:    vpslld $31, %zmm2, %zmm2
; KNL_64-NEXT:    vptestmd %zmm2, %zmm2, %k1
; KNL_64-NEXT:    kshiftrw $8, %k1, %k2
; KNL_64-NEXT:    vscatterqpd %zmm3, (,%zmm0) {%k1}
; KNL_64-NEXT:    vscatterqpd %zmm4, (,%zmm1) {%k2}
; KNL_64-NEXT:    retq
;
; KNL_32-LABEL: test_scatter_16f64:
; KNL_32:       # BB#0:
; KNL_32-NEXT:    pushl %ebp
; KNL_32-NEXT:  .Ltmp13:
; KNL_32-NEXT:    .cfi_def_cfa_offset 8
; KNL_32-NEXT:  .Ltmp14:
; KNL_32-NEXT:    .cfi_offset %ebp, -8
; KNL_32-NEXT:    movl %esp, %ebp
; KNL_32-NEXT:  .Ltmp15:
; KNL_32-NEXT:    .cfi_def_cfa_register %ebp
; KNL_32-NEXT:    andl $-64, %esp
; KNL_32-NEXT:    subl $64, %esp
; KNL_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; KNL_32-NEXT:    vpslld $31, %zmm1, %zmm1
; KNL_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; KNL_32-NEXT:    vmovapd 8(%ebp), %zmm1
; KNL_32-NEXT:    kshiftrw $8, %k1, %k2
; KNL_32-NEXT:    vscatterdpd %zmm2, (,%ymm0) {%k1}
; KNL_32-NEXT:    vextracti64x4 $1, %zmm0, %ymm0
; KNL_32-NEXT:    vscatterdpd %zmm1, (,%ymm0) {%k2}
; KNL_32-NEXT:    movl %ebp, %esp
; KNL_32-NEXT:    popl %ebp
; KNL_32-NEXT:    retl
;
; SKX-LABEL: test_scatter_16f64:
; SKX:       # BB#0:
; SKX-NEXT:    vpmovsxbd %xmm2, %zmm2
; SKX-NEXT:    vpslld $31, %zmm2, %zmm2
; SKX-NEXT:    vptestmd %zmm2, %zmm2, %k1
; SKX-NEXT:    kshiftrw $8, %k1, %k2
; SKX-NEXT:    vscatterqpd %zmm3, (,%zmm0) {%k1}
; SKX-NEXT:    vscatterqpd %zmm4, (,%zmm1) {%k2}
; SKX-NEXT:    retq
;
; SKX_32-LABEL: test_scatter_16f64:
; SKX_32:       # BB#0:
; SKX_32-NEXT:    pushl %ebp
; SKX_32-NEXT:  .Ltmp10:
; SKX_32-NEXT:    .cfi_def_cfa_offset 8
; SKX_32-NEXT:  .Ltmp11:
; SKX_32-NEXT:    .cfi_offset %ebp, -8
; SKX_32-NEXT:    movl %esp, %ebp
; SKX_32-NEXT:  .Ltmp12:
; SKX_32-NEXT:    .cfi_def_cfa_register %ebp
; SKX_32-NEXT:    andl $-64, %esp
; SKX_32-NEXT:    subl $64, %esp
; SKX_32-NEXT:    vpmovsxbd %xmm1, %zmm1
; SKX_32-NEXT:    vpslld $31, %zmm1, %zmm1
; SKX_32-NEXT:    vptestmd %zmm1, %zmm1, %k1
; SKX_32-NEXT:    vmovapd 8(%ebp), %zmm1
; SKX_32-NEXT:    kshiftrw $8, %k1, %k2
; SKX_32-NEXT:    vscatterdpd %zmm2, (,%ymm0) {%k1}
; SKX_32-NEXT:    vextracti32x8 $1, %zmm0, %ymm0
; SKX_32-NEXT:    vscatterdpd %zmm1, (,%ymm0) {%k2}
; SKX_32-NEXT:    movl %ebp, %esp
; SKX_32-NEXT:    popl %ebp
; SKX_32-NEXT:    retl
  call void @llvm.masked.scatter.v16f64(<16 x double> %src0, <16 x double*> %ptrs, i32 4, <16 x i1> %mask)
  ret void
}
declare void @llvm.masked.scatter.v16f64(<16 x double> %src0, <16 x double*> %ptrs, i32, <16 x i1> %mask)
