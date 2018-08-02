; RUN: llc < %s -asm-verbose=false -disable-wasm-explicit-locals -enable-emscripten-cxx-exceptions -wasm-temporary-workarounds=false | FileCheck %s

; Test that function pointer casts are replaced with wrappers.

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

declare void @has_i32_arg(i32)
declare i32 @has_i32_ret()
declare void @vararg(...)
declare void @plain(i32)

declare void @foo0()
declare void @foo1()
declare void @foo2()
declare void @foo3()

; CHECK-LABEL: test:
; CHECK-NEXT: call        .Lhas_i32_arg_bitcast@FUNCTION{{$}}
; CHECK-NEXT: call        .Lhas_i32_arg_bitcast@FUNCTION{{$}}
; CHECK-NEXT: call        .Lhas_i32_ret_bitcast@FUNCTION{{$}}
; CHECK-NEXT: i32.const   $push[[L0:[0-9]+]]=, 0
; CHECK-NEXT: call        .Lfoo0_bitcast@FUNCTION, $pop[[L0]]{{$}}
; CHECK-NEXT: i32.const   $push[[L1:[0-9]+]]=, 0
; CHECK-NEXT: call        .Lfoo0_bitcast@FUNCTION, $pop[[L1]]{{$}}
; CHECK-NEXT: i32.const   $push[[L2:[0-9]+]]=, 0
; CHECK-NEXT: call        .Lfoo0_bitcast@FUNCTION, $pop[[L2]]{{$}}
; CHECK-NEXT: call        foo0@FUNCTION
; CHECK-NEXT: i32.call    $drop=, .Lfoo1_bitcast@FUNCTION{{$}}
; CHECK-NEXT: call        foo2@FUNCTION{{$}}
; CHECK-NEXT: call        foo1@FUNCTION{{$}}
; CHECK-NEXT: call        foo3@FUNCTION{{$}}
; CHECK-NEXT: end_function
define void @test() {
entry:
  call void bitcast (void (i32)* @has_i32_arg to void ()*)()
  call void bitcast (void (i32)* @has_i32_arg to void ()*)()
  call void bitcast (i32 ()* @has_i32_ret to void ()*)()
  call void bitcast (void ()* @foo0 to void (i32)*)(i32 0)
  %p = bitcast void ()* @foo0 to void (i32)*
  call void %p(i32 0)
  %q = bitcast void ()* @foo0 to void (i32)*
  call void %q(i32 0)
  %r = bitcast void (i32)* %q to void ()*
  call void %r()
  %t = call i32 bitcast (void ()* @foo1 to i32 ()*)()
  call void bitcast (void ()* @foo2 to void ()*)()
  call void @foo1()
  call void @foo3()

  ret void
}

; CHECK-LABEL: test_varargs:
; CHECK:      set_global
; CHECK:      i32.const   $push[[L3:[0-9]+]]=, 0{{$}}
; CHECK-NEXT: call        .Lvararg_bitcast@FUNCTION, $pop[[L3]]{{$}}
; CHECK-NEXT: i32.const   $push[[L4:[0-9]+]]=, 0{{$}}
; CHECK-NEXT: i32.store   0($[[L5:[0-9]+]]), $pop[[L4]]{{$}}
; CHECK-NEXT: call        .Lplain_bitcast@FUNCTION, $[[L5]]{{$}}
define void @test_varargs() {
  call void bitcast (void (...)* @vararg to void (i32)*)(i32 0)
  call void (...) bitcast (void (i32)* @plain to void (...)*)(i32 0)
  ret void
}

; Don't use wrappers when the value is stored in memory

@global_func = hidden local_unnamed_addr global void ()* null

; CHECK-LABEL: test_store:
; CHECK-NEXT: i32.const   $push[[L0:[0-9]+]]=, 0{{$}}
; CHECK-NEXT: i32.const   $push[[L1:[0-9]+]]=, has_i32_ret@FUNCTION{{$}}
; CHECK-NEXT: i32.store   global_func($pop[[L0]]), $pop[[L1]]{{$}}
define void @test_store() {
  %1 = bitcast i32 ()* @has_i32_ret to void ()*
  store void ()* %1, void ()** @global_func
  ret void
}

