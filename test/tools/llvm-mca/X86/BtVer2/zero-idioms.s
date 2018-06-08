# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -timeline -register-file-stats -iterations=1 < %s | FileCheck %s

subl  %eax, %eax
subq  %rax, %rax
xorl  %eax, %eax
xorq  %rax, %rax

pcmpgtb   %mm2, %mm2
pcmpgtd   %mm2, %mm2
pcmpgtw   %mm2, %mm2
pcmpgtb   %xmm2, %xmm2
pcmpgtd   %xmm2, %xmm2
pcmpgtq   %xmm2, %xmm2
pcmpgtw   %xmm2, %xmm2
vpcmpgtb  %xmm3, %xmm3, %xmm3
vpcmpgtd  %xmm3, %xmm3, %xmm3
vpcmpgtq  %xmm3, %xmm3, %xmm3
vpcmpgtw  %xmm3, %xmm3, %xmm3

vpcmpgtb  %xmm3, %xmm3, %xmm5
vpcmpgtd  %xmm3, %xmm3, %xmm5
vpcmpgtq  %xmm3, %xmm3, %xmm5
vpcmpgtw  %xmm3, %xmm3, %xmm5

psubb   %mm2, %mm2
psubd   %mm2, %mm2
psubq   %mm2, %mm2
psubw   %mm2, %mm2
psubb   %xmm2, %xmm2
psubd   %xmm2, %xmm2
psubq   %xmm2, %xmm2
psubw   %xmm2, %xmm2
vpsubb  %xmm3, %xmm3, %xmm3
vpsubd  %xmm3, %xmm3, %xmm3
vpsubq  %xmm3, %xmm3, %xmm3
vpsubw  %xmm3, %xmm3, %xmm3

vpsubb  %xmm3, %xmm3, %xmm5
vpsubd  %xmm3, %xmm3, %xmm5
vpsubq  %xmm3, %xmm3, %xmm5
vpsubw  %xmm3, %xmm3, %xmm5

andnps  %xmm0, %xmm0
andnpd  %xmm1, %xmm1
vandnps %xmm2, %xmm2, %xmm2
vandnpd %xmm1, %xmm1, %xmm1
pandn   %mm2, %mm2
pandn   %xmm2, %xmm2
vpandn  %xmm3, %xmm3, %xmm3

vandnps %xmm2, %xmm2, %xmm5
vandnpd %xmm1, %xmm1, %xmm5
vpandn  %xmm3, %xmm3, %xmm5

xorps  %xmm0, %xmm0
xorpd  %xmm1, %xmm1
vxorps %xmm2, %xmm2, %xmm2
vxorpd %xmm1, %xmm1, %xmm1
pxor   %mm2, %mm2
pxor   %xmm2, %xmm2
vpxor  %xmm3, %xmm3, %xmm3

vxorps %xmm4, %xmm4, %xmm5
vxorpd %xmm1, %xmm1, %xmm3
vpxor  %xmm3, %xmm3, %xmm5

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      55
# CHECK-NEXT: Total Cycles:      32
# CHECK-NEXT: Dispatch Width:    2
# CHECK-NEXT: IPC:               1.72
# CHECK-NEXT: Block RThroughput: 27.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.50                        subl	%eax, %eax
# CHECK-NEXT:  1      1     0.50                        subq	%rax, %rax
# CHECK-NEXT:  1      1     0.50                        xorl	%eax, %eax
# CHECK-NEXT:  1      1     0.50                        xorq	%rax, %rax
# CHECK-NEXT:  1      0     0.50                        pcmpgtb	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        pcmpgtd	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        pcmpgtw	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        vpcmpgtb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpcmpgtd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpcmpgtq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpcmpgtw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpcmpgtb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        vpcmpgtd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        vpcmpgtq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        vpcmpgtw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        psubb	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        psubd	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        psubq	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        psubw	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        psubb	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        psubd	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        psubq	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        psubw	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        vpsubb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpsubd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpsubq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpsubw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpsubb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        vpsubd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        vpsubq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        vpsubw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        andnps	%xmm0, %xmm0
# CHECK-NEXT:  1      0     0.50                        andnpd	%xmm1, %xmm1
# CHECK-NEXT:  1      0     0.50                        vandnps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        vandnpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT:  1      0     0.50                        pandn	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        pandn	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vandnps	%xmm2, %xmm2, %xmm5
# CHECK-NEXT:  1      0     0.50                        vandnpd	%xmm1, %xmm1, %xmm5
# CHECK-NEXT:  1      0     0.50                        vpandn	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  1      0     0.50                        xorps	%xmm0, %xmm0
# CHECK-NEXT:  1      0     0.50                        xorpd	%xmm1, %xmm1
# CHECK-NEXT:  1      0     0.50                        vxorps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        vxorpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT:  1      0     0.50                        pxor	%mm2, %mm2
# CHECK-NEXT:  1      0     0.50                        pxor	%xmm2, %xmm2
# CHECK-NEXT:  1      0     0.50                        vpxor	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  1      0     0.50                        vxorps	%xmm4, %xmm4, %xmm5
# CHECK-NEXT:  1      0     0.50                        vxorpd	%xmm1, %xmm1, %xmm3
# CHECK-NEXT:  1      0     0.50                        vpxor	%xmm3, %xmm3, %xmm5

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    8
# CHECK-NEXT: Max number of mappings used:         8

