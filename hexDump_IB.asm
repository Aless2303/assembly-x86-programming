;;in eax va fi stocata valoarea care va fi scrisa in hexa
mdump:
    push    ebp
    mov     ebp, esp

    mov     ecx, 2            ; 2 hex digits in a Byte

dump_loop:
    rol     al, 4            ; Rotate left by 4 bits
    mov     dl, al
    and     dl, 0x0F           ; Mask high nibble
    add     dl, '0'           ; Convert to ASCII
    cmp     dl, '9'           ; Check if it's a digit
    jbe     print_digit       ; Jump if less than or equal to '9'
    add     dl, 7             ; Adjust for letters A-F

print_digit:
    push eax
    mov     byte [char], dl
    push    ecx
    mov     eax, 0x04
    mov     ebx, 0x01   ;;;;;;;;;;;;;;Se afiseaza la std::out
    mov     ecx, char
    mov     edx, 0x01
    int     0x80              
    pop     ecx
    pop eax
    loop    dump_loop

    mov     esp, ebp
    pop     ebp
    ret