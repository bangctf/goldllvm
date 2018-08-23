; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i32 @sterix(i32, i8, i64) {
; CHECK-LABEL: @sterix(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = zext i32 [[TMP0:%.*]] to i64
; CHECK-NEXT:    [[CONV1:%.*]] = sext i8 [[TMP1:%.*]] to i32
; CHECK-NEXT:    [[MUL:%.*]] = mul i32 [[CONV1]], 1945964878
; CHECK-NEXT:    [[SH_PROM:%.*]] = trunc i64 [[TMP2:%.*]] to i32
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[MUL]], [[SH_PROM]]
; CHECK-NEXT:    [[CONV2:%.*]] = zext i32 [[SHR]] to i64
; CHECK-NEXT:    [[MUL3:%.*]] = mul nuw nsw i64 [[CONV]], [[CONV2]]
; CHECK-NEXT:    [[CONV6:%.*]] = and i64 [[MUL3]], 4294967295
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i64 [[CONV6]], [[MUL3]]
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[LOR_RHS:%.*]], label [[LOR_END:%.*]]
; CHECK:       lor.rhs:
; CHECK-NEXT:    [[AND:%.*]] = and i64 [[MUL3]], [[TMP2]]
; CHECK-NEXT:    [[CONV4:%.*]] = trunc i64 [[AND]] to i32
; CHECK-NEXT:    [[TOBOOL7:%.*]] = icmp eq i32 [[CONV4]], 0
; CHECK-NEXT:    [[PHITMP:%.*]] = zext i1 [[TOBOOL7]] to i32
; CHECK-NEXT:    br label [[LOR_END]]
; CHECK:       lor.end:
; CHECK-NEXT:    [[TMP3:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[PHITMP]], [[LOR_RHS]] ]
; CHECK-NEXT:    ret i32 [[TMP3]]
;
entry:
  %conv = zext i32 %0 to i64
  %conv1 = sext i8 %1 to i32
  %mul = mul i32 %conv1, 1945964878
  %sh_prom = trunc i64 %2 to i32
  %shr = lshr i32 %mul, %sh_prom
  %conv2 = zext i32 %shr to i64
  %mul3 = mul nuw nsw i64 %conv, %conv2
  %conv6 = and i64 %mul3, 4294967295
  %tobool = icmp ne i64 %conv6, %mul3
  br i1 %tobool, label %lor.end, label %lor.rhs

lor.rhs:
  %and = and i64 %2, %mul3
  %conv4 = trunc i64 %and to i32
  %tobool7 = icmp ne i32 %conv4, 0
  %lnot = xor i1 %tobool7, true
  br label %lor.end

lor.end:
  %3 = phi i1 [ true, %entry ], [ %lnot, %lor.rhs ]
  %conv8 = zext i1 %3 to i32
  ret i32 %conv8
}

