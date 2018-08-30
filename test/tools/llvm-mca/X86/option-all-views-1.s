# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-views       < %s | FileCheck %s -check-prefix=DEFAULTREPORT -check-prefix=FULLREPORT
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-views=true  < %s | FileCheck %s -check-prefix=DEFAULTREPORT -check-prefix=FULLREPORT
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-views=false < %s | FileCheck %s -check-prefix=NOREPORT -allow-empty
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2                  < %s | FileCheck %s -check-prefix=DEFAULTREPORT

add %eax, %eax

# NOREPORT-NOT: {{.}}

# DEFAULTREPORT:      Iterations:        100
# DEFAULTREPORT-NEXT: Instructions:      100
# DEFAULTREPORT-NEXT: Total Cycles:      103
# DEFAULTREPORT-NEXT: Total uOps:        100

# DEFAULTREPORT:      Dispatch Width:    2
# DEFAULTREPORT-NEXT: uOps Per Cycle:    0.97
# DEFAULTREPORT-NEXT: IPC:               0.97
# DEFAULTREPORT-NEXT: Block RThroughput: 0.5

# DEFAULTREPORT:      Instruction Info:
# DEFAULTREPORT-NEXT: [1]: #uOps
# DEFAULTREPORT-NEXT: [2]: Latency
# DEFAULTREPORT-NEXT: [3]: RThroughput
# DEFAULTREPORT-NEXT: [4]: MayLoad
# DEFAULTREPORT-NEXT: [5]: MayStore
# DEFAULTREPORT-NEXT: [6]: HasSideEffects (U)

# DEFAULTREPORT:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# DEFAULTREPORT-NEXT:  1      1     0.50                        addl	%eax, %eax

# FULLREPORT:         Dynamic Dispatch Stall Cycles:
# FULLREPORT-NEXT:    RAT     - Register unavailable:                      0
# FULLREPORT-NEXT:    RCU     - Retire tokens unavailable:                 0
# FULLREPORT-NEXT:    SCHEDQ  - Scheduler full:                            61  (59.2%)
# FULLREPORT-NEXT:    LQ      - Load queue full:                           0
# FULLREPORT-NEXT:    SQ      - Store queue full:                          0
# FULLREPORT-NEXT:    GROUP   - Static restrictions on the dispatch group: 0

# FULLREPORT:         Dispatch Logic - number of cycles where we saw N micro opcodes dispatched:
# FULLREPORT-NEXT:    [# dispatched], [# cycles]
# FULLREPORT-NEXT:     0,              22  (21.4%)
# FULLREPORT-NEXT:     1,              62  (60.2%)
# FULLREPORT-NEXT:     2,              19  (18.4%)

# FULLREPORT:         Schedulers - number of cycles where we saw N instructions issued:
# FULLREPORT-NEXT:    [# issued], [# cycles]
# FULLREPORT-NEXT:     0,          3  (2.9%)
# FULLREPORT-NEXT:     1,          100  (97.1%)

# FULLREPORT:         Scheduler's queue usage:
# FULLREPORT-NEXT:    [1] Resource name.
# FULLREPORT-NEXT:    [2] Average number of used buffer entries.
# FULLREPORT-NEXT:    [3] Maximum number of used buffer entries.
# FULLREPORT-NEXT:    [4] Total number of buffer entries.

# FULLREPORT:          [1]            [2]        [3]        [4]
# FULLREPORT-NEXT:    JALU01           15         20         20
# FULLREPORT-NEXT:    JFPU01           0          0          18
# FULLREPORT-NEXT:    JLSAGU           0          0          12

# FULLREPORT:         Retire Control Unit - number of cycles where we saw N instructions retired:
# FULLREPORT-NEXT:    [# retired], [# cycles]
# FULLREPORT-NEXT:     0,           3  (2.9%)
# FULLREPORT-NEXT:     1,           100  (97.1%)

# FULLREPORT:         Register File statistics:
# FULLREPORT-NEXT:    Total number of mappings created:    200
# FULLREPORT-NEXT:    Max number of mappings used:         44

# FULLREPORT:         *  Register File #1 -- JFpuPRF:
# FULLREPORT-NEXT:       Number of physical registers:     72
# FULLREPORT-NEXT:       Total number of mappings created: 0
# FULLREPORT-NEXT:       Max number of mappings used:      0

# FULLREPORT:         *  Register File #2 -- JIntegerPRF:
# FULLREPORT-NEXT:       Number of physical registers:     64
# FULLREPORT-NEXT:       Total number of mappings created: 200
# FULLREPORT-NEXT:       Max number of mappings used:      44

# FULLREPORT:         Resources:
# FULLREPORT-NEXT:    [0]   - JALU0
# FULLREPORT-NEXT:    [1]   - JALU1
# FULLREPORT-NEXT:    [2]   - JDiv
# FULLREPORT-NEXT:    [3]   - JFPA
# FULLREPORT-NEXT:    [4]   - JFPM
# FULLREPORT-NEXT:    [5]   - JFPU0
# FULLREPORT-NEXT:    [6]   - JFPU1
# FULLREPORT-NEXT:    [7]   - JLAGU
# FULLREPORT-NEXT:    [8]   - JMul
# FULLREPORT-NEXT:    [9]   - JSAGU
# FULLREPORT-NEXT:    [10]  - JSTC
# FULLREPORT-NEXT:    [11]  - JVALU0
# FULLREPORT-NEXT:    [12]  - JVALU1
# FULLREPORT-NEXT:    [13]  - JVIMUL

# FULLREPORT:         Resource pressure per iteration:
# FULLREPORT-NEXT:    [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# FULLREPORT-NEXT:    0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -

# FULLREPORT:         Resource pressure by instruction:
# FULLREPORT-NEXT:    [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# FULLREPORT-NEXT:    0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %eax

# FULLREPORT:         Timeline view:
# FULLREPORT-NEXT:                        012
# FULLREPORT-NEXT:    Index     0123456789

# FULLREPORT:         [0,0]     DeER .    . .   addl	%eax, %eax
# FULLREPORT-NEXT:    [1,0]     D=eER.    . .   addl	%eax, %eax
# FULLREPORT-NEXT:    [2,0]     .D=eER    . .   addl	%eax, %eax
# FULLREPORT-NEXT:    [3,0]     .D==eER   . .   addl	%eax, %eax
# FULLREPORT-NEXT:    [4,0]     . D==eER  . .   addl	%eax, %eax
# FULLREPORT-NEXT:    [5,0]     . D===eER . .   addl	%eax, %eax
# FULLREPORT-NEXT:    [6,0]     .  D===eER. .   addl	%eax, %eax
# FULLREPORT-NEXT:    [7,0]     .  D====eER .   addl	%eax, %eax
# FULLREPORT-NEXT:    [8,0]     .   D====eER.   addl	%eax, %eax
# FULLREPORT-NEXT:    [9,0]     .   D=====eER   addl	%eax, %eax

# FULLREPORT:         Average Wait times (based on the timeline view):
# FULLREPORT-NEXT:    [0]: Executions
# FULLREPORT-NEXT:    [1]: Average time spent waiting in a scheduler's queue
# FULLREPORT-NEXT:    [2]: Average time spent waiting in a scheduler's queue while ready
# FULLREPORT-NEXT:    [3]: Average time elapsed from WB until retire stage

# FULLREPORT:               [0]    [1]    [2]    [3]
# FULLREPORT-NEXT:    0.     10    3.5    0.1    0.0       addl	%eax, %eax
