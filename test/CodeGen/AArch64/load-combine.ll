; RUN: llc < %s -mtriple=arm64-unknown | FileCheck %s

; i8* p; // p is 1 byte aligned
; (i32) p[0] | ((i32) p[1] << 8) | ((i32) p[2] << 16) | ((i32) p[3] << 24)
define i32 @load_i32_by_i8_unaligned(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_unaligned:
; CHECK: ldr		w0, [x0]
; CHECK-NEXT: ret
  %tmp = bitcast i32* %arg to i8*
  %tmp1 = getelementptr inbounds i8, i8* %tmp, i32 0
  %tmp2 = load i8, i8* %tmp, align 1
  %tmp3 = zext i8 %tmp2 to i32
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 8
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 16
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = shl nuw nsw i32 %tmp16, 24
  %tmp18 = or i32 %tmp13, %tmp17
  ret i32 %tmp18
}

; i8* p; // p is 4 byte aligned
; (i32) p[0] | ((i32) p[1] << 8) | ((i32) p[2] << 16) | ((i32) p[3] << 24)
define i32 @load_i32_by_i8_aligned(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_aligned:
; CHECK: ldr    w0, [x0]
; CHECK-NEXT: ret
  %tmp = bitcast i32* %arg to i8*
  %tmp1 = getelementptr inbounds i8, i8* %tmp, i32 0
  %tmp2 = load i8, i8* %tmp, align 4
  %tmp3 = zext i8 %tmp2 to i32
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 8
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 16
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = shl nuw nsw i32 %tmp16, 24
  %tmp18 = or i32 %tmp13, %tmp17
  ret i32 %tmp18
}

; i8* p; // p is 4 byte aligned
; ((i32) p[0] << 24) | ((i32) p[1] << 16) | ((i32) p[2] << 8) | (i32) p[3]
define i32 @load_i32_by_i8_bswap(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_bswap:
; CHECK: ldr		w8, [x0]
; CHECK-NEXT: rev	w0, w8
; CHECK-NEXT: ret
  %tmp = bitcast i32* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 4
  %tmp2 = zext i8 %tmp1 to i32
  %tmp3 = shl nuw nsw i32 %tmp2, 24
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 16
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 8
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = or i32 %tmp13, %tmp16
  ret i32 %tmp17
}

; i8* p; // p is 8 byte aligned
; (i64) p[0] | ((i64) p[1] << 8) | ((i64) p[2] << 16) | ((i64) p[3] << 24) | ((i64) p[4] << 32) | ((i64) p[5] << 40) | ((i64) p[6] << 48) | ((i64) p[7] << 56)
define i64 @load_i64_by_i8(i64* %arg) {
; CHECK-LABEL: load_i64_by_i8:
; CHECK: ldr		x0, [x0]
; CHECK-NEXT: ret
  %tmp = bitcast i64* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 8
  %tmp2 = zext i8 %tmp1 to i64
  %tmp3 = getelementptr inbounds i8, i8* %tmp, i64 1
  %tmp4 = load i8, i8* %tmp3, align 1
  %tmp5 = zext i8 %tmp4 to i64
  %tmp6 = shl nuw nsw i64 %tmp5, 8
  %tmp7 = or i64 %tmp6, %tmp2
  %tmp8 = getelementptr inbounds i8, i8* %tmp, i64 2
  %tmp9 = load i8, i8* %tmp8, align 1
  %tmp10 = zext i8 %tmp9 to i64
  %tmp11 = shl nuw nsw i64 %tmp10, 16
  %tmp12 = or i64 %tmp7, %tmp11
  %tmp13 = getelementptr inbounds i8, i8* %tmp, i64 3
  %tmp14 = load i8, i8* %tmp13, align 1
  %tmp15 = zext i8 %tmp14 to i64
  %tmp16 = shl nuw nsw i64 %tmp15, 24
  %tmp17 = or i64 %tmp12, %tmp16
  %tmp18 = getelementptr inbounds i8, i8* %tmp, i64 4
  %tmp19 = load i8, i8* %tmp18, align 1
  %tmp20 = zext i8 %tmp19 to i64
  %tmp21 = shl nuw nsw i64 %tmp20, 32
  %tmp22 = or i64 %tmp17, %tmp21
  %tmp23 = getelementptr inbounds i8, i8* %tmp, i64 5
  %tmp24 = load i8, i8* %tmp23, align 1
  %tmp25 = zext i8 %tmp24 to i64
  %tmp26 = shl nuw nsw i64 %tmp25, 40
  %tmp27 = or i64 %tmp22, %tmp26
  %tmp28 = getelementptr inbounds i8, i8* %tmp, i64 6
  %tmp29 = load i8, i8* %tmp28, align 1
  %tmp30 = zext i8 %tmp29 to i64
  %tmp31 = shl nuw nsw i64 %tmp30, 48
  %tmp32 = or i64 %tmp27, %tmp31
  %tmp33 = getelementptr inbounds i8, i8* %tmp, i64 7
  %tmp34 = load i8, i8* %tmp33, align 1
  %tmp35 = zext i8 %tmp34 to i64
  %tmp36 = shl nuw i64 %tmp35, 56
  %tmp37 = or i64 %tmp32, %tmp36
  ret i64 %tmp37
}

