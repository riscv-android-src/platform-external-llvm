# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-views                          < %s | FileCheck %s -check-prefix=ALL -check-prefix=FULLREPORT
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-views -resource-pressure       < %s | FileCheck %s -check-prefix=ALL -check-prefix=FULLREPORT
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -resource-pressure -all-views       < %s | FileCheck %s -check-prefix=ALL -check-prefix=FULLREPORT
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -resource-pressure=false -all-views < %s | FileCheck %s -check-prefix=ALL -check-prefix=FULLREPORT
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -all-views -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=NORPV

add %eax, %eax

# ALL:             Iterations:        100
# ALL-NEXT:        Instructions:      100
# ALL-NEXT:        Total Cycles:      103
# ALL-NEXT:        Dispatch Width:    2
# ALL-NEXT:        IPC:               0.97
# ALL-NEXT:        Block RThroughput: 0.5

# ALL:             Instruction Info:
# ALL-NEXT:        [1]: #uOps
# ALL-NEXT:        [2]: Latency
# ALL-NEXT:        [3]: RThroughput
# ALL-NEXT:        [4]: MayLoad
# ALL-NEXT:        [5]: MayStore
# ALL-NEXT:        [6]: HasSideEffects (U)

# ALL:             [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# ALL-NEXT:         1      1     0.50                        addl	%eax, %eax

# ALL:             Dynamic Dispatch Stall Cycles:
# ALL-NEXT:        RAT     - Register unavailable:                      0
# ALL-NEXT:        RCU     - Retire tokens unavailable:                 0
# ALL-NEXT:        SCHEDQ  - Scheduler full:                            61
# ALL-NEXT:        LQ      - Load queue full:                           0
# ALL-NEXT:        SQ      - Store queue full:                          0
# ALL-NEXT:        GROUP   - Static restrictions on the dispatch group: 0

# ALL:             Dispatch Logic - number of cycles where we saw N instructions dispatched:
# ALL-NEXT:        [# dispatched], [# cycles]
# ALL-NEXT:         0,              22  (21.4%)
# ALL-NEXT:         1,              62  (60.2%)
# ALL-NEXT:         2,              19  (18.4%)

# ALL:             Schedulers - number of cycles where we saw N instructions issued:
# ALL-NEXT:        [# issued], [# cycles]
# ALL-NEXT:         0,          3  (2.9%)
# ALL-NEXT:         1,          100  (97.1%)

# ALL:             Scheduler's queue usage:
# ALL-NEXT:        [1] Resource name.
# ALL-NEXT:        [2] Average number of used buffer entries.
# ALL-NEXT:        [3] Maximum number of used buffer entries.
# ALL-NEXT:        [4] Total number of buffer entries.

# ALL:              [1]            [2]        [3]        [4]
# ALL-NEXT:        JALU01           15         20         20
# ALL-NEXT:        JFPU01           0          0          18
# ALL-NEXT:        JLSAGU           0          0          12

# ALL:             Retire Control Unit - number of cycles where we saw N instructions retired:
# ALL-NEXT:        [# retired], [# cycles]
# ALL-NEXT:         0,           3  (2.9%)
# ALL-NEXT:         1,           100  (97.1%)

# ALL:             Register File statistics:
# ALL-NEXT:        Total number of mappings created:    200
# ALL-NEXT:        Max number of mappings used:         44

# ALL:             *  Register File #1 -- JFpuPRF:
# ALL-NEXT:           Number of physical registers:     72
# ALL-NEXT:           Total number of mappings created: 0
# ALL-NEXT:           Max number of mappings used:      0

# ALL:             *  Register File #2 -- JIntegerPRF:
# ALL-NEXT:           Number of physical registers:     64
# ALL-NEXT:           Total number of mappings created: 200
# ALL-NEXT:           Max number of mappings used:      44