; CHECK-LABEL: test_load:
; CHECK-NEXT: result      i32{{$}}
; CHECK-NEXT: i32.const   $push[[L0:[0-9]+]]=, 0{{$}}
; CHECK-NEXT: i32.load    $push[[L1:[0-9]+]]=, global_func($pop[[L0]]){{$}}
; CHECK-NEXT: i32.call_indirect $push{{[0-9]+}}=, $pop[[L1]]{{$}}
define i32 @test_load() {
  %1 = load i32 ()*, i32 ()** bitcast (void ()** @global_func to i32 ()**)
  %2 = call i32 %1()
  ret i32 %2
}

; Don't use wrappers when the value is passed to a function call

declare void @call_func(i32 ()*)

; CHECK-LABEL: test_argument:
; CHECK-NEXT: i32.const   $push[[L0:[0-9]+]]=, has_i32_ret@FUNCTION{{$}}
; CHECK-NEXT: call        call_func@FUNCTION, $pop[[L0]]{{$}}
; CHECK-NEXT: i32.const   $push[[L1:[0-9]+]]=, has_i32_arg@FUNCTION{{$}}
; CHECK-NEXT: call        call_func@FUNCTION, $pop[[L1]]{{$}}
define void @test_argument() {
  call void @call_func(i32 ()* @has_i32_ret)
  call void @call_func(i32 ()* bitcast (void (i32)* @has_i32_arg to i32 ()*))
  ret void
}

; Invokes should be treated like calls

; CHECK-LABEL: test_invoke:
; CHECK:      i32.const   $push[[L1:[0-9]+]]=, call_func@FUNCTION{{$}}
; CHECK-NEXT: i32.const   $push[[L0:[0-9]+]]=, has_i32_ret@FUNCTION{{$}}
; CHECK-NEXT: call        "__invoke_void_i32()*"@FUNCTION, $pop[[L1]], $pop[[L0]]{{$}}
; CHECK:      i32.const   $push[[L3:[0-9]+]]=, call_func@FUNCTION{{$}}
; CHECK-NEXT: i32.const   $push[[L2:[0-9]+]]=, has_i32_arg@FUNCTION{{$}}
; CHECK-NEXT: call        "__invoke_void_i32()*"@FUNCTION, $pop[[L3]], $pop[[L2]]{{$}}
; CHECK:      i32.const   $push[[L4:[0-9]+]]=, .Lhas_i32_arg_bitcast@FUNCTION{{$}}
; CHECK-NEXT: call        __invoke_void@FUNCTION, $pop[[L4]]{{$}}
declare i32 @personality(...)
define void @test_invoke() personality i32 (...)* @personality {
entry:
  invoke void @call_func(i32 ()* @has_i32_ret)
          to label %cont unwind label %lpad

cont:
  invoke void @call_func(i32 ()* bitcast (void (i32)* @has_i32_arg to i32 ()*))
          to label %cont2 unwind label %lpad

cont2:
  invoke void bitcast (void (i32)* @has_i32_arg to void ()*)()
          to label %end unwind label %lpad

lpad:
  %0 = landingpad { i8*, i32 }
          catch i8* null
  br label %end

end:
  ret void
}

; CHECK-LABEL: .Lhas_i32_arg_bitcast:
; CHECK-NEXT: call        has_i32_arg@FUNCTION, $0{{$}}
; CHECK-NEXT: end_function

; CHECK-LABEL: .Lhas_i32_ret_bitcast:
; CHECK-NEXT: call        $drop=, has_i32_ret@FUNCTION{{$}}
; CHECK-NEXT: end_function

; CHECK-LABEL: .Lvararg_bitcast:
; CHECK: call        vararg@FUNCTION, $1{{$}}
; CHECK: end_function

; CHECK-LABEL: .Lplain_bitcast:
; CHECK: call        plain@FUNCTION, $1{{$}}
; CHECK: end_function

; CHECK-LABEL: .Lfoo0_bitcast:
; CHECK-NEXT: .param      i32
; CHECK-NEXT: call        foo0@FUNCTION{{$}}
; CHECK-NEXT: end_function

; CHECK-LABEL: .Lfoo1_bitcast:
; CHECK-NEXT: .result     i32
; CHECK-NEXT: call        foo1@FUNCTION{{$}}
; CHECK-NEXT: copy_local  $push0=, $0
; CHECK-NEXT: end_function
