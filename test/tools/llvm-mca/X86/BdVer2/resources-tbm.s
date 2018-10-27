# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -instruction-tables < %s | FileCheck %s

bextr        $8192, %ebx, %ecx
bextr        $8192, (%rbx), %ecx

bextr        $16384, %rbx, %rcx
bextr        $16384, (%rbx), %rcx

blcfill      %eax, %ecx
blcfill      (%rax), %ecx

blcfill      %rax, %rcx
blcfill      (%rax), %rcx

blci         %eax, %ecx
blci         (%rax), %ecx

blci         %rax, %rcx
blci         (%rax), %rcx

blcic        %eax, %ecx
blcic        (%rax), %ecx

blcic        %rax, %rcx
blcic        (%rax), %rcx

blcmsk       %eax, %ecx
blcmsk       (%rax), %ecx

blcmsk       %rax, %rcx
blcmsk       (%rax), %rcx

blcs         %eax, %ecx
blcs         (%rax), %ecx

blcs         %rax, %rcx
blcs         (%rax), %rcx

blsfill      %eax, %ecx
blsfill      (%rax), %ecx

blsfill      %rax, %rcx
blsfill      (%rax), %rcx

blsic        %eax, %ecx
blsic        (%rax), %ecx

blsic        %rax, %rcx
blsic        (%rax), %rcx

t1mskc       %eax, %ecx
t1mskc       (%rax), %ecx

t1mskc       %rax, %rcx
t1mskc       (%rax), %rcx

tzmsk        %eax, %ecx
tzmsk        (%rax), %ecx

tzmsk        %rax, %rcx
tzmsk        (%rax), %rcx

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      2     1.00                        bextrl	$8192, %ebx, %ecx
# CHECK-NEXT:  3      7     1.00    *                   bextrl	$8192, (%rbx), %ecx
# CHECK-NEXT:  2      2     1.00                        bextrq	$16384, %rbx, %rcx
# CHECK-NEXT:  3      7     1.00    *                   bextrq	$16384, (%rbx), %rcx
# CHECK-NEXT:  1      1     0.33                        blcfilll	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   blcfilll	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        blcfillq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   blcfillq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.33                        blcil	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   blcil	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        blciq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   blciq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.33                        blcicl	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   blcicl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        blcicq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   blcicq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.33                        blcmskl	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   blcmskl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        blcmskq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   blcmskq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.33                        blcsl	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   blcsl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        blcsq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   blcsq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.33                        blsfilll	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   blsfilll	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        blsfillq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   blsfillq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.33                        blsicl	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   blsicl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        blsicq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   blsicq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.33                        t1mskcl	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   t1mskcl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        t1mskcq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   t1mskcq	(%rax), %rcx
# CHECK-NEXT:  1      1     0.33                        tzmskl	%eax, %ecx
# CHECK-NEXT:  2      6     0.50    *                   tzmskl	(%rax), %ecx
# CHECK-NEXT:  1      1     0.33                        tzmskq	%rax, %rcx
# CHECK-NEXT:  2      6     0.50    *                   tzmskq	(%rax), %rcx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SBDivider
# CHECK-NEXT: [1]   - SBFPDivider
# CHECK-NEXT: [2]   - SBPort0
# CHECK-NEXT: [3]   - SBPort1
# CHECK-NEXT: [4]   - SBPort4
# CHECK-NEXT: [5]   - SBPort5
# CHECK-NEXT: [6.0] - SBPort23
# CHECK-NEXT: [6.1] - SBPort23

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]
# CHECK-NEXT:  -      -     14.00  16.00   -     14.00  10.00  10.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -     0.50   1.00    -     0.50    -      -     bextrl	$8192, %ebx, %ecx
# CHECK-NEXT:  -      -     0.50   1.00    -     0.50   0.50   0.50   bextrl	$8192, (%rbx), %ecx
# CHECK-NEXT:  -      -     0.50   1.00    -     0.50    -      -     bextrq	$16384, %rbx, %rcx
# CHECK-NEXT:  -      -     0.50   1.00    -     0.50   0.50   0.50   bextrq	$16384, (%rbx), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcfilll	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcfilll	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcfillq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcfillq	(%rax), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcil	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcil	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blciq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blciq	(%rax), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcicl	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcicl	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcicq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcicq	(%rax), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcmskl	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcmskl	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcmskq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcmskq	(%rax), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcsl	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcsl	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blcsq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blcsq	(%rax), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blsfilll	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blsfilll	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blsfillq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blsfillq	(%rax), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blsicl	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blsicl	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     blsicq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   blsicq	(%rax), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     t1mskcl	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   t1mskcl	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     t1mskcq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   t1mskcq	(%rax), %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     tzmskl	%eax, %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   tzmskl	(%rax), %ecx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33    -      -     tzmskq	%rax, %rcx
# CHECK-NEXT:  -      -     0.33   0.33    -     0.33   0.50   0.50   tzmskq	(%rax), %rcx
