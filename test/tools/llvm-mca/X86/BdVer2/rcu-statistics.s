# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=bdver2 -resource-pressure=false -retire-stats -iterations=1 < %s | FileCheck %s

  vsqrtps %xmm0, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2
  vaddps  %xmm0, %xmm1, %xmm2

# CHECK:      Iterations:        1
# CHECK-NEXT: Instructions:      16
# CHECK-NEXT: Total Cycles:      22
# CHECK-NEXT: Total uOps:        16

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    0.73
# CHECK-NEXT: IPC:               0.73
# CHECK-NEXT: Block RThroughput: 18.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      9     10.50                       vsqrtps	%xmm0, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2
# CHECK-NEXT:  1      5     1.00                        vaddps	%xmm0, %xmm1, %xmm2

# CHECK:      Retire Control Unit - number of cycles where we saw N instructions retired:
# CHECK-NEXT: [# retired], [# cycles]
# CHECK-NEXT:  0,           11  (50.0%)
# CHECK-NEXT:  1,           9  (40.9%)
# CHECK-NEXT:  3,           1  (4.5%)
# CHECK-NEXT:  4,           1  (4.5%)

# CHECK:      Total ROB Entries:                128
# CHECK-NEXT: Max Used ROB Entries:             16  ( 12.5% )
# CHECK-NEXT: Average Used ROB Entries per cy:  9  ( 7.0% )
