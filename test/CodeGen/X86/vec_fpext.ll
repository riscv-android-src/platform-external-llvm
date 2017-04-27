; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse4.1 -show-mc-encoding | FileCheck %s --check-prefix=X32-SSE
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx -show-mc-encoding | FileCheck %s --check-prefix=X32-AVX
; RUN: llc < %s -mtriple=i686-unknown -mattr=+avx512vl -show-mc-encoding | FileCheck %s --check-prefix=X32-AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.1 -show-mc-encoding | FileCheck %s --check-prefix=X64-SSE
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx -show-mc-encoding | FileCheck %s --check-prefix=X64-AVX
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx512vl -show-mc-encoding | FileCheck %s --check-prefix=X64-AVX512VL

; PR11674
define void @fpext_frommem(<2 x float>* %in, <2 x double>* %out) {
; X32-SSE-LABEL: fpext_frommem:
; X32-SSE:       # BB#0: # %entry
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-SSE-NEXT:    cvtps2pd (%ecx), %xmm0 # encoding: [0x0f,0x5a,0x01]
; X32-SSE-NEXT:    movups %xmm0, (%eax) # encoding: [0x0f,0x11,0x00]
; X32-SSE-NEXT:    retl # encoding: [0xc3]
;
; X32-AVX-LABEL: fpext_frommem:
; X32-AVX:       # BB#0: # %entry
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-AVX-NEXT:    vcvtps2pd (%ecx), %xmm0 # encoding: [0xc5,0xf8,0x5a,0x01]
; X32-AVX-NEXT:    vmovups %xmm0, (%eax) # encoding: [0xc5,0xf8,0x11,0x00]
; X32-AVX-NEXT:    retl # encoding: [0xc3]
;
; X32-AVX512VL-LABEL: fpext_frommem:
; X32-AVX512VL:       # BB#0: # %entry
; X32-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-AVX512VL-NEXT:    vcvtps2pd (%ecx), %xmm0 # EVEX TO VEX Compression encoding: [0xc5,0xf8,0x5a,0x01]
; X32-AVX512VL-NEXT:    vmovups %xmm0, (%eax) # EVEX TO VEX Compression encoding: [0xc5,0xf8,0x11,0x00]
; X32-AVX512VL-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: fpext_frommem:
; X64-SSE:       # BB#0: # %entry
; X64-SSE-NEXT:    cvtps2pd (%rdi), %xmm0 # encoding: [0x0f,0x5a,0x07]
; X64-SSE-NEXT:    movups %xmm0, (%rsi) # encoding: [0x0f,0x11,0x06]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: fpext_frommem:
; X64-AVX:       # BB#0: # %entry
; X64-AVX-NEXT:    vcvtps2pd (%rdi), %xmm0 # encoding: [0xc5,0xf8,0x5a,0x07]
; X64-AVX-NEXT:    vmovups %xmm0, (%rsi) # encoding: [0xc5,0xf8,0x11,0x06]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX512VL-LABEL: fpext_frommem:
; X64-AVX512VL:       # BB#0: # %entry
; X64-AVX512VL-NEXT:    vcvtps2pd (%rdi), %xmm0 # EVEX TO VEX Compression encoding: [0xc5,0xf8,0x5a,0x07]
; X64-AVX512VL-NEXT:    vmovups %xmm0, (%rsi) # EVEX TO VEX Compression encoding: [0xc5,0xf8,0x11,0x06]
; X64-AVX512VL-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load <2 x float>, <2 x float>* %in, align 8
  %1 = fpext <2 x float> %0 to <2 x double>
  store <2 x double> %1, <2 x double>* %out, align 1
  ret void
}

