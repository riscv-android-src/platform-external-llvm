; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -disable-peephole -mtriple=i386-apple-darwin -mattr=+sse4.1 -show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86,SSE,X86-SSE
; RUN: llc < %s -disable-peephole -mtriple=i386-apple-darwin -mattr=+avx -show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86,AVX,X86-AVX,AVX1,X86-AVX1
; RUN: llc < %s -disable-peephole -mtriple=i386-apple-darwin -mattr=+avx512f -show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X86,AVX,X86-AVX,AVX512,X86-AVX512
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-darwin -mattr=+sse4.1 -show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64,SSE,X64-SSE
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-darwin -mattr=+avx -show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64,AVX,X64-AVX,AVX1,X64-AVX1
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-darwin -mattr=+avx512f -show-mc-encoding | FileCheck %s --check-prefixes=CHECK,X64,AVX,X64-AVX,AVX512,X64-AVX512

define <2 x double> @test_x86_sse41_blendvpd(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2) {
; SSE-LABEL: test_x86_sse41_blendvpd:
; SSE:       ## %bb.0:
; SSE-NEXT:    movapd %xmm0, %xmm3 ## encoding: [0x66,0x0f,0x28,0xd8]
; SSE-NEXT:    movaps %xmm2, %xmm0 ## encoding: [0x0f,0x28,0xc2]
; SSE-NEXT:    blendvpd %xmm0, %xmm1, %xmm3 ## encoding: [0x66,0x0f,0x38,0x15,0xd9]
; SSE-NEXT:    movapd %xmm3, %xmm0 ## encoding: [0x66,0x0f,0x28,0xc3]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_blendvpd:
; AVX:       ## %bb.0:
; AVX-NEXT:    vblendvpd %xmm2, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x4b,0xc1,0x20]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <2 x double> @llvm.x86.sse41.blendvpd(<2 x double> %a0, <2 x double> %a1, <2 x double> %a2) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse41.blendvpd(<2 x double>, <2 x double>, <2 x double>) nounwind readnone


define <4 x float> @test_x86_sse41_blendvps(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2) {
; SSE-LABEL: test_x86_sse41_blendvps:
; SSE:       ## %bb.0:
; SSE-NEXT:    movaps %xmm0, %xmm3 ## encoding: [0x0f,0x28,0xd8]
; SSE-NEXT:    movaps %xmm2, %xmm0 ## encoding: [0x0f,0x28,0xc2]
; SSE-NEXT:    blendvps %xmm0, %xmm1, %xmm3 ## encoding: [0x66,0x0f,0x38,0x14,0xd9]
; SSE-NEXT:    movaps %xmm3, %xmm0 ## encoding: [0x0f,0x28,0xc3]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_blendvps:
; AVX:       ## %bb.0:
; AVX-NEXT:    vblendvps %xmm2, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x4a,0xc1,0x20]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse41.blendvps(<4 x float> %a0, <4 x float> %a1, <4 x float> %a2) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse41.blendvps(<4 x float>, <4 x float>, <4 x float>) nounwind readnone


define <2 x double> @test_x86_sse41_dppd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse41_dppd:
; SSE:       ## %bb.0:
; SSE-NEXT:    dppd $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x41,0xc1,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_dppd:
; AVX:       ## %bb.0:
; AVX-NEXT:    vdppd $7, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x41,0xc1,0x07]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <2 x double> @llvm.x86.sse41.dppd(<2 x double> %a0, <2 x double> %a1, i8 7) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse41.dppd(<2 x double>, <2 x double>, i8) nounwind readnone


define <4 x float> @test_x86_sse41_dpps(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse41_dpps:
; SSE:       ## %bb.0:
; SSE-NEXT:    dpps $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x40,0xc1,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_dpps:
; AVX:       ## %bb.0:
; AVX-NEXT:    vdpps $7, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x40,0xc1,0x07]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse41.dpps(<4 x float> %a0, <4 x float> %a1, i8 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse41.dpps(<4 x float>, <4 x float>, i8) nounwind readnone


define <4 x float> @test_x86_sse41_insertps(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse41_insertps:
; SSE:       ## %bb.0:
; SSE-NEXT:    insertps $17, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x21,0xc1,0x11]
; SSE-NEXT:    ## xmm0 = zero,xmm1[0],xmm0[2,3]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX1-LABEL: test_x86_sse41_insertps:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vinsertps $17, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x21,0xc1,0x11]
; AVX1-NEXT:    ## xmm0 = zero,xmm1[0],xmm0[2,3]
; AVX1-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX512-LABEL: test_x86_sse41_insertps:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vinsertps $17, %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe3,0x79,0x21,0xc1,0x11]
; AVX512-NEXT:    ## xmm0 = zero,xmm1[0],xmm0[2,3]
; AVX512-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse41.insertps(<4 x float> %a0, <4 x float> %a1, i8 17) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse41.insertps(<4 x float>, <4 x float>, i8) nounwind readnone



