mabs:                                       # функция mabs(double x)
        push    rbp                         # сохраняем rbp на стек
        mov     rbp, rsp                    # присваиваем rbp rsp
        movsd   QWORD PTR [rbp-8], xmm0     # [rbp-8] := xmm0    
        pxor    xmm0, xmm0                  # побитовый xor xmm0 и xmm0
        comisd  xmm0, QWORD PTR [rbp-8]     # сравниваем два double 
        jbe     .L7                         # Перейти к .L7, если меньше или равно
        movsd   xmm0, QWORD PTR [rbp-8]     # xmm0 := [rbp-8]  
        movq    xmm1, QWORD PTR .LC1[rip]   # xmm1 := .LC1[rip]    
        xorpd   xmm0, xmm1                  # xor двух double 
        jmp     .L5                         # jump -> .L5
.L7:
        movsd   xmm0, QWORD PTR [rbp-8]     # xmm0 := [rbp-8] 
.L5:
        movq    rax, xmm0                   # rax := xmm0  
        movq    xmm0, rax                   # xmm0 := *(rax)
        pop     rbp                         # извлекаем rbp из стека 
        ret                                 # return
.LC2:
        .string "r"                         # строка "r"
.LC3:
        .string "%lf"                       # строка "%lf"
.LC4:
        .string "Error "                    # строка "Error "
read_from_file:
        push    rbp                         # сохраняем rbp на стек
        mov     rbp, rsp                    # присваиваем rbp rsp
        sub     rsp, 32                     # rsp двигаем на 32 байта
        mov     QWORD PTR [rbp-24], rdi     # сохраняем char* inpath на стек
        mov     rax, QWORD PTR [rbp-24]     # rax := [rbp-24]
        mov     esi, OFFSET FLAT:.LC2       # esi := "r"
        mov     rdi, rax                    # rdi := rax
        call    fopen                       # FILE *input = fopen(inpath, "r");
        mov     QWORD PTR [rbp-8], rax      # [rbp-8] := rax
        cmp     QWORD PTR [rbp-8], 0        # сравниваем input с 0
        je      .L9                         # jump equal -> .L9
        lea     rdx, [rbp-16]               # rdx := [rbp-16]
        mov     rax, QWORD PTR [rbp-8]      # *(rax) := [rbp-8]
        mov     esi, OFFSET FLAT:.LC3       # esi := "%lf"
        mov     rdi, rax                    # rdi := *(rax) 
        mov     eax, 0                      # eax := 0
        call    __isoc99_fscanf             # вызываем fscanf
        mov     rax, QWORD PTR [rbp-8]      # *(rax) := [rbp-8]
        mov     rdi, rax                    # rdi := *(rax)
        call    fclose                      # вызываем fclose
        movsd   xmm0, QWORD PTR [rbp-16]    # xmm0 := [rbp-16]
        movq    rax, xmm0                   # *(rax) := xmm0
        jmp     .L8                         # jump -> .L8
.L9:
        mov     edi, OFFSET FLAT:.LC4       # esi := "Error "
        call    perror                      # вызываем perror
.L8:
        movq    xmm0, rax                   # xmm0 := *(rax)
        leave                               
        ret                                 
.LC8:
        .string "w"                         # строка "w"
.LC9:
        .string "root = %lf\n"              # строка "%lf\n"
calculate_root:
        push    rbp                         # сохраняем rbp на стек
        mov     rbp, rsp                    # присваиваем rbp rsp
        push    r15                         # register double rn asm ("r15")
        push    r14                         # register int i asm ("r14")
        push    r13                         # register double root asm ("r13")
        push    r12                         # register double eps asm ("r12")
        sub     rsp, 32                     # rsp двигаем на 32 байта
        movsd   QWORD PTR [rbp-56], xmm0    # [rbp-56] := xmm0
        mov     QWORD PTR [rbp-64], rdi     # [rbp-64] := rdi
        mov     r12, QWORD PTR .LC5[rip]    # eps := 0.0005
        movsd   xmm0, QWORD PTR [rbp-56]    # xmm0 := [rbp-56]
        movsd   xmm1, QWORD PTR .LC6[rip]   # xmm1 := 3
        divsd   xmm0, xmm1                  # num / 3
        movq    r13, xmm0                   # root := num / 3
        mov     r15, QWORD PTR [rbp-56]     # rn := num 
        jmp     .L12                        # jump -> .L12
.L15:
        mov     r15, QWORD PTR [rbp-56]
        mov     r14d, 1
        jmp     .L13                        # jump -> .L13
.L14:
        movq    xmm0, r15                   # xmm0 := rn
        movq    xmm1, r13                   # xmm1 := root
        divsd   xmm0, xmm1                  # xmm0 / xmm1
        movq    r15, xmm0                   # rn := xmm0
        mov     eax, r14d                   # eax := r14d
        add     eax, 1                      # eax += 1
        mov     r14d, eax                   # r14d := eax
