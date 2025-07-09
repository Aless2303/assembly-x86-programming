;;Transforma un numar ascii (din esi) in binar, si il stocheaza in eax
;



;mov esi buffer
ascbin:
    push ebp
    mov ebp, esp

    mov eax, 0          ;;in eax avem valoarea finala(din ascii in binar)
    mov ebx, 10
    

creare_numar:
    cmp byte [esi], 0x20
    je final
    cmp byte [esi], 0x00 
    je final

    mul ebx; -> eax = eax * 10

    xor edx, edx
    mov dl, byte [esi]
    sub dl, 0x30

    add eax, edx

    inc esi
    jmp creare_numar

final:
    mov esp, ebp
    pop ebp

    ret



;;;;Context de folosire:

    mov ecx, 6 ;;stim ca avem FIX 6 elemente din matrice
    mov esi, buffer
    mov edi, matrice
populare_matrice:

    call ascbin
    inc esi

    ;eax -> numar curent

    mov byte [edi], al
    inc edi
    loop populare_matrice