define void @fpext_frommem4(<4 x float>* %in, <4 x double>* %out) {
; X32-SSE-LABEL: fpext_frommem4:
; X32-SSE:       # BB#0: # %entry
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-SSE-NEXT:    cvtps2pd (%ecx), %xmm0 # encoding: [0x0f,0x5a,0x01]
; X32-SSE-NEXT:    cvtps2pd 8(%ecx), %xmm1 # encoding: [0x0f,0x5a,0x49,0x08]
; X32-SSE-NEXT:    movups %xmm1, 16(%eax) # encoding: [0x0f,0x11,0x48,0x10]
; X32-SSE-NEXT:    movups %xmm0, (%eax) # encoding: [0x0f,0x11,0x00]
; X32-SSE-NEXT:    retl # encoding: [0xc3]
;
; X32-AVX-LABEL: fpext_frommem4:
; X32-AVX:       # BB#0: # %entry
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-AVX-NEXT:    vcvtps2pd (%ecx), %ymm0 # encoding: [0xc5,0xfc,0x5a,0x01]
; X32-AVX-NEXT:    vmovups %ymm0, (%eax) # encoding: [0xc5,0xfc,0x11,0x00]
; X32-AVX-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X32-AVX-NEXT:    retl # encoding: [0xc3]
;
; X32-AVX512VL-LABEL: fpext_frommem4:
; X32-AVX512VL:       # BB#0: # %entry
; X32-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-AVX512VL-NEXT:    vcvtps2pd (%ecx), %ymm0 # EVEX TO VEX Compression encoding: [0xc5,0xfc,0x5a,0x01]
; X32-AVX512VL-NEXT:    vmovups %ymm0, (%eax) # EVEX TO VEX Compression encoding: [0xc5,0xfc,0x11,0x00]
; X32-AVX512VL-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X32-AVX512VL-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: fpext_frommem4:
; X64-SSE:       # BB#0: # %entry
; X64-SSE-NEXT:    cvtps2pd (%rdi), %xmm0 # encoding: [0x0f,0x5a,0x07]
; X64-SSE-NEXT:    cvtps2pd 8(%rdi), %xmm1 # encoding: [0x0f,0x5a,0x4f,0x08]
; X64-SSE-NEXT:    movups %xmm1, 16(%rsi) # encoding: [0x0f,0x11,0x4e,0x10]
; X64-SSE-NEXT:    movups %xmm0, (%rsi) # encoding: [0x0f,0x11,0x06]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: fpext_frommem4:
; X64-AVX:       # BB#0: # %entry
; X64-AVX-NEXT:    vcvtps2pd (%rdi), %ymm0 # encoding: [0xc5,0xfc,0x5a,0x07]
; X64-AVX-NEXT:    vmovups %ymm0, (%rsi) # encoding: [0xc5,0xfc,0x11,0x06]
; X64-AVX-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX512VL-LABEL: fpext_frommem4:
; X64-AVX512VL:       # BB#0: # %entry
; X64-AVX512VL-NEXT:    vcvtps2pd (%rdi), %ymm0 # EVEX TO VEX Compression encoding: [0xc5,0xfc,0x5a,0x07]
; X64-AVX512VL-NEXT:    vmovups %ymm0, (%rsi) # EVEX TO VEX Compression encoding: [0xc5,0xfc,0x11,0x06]
; X64-AVX512VL-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-AVX512VL-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load <4 x float>, <4 x float>* %in
  %1 = fpext <4 x float> %0 to <4 x double>
  store <4 x double> %1, <4 x double>* %out, align 1
  ret void
}

