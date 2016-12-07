; ModuleID = 'fib.c'
source_filename = "fib.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0a\00", align 1

define i32 @fib(i32 %n)
{
entry:
    %cmp = icmp eq i32 %n, 0
    br i1 %cmp, label %end_imm, label %continue

continue:
    %cmp_1 = icmp eq i32 %n, 1
    br i1 %cmp_1, label %end_imm, label %compute_end

compute_end:
    %argv1 = sub nsw i32 %n, 1
    %argv2 = sub nsw i32 %n, 2
    %ret_1 = tail call i32 @fib(i32 %argv1)
    %ret_2 = tail call i32 @fib(i32 %argv2)
    %ret_val = add nsw i32 %ret_1, %ret_2
    ret i32 %ret_val

end_imm:
    %ret_val_1 = phi i32 [ 0, %entry ], [ 1, %continue ]
    ret i32 %ret_val_1
}

define i32 @main(i32 %argc, i8** %argv)
{
entry:
    %argv1 = getelementptr inbounds i8*, i8** %argv, i32 1
    %num_str = load i8*, i8** %argv1, align 8
    %num = tail call i32 @atoi(i8* %num_str)
    %ans = tail call i32 @fib(i32 %num)
    tail call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i32 0, i32 0), i32 %ans)
    ret i32 0
}

declare i32 @printf(i8*, ...)
declare i32 @atoi(i8*)