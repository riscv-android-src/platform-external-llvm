; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=skylake -mtriple=i386-unknown-linux-gnu -mattr=+avx2 | FileCheck --check-prefix=X86 %s
; RUN: llc < %s -mcpu=skylake -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2 | FileCheck --check-prefix=X64 %s
; RUN: llc < %s -mcpu=skx -mtriple=x86_64-unknown-linux-gnu -mattr=+avx2,-avx512f | FileCheck --check-prefix=X64 %s
; RUN: llc < %s -mcpu=skylake -mtriple=x86_64-unknown-linux-gnu -mattr=-avx2 | FileCheck --check-prefix=NOGATHER %s

declare <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*> %ptrs, i32 %align, <2 x i1> %masks, <2 x i32> %passthro)

define <2 x i32> @masked_gather_v2i32(<2 x i32*>* %ptr, <2 x i1> %masks, <2 x i32> %passthro) {
; X86-LABEL: masked_gather_v2i32:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpsllq $63, %xmm0, %xmm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm2 = mem[0],zero,mem[1],zero
; X86-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-NEXT:    vpgatherqd %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vpmovsxdq %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2i32:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpsllq $63, %xmm0, %xmm0
; X64-NEXT:    vmovdqa (%rdi), %xmm2
; X64-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    vpgatherqd %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vpmovsxdq %xmm1, %xmm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v2i32:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %xmm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %xmm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB0_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; NOGATHER-NEXT:  .LBB0_2: # %else
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB0_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    movl (%rax), %eax
; NOGATHER-NEXT:    vpinsrq $1, %rax, %xmm2, %xmm2
; NOGATHER-NEXT:  .LBB0_4: # %else2
; NOGATHER-NEXT:    vpsllq $63, %xmm0, %xmm0
; NOGATHER-NEXT:    vblendvpd %xmm0, %xmm2, %xmm1, %xmm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <2 x i32*>, <2 x i32*>* %ptr
  %res = call <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*> %ld, i32 0, <2 x i1> %masks, <2 x i32> %passthro)
  ret <2 x i32> %res
}

define <4 x i32> @masked_gather_v2i32_concat(<2 x i32*>* %ptr, <2 x i1> %masks, <2 x i32> %passthro) {
; X86-LABEL: masked_gather_v2i32_concat:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpsllq $63, %xmm0, %xmm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm2 = mem[0],zero,mem[1],zero
; X86-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-NEXT:    vpgatherqd %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vpmovsxdq %xmm1, %xmm0
; X86-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2i32_concat:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpsllq $63, %xmm0, %xmm0
; X64-NEXT:    vmovdqa (%rdi), %xmm2
; X64-NEXT:    vpshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    vpgatherqd %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vpmovsxdq %xmm1, %xmm0
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v2i32_concat:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %xmm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %xmm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB1_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; NOGATHER-NEXT:  .LBB1_2: # %else
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB1_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    movl (%rax), %eax
; NOGATHER-NEXT:    vpinsrq $1, %rax, %xmm2, %xmm2
; NOGATHER-NEXT:  .LBB1_4: # %else2
; NOGATHER-NEXT:    vpsllq $63, %xmm0, %xmm0
; NOGATHER-NEXT:    vblendvpd %xmm0, %xmm2, %xmm1, %xmm0
; NOGATHER-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,2,2,3]
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <2 x i32*>, <2 x i32*>* %ptr
  %res = call <2 x i32> @llvm.masked.gather.v2i32(<2 x i32*> %ld, i32 0, <2 x i1> %masks, <2 x i32> %passthro)
  %res2 = shufflevector <2 x i32> %res, <2 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %res2
}

declare <2 x float> @llvm.masked.gather.v2float(<2 x float*> %ptrs, i32 %align, <2 x i1> %masks, <2 x float> %passthro)