# CHECK:      *  Register File #1 -- JFpuPRF:
# CHECK-NEXT:    Number of physical registers:     72
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      *  Register File #2 -- JIntegerPRF:
# CHECK-NEXT:    Number of physical registers:     64
# CHECK-NEXT:    Total number of mappings created: 8
# CHECK-NEXT:    Max number of mappings used:      8

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 2.00   2.00    -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -      -      -      -      -      -      -     subl	%eax, %eax
# CHECK-NEXT: 1.00    -      -      -      -      -      -      -      -      -      -      -      -      -     subq	%rax, %rax
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -      -      -      -      -      -      -     xorl	%eax, %eax
# CHECK-NEXT: 1.00    -      -      -      -      -      -      -      -      -      -      -      -      -     xorq	%rax, %rax
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpgtb	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpgtd	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpgtw	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpcmpgtb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpcmpgtd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpcmpgtq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpcmpgtw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpcmpgtb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpcmpgtd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpcmpgtq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpcmpgtw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     psubb	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     psubd	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     psubq	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     psubw	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     psubb	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     psubd	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     psubq	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     psubw	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpsubb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpsubd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpsubq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpsubw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpsubb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpsubd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpsubq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpsubw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     andnps	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     andnpd	%xmm1, %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vandnps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vandnpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pandn	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pandn	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vandnps	%xmm2, %xmm2, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vandnpd	%xmm1, %xmm1, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpandn	%xmm3, %xmm3, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     xorps	%xmm0, %xmm0
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     xorpd	%xmm1, %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vxorps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vxorpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pxor	%mm2, %mm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     pxor	%xmm2, %xmm2
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpxor	%xmm3, %xmm3, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vxorps	%xmm4, %xmm4, %xmm5
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vxorpd	%xmm1, %xmm1, %xmm3
# CHECK-NEXT:  -      -      -      -      -      -      -      -      -      -      -      -      -      -     vpxor	%xmm3, %xmm3, %xmm5

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          01
# CHECK-NEXT: Index     0123456789          0123456789

