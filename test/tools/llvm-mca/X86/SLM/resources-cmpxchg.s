# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=slm -instruction-tables < %s | FileCheck %s

cmpxchg8b  (%rax)
cmpxchg16b (%rax)

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      4     2.00    *      *            cmpxchg8b	(%rax)
# CHECK-NEXT:  2      4     2.00    *      *            cmpxchg16b	(%rax)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SLMDivider
# CHECK-NEXT: [1]   - SLMFPDivider
# CHECK-NEXT: [2]   - SLMFPMultiplier
# CHECK-NEXT: [3]   - SLM_FPC_RSV0
# CHECK-NEXT: [4]   - SLM_FPC_RSV1
# CHECK-NEXT: [5]   - SLM_IEC_RSV0
# CHECK-NEXT: [6]   - SLM_IEC_RSV1
# CHECK-NEXT: [7]   - SLM_MEC_RSV

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]
# CHECK-NEXT:  -      -      -      -      -     1.00   1.00   4.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    Instructions:
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   2.00   cmpxchg8b	(%rax)
# CHECK-NEXT:  -      -      -      -      -     0.50   0.50   2.00   cmpxchg16b	(%rax)