define <2 x float> @masked_gather_v2float(<2 x float*>* %ptr, <2 x i1> %masks, <2 x float> %passthro) {
; X86-LABEL: masked_gather_v2float:
; X86:       # BB#0: # %entry
; X86-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,2],zero,zero
; X86-NEXT:    vpslld $31, %xmm0, %xmm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X86-NEXT:    vgatherdps %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vmovaps %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2float:
; X64:       # BB#0: # %entry
; X64-NEXT:    vmovaps (%rdi), %xmm2
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    vpslld $31, %xmm0, %xmm0
; X64-NEXT:    vgatherqps %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vmovaps %xmm1, %xmm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v2float:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %xmm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %xmm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB2_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; NOGATHER-NEXT:  .LBB2_2: # %else
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB2_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; NOGATHER-NEXT:  .LBB2_4: # %else2
; NOGATHER-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; NOGATHER-NEXT:    vpslld $31, %xmm0, %xmm0
; NOGATHER-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <2 x float*>, <2 x float*>* %ptr
  %res = call <2 x float> @llvm.masked.gather.v2float(<2 x float*> %ld, i32 0, <2 x i1> %masks, <2 x float> %passthro)
  ret <2 x float> %res
}

define <4 x float> @masked_gather_v2float_concat(<2 x float*>* %ptr, <2 x i1> %masks, <2 x float> %passthro) {
; X86-LABEL: masked_gather_v2float_concat:
; X86:       # BB#0: # %entry
; X86-NEXT:    vinsertps {{.*#+}} xmm0 = xmm0[0,2],zero,zero
; X86-NEXT:    vpslld $31, %xmm0, %xmm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X86-NEXT:    vgatherdps %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vmovaps %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2float_concat:
; X64:       # BB#0: # %entry
; X64-NEXT:    vmovaps (%rdi), %xmm2
; X64-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X64-NEXT:    vpslld $31, %xmm0, %xmm0
; X64-NEXT:    vgatherqps %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vmovaps %xmm1, %xmm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v2float_concat:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %xmm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %xmm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB3_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; NOGATHER-NEXT:  .LBB3_2: # %else
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB3_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm2 = xmm2[0],mem[0],xmm2[2,3]
; NOGATHER-NEXT:  .LBB3_4: # %else2
; NOGATHER-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; NOGATHER-NEXT:    vpslld $31, %xmm0, %xmm0
; NOGATHER-NEXT:    vblendvps %xmm0, %xmm2, %xmm1, %xmm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <2 x float*>, <2 x float*>* %ptr
  %res = call <2 x float> @llvm.masked.gather.v2float(<2 x float*> %ld, i32 0, <2 x i1> %masks, <2 x float> %passthro)
  %res2 = shufflevector <2 x float> %res, <2 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x float> %res2
}


declare <4 x i32> @llvm.masked.gather.v4i32(<4 x i32*> %ptrs, i32 %align, <4 x i1> %masks, <4 x i32> %passthro)

define <4 x i32> @masked_gather_v4i32(<4 x i32*> %ptrs, <4 x i1> %masks, <4 x i32> %passthro) {
; X86-LABEL: masked_gather_v4i32:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpslld $31, %xmm1, %xmm1
; X86-NEXT:    vpgatherdd %xmm1, (,%xmm0), %xmm2
; X86-NEXT:    vmovdqa %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v4i32:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpslld $31, %xmm1, %xmm1
; X64-NEXT:    vpgatherqd %xmm1, (,%ymm0), %xmm2
; X64-NEXT:    vmovdqa %xmm2, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v4i32:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vpextrb $0, %xmm1, %eax
; NOGATHER-NEXT:    # implicit-def: %xmm3
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB4_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm0, %rax
; NOGATHER-NEXT:    vmovd {{.*#+}} xmm3 = mem[0],zero,zero,zero
; NOGATHER-NEXT:  .LBB4_2: # %else
; NOGATHER-NEXT:    vpextrb $4, %xmm1, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB4_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm0, %rax
; NOGATHER-NEXT:    vpinsrd $1, (%rax), %xmm3, %xmm3
; NOGATHER-NEXT:  .LBB4_4: # %else2
; NOGATHER-NEXT:    vpextrb $8, %xmm1, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB4_6
; NOGATHER-NEXT:  # BB#5: # %cond.load4
; NOGATHER-NEXT:    vextractf128 $1, %ymm0, %xmm4
; NOGATHER-NEXT:    vmovq %xmm4, %rax
; NOGATHER-NEXT:    vpinsrd $2, (%rax), %xmm3, %xmm3
; NOGATHER-NEXT:  .LBB4_6: # %else5
; NOGATHER-NEXT:    vpextrb $12, %xmm1, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB4_8
; NOGATHER-NEXT:  # BB#7: # %cond.load7
; NOGATHER-NEXT:    vextractf128 $1, %ymm0, %xmm0
; NOGATHER-NEXT:    vpextrq $1, %xmm0, %rax
; NOGATHER-NEXT:    vpinsrd $3, (%rax), %xmm3, %xmm3
; NOGATHER-NEXT:  .LBB4_8: # %else8
; NOGATHER-NEXT:    vpslld $31, %xmm1, %xmm0
; NOGATHER-NEXT:    vblendvps %xmm0, %xmm3, %xmm2, %xmm0
; NOGATHER-NEXT:    vzeroupper
; NOGATHER-NEXT:    retq
entry:
  %res = call <4 x i32> @llvm.masked.gather.v4i32(<4 x i32*> %ptrs, i32 0, <4 x i1> %masks, <4 x i32> %passthro)
  ret <4 x i32> %res
}

declare <4 x float> @llvm.masked.gather.v4float(<4 x float*> %ptrs, i32 %align, <4 x i1> %masks, <4 x float> %passthro)

define <4 x float> @masked_gather_v4float(<4 x float*> %ptrs, <4 x i1> %masks, <4 x float> %passthro) {
; X86-LABEL: masked_gather_v4float:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpslld $31, %xmm1, %xmm1
; X86-NEXT:    vgatherdps %xmm1, (,%xmm0), %xmm2
; X86-NEXT:    vmovaps %xmm2, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v4float:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpslld $31, %xmm1, %xmm1
; X64-NEXT:    vgatherqps %xmm1, (,%ymm0), %xmm2
; X64-NEXT:    vmovaps %xmm2, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v4float:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vpextrb $0, %xmm1, %eax
; NOGATHER-NEXT:    # implicit-def: %xmm3
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB5_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm0, %rax
; NOGATHER-NEXT:    vmovss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; NOGATHER-NEXT:  .LBB5_2: # %else
; NOGATHER-NEXT:    vpextrb $4, %xmm1, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB5_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm0, %rax
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm3 = xmm3[0],mem[0],xmm3[2,3]
; NOGATHER-NEXT:  .LBB5_4: # %else2
; NOGATHER-NEXT:    vpextrb $8, %xmm1, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB5_6
; NOGATHER-NEXT:  # BB#5: # %cond.load4
; NOGATHER-NEXT:    vextractf128 $1, %ymm0, %xmm4
; NOGATHER-NEXT:    vmovq %xmm4, %rax
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm3 = xmm3[0,1],mem[0],xmm3[3]
; NOGATHER-NEXT:  .LBB5_6: # %else5
; NOGATHER-NEXT:    vpextrb $12, %xmm1, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB5_8
; NOGATHER-NEXT:  # BB#7: # %cond.load7
; NOGATHER-NEXT:    vextractf128 $1, %ymm0, %xmm0
; NOGATHER-NEXT:    vpextrq $1, %xmm0, %rax
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm3 = xmm3[0,1,2],mem[0]
; NOGATHER-NEXT:  .LBB5_8: # %else8
; NOGATHER-NEXT:    vpslld $31, %xmm1, %xmm0
; NOGATHER-NEXT:    vblendvps %xmm0, %xmm3, %xmm2, %xmm0
; NOGATHER-NEXT:    vzeroupper
; NOGATHER-NEXT:    retq
entry:
  %res = call <4 x float> @llvm.masked.gather.v4float(<4 x float*> %ptrs, i32 0, <4 x i1> %masks, <4 x float> %passthro)
  ret <4 x float> %res
}

declare <8 x i32> @llvm.masked.gather.v8i32(<8 x i32*> %ptrs, i32 %align, <8 x i1> %masks, <8 x i32> %passthro)

define <8 x i32> @masked_gather_v8i32(<8 x i32*>* %ptr, <8 x i1> %masks, <8 x i32> %passthro) {
; X86-LABEL: masked_gather_v8i32:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X86-NEXT:    vpslld $31, %ymm0, %ymm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovdqa (%eax), %ymm2
; X86-NEXT:    vpgatherdd %ymm0, (,%ymm2), %ymm1
; X86-NEXT:    vmovdqa %ymm1, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v8i32:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X64-NEXT:    vpslld $31, %ymm0, %ymm0
; X64-NEXT:    vpsrad $31, %ymm0, %ymm0
; X64-NEXT:    vmovdqa (%rdi), %ymm2
; X64-NEXT:    vmovdqa 32(%rdi), %ymm3
; X64-NEXT:    vextracti128 $1, %ymm1, %xmm4
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm5
; X64-NEXT:    vpgatherqd %xmm5, (,%ymm3), %xmm4
; X64-NEXT:    vpgatherqd %xmm0, (,%ymm2), %xmm1
; X64-NEXT:    vinserti128 $1, %xmm4, %ymm1, %ymm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v8i32:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %ymm4
; NOGATHER-NEXT:    vmovdqa 32(%rdi), %ymm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %ymm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB6_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm4, %rax
; NOGATHER-NEXT:    vmovd {{.*#+}} xmm2 = mem[0],zero,zero,zero
; NOGATHER-NEXT:  .LBB6_2: # %else
; NOGATHER-NEXT:    vpextrb $2, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB6_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm4, %rax
; NOGATHER-NEXT:    vpinsrd $1, (%rax), %xmm2, %xmm5
; NOGATHER-NEXT:    vblendps {{.*#+}} ymm2 = ymm5[0,1,2,3],ymm2[4,5,6,7]
; NOGATHER-NEXT:  .LBB6_4: # %else2
; NOGATHER-NEXT:    vpextrb $4, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB6_6
; NOGATHER-NEXT:  # BB#5: # %cond.load4
; NOGATHER-NEXT:    vextractf128 $1, %ymm4, %xmm5
; NOGATHER-NEXT:    vmovq %xmm5, %rax
; NOGATHER-NEXT:    vpinsrd $2, (%rax), %xmm2, %xmm5
; NOGATHER-NEXT:    vblendps {{.*#+}} ymm2 = ymm5[0,1,2,3],ymm2[4,5,6,7]
; NOGATHER-NEXT:  .LBB6_6: # %else5
; NOGATHER-NEXT:    vpextrb $6, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB6_8
; NOGATHER-NEXT:  # BB#7: # %cond.load7
; NOGATHER-NEXT:    vextractf128 $1, %ymm4, %xmm4
; NOGATHER-NEXT:    vpextrq $1, %xmm4, %rax
; NOGATHER-NEXT:    vpinsrd $3, (%rax), %xmm2, %xmm4
; NOGATHER-NEXT:    vblendps {{.*#+}} ymm2 = ymm4[0,1,2,3],ymm2[4,5,6,7]
; NOGATHER-NEXT:  .LBB6_8: # %else8
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB6_10
; NOGATHER-NEXT:  # BB#9: # %cond.load10
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm4
; NOGATHER-NEXT:    vpinsrd $0, (%rax), %xmm4, %xmm4
; NOGATHER-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB6_10: # %else11
; NOGATHER-NEXT:    vpextrb $10, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB6_12
; NOGATHER-NEXT:  # BB#11: # %cond.load13
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm4
; NOGATHER-NEXT:    vpinsrd $1, (%rax), %xmm4, %xmm4
; NOGATHER-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB6_12: # %else14
; NOGATHER-NEXT:    vpextrb $12, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB6_14
; NOGATHER-NEXT:  # BB#13: # %cond.load16
; NOGATHER-NEXT:    vextractf128 $1, %ymm3, %xmm4
; NOGATHER-NEXT:    vmovq %xmm4, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm4
; NOGATHER-NEXT:    vpinsrd $2, (%rax), %xmm4, %xmm4
; NOGATHER-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB6_14: # %else17
; NOGATHER-NEXT:    vpextrb $14, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB6_16
; NOGATHER-NEXT:  # BB#15: # %cond.load19
; NOGATHER-NEXT:    vextractf128 $1, %ymm3, %xmm3
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm3
; NOGATHER-NEXT:    vpinsrd $3, (%rax), %xmm3, %xmm3
; NOGATHER-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB6_16: # %else20
; NOGATHER-NEXT:    vpmovzxwd {{.*#+}} xmm3 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; NOGATHER-NEXT:    vpslld $31, %xmm3, %xmm3
; NOGATHER-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4,4,5,5,6,6,7,7]
; NOGATHER-NEXT:    vpslld $31, %xmm0, %xmm0
; NOGATHER-NEXT:    vinsertf128 $1, %xmm0, %ymm3, %ymm0
; NOGATHER-NEXT:    vblendvps %ymm0, %ymm2, %ymm1, %ymm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <8 x i32*>, <8 x i32*>* %ptr
  %res = call <8 x i32> @llvm.masked.gather.v8i32(<8 x i32*> %ld, i32 0, <8 x i1> %masks, <8 x i32> %passthro)
  ret <8 x i32> %res
}

declare <8 x float> @llvm.masked.gather.v8float(<8 x float*> %ptrs, i32 %align, <8 x i1> %masks, <8 x float> %passthro)

define <8 x float> @masked_gather_v8float(<8 x float*>* %ptr, <8 x i1> %masks, <8 x float> %passthro) {
; X86-LABEL: masked_gather_v8float:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X86-NEXT:    vpslld $31, %ymm0, %ymm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovaps (%eax), %ymm2
; X86-NEXT:    vgatherdps %ymm0, (,%ymm2), %ymm1
; X86-NEXT:    vmovaps %ymm1, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v8float:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpmovzxwd {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; X64-NEXT:    vpslld $31, %ymm0, %ymm0
; X64-NEXT:    vpsrad $31, %ymm0, %ymm0
; X64-NEXT:    vmovaps (%rdi), %ymm2
; X64-NEXT:    vmovaps 32(%rdi), %ymm3
; X64-NEXT:    vextractf128 $1, %ymm1, %xmm4
; X64-NEXT:    vextracti128 $1, %ymm0, %xmm5
; X64-NEXT:    vgatherqps %xmm5, (,%ymm3), %xmm4
; X64-NEXT:    vgatherqps %xmm0, (,%ymm2), %xmm1
; X64-NEXT:    vinsertf128 $1, %xmm4, %ymm1, %ymm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v8float:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %ymm4
; NOGATHER-NEXT:    vmovdqa 32(%rdi), %ymm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %ymm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB7_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm4, %rax
; NOGATHER-NEXT:    vmovss {{.*#+}} xmm2 = mem[0],zero,zero,zero
; NOGATHER-NEXT:  .LBB7_2: # %else
; NOGATHER-NEXT:    vpextrb $2, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB7_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm4, %rax
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm5 = xmm2[0],mem[0],xmm2[2,3]
; NOGATHER-NEXT:    vblendps {{.*#+}} ymm2 = ymm5[0,1,2,3],ymm2[4,5,6,7]
; NOGATHER-NEXT:  .LBB7_4: # %else2
; NOGATHER-NEXT:    vpextrb $4, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB7_6
; NOGATHER-NEXT:  # BB#5: # %cond.load4
; NOGATHER-NEXT:    vextractf128 $1, %ymm4, %xmm5
; NOGATHER-NEXT:    vmovq %xmm5, %rax
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm5 = xmm2[0,1],mem[0],xmm2[3]
; NOGATHER-NEXT:    vblendps {{.*#+}} ymm2 = ymm5[0,1,2,3],ymm2[4,5,6,7]
; NOGATHER-NEXT:  .LBB7_6: # %else5
; NOGATHER-NEXT:    vpextrb $6, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB7_8
; NOGATHER-NEXT:  # BB#7: # %cond.load7
; NOGATHER-NEXT:    vextractf128 $1, %ymm4, %xmm4
; NOGATHER-NEXT:    vpextrq $1, %xmm4, %rax
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm4 = xmm2[0,1,2],mem[0]
; NOGATHER-NEXT:    vblendps {{.*#+}} ymm2 = ymm4[0,1,2,3],ymm2[4,5,6,7]
; NOGATHER-NEXT:  .LBB7_8: # %else8
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB7_10
; NOGATHER-NEXT:  # BB#9: # %cond.load10
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovss {{.*#+}} xmm4 = mem[0],zero,zero,zero
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm5
; NOGATHER-NEXT:    vblendps {{.*#+}} xmm4 = xmm4[0],xmm5[1,2,3]
; NOGATHER-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB7_10: # %else11
; NOGATHER-NEXT:    vpextrb $10, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB7_12
; NOGATHER-NEXT:  # BB#11: # %cond.load13
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm4
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0],mem[0],xmm4[2,3]
; NOGATHER-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB7_12: # %else14
; NOGATHER-NEXT:    vpextrb $12, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB7_14
; NOGATHER-NEXT:  # BB#13: # %cond.load16
; NOGATHER-NEXT:    vextractf128 $1, %ymm3, %xmm4
; NOGATHER-NEXT:    vmovq %xmm4, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm4
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm4 = xmm4[0,1],mem[0],xmm4[3]
; NOGATHER-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB7_14: # %else17
; NOGATHER-NEXT:    vpextrb $14, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB7_16
; NOGATHER-NEXT:  # BB#15: # %cond.load19
; NOGATHER-NEXT:    vextractf128 $1, %ymm3, %xmm3
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm3
; NOGATHER-NEXT:    vinsertps {{.*#+}} xmm3 = xmm3[0,1,2],mem[0]
; NOGATHER-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB7_16: # %else20
; NOGATHER-NEXT:    vpmovzxwd {{.*#+}} xmm3 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; NOGATHER-NEXT:    vpslld $31, %xmm3, %xmm3
; NOGATHER-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4,4,5,5,6,6,7,7]
; NOGATHER-NEXT:    vpslld $31, %xmm0, %xmm0
; NOGATHER-NEXT:    vinsertf128 $1, %xmm0, %ymm3, %ymm0
; NOGATHER-NEXT:    vblendvps %ymm0, %ymm2, %ymm1, %ymm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <8 x float*>, <8 x float*>* %ptr
  %res = call <8 x float> @llvm.masked.gather.v8float(<8 x float*> %ld, i32 0, <8 x i1> %masks, <8 x float> %passthro)
  ret <8 x float> %res
}

declare <4 x i64> @llvm.masked.gather.v4i64(<4 x i64*> %ptrs, i32 %align, <4 x i1> %masks, <4 x i64> %passthro)

define <4 x i64> @masked_gather_v4i64(<4 x i64*>* %ptr, <4 x i1> %masks, <4 x i64> %passthro) {
; X86-LABEL: masked_gather_v4i64:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpslld $31, %xmm0, %xmm0
; X86-NEXT:    vpmovsxdq %xmm0, %ymm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovdqa (%eax), %xmm2
; X86-NEXT:    vpgatherdq %ymm0, (,%xmm2), %ymm1
; X86-NEXT:    vmovdqa %ymm1, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v4i64:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpslld $31, %xmm0, %xmm0
; X64-NEXT:    vpmovsxdq %xmm0, %ymm0
; X64-NEXT:    vmovdqa (%rdi), %ymm2
; X64-NEXT:    vpgatherqq %ymm0, (,%ymm2), %ymm1
; X64-NEXT:    vmovdqa %ymm1, %ymm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v4i64:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %ymm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %ymm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB8_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovq {{.*#+}} xmm2 = mem[0],zero
; NOGATHER-NEXT:  .LBB8_2: # %else
; NOGATHER-NEXT:    vpextrb $4, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB8_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vpinsrq $1, (%rax), %xmm2, %xmm4
; NOGATHER-NEXT:    vblendps {{.*#+}} ymm2 = ymm4[0,1,2,3],ymm2[4,5,6,7]
; NOGATHER-NEXT:  .LBB8_4: # %else2
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB8_6
; NOGATHER-NEXT:  # BB#5: # %cond.load4
; NOGATHER-NEXT:    vextractf128 $1, %ymm3, %xmm4
; NOGATHER-NEXT:    vmovq %xmm4, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm4
; NOGATHER-NEXT:    vpinsrq $0, (%rax), %xmm4, %xmm4
; NOGATHER-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB8_6: # %else5
; NOGATHER-NEXT:    vpextrb $12, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB8_8
; NOGATHER-NEXT:  # BB#7: # %cond.load7
; NOGATHER-NEXT:    vextractf128 $1, %ymm3, %xmm3
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm3
; NOGATHER-NEXT:    vpinsrq $1, (%rax), %xmm3, %xmm3
; NOGATHER-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB8_8: # %else8
; NOGATHER-NEXT:    vpslld $31, %xmm0, %xmm0
; NOGATHER-NEXT:    vpsrad $31, %xmm0, %xmm0
; NOGATHER-NEXT:    vpmovsxdq %xmm0, %xmm3
; NOGATHER-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; NOGATHER-NEXT:    vpmovsxdq %xmm0, %xmm0
; NOGATHER-NEXT:    vinsertf128 $1, %xmm0, %ymm3, %ymm0
; NOGATHER-NEXT:    vblendvpd %ymm0, %ymm2, %ymm1, %ymm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <4 x i64*>, <4 x i64*>* %ptr
  %res = call <4 x i64> @llvm.masked.gather.v4i64(<4 x i64*> %ld, i32 0, <4 x i1> %masks, <4 x i64> %passthro)
  ret <4 x i64> %res
}

declare <4 x double> @llvm.masked.gather.v4double(<4 x double*> %ptrs, i32 %align, <4 x i1> %masks, <4 x double> %passthro)

define <4 x double> @masked_gather_v4double(<4 x double*>* %ptr, <4 x i1> %masks, <4 x double> %passthro) {
; X86-LABEL: masked_gather_v4double:
; X86:       # BB#0: # %entry
; X86-NEXT:    vpslld $31, %xmm0, %xmm0
; X86-NEXT:    vpmovsxdq %xmm0, %ymm0
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vmovapd (%eax), %xmm2
; X86-NEXT:    vgatherdpd %ymm0, (,%xmm2), %ymm1
; X86-NEXT:    vmovapd %ymm1, %ymm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v4double:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpslld $31, %xmm0, %xmm0
; X64-NEXT:    vpmovsxdq %xmm0, %ymm0
; X64-NEXT:    vmovapd (%rdi), %ymm2
; X64-NEXT:    vgatherqpd %ymm0, (,%ymm2), %ymm1
; X64-NEXT:    vmovapd %ymm1, %ymm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v4double:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %ymm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %ymm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB9_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; NOGATHER-NEXT:  .LBB9_2: # %else
; NOGATHER-NEXT:    vpextrb $4, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB9_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vmovhpd {{.*#+}} xmm4 = xmm2[0],mem[0]
; NOGATHER-NEXT:    vblendpd {{.*#+}} ymm2 = ymm4[0,1],ymm2[2,3]
; NOGATHER-NEXT:  .LBB9_4: # %else2
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB9_6
; NOGATHER-NEXT:  # BB#5: # %cond.load4
; NOGATHER-NEXT:    vextractf128 $1, %ymm3, %xmm4
; NOGATHER-NEXT:    vmovq %xmm4, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm4
; NOGATHER-NEXT:    vmovlpd {{.*#+}} xmm4 = mem[0],xmm4[1]
; NOGATHER-NEXT:    vinsertf128 $1, %xmm4, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB9_6: # %else5
; NOGATHER-NEXT:    vpextrb $12, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB9_8
; NOGATHER-NEXT:  # BB#7: # %cond.load7
; NOGATHER-NEXT:    vextractf128 $1, %ymm3, %xmm3
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vextractf128 $1, %ymm2, %xmm3
; NOGATHER-NEXT:    vmovhpd {{.*#+}} xmm3 = xmm3[0],mem[0]
; NOGATHER-NEXT:    vinsertf128 $1, %xmm3, %ymm2, %ymm2
; NOGATHER-NEXT:  .LBB9_8: # %else8
; NOGATHER-NEXT:    vpslld $31, %xmm0, %xmm0
; NOGATHER-NEXT:    vpsrad $31, %xmm0, %xmm0
; NOGATHER-NEXT:    vpmovsxdq %xmm0, %xmm3
; NOGATHER-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[2,3,0,1]
; NOGATHER-NEXT:    vpmovsxdq %xmm0, %xmm0
; NOGATHER-NEXT:    vinsertf128 $1, %xmm0, %ymm3, %ymm0
; NOGATHER-NEXT:    vblendvpd %ymm0, %ymm2, %ymm1, %ymm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <4 x double*>, <4 x double*>* %ptr
  %res = call <4 x double> @llvm.masked.gather.v4double(<4 x double*> %ld, i32 0, <4 x i1> %masks, <4 x double> %passthro)
  ret <4 x double> %res
}

declare <2 x i64> @llvm.masked.gather.v2i64(<2 x i64*> %ptrs, i32 %align, <2 x i1> %masks, <2 x i64> %passthro)

define <2 x i64> @masked_gather_v2i64(<2 x i64*>* %ptr, <2 x i1> %masks, <2 x i64> %passthro) {
; X86-LABEL: masked_gather_v2i64:
; X86:       # BB#0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm2 = mem[0],zero,mem[1],zero
; X86-NEXT:    vpsllq $63, %xmm0, %xmm0
; X86-NEXT:    vpgatherqq %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vmovdqa %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2i64:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpsllq $63, %xmm0, %xmm0
; X64-NEXT:    vmovdqa (%rdi), %xmm2
; X64-NEXT:    vpgatherqq %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vmovdqa %xmm1, %xmm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v2i64:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %xmm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %xmm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB10_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovq {{.*#+}} xmm2 = mem[0],zero
; NOGATHER-NEXT:  .LBB10_2: # %else
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB10_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vpinsrq $1, (%rax), %xmm2, %xmm2
; NOGATHER-NEXT:  .LBB10_4: # %else2
; NOGATHER-NEXT:    vpsllq $63, %xmm0, %xmm0
; NOGATHER-NEXT:    vblendvpd %xmm0, %xmm2, %xmm1, %xmm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <2 x i64*>, <2 x i64*>* %ptr
  %res = call <2 x i64> @llvm.masked.gather.v2i64(<2 x i64*> %ld, i32 0, <2 x i1> %masks, <2 x i64> %passthro)
  ret <2 x i64> %res
}

declare <2 x double> @llvm.masked.gather.v2double(<2 x double*> %ptrs, i32 %align, <2 x i1> %masks, <2 x double> %passthro)

define <2 x double> @masked_gather_v2double(<2 x double*>* %ptr, <2 x i1> %masks, <2 x double> %passthro) {
; X86-LABEL: masked_gather_v2double:
; X86:       # BB#0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmovzxdq {{.*#+}} xmm2 = mem[0],zero,mem[1],zero
; X86-NEXT:    vpsllq $63, %xmm0, %xmm0
; X86-NEXT:    vgatherqpd %xmm0, (,%xmm2), %xmm1
; X86-NEXT:    vmovapd %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: masked_gather_v2double:
; X64:       # BB#0: # %entry
; X64-NEXT:    vpsllq $63, %xmm0, %xmm0
; X64-NEXT:    vmovapd (%rdi), %xmm2
; X64-NEXT:    vgatherqpd %xmm0, (,%xmm2), %xmm1
; X64-NEXT:    vmovapd %xmm1, %xmm0
; X64-NEXT:    retq
;
; NOGATHER-LABEL: masked_gather_v2double:
; NOGATHER:       # BB#0: # %entry
; NOGATHER-NEXT:    vmovdqa (%rdi), %xmm3
; NOGATHER-NEXT:    vpextrb $0, %xmm0, %eax
; NOGATHER-NEXT:    # implicit-def: %xmm2
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB11_2
; NOGATHER-NEXT:  # BB#1: # %cond.load
; NOGATHER-NEXT:    vmovq %xmm3, %rax
; NOGATHER-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; NOGATHER-NEXT:  .LBB11_2: # %else
; NOGATHER-NEXT:    vpextrb $8, %xmm0, %eax
; NOGATHER-NEXT:    testb $1, %al
; NOGATHER-NEXT:    je .LBB11_4
; NOGATHER-NEXT:  # BB#3: # %cond.load1
; NOGATHER-NEXT:    vpextrq $1, %xmm3, %rax
; NOGATHER-NEXT:    vmovhpd {{.*#+}} xmm2 = xmm2[0],mem[0]
; NOGATHER-NEXT:  .LBB11_4: # %else2
; NOGATHER-NEXT:    vpsllq $63, %xmm0, %xmm0
; NOGATHER-NEXT:    vblendvpd %xmm0, %xmm2, %xmm1, %xmm0
; NOGATHER-NEXT:    retq
entry:
  %ld  = load <2 x double*>, <2 x double*>* %ptr
  %res = call <2 x double> @llvm.masked.gather.v2double(<2 x double*> %ld, i32 0, <2 x i1> %masks, <2 x double> %passthro)
  ret <2 x double> %res
}