# CHECK:      [0,0]     DeER .    .    .    .    .    ..   subl	%eax, %eax
# CHECK-NEXT: [0,1]     D=eER.    .    .    .    .    ..   subq	%rax, %rax
# CHECK-NEXT: [0,2]     .D=eER    .    .    .    .    ..   xorl	%eax, %eax
# CHECK-NEXT: [0,3]     .D==eER   .    .    .    .    ..   xorq	%rax, %rax
# CHECK-NEXT: [0,4]     . D---R   .    .    .    .    ..   pcmpgtb	%mm2, %mm2
# CHECK-NEXT: [0,5]     . D----R  .    .    .    .    ..   pcmpgtd	%mm2, %mm2
# CHECK-NEXT: [0,6]     .  D---R  .    .    .    .    ..   pcmpgtw	%mm2, %mm2
# CHECK-NEXT: [0,7]     .  D----R .    .    .    .    ..   pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT: [0,8]     .   D---R .    .    .    .    ..   pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: [0,9]     .   D----R.    .    .    .    ..   pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT: [0,10]    .    D---R.    .    .    .    ..   pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: [0,11]    .    D----R    .    .    .    ..   vpcmpgtb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,12]    .    .D---R    .    .    .    ..   vpcmpgtd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,13]    .    .D----R   .    .    .    ..   vpcmpgtq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,14]    .    . D---R   .    .    .    ..   vpcmpgtw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,15]    .    . D----R  .    .    .    ..   vpcmpgtb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,16]    .    .  D---R  .    .    .    ..   vpcmpgtd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,17]    .    .  D----R .    .    .    ..   vpcmpgtq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,18]    .    .   D---R .    .    .    ..   vpcmpgtw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,19]    .    .   D----R.    .    .    ..   psubb	%mm2, %mm2
# CHECK-NEXT: [0,20]    .    .    D---R.    .    .    ..   psubd	%mm2, %mm2
# CHECK-NEXT: [0,21]    .    .    D----R    .    .    ..   psubq	%mm2, %mm2
# CHECK-NEXT: [0,22]    .    .    .D---R    .    .    ..   psubw	%mm2, %mm2
# CHECK-NEXT: [0,23]    .    .    .D----R   .    .    ..   psubb	%xmm2, %xmm2
# CHECK-NEXT: [0,24]    .    .    . D---R   .    .    ..   psubd	%xmm2, %xmm2
# CHECK-NEXT: [0,25]    .    .    . D----R  .    .    ..   psubq	%xmm2, %xmm2
# CHECK-NEXT: [0,26]    .    .    .  D---R  .    .    ..   psubw	%xmm2, %xmm2
# CHECK-NEXT: [0,27]    .    .    .  D----R .    .    ..   vpsubb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,28]    .    .    .   D---R .    .    ..   vpsubd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,29]    .    .    .   D----R.    .    ..   vpsubq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,30]    .    .    .    D---R.    .    ..   vpsubw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,31]    .    .    .    D----R    .    ..   vpsubb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,32]    .    .    .    .D---R    .    ..   vpsubd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,33]    .    .    .    .D----R   .    ..   vpsubq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,34]    .    .    .    . D---R   .    ..   vpsubw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,35]    .    .    .    . D----R  .    ..   andnps	%xmm0, %xmm0
# CHECK-NEXT: [0,36]    .    .    .    .  D---R  .    ..   andnpd	%xmm1, %xmm1
# CHECK-NEXT: [0,37]    .    .    .    .  D----R .    ..   vandnps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT: [0,38]    .    .    .    .   D---R .    ..   vandnpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT: [0,39]    .    .    .    .   D----R.    ..   pandn	%mm2, %mm2
# CHECK-NEXT: [0,40]    .    .    .    .    D---R.    ..   pandn	%xmm2, %xmm2
# CHECK-NEXT: [0,41]    .    .    .    .    D----R    ..   vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,42]    .    .    .    .    .D---R    ..   vandnps	%xmm2, %xmm2, %xmm5
# CHECK-NEXT: [0,43]    .    .    .    .    .D----R   ..   vandnpd	%xmm1, %xmm1, %xmm5
# CHECK-NEXT: [0,44]    .    .    .    .    . D---R   ..   vpandn	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: [0,45]    .    .    .    .    . D----R  ..   xorps	%xmm0, %xmm0
# CHECK-NEXT: [0,46]    .    .    .    .    .  D---R  ..   xorpd	%xmm1, %xmm1
# CHECK-NEXT: [0,47]    .    .    .    .    .  D----R ..   vxorps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT: [0,48]    .    .    .    .    .   D---R ..   vxorpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT: [0,49]    .    .    .    .    .   D----R..   pxor	%mm2, %mm2
# CHECK-NEXT: [0,50]    .    .    .    .    .    D---R..   pxor	%xmm2, %xmm2
# CHECK-NEXT: [0,51]    .    .    .    .    .    D----R.   vpxor	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: [0,52]    .    .    .    .    .    .D---R.   vxorps	%xmm4, %xmm4, %xmm5
# CHECK-NEXT: [0,53]    .    .    .    .    .    .D----R   vxorpd	%xmm1, %xmm1, %xmm3
# CHECK-NEXT: [0,54]    .    .    .    .    .    . D---R   vpxor	%xmm3, %xmm3, %xmm5

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       subl	%eax, %eax
# CHECK-NEXT: 1.     1     2.0    0.0    0.0       subq	%rax, %rax
# CHECK-NEXT: 2.     1     2.0    0.0    0.0       xorl	%eax, %eax
# CHECK-NEXT: 3.     1     3.0    0.0    0.0       xorq	%rax, %rax
# CHECK-NEXT: 4.     1     0.0    0.0    3.0       pcmpgtb	%mm2, %mm2
# CHECK-NEXT: 5.     1     0.0    0.0    4.0       pcmpgtd	%mm2, %mm2
# CHECK-NEXT: 6.     1     0.0    0.0    3.0       pcmpgtw	%mm2, %mm2
# CHECK-NEXT: 7.     1     0.0    0.0    4.0       pcmpgtb	%xmm2, %xmm2
# CHECK-NEXT: 8.     1     0.0    0.0    3.0       pcmpgtd	%xmm2, %xmm2
# CHECK-NEXT: 9.     1     0.0    0.0    4.0       pcmpgtq	%xmm2, %xmm2
# CHECK-NEXT: 10.    1     0.0    0.0    3.0       pcmpgtw	%xmm2, %xmm2
# CHECK-NEXT: 11.    1     0.0    0.0    4.0       vpcmpgtb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 12.    1     0.0    0.0    3.0       vpcmpgtd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 13.    1     0.0    0.0    4.0       vpcmpgtq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 14.    1     0.0    0.0    3.0       vpcmpgtw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 15.    1     0.0    0.0    4.0       vpcmpgtb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 16.    1     0.0    0.0    3.0       vpcmpgtd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 17.    1     0.0    0.0    4.0       vpcmpgtq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 18.    1     0.0    0.0    3.0       vpcmpgtw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 19.    1     0.0    0.0    4.0       psubb	%mm2, %mm2
# CHECK-NEXT: 20.    1     0.0    0.0    3.0       psubd	%mm2, %mm2
# CHECK-NEXT: 21.    1     0.0    0.0    4.0       psubq	%mm2, %mm2
# CHECK-NEXT: 22.    1     0.0    0.0    3.0       psubw	%mm2, %mm2
# CHECK-NEXT: 23.    1     0.0    0.0    4.0       psubb	%xmm2, %xmm2
# CHECK-NEXT: 24.    1     0.0    0.0    3.0       psubd	%xmm2, %xmm2
# CHECK-NEXT: 25.    1     0.0    0.0    4.0       psubq	%xmm2, %xmm2
# CHECK-NEXT: 26.    1     0.0    0.0    3.0       psubw	%xmm2, %xmm2
# CHECK-NEXT: 27.    1     0.0    0.0    4.0       vpsubb	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 28.    1     0.0    0.0    3.0       vpsubd	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 29.    1     0.0    0.0    4.0       vpsubq	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 30.    1     0.0    0.0    3.0       vpsubw	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 31.    1     0.0    0.0    4.0       vpsubb	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 32.    1     0.0    0.0    3.0       vpsubd	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 33.    1     0.0    0.0    4.0       vpsubq	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 34.    1     0.0    0.0    3.0       vpsubw	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 35.    1     0.0    0.0    4.0       andnps	%xmm0, %xmm0
# CHECK-NEXT: 36.    1     0.0    0.0    3.0       andnpd	%xmm1, %xmm1
# CHECK-NEXT: 37.    1     0.0    0.0    4.0       vandnps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT: 38.    1     0.0    0.0    3.0       vandnpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT: 39.    1     0.0    0.0    4.0       pandn	%mm2, %mm2
# CHECK-NEXT: 40.    1     0.0    0.0    3.0       pandn	%xmm2, %xmm2
# CHECK-NEXT: 41.    1     0.0    0.0    4.0       vpandn	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 42.    1     0.0    0.0    3.0       vandnps	%xmm2, %xmm2, %xmm5
# CHECK-NEXT: 43.    1     0.0    0.0    4.0       vandnpd	%xmm1, %xmm1, %xmm5
# CHECK-NEXT: 44.    1     0.0    0.0    3.0       vpandn	%xmm3, %xmm3, %xmm5
# CHECK-NEXT: 45.    1     0.0    0.0    4.0       xorps	%xmm0, %xmm0
# CHECK-NEXT: 46.    1     0.0    0.0    3.0       xorpd	%xmm1, %xmm1
# CHECK-NEXT: 47.    1     0.0    0.0    4.0       vxorps	%xmm2, %xmm2, %xmm2
# CHECK-NEXT: 48.    1     0.0    0.0    3.0       vxorpd	%xmm1, %xmm1, %xmm1
# CHECK-NEXT: 49.    1     0.0    0.0    4.0       pxor	%mm2, %mm2
# CHECK-NEXT: 50.    1     0.0    0.0    3.0       pxor	%xmm2, %xmm2
# CHECK-NEXT: 51.    1     0.0    0.0    4.0       vpxor	%xmm3, %xmm3, %xmm3
# CHECK-NEXT: 52.    1     0.0    0.0    3.0       vxorps	%xmm4, %xmm4, %xmm5
# CHECK-NEXT: 53.    1     0.0    0.0    4.0       vxorpd	%xmm1, %xmm1, %xmm3
# CHECK-NEXT: 54.    1     0.0    0.0    3.0       vpxor	%xmm3, %xmm3, %xmm5