.L13:
        mov     eax, r14d                   # eax := r14d
        cmp     eax, 2                      # сравниваем eax с 2
        jle     .L14                        # jump less or equal -> .L14
        movq    xmm1, r15                   # xmm1 := rn
        movq    xmm0, r13                   # xmm0 := root
        addsd   xmm1, xmm0                  # xmm1 += xmm0
        movsd   xmm0, QWORD PTR .LC7[rip]   # xmm0 :=  0.5
        mulsd   xmm0, xmm1                  # xmmo *= xmm1
        movq    r13, xmm0                   # root := xmm0
.L12:
        movq    xmm0, r13                   # xmm0 := root
        movq    xmm1, r15                   # xmm1 := rn
        subsd   xmm0, xmm1                  # root - rn
        movq    rax, xmm0                   # *(rax) := xmm0
        movq    xmm0, rax                   # xmm0 := *(rax)
        call    mabs                        # вызываем mabs
        movq    rax, xmm0                   # *(rax) := xmm0
        movq    xmm0, r12                   # xmm0 := eps
        movq    xmm2, rax                   # xmm2 := *(rax)
        comisd  xmm2, xmm0                  # сравниваем xmm2 и xmm0
        jnb     .L15                        # jump not less -> .L15
        mov     rax, QWORD PTR [rbp-64]
        mov     esi, OFFSET FLAT:.LC8
        mov     rdi, rax
        call    fopen
        mov     QWORD PTR [rbp-40], rax
        cmp     QWORD PTR [rbp-40], 0
        je      .L16                        # jump equal -> .L16
        mov     rax, r13
        movq    xmm0, rax
        call    round
        movq    rax, xmm0
        mov     r15, rax
        mov     rax, r15
        movsd   xmm0, QWORD PTR .LC6[rip]
        movapd  xmm1, xmm0
        movq    xmm0, rax
        call    pow
        movq    rax, xmm0
        movq    xmm3, rax
        ucomisd xmm3, QWORD PTR [rbp-56]
        jp      .L17                        # jump if parity -> .L17
        movq    xmm4, rax
        ucomisd xmm4, QWORD PTR [rbp-56]
        jne     .L17                        # jump not equal -> .L16
        mov     rdx, r15
        mov     rax, QWORD PTR [rbp-40]
        movq    xmm0, rdx
        mov     esi, OFFSET FLAT:.LC9
        mov     rdi, rax
        mov     eax, 1
        call    fprintf
        jmp     .L19                        # jump -> .L19
.L17:
        mov     rdx, r13
        mov     rax, QWORD PTR [rbp-40]
        movq    xmm0, rdx
        mov     esi, OFFSET FLAT:.LC9
        mov     rdi, rax
        mov     eax, 1
        call    fprintf
        jmp     .L19                        # jump -> .L19
.L16:
        mov     edi, OFFSET FLAT:.LC4
        call    perror
.L19:
        nop
        add     rsp, 32
        pop     r12
        pop     r13
        pop     r14
        pop     r15
        pop     rbp
        ret
main:
        push    rbp                         # сохраняем rbp на стек
        mov     rbp, rsp                    # присваиваем rbp rsp
        sub     rsp, 32                     # rsp двигаем на 32 байта
        mov     DWORD PTR [rbp-20], edi     # argc
        mov     QWORD PTR [rbp-32], rsi     # argv
        mov     rax, QWORD PTR [rbp-32]     # rax := [rbp-32]
        add     rax, 8                      # rax += 8
        mov     rax, QWORD PTR [rax]        
        mov     rdi, rax                    # rdi := rax
        call    read_from_file              # вызываем read_from_filw             
        movq    rax, xmm0                   # rax := xmm0
        mov     QWORD PTR [rbp-8], rax      # [rbp-8] := rax  
        mov     rax, QWORD PTR [rbp-32]     # rax := [rbp-32]    
        add     rax, 16                     # rax += 16
        mov     rdx, QWORD PTR [rax]
        mov     rax, QWORD PTR [rbp-8]       
        mov     rdi, rdx                     # rdi := rax
        movq    xmm0, rax                    # xmm0 := *(rax)
        call    calculate_root               # вызываем calculate_root
        mov     eax, 0                       # eax := 0
        leave
        ret
.LC1:                                        # 1.0
        .long   0                            
        .long   -2147483648
        .long   0
        .long   0
.LC5:                                        # 0.0005
        .long   -755914244
        .long   1061184077
.LC6:                                        # 3
        .long   0
        .long   1074266112
.LC7:
        .long   0                            #  0.5
        .long   1071644672