# FULLREPORT:      Resources:
# FULLREPORT-NEXT: [0]   - JALU0
# FULLREPORT-NEXT: [1]   - JALU1
# FULLREPORT-NEXT: [2]   - JDiv
# FULLREPORT-NEXT: [3]   - JFPA
# FULLREPORT-NEXT: [4]   - JFPM
# FULLREPORT-NEXT: [5]   - JFPU0
# FULLREPORT-NEXT: [6]   - JFPU1
# FULLREPORT-NEXT: [7]   - JLAGU
# FULLREPORT-NEXT: [8]   - JMul
# FULLREPORT-NEXT: [9]   - JSAGU
# FULLREPORT-NEXT: [10]  - JSTC
# FULLREPORT-NEXT: [11]  - JVALU0
# FULLREPORT-NEXT: [12]  - JVALU1
# FULLREPORT-NEXT: [13]  - JVIMUL

# NORPV:           Timeline view:
# NORPV-NEXT:                          012
# NORPV-NEXT:      Index     0123456789

# FULLREPORT:      Resource pressure per iteration:
# FULLREPORT-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# FULLREPORT-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -

# NORPV:           [0,0]     DeER .    . .   addl	%eax, %eax
# NORPV-NEXT:      [1,0]     D=eER.    . .   addl	%eax, %eax
# NORPV-NEXT:      [2,0]     .D=eER    . .   addl	%eax, %eax
# NORPV-NEXT:      [3,0]     .D==eER   . .   addl	%eax, %eax
# NORPV-NEXT:      [4,0]     . D==eER  . .   addl	%eax, %eax
# NORPV-NEXT:      [5,0]     . D===eER . .   addl	%eax, %eax
# NORPV-NEXT:      [6,0]     .  D===eER. .   addl	%eax, %eax
# NORPV-NEXT:      [7,0]     .  D====eER .   addl	%eax, %eax
# NORPV-NEXT:      [8,0]     .   D====eER.   addl	%eax, %eax
# NORPV-NEXT:      [9,0]     .   D=====eER   addl	%eax, %eax

# NORPV:           Average Wait times (based on the timeline view):
# NORPV-NEXT:      [0]: Executions
# NORPV-NEXT:      [1]: Average time spent waiting in a scheduler's queue
# NORPV-NEXT:      [2]: Average time spent waiting in a scheduler's queue while ready
# NORPV-NEXT:      [3]: Average time elapsed from WB until retire stage

# FULLREPORT:      Resource pressure by instruction:
# FULLREPORT-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# FULLREPORT-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %eax

# NORPV:                 [0]    [1]    [2]    [3]
# NORPV-NEXT:      0.     10    3.5    0.1    0.0       addl	%eax, %eax

# FULLREPORT:      Timeline view:
# FULLREPORT-NEXT:                     012
# FULLREPORT-NEXT: Index     0123456789

# FULLREPORT:      [0,0]     DeER .    . .   addl	%eax, %eax
# FULLREPORT-NEXT: [1,0]     D=eER.    . .   addl	%eax, %eax
# FULLREPORT-NEXT: [2,0]     .D=eER    . .   addl	%eax, %eax
# FULLREPORT-NEXT: [3,0]     .D==eER   . .   addl	%eax, %eax
# FULLREPORT-NEXT: [4,0]     . D==eER  . .   addl	%eax, %eax
# FULLREPORT-NEXT: [5,0]     . D===eER . .   addl	%eax, %eax
# FULLREPORT-NEXT: [6,0]     .  D===eER. .   addl	%eax, %eax
# FULLREPORT-NEXT: [7,0]     .  D====eER .   addl	%eax, %eax
# FULLREPORT-NEXT: [8,0]     .   D====eER.   addl	%eax, %eax
# FULLREPORT-NEXT: [9,0]     .   D=====eER   addl	%eax, %eax

# FULLREPORT:      Average Wait times (based on the timeline view):
# FULLREPORT-NEXT: [0]: Executions
# FULLREPORT-NEXT: [1]: Average time spent waiting in a scheduler's queue
# FULLREPORT-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# FULLREPORT-NEXT: [3]: Average time elapsed from WB until retire stage

# FULLREPORT:            [0]    [1]    [2]    [3]
# FULLREPORT-NEXT: 0.     10    3.5    0.1    0.0       addl	%eax, %eax
