section .data
    ask             db  'x=', 0
    len_ask         equ $-ask
    result          db  'f(x)=0x', 0
    len_result      equ $-result
    numar           dd  0
    y               dd  0
    coef            dd  0
    kbd             db  3 dup(0)
    char_to_print   db  0
 
section .text
    global _start
 
_start:
    ; x=
    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, ask
    mov edx, len_ask
    int 0x80
 
    ; Introducere numar in format ASCII
    mov eax, 0x03            ; sys_read
    mov ebx, 0x00            ; stdin
    mov ecx, kbd             ; Buffer
    mov edx, 0x03               
    int 0x80
 
    push edx
    push ecx
    call    ascbin
    add esp, 8
calcul:
    finit                     ; Initialize FPU
    fild    dword [numar]     ; st0 = x
    fmul    st0, st0          ; st0 = x^2
    fild    dword [numar]     ; st0 = x     | st1 = x^2
    fmul    st0, st1          ; st0 = x^3   | st1 = x^2
    mov     dword [coef], 7
    fild    dword [coef]      ; st0 = 7     | st1 = x^3   | st2 = x^2
    fmul    st0, st1          ; st0 = 7*x^3 | st1 = x^3   | st2 = x^2
    mov     dword [coef], 5
    fild    dword [coef]      ; st0 = 5     | st1 = 7*x^3 | st2 = x^3   | st3 = x^2
    fmul    st0, st3          ; st0 = 5*x^2 | st1 = 7*x^3 | st2 = x^3   | st3 = x^2
    fsubp   st1, st0          ; st0 = 7*x^3 - 5*x^2 | st1 = x^3 | st2 = x^2
    mov     dword [coef], 11
    fild    dword [coef]      ; st0 = 11    | st1 = 7*x^3 - 5*x^2 | st2 = x^3 | st3 = x^2
    faddp   st1, st0          ; st0 = 7*x^3 - 5*x^2 + 11 | st1 = x^3 | st2 = x^2
    mov     dword [coef], 9
    fild    dword [coef]      ; st0 = 9     | st1 = 7*x^3 - 5*x^2 + 11 | st2 = x^3 | st3 = x^2
    fdivp   st1, st0          ; st0 = (7/9)*x^3 - (5/9)*x^2 + (11/9) | st1 = x^3 | st2 = x^2
    fstp    dword [y]         ; store result in y
    ffree
 
    mov     eax, 0x04            
    mov     ebx, 0x01            
    mov     ecx, result       
    mov     edx, len_result
    int     0x80
 
 
    ; Display result in IEEE-754 Hex Representation
    call    mdump
 
    ; Exit program
    mov     eax, 0x01
    xor     ebx, ebx          
    int     0x80              
 
ascbin:
    push ebp
    mov ebp, esp
 
    mov     ecx, [ebp+12]
    mov     ebx, 10
    mov     esi, [ebp+8]
 
next_char:
    mov     eax, dword [numar]
    mul     ebx
    xor     edx, edx
    mov     dl, byte [esi]
    sub     dl, '0'
    add     eax, edx
    mov     dword [numar], eax
    inc     esi 
    cmp     byte [esi], 0x0a
    je      end_string
    loop    next_char
 
end_string:
    mov esp, ebp
    pop ebp
    ret
 
mdump:
    push    ebp
    mov     ebp, esp
 
    mov     esi, dword [y]
    mov     ecx, 8            ; 8 hex digits in a DWORD
 
dump_loop:
    rol     esi, 4            ; Rotate left by 4 bits
    mov     eax, esi
    mov     dl, al            ; Lower nibble to DL
    and     dl, 0Fh           ; Mask high nibble
    add     dl, '0'           ; Convert to ASCII
    cmp     dl, '9'           ; Check if it's a digit
    jbe     print_digit       ; Jump if less than or equal to '9'
    add     dl, 7             ; Adjust for letters A-F
 
print_digit:
    mov     byte [char_to_print], dl
    push    ecx
    mov     eax, 0x04
    mov     ebx, 0x01
    mov     ecx, char_to_print
    mov     edx, 0x01
    int     0x80              
    pop     ecx
    loop    dump_loop
 
    mov     esp, ebp
    pop     ebp
    ret