define void @fpext_frommem8(<8 x float>* %in, <8 x double>* %out) {
; X32-SSE-LABEL: fpext_frommem8:
; X32-SSE:       # BB#0: # %entry
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-SSE-NEXT:    cvtps2pd (%ecx), %xmm0 # encoding: [0x0f,0x5a,0x01]
; X32-SSE-NEXT:    cvtps2pd 8(%ecx), %xmm1 # encoding: [0x0f,0x5a,0x49,0x08]
; X32-SSE-NEXT:    cvtps2pd 16(%ecx), %xmm2 # encoding: [0x0f,0x5a,0x51,0x10]
; X32-SSE-NEXT:    cvtps2pd 24(%ecx), %xmm3 # encoding: [0x0f,0x5a,0x59,0x18]
; X32-SSE-NEXT:    movups %xmm3, 48(%eax) # encoding: [0x0f,0x11,0x58,0x30]
; X32-SSE-NEXT:    movups %xmm2, 32(%eax) # encoding: [0x0f,0x11,0x50,0x20]
; X32-SSE-NEXT:    movups %xmm1, 16(%eax) # encoding: [0x0f,0x11,0x48,0x10]
; X32-SSE-NEXT:    movups %xmm0, (%eax) # encoding: [0x0f,0x11,0x00]
; X32-SSE-NEXT:    retl # encoding: [0xc3]
;
; X32-AVX-LABEL: fpext_frommem8:
; X32-AVX:       # BB#0: # %entry
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-AVX-NEXT:    vcvtps2pd (%ecx), %ymm0 # encoding: [0xc5,0xfc,0x5a,0x01]
; X32-AVX-NEXT:    vcvtps2pd 16(%ecx), %ymm1 # encoding: [0xc5,0xfc,0x5a,0x49,0x10]
; X32-AVX-NEXT:    vmovups %ymm1, 32(%eax) # encoding: [0xc5,0xfc,0x11,0x48,0x20]
; X32-AVX-NEXT:    vmovups %ymm0, (%eax) # encoding: [0xc5,0xfc,0x11,0x00]
; X32-AVX-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X32-AVX-NEXT:    retl # encoding: [0xc3]
;
; X32-AVX512VL-LABEL: fpext_frommem8:
; X32-AVX512VL:       # BB#0: # %entry
; X32-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %eax # encoding: [0x8b,0x44,0x24,0x08]
; X32-AVX512VL-NEXT:    movl {{[0-9]+}}(%esp), %ecx # encoding: [0x8b,0x4c,0x24,0x04]
; X32-AVX512VL-NEXT:    vcvtps2pd (%ecx), %zmm0 # encoding: [0x62,0xf1,0x7c,0x48,0x5a,0x01]
; X32-AVX512VL-NEXT:    vmovups %zmm0, (%eax) # encoding: [0x62,0xf1,0x7c,0x48,0x11,0x00]
; X32-AVX512VL-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X32-AVX512VL-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: fpext_frommem8:
; X64-SSE:       # BB#0: # %entry
; X64-SSE-NEXT:    cvtps2pd (%rdi), %xmm0 # encoding: [0x0f,0x5a,0x07]
; X64-SSE-NEXT:    cvtps2pd 8(%rdi), %xmm1 # encoding: [0x0f,0x5a,0x4f,0x08]
; X64-SSE-NEXT:    cvtps2pd 16(%rdi), %xmm2 # encoding: [0x0f,0x5a,0x57,0x10]
; X64-SSE-NEXT:    cvtps2pd 24(%rdi), %xmm3 # encoding: [0x0f,0x5a,0x5f,0x18]
; X64-SSE-NEXT:    movups %xmm3, 48(%rsi) # encoding: [0x0f,0x11,0x5e,0x30]
; X64-SSE-NEXT:    movups %xmm2, 32(%rsi) # encoding: [0x0f,0x11,0x56,0x20]
; X64-SSE-NEXT:    movups %xmm1, 16(%rsi) # encoding: [0x0f,0x11,0x4e,0x10]
; X64-SSE-NEXT:    movups %xmm0, (%rsi) # encoding: [0x0f,0x11,0x06]
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: fpext_frommem8:
; X64-AVX:       # BB#0: # %entry
; X64-AVX-NEXT:    vcvtps2pd (%rdi), %ymm0 # encoding: [0xc5,0xfc,0x5a,0x07]
; X64-AVX-NEXT:    vcvtps2pd 16(%rdi), %ymm1 # encoding: [0xc5,0xfc,0x5a,0x4f,0x10]
; X64-AVX-NEXT:    vmovups %ymm1, 32(%rsi) # encoding: [0xc5,0xfc,0x11,0x4e,0x20]
; X64-AVX-NEXT:    vmovups %ymm0, (%rsi) # encoding: [0xc5,0xfc,0x11,0x06]
; X64-AVX-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-AVX-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX512VL-LABEL: fpext_frommem8:
; X64-AVX512VL:       # BB#0: # %entry
; X64-AVX512VL-NEXT:    vcvtps2pd (%rdi), %zmm0 # encoding: [0x62,0xf1,0x7c,0x48,0x5a,0x07]
; X64-AVX512VL-NEXT:    vmovups %zmm0, (%rsi) # encoding: [0x62,0xf1,0x7c,0x48,0x11,0x06]
; X64-AVX512VL-NEXT:    vzeroupper # encoding: [0xc5,0xf8,0x77]
; X64-AVX512VL-NEXT:    retq # encoding: [0xc3]
entry:
  %0 = load <8 x float>, <8 x float>* %in
  %1 = fpext <8 x float> %0 to <8 x double>
  store <8 x double> %1, <8 x double>* %out, align 1
  ret void
}