; i8* p; // p is 8 byte aligned
; ((i64) p[0] << 56) | ((i64) p[1] << 48) | ((i64) p[2] << 40) | ((i64) p[3] << 32) | ((i64) p[4] << 24) | ((i64) p[5] << 16) | ((i64) p[6] << 8) | (i64) p[7]
define i64 @load_i64_by_i8_bswap(i64* %arg) {
; CHECK-LABEL: load_i64_by_i8_bswap:
; CHECK: ldr		x8, [x0]
; CHECK-NEXT: rev	x0, x8
; CHECK-NEXT: ret
  %tmp = bitcast i64* %arg to i8*
  %tmp1 = load i8, i8* %tmp, align 8
  %tmp2 = zext i8 %tmp1 to i64
  %tmp3 = shl nuw i64 %tmp2, 56
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i64 1
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i64
  %tmp7 = shl nuw nsw i64 %tmp6, 48
  %tmp8 = or i64 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i64 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i64
  %tmp12 = shl nuw nsw i64 %tmp11, 40
  %tmp13 = or i64 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i64 3
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i64
  %tmp17 = shl nuw nsw i64 %tmp16, 32
  %tmp18 = or i64 %tmp13, %tmp17
  %tmp19 = getelementptr inbounds i8, i8* %tmp, i64 4
  %tmp20 = load i8, i8* %tmp19, align 1
  %tmp21 = zext i8 %tmp20 to i64
  %tmp22 = shl nuw nsw i64 %tmp21, 24
  %tmp23 = or i64 %tmp18, %tmp22
  %tmp24 = getelementptr inbounds i8, i8* %tmp, i64 5
  %tmp25 = load i8, i8* %tmp24, align 1
  %tmp26 = zext i8 %tmp25 to i64
  %tmp27 = shl nuw nsw i64 %tmp26, 16
  %tmp28 = or i64 %tmp23, %tmp27
  %tmp29 = getelementptr inbounds i8, i8* %tmp, i64 6
  %tmp30 = load i8, i8* %tmp29, align 1
  %tmp31 = zext i8 %tmp30 to i64
  %tmp32 = shl nuw nsw i64 %tmp31, 8
  %tmp33 = or i64 %tmp28, %tmp32
  %tmp34 = getelementptr inbounds i8, i8* %tmp, i64 7
  %tmp35 = load i8, i8* %tmp34, align 1
  %tmp36 = zext i8 %tmp35 to i64
  %tmp37 = or i64 %tmp33, %tmp36
  ret i64 %tmp37
}