define <8 x i16> @test_x86_sse41_mpsadbw(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse41_mpsadbw:
; SSE:       ## %bb.0:
; SSE-NEXT:    mpsadbw $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x42,0xc1,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_mpsadbw:
; AVX:       ## %bb.0:
; AVX-NEXT:    vmpsadbw $7, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x42,0xc1,0x07]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.sse41.mpsadbw(<16 x i8> %a0, <16 x i8> %a1, i8 7) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.mpsadbw(<16 x i8>, <16 x i8>, i8) nounwind readnone


define <8 x i16> @test_x86_sse41_packusdw(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: test_x86_sse41_packusdw:
; SSE:       ## %bb.0:
; SSE-NEXT:    packusdw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x2b,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_packusdw:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpackusdw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x2b,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> %a0, <4 x i32> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32>, <4 x i32>) nounwind readnone


define <8 x i16> @test_x86_sse41_packusdw_fold() {
; X86-SSE-LABEL: test_x86_sse41_packusdw_fold:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    movaps {{.*#+}} xmm0 = [0,0,0,0,65535,65535,0,0]
; X86-SSE-NEXT:    ## encoding: [0x0f,0x28,0x05,A,A,A,A]
; X86-SSE-NEXT:    ## fixup A - offset: 3, value: LCPI7_0, kind: FK_Data_4
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_sse41_packusdw_fold:
; X86-AVX:       ## %bb.0:
; X86-AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [0,0,0,0,65535,65535,0,0]
; X86-AVX-NEXT:    ## encoding: [0xc5,0xf8,0x28,0x05,A,A,A,A]
; X86-AVX-NEXT:    ## fixup A - offset: 4, value: LCPI7_0, kind: FK_Data_4
; X86-AVX-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse41_packusdw_fold:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    movaps {{.*#+}} xmm0 = [0,0,0,0,65535,65535,0,0]
; X64-SSE-NEXT:    ## encoding: [0x0f,0x28,0x05,A,A,A,A]
; X64-SSE-NEXT:    ## fixup A - offset: 3, value: LCPI7_0-4, kind: reloc_riprel_4byte
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_sse41_packusdw_fold:
; X64-AVX:       ## %bb.0:
; X64-AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [0,0,0,0,65535,65535,0,0]
; X64-AVX-NEXT:    ## encoding: [0xc5,0xf8,0x28,0x05,A,A,A,A]
; X64-AVX-NEXT:    ## fixup A - offset: 4, value: LCPI7_0-4, kind: reloc_riprel_4byte
; X64-AVX-NEXT:    retq ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> zeroinitializer, <4 x i32> <i32 65535, i32 65536, i32 -1, i32 -131072>)
  ret <8 x i16> %res
}


define <16 x i8> @test_x86_sse41_pblendvb(<16 x i8> %a0, <16 x i8> %a1, <16 x i8> %a2) {
; SSE-LABEL: test_x86_sse41_pblendvb:
; SSE:       ## %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm3 ## encoding: [0x66,0x0f,0x6f,0xd8]
; SSE-NEXT:    movaps %xmm2, %xmm0 ## encoding: [0x0f,0x28,0xc2]
; SSE-NEXT:    pblendvb %xmm0, %xmm1, %xmm3 ## encoding: [0x66,0x0f,0x38,0x10,0xd9]
; SSE-NEXT:    movdqa %xmm3, %xmm0 ## encoding: [0x66,0x0f,0x6f,0xc3]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pblendvb:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpblendvb %xmm2, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x4c,0xc1,0x20]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8> %a0, <16 x i8> %a1, <16 x i8> %a2) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.sse41.pblendvb(<16 x i8>, <16 x i8>, <16 x i8>) nounwind readnone


define <8 x i16> @test_x86_sse41_phminposuw(<8 x i16> %a0) {
; SSE-LABEL: test_x86_sse41_phminposuw:
; SSE:       ## %bb.0:
; SSE-NEXT:    phminposuw %xmm0, %xmm0 ## encoding: [0x66,0x0f,0x38,0x41,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_phminposuw:
; AVX:       ## %bb.0:
; AVX-NEXT:    vphminposuw %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x41,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.sse41.phminposuw(<8 x i16> %a0) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.phminposuw(<8 x i16>) nounwind readnone


define <16 x i8> @test_x86_sse41_pmaxsb(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse41_pmaxsb:
; SSE:       ## %bb.0:
; SSE-NEXT:    pmaxsb %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x3c,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pmaxsb:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpmaxsb %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x3c,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <16 x i8> @llvm.x86.sse41.pmaxsb(<16 x i8> %a0, <16 x i8> %a1) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.sse41.pmaxsb(<16 x i8>, <16 x i8>) nounwind readnone


define <4 x i32> @test_x86_sse41_pmaxsd(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: test_x86_sse41_pmaxsd:
; SSE:       ## %bb.0:
; SSE-NEXT:    pmaxsd %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x3d,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pmaxsd:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpmaxsd %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x3d,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32> %a0, <4 x i32> %a1) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmaxsd(<4 x i32>, <4 x i32>) nounwind readnone


define <4 x i32> @test_x86_sse41_pmaxud(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: test_x86_sse41_pmaxud:
; SSE:       ## %bb.0:
; SSE-NEXT:    pmaxud %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x3f,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pmaxud:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpmaxud %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x3f,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32> %a0, <4 x i32> %a1) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pmaxud(<4 x i32>, <4 x i32>) nounwind readnone


define <8 x i16> @test_x86_sse41_pmaxuw(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: test_x86_sse41_pmaxuw:
; SSE:       ## %bb.0:
; SSE-NEXT:    pmaxuw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x3e,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pmaxuw:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpmaxuw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x3e,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.sse41.pmaxuw(<8 x i16> %a0, <8 x i16> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.pmaxuw(<8 x i16>, <8 x i16>) nounwind readnone


define <16 x i8> @test_x86_sse41_pminsb(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse41_pminsb:
; SSE:       ## %bb.0:
; SSE-NEXT:    pminsb %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x38,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pminsb:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpminsb %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x38,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <16 x i8> @llvm.x86.sse41.pminsb(<16 x i8> %a0, <16 x i8> %a1) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.sse41.pminsb(<16 x i8>, <16 x i8>) nounwind readnone


define <4 x i32> @test_x86_sse41_pminsd(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: test_x86_sse41_pminsd:
; SSE:       ## %bb.0:
; SSE-NEXT:    pminsd %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x39,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pminsd:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpminsd %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x39,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32> %a0, <4 x i32> %a1) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pminsd(<4 x i32>, <4 x i32>) nounwind readnone


define <4 x i32> @test_x86_sse41_pminud(<4 x i32> %a0, <4 x i32> %a1) {
; SSE-LABEL: test_x86_sse41_pminud:
; SSE:       ## %bb.0:
; SSE-NEXT:    pminud %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x3b,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pminud:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpminud %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x3b,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x i32> @llvm.x86.sse41.pminud(<4 x i32> %a0, <4 x i32> %a1) ; <<4 x i32>> [#uses=1]
  ret <4 x i32> %res
}
declare <4 x i32> @llvm.x86.sse41.pminud(<4 x i32>, <4 x i32>) nounwind readnone


define <8 x i16> @test_x86_sse41_pminuw(<8 x i16> %a0, <8 x i16> %a1) {
; SSE-LABEL: test_x86_sse41_pminuw:
; SSE:       ## %bb.0:
; SSE-NEXT:    pminuw %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x3a,0xc1]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_pminuw:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpminuw %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x3a,0xc1]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <8 x i16> @llvm.x86.sse41.pminuw(<8 x i16> %a0, <8 x i16> %a1) ; <<8 x i16>> [#uses=1]
  ret <8 x i16> %res
}
declare <8 x i16> @llvm.x86.sse41.pminuw(<8 x i16>, <8 x i16>) nounwind readnone


define i32 @test_x86_sse41_ptestc(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_x86_sse41_ptestc:
; SSE:       ## %bb.0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    ptest %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x17,0xc1]
; SSE-NEXT:    setb %al ## encoding: [0x0f,0x92,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_ptestc:
; AVX:       ## %bb.0:
; AVX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX-NEXT:    vptest %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x17,0xc1]
; AVX-NEXT:    setb %al ## encoding: [0x0f,0x92,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse41.ptestc(<2 x i64> %a0, <2 x i64> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse41.ptestc(<2 x i64>, <2 x i64>) nounwind readnone


define i32 @test_x86_sse41_ptestnzc(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_x86_sse41_ptestnzc:
; SSE:       ## %bb.0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    ptest %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x17,0xc1]
; SSE-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_ptestnzc:
; AVX:       ## %bb.0:
; AVX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX-NEXT:    vptest %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x17,0xc1]
; AVX-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse41.ptestnzc(<2 x i64> %a0, <2 x i64> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse41.ptestnzc(<2 x i64>, <2 x i64>) nounwind readnone


define i32 @test_x86_sse41_ptestz(<2 x i64> %a0, <2 x i64> %a1) {
; SSE-LABEL: test_x86_sse41_ptestz:
; SSE:       ## %bb.0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    ptest %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x38,0x17,0xc1]
; SSE-NEXT:    sete %al ## encoding: [0x0f,0x94,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_ptestz:
; AVX:       ## %bb.0:
; AVX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX-NEXT:    vptest %xmm1, %xmm0 ## encoding: [0xc4,0xe2,0x79,0x17,0xc1]
; AVX-NEXT:    sete %al ## encoding: [0x0f,0x94,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %a0, <2 x i64> %a1) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse41.ptestz(<2 x i64>, <2 x i64>) nounwind readnone


define <2 x double> @test_x86_sse41_round_pd(<2 x double> %a0) {
; SSE-LABEL: test_x86_sse41_round_pd:
; SSE:       ## %bb.0:
; SSE-NEXT:    roundpd $7, %xmm0, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x09,0xc0,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_round_pd:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundpd $7, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x09,0xc0,0x07]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <2 x double> @llvm.x86.sse41.round.pd(<2 x double> %a0, i32 7) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse41.round.pd(<2 x double>, i32) nounwind readnone


define <4 x float> @test_x86_sse41_round_ps(<4 x float> %a0) {
; SSE-LABEL: test_x86_sse41_round_ps:
; SSE:       ## %bb.0:
; SSE-NEXT:    roundps $7, %xmm0, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x08,0xc0,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse41_round_ps:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundps $7, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x08,0xc0,0x07]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse41.round.ps(<4 x float> %a0, i32 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse41.round.ps(<4 x float>, i32) nounwind readnone


define <2 x double> @test_x86_sse41_round_sd(<2 x double> %a0, <2 x double> %a1) {
; SSE-LABEL: test_x86_sse41_round_sd:
; SSE:       ## %bb.0:
; SSE-NEXT:    roundsd $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x0b,0xc1,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX1-LABEL: test_x86_sse41_round_sd:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vroundsd $7, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x0b,0xc1,0x07]
; AVX1-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX512-LABEL: test_x86_sse41_round_sd:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vroundsd $7, %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe3,0x79,0x0b,0xc1,0x07]
; AVX512-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <2 x double> @llvm.x86.sse41.round.sd(<2 x double> %a0, <2 x double> %a1, i32 7) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}
declare <2 x double> @llvm.x86.sse41.round.sd(<2 x double>, <2 x double>, i32) nounwind readnone


define <2 x double> @test_x86_sse41_round_sd_load(<2 x double> %a0, <2 x double>* %a1) {
; X86-SSE-LABEL: test_x86_sse41_round_sd_load:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-SSE-NEXT:    roundsd $7, (%eax), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x0b,0x00,0x07]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX1-LABEL: test_x86_sse41_round_sd_load:
; X86-AVX1:       ## %bb.0:
; X86-AVX1-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX1-NEXT:    vroundsd $7, (%eax), %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x0b,0x00,0x07]
; X86-AVX1-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX512-LABEL: test_x86_sse41_round_sd_load:
; X86-AVX512:       ## %bb.0:
; X86-AVX512-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX512-NEXT:    vroundsd $7, (%eax), %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe3,0x79,0x0b,0x00,0x07]
; X86-AVX512-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse41_round_sd_load:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    roundsd $7, (%rdi), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x0b,0x07,0x07]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX1-LABEL: test_x86_sse41_round_sd_load:
; X64-AVX1:       ## %bb.0:
; X64-AVX1-NEXT:    vroundsd $7, (%rdi), %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x0b,0x07,0x07]
; X64-AVX1-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX512-LABEL: test_x86_sse41_round_sd_load:
; X64-AVX512:       ## %bb.0:
; X64-AVX512-NEXT:    vroundsd $7, (%rdi), %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe3,0x79,0x0b,0x07,0x07]
; X64-AVX512-NEXT:    retq ## encoding: [0xc3]
  %a1b = load <2 x double>, <2 x double>* %a1
  %res = call <2 x double> @llvm.x86.sse41.round.sd(<2 x double> %a0, <2 x double> %a1b, i32 7) ; <<2 x double>> [#uses=1]
  ret <2 x double> %res
}


define <4 x float> @test_x86_sse41_round_ss(<4 x float> %a0, <4 x float> %a1) {
; SSE-LABEL: test_x86_sse41_round_ss:
; SSE:       ## %bb.0:
; SSE-NEXT:    roundss $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x0a,0xc1,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX1-LABEL: test_x86_sse41_round_ss:
; AVX1:       ## %bb.0:
; AVX1-NEXT:    vroundss $7, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x0a,0xc1,0x07]
; AVX1-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX512-LABEL: test_x86_sse41_round_ss:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vroundss $7, %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe3,0x79,0x0a,0xc1,0x07]
; AVX512-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <4 x float> @llvm.x86.sse41.round.ss(<4 x float> %a0, <4 x float> %a1, i32 7) ; <<4 x float>> [#uses=1]
  ret <4 x float> %res
}
declare <4 x float> @llvm.x86.sse41.round.ss(<4 x float>, <4 x float>, i32) nounwind readnone