define <2 x double> @fpext_fromconst() {
; X32-SSE-LABEL: fpext_fromconst:
; X32-SSE:       # BB#0: # %entry
; X32-SSE-NEXT:    movaps {{.*#+}} xmm0 = [1.000000e+00,-2.000000e+00]
; X32-SSE-NEXT:    # encoding: [0x0f,0x28,0x05,A,A,A,A]
; X32-SSE-NEXT:    # fixup A - offset: 3, value: {{\.LCPI.*}}, kind: FK_Data_4
; X32-SSE-NEXT:    retl # encoding: [0xc3]
;
; X32-AVX-LABEL: fpext_fromconst:
; X32-AVX:       # BB#0: # %entry
; X32-AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [1.000000e+00,-2.000000e+00]
; X32-AVX-NEXT:    # encoding: [0xc5,0xf8,0x28,0x05,A,A,A,A]
; X32-AVX-NEXT:    # fixup A - offset: 4, value: {{\.LCPI.*}}, kind: FK_Data_4
; X32-AVX-NEXT:    retl # encoding: [0xc3]
;
; X32-AVX512VL-LABEL: fpext_fromconst:
; X32-AVX512VL:       # BB#0: # %entry
; X32-AVX512VL-NEXT:    vmovaps {{\.LCPI.*}}, %xmm0 # EVEX TO VEX Compression xmm0 = [1.000000e+00,-2.000000e+00]
; X32-AVX512VL-NEXT:    # encoding: [0xc5,0xf8,0x28,0x05,A,A,A,A]
; X32-AVX512VL-NEXT:    # fixup A - offset: 4, value: {{\.LCPI.*}}, kind: FK_Data_4
; X32-AVX512VL-NEXT:    retl # encoding: [0xc3]
;
; X64-SSE-LABEL: fpext_fromconst:
; X64-SSE:       # BB#0: # %entry
; X64-SSE-NEXT:    movaps {{.*#+}} xmm0 = [1.000000e+00,-2.000000e+00]
; X64-SSE-NEXT:    # encoding: [0x0f,0x28,0x05,A,A,A,A]
; X64-SSE-NEXT:    # fixup A - offset: 3, value: {{\.LCPI.*}}-4, kind: reloc_riprel_4byte
; X64-SSE-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX-LABEL: fpext_fromconst:
; X64-AVX:       # BB#0: # %entry
; X64-AVX-NEXT:    vmovaps {{.*#+}} xmm0 = [1.000000e+00,-2.000000e+00]
; X64-AVX-NEXT:    # encoding: [0xc5,0xf8,0x28,0x05,A,A,A,A]
; X64-AVX-NEXT:    # fixup A - offset: 4, value: {{\.LCPI.*}}-4, kind: reloc_riprel_4byte
; X64-AVX-NEXT:    retq # encoding: [0xc3]
;
; X64-AVX512VL-LABEL: fpext_fromconst:
; X64-AVX512VL:       # BB#0: # %entry
; X64-AVX512VL-NEXT:    vmovaps {{.*}}(%rip), %xmm0 # EVEX TO VEX Compression xmm0 = [1.000000e+00,-2.000000e+00]
; X64-AVX512VL-NEXT:    # encoding: [0xc5,0xf8,0x28,0x05,A,A,A,A]
; X64-AVX512VL-NEXT:    # fixup A - offset: 4, value: {{\.LCPI.*}}-4, kind: reloc_riprel_4byte
; X64-AVX512VL-NEXT:    retq # encoding: [0xc3]
entry:
  %0  = insertelement <2 x float> undef, float 1.0, i32 0
  %1  = insertelement <2 x float> %0, float -2.0, i32 1
  %2  = fpext <2 x float> %1 to <2 x double>
  ret <2 x double> %2
}