; i8* p; // p[1] is 4 byte aligned
; (i32) p[1] | ((i32) p[2] << 8) | ((i32) p[3] << 16) | ((i32) p[4] << 24)
define i32 @load_i32_by_i8_nonzero_offset(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_nonzero_offset:
; CHECK: ldrb  w8, [x0, #1]
; CHECK-NEXT: ldrb  w9, [x0, #2]
; CHECK-NEXT: ldrb  w10, [x0, #3]
; CHECK-NEXT: ldrb  w11, [x0, #4]
; CHECK-NEXT: bfi w8, w9, #8, #8
; CHECK-NEXT: bfi w8, w10, #16, #8
; CHECK-NEXT: bfi w8, w11, #24, #8
; CHECK-NEXT: mov  w0, w8
; CHECK-NEXT: ret
  %tmp = bitcast i32* %arg to i8*
  %tmp1 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp2 = load i8, i8* %tmp1, align 4
  %tmp3 = zext i8 %tmp2 to i32
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 8
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 16
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 4
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = shl nuw nsw i32 %tmp16, 24
  %tmp18 = or i32 %tmp13, %tmp17
  ret i32 %tmp18
}

; i8* p; // p[-4] is 4 byte aligned
; (i32) p[-4] | ((i32) p[-3] << 8) | ((i32) p[-2] << 16) | ((i32) p[-1] << 24)
define i32 @load_i32_by_i8_neg_offset(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_neg_offset:
; CHECK: ldurb w8, [x0, #-4]
; CHECK-NEXT: ldurb w9, [x0, #-3]
; CHECK-NEXT: ldurb w10, [x0, #-2]
; CHECK-NEXT: ldurb w11, [x0, #-1]
; CHECK-NEXT: bfi w8, w9, #8, #8
; CHECK-NEXT: bfi w8, w10, #16, #8
; CHECK-NEXT: bfi w8, w11, #24, #8
; CHECK-NEXT: mov  w0, w8
; CHECK-NEXT: ret
  %tmp = bitcast i32* %arg to i8*
  %tmp1 = getelementptr inbounds i8, i8* %tmp, i32 -4
  %tmp2 = load i8, i8* %tmp1, align 4
  %tmp3 = zext i8 %tmp2 to i32
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 -3
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 8
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 -2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 16
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 -1
  %tmp15 = load i8, i8* %tmp14, align 1
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = shl nuw nsw i32 %tmp16, 24
  %tmp18 = or i32 %tmp13, %tmp17
  ret i32 %tmp18
}

; i8* p; // p[1] is 4 byte aligned
; (i32) p[4] | ((i32) p[3] << 8) | ((i32) p[2] << 16) | ((i32) p[1] << 24)
define i32 @load_i32_by_i8_nonzero_offset_bswap(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_nonzero_offset_bswap:
; CHECK: ldrb  w8, [x0, #4]
; CHECK-NEXT: ldrb  w9, [x0, #3]
; CHECK-NEXT: ldrb  w10, [x0, #2]
; CHECK-NEXT: ldrb  w11, [x0, #1]
; CHECK-NEXT: bfi w8, w9, #8, #8
; CHECK-NEXT: bfi w8, w10, #16, #8
; CHECK-NEXT: bfi w8, w11, #24, #8
; CHECK-NEXT: mov  w0, w8
; CHECK-NEXT: ret
  %tmp = bitcast i32* %arg to i8*
  %tmp1 = getelementptr inbounds i8, i8* %tmp, i32 4
  %tmp2 = load i8, i8* %tmp1, align 1
  %tmp3 = zext i8 %tmp2 to i32
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 3
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 8
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 2
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 16
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 1
  %tmp15 = load i8, i8* %tmp14, align 4
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = shl nuw nsw i32 %tmp16, 24
  %tmp18 = or i32 %tmp13, %tmp17
  ret i32 %tmp18
}

; i8* p; // p[-4] is 4 byte aligned
; (i32) p[-1] | ((i32) p[-2] << 8) | ((i32) p[-3] << 16) | ((i32) p[-4] << 24)
define i32 @load_i32_by_i8_neg_offset_bswap(i32* %arg) {
; CHECK-LABEL: load_i32_by_i8_neg_offset_bswap:
; CHECK: ldurb w8, [x0, #-1]
; CHECK-NEXT: ldurb w9, [x0, #-2]
; CHECK-NEXT: ldurb w10, [x0, #-3]
; CHECK-NEXT: ldurb w11, [x0, #-4]
; CHECK-NEXT: bfi w8, w9, #8, #8
; CHECK-NEXT: bfi w8, w10, #16, #8
; CHECK-NEXT: bfi w8, w11, #24, #8
; CHECK-NEXT: mov  w0, w8
; CHECK-NEXT: ret
  %tmp = bitcast i32* %arg to i8*
  %tmp1 = getelementptr inbounds i8, i8* %tmp, i32 -1
  %tmp2 = load i8, i8* %tmp1, align 1
  %tmp3 = zext i8 %tmp2 to i32
  %tmp4 = getelementptr inbounds i8, i8* %tmp, i32 -2
  %tmp5 = load i8, i8* %tmp4, align 1
  %tmp6 = zext i8 %tmp5 to i32
  %tmp7 = shl nuw nsw i32 %tmp6, 8
  %tmp8 = or i32 %tmp7, %tmp3
  %tmp9 = getelementptr inbounds i8, i8* %tmp, i32 -3
  %tmp10 = load i8, i8* %tmp9, align 1
  %tmp11 = zext i8 %tmp10 to i32
  %tmp12 = shl nuw nsw i32 %tmp11, 16
  %tmp13 = or i32 %tmp8, %tmp12
  %tmp14 = getelementptr inbounds i8, i8* %tmp, i32 -4
  %tmp15 = load i8, i8* %tmp14, align 4
  %tmp16 = zext i8 %tmp15 to i32
  %tmp17 = shl nuw nsw i32 %tmp16, 24
  %tmp18 = or i32 %tmp13, %tmp17
  ret i32 %tmp18
}

declare i16 @llvm.bswap.i16(i16)

; i16* p; // p is 4 byte aligned
; (i32) bswap(p[1]) | (i32) bswap(p[0] << 16)
define i32 @load_i32_by_bswap_i16(i32* %arg) {
; CHECK-LABEL: load_i32_by_bswap_i16:
; CHECK: ldr    w8, [x0]
; CHECK-NEXT: rev w0, w8
; CHECK-NEXT: ret

  %tmp = bitcast i32* %arg to i16*
  %tmp1 = load i16, i16* %tmp, align 4
  %tmp11 = call i16 @llvm.bswap.i16(i16 %tmp1)
  %tmp2 = zext i16 %tmp11 to i32
  %tmp3 = getelementptr inbounds i16, i16* %tmp, i32 1
  %tmp4 = load i16, i16* %tmp3, align 1
  %tmp41 = call i16 @llvm.bswap.i16(i16 %tmp4)
  %tmp5 = zext i16 %tmp41 to i32
  %tmp6 = shl nuw nsw i32 %tmp2, 16
  %tmp7 = or i32 %tmp6, %tmp5
  ret i32 %tmp7
}

; i16* p; // p is 4 byte aligned
; (i32) p[0] | (sext(p[1] << 16) to i32)
define i32 @load_i32_by_sext_i16(i32* %arg) {
; CHECK-LABEL: load_i32_by_sext_i16:
; CHECK: ldrh    w8, [x0]
; CHECK-NEXT: ldrh  w9, [x0, #2]
; CHECK-NEXT: bfi w8, w9, #16, #16
; CHECK-NEXT: mov  w0, w8
; CHECK-NEXT: ret

  %tmp = bitcast i32* %arg to i16*
  %tmp1 = load i16, i16* %tmp, align 4
  %tmp2 = zext i16 %tmp1 to i32
  %tmp3 = getelementptr inbounds i16, i16* %tmp, i32 1
  %tmp4 = load i16, i16* %tmp3, align 1
  %tmp5 = sext i16 %tmp4 to i32
  %tmp6 = shl nuw nsw i32 %tmp5, 16
  %tmp7 = or i32 %tmp6, %tmp2
  ret i32 %tmp7
}

; i8* arg; i32 i;
; p = arg + 12;
; (i32) p[i] | ((i32) p[i + 1] << 8) | ((i32) p[i + 2] << 16) | ((i32) p[i + 3] << 24)
define i32 @load_i32_by_i8_base_offset_index(i8* %arg, i32 %i) {
; CHECK-LABEL: load_i32_by_i8_base_offset_index:
; CHECK: add x8, x0, w1, uxtw
; CHECK-NEXT: ldr w0, [x8, #12]
; CHECK-NEXT: ret
  %tmp = add nuw nsw i32 %i, 3
  %tmp2 = add nuw nsw i32 %i, 2
  %tmp3 = add nuw nsw i32 %i, 1
  %tmp4 = getelementptr inbounds i8, i8* %arg, i64 12
  %tmp5 = zext i32 %i to i64
  %tmp6 = getelementptr inbounds i8, i8* %tmp4, i64 %tmp5
  %tmp7 = load i8, i8* %tmp6, align 4
  %tmp8 = zext i8 %tmp7 to i32
  %tmp9 = zext i32 %tmp3 to i64
  %tmp10 = getelementptr inbounds i8, i8* %tmp4, i64 %tmp9
  %tmp11 = load i8, i8* %tmp10, align 1
  %tmp12 = zext i8 %tmp11 to i32
  %tmp13 = shl nuw nsw i32 %tmp12, 8
  %tmp14 = or i32 %tmp13, %tmp8
  %tmp15 = zext i32 %tmp2 to i64
  %tmp16 = getelementptr inbounds i8, i8* %tmp4, i64 %tmp15
  %tmp17 = load i8, i8* %tmp16, align 1
  %tmp18 = zext i8 %tmp17 to i32
  %tmp19 = shl nuw nsw i32 %tmp18, 16
  %tmp20 = or i32 %tmp14, %tmp19
  %tmp21 = zext i32 %tmp to i64
  %tmp22 = getelementptr inbounds i8, i8* %tmp4, i64 %tmp21
  %tmp23 = load i8, i8* %tmp22, align 1
  %tmp24 = zext i8 %tmp23 to i32
  %tmp25 = shl nuw i32 %tmp24, 24
  %tmp26 = or i32 %tmp20, %tmp25
  ret i32 %tmp26
}

; i8* arg; i32 i;
; p = arg + 12;
; (i32) p[i + 1] | ((i32) p[i + 2] << 8) | ((i32) p[i + 3] << 16) | ((i32) p[i + 4] << 24)
define i32 @load_i32_by_i8_base_offset_index_2(i8* %arg, i32 %i) {
; CHECK-LABEL: load_i32_by_i8_base_offset_index_2:
; CHECK: add x8, x0, w1, uxtw
; CHECK-NEXT: ldrb  w0, [x8, #13]
; CHECK-NEXT: ldrb  w9, [x8, #14]
; CHECK-NEXT: ldrb  w10, [x8, #15]
; CHECK-NEXT: ldrb  w8, [x8, #16]
; CHECK-NEXT: bfi w0, w9, #8, #8
; CHECK-NEXT: bfi w0, w10, #16, #8
; CHECK-NEXT: bfi w0, w8, #24, #8
; CHECK-NEXT: ret

  %tmp = add nuw nsw i32 %i, 4
  %tmp2 = add nuw nsw i32 %i, 3
  %tmp3 = add nuw nsw i32 %i, 2
  %tmp4 = getelementptr inbounds i8, i8* %arg, i64 12
  %tmp5 = add nuw nsw i32 %i, 1
  %tmp27 = zext i32 %tmp5 to i64
  %tmp28 = getelementptr inbounds i8, i8* %tmp4, i64 %tmp27
  %tmp29 = load i8, i8* %tmp28, align 4
  %tmp30 = zext i8 %tmp29 to i32
  %tmp31 = zext i32 %tmp3 to i64
  %tmp32 = getelementptr inbounds i8, i8* %tmp4, i64 %tmp31
  %tmp33 = load i8, i8* %tmp32, align 1
  %tmp34 = zext i8 %tmp33 to i32
  %tmp35 = shl nuw nsw i32 %tmp34, 8
  %tmp36 = or i32 %tmp35, %tmp30
  %tmp37 = zext i32 %tmp2 to i64
  %tmp38 = getelementptr inbounds i8, i8* %tmp4, i64 %tmp37
  %tmp39 = load i8, i8* %tmp38, align 1
  %tmp40 = zext i8 %tmp39 to i32
  %tmp41 = shl nuw nsw i32 %tmp40, 16
  %tmp42 = or i32 %tmp36, %tmp41
  %tmp43 = zext i32 %tmp to i64
  %tmp44 = getelementptr inbounds i8, i8* %tmp4, i64 %tmp43
  %tmp45 = load i8, i8* %tmp44, align 1
  %tmp46 = zext i8 %tmp45 to i32
  %tmp47 = shl nuw i32 %tmp46, 24
  %tmp48 = or i32 %tmp42, %tmp47
  ret i32 %tmp48
}