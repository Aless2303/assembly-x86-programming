BITS 32

section .data
    buffer db 100 dup (0)
    vector dw 10 dup (0)
    fileIn db 'in.txt', 0
    fileOut db 'out.txt', 0
    fdIn db 0
    fdOut db 0
    cifra db 0

section .text
    global _start

_start:
    ;deschidere fisier pentru citire
    mov eax, 5
    mov ebx, fileIn
    mov ecx, 0            
    mov edx, 666o         
    int  0x80
    
    mov  [fdIn], al
    
    ;citire din fisier
    mov eax, 3
    xor ebx, ebx
    mov bl, [fdIn]
    mov ecx, buffer
    mov edx, 100
    int 0x80
    
    ;inchidere fisier
    mov eax, 6
    xor ebx, ebx
    mov bl, [fdIn]
    int  0x80  

    mov ecx, 10 ;;;;;10 elemente
    mov esi, buffer
    mov edi, vector
    populareVector:

        call ascbin
        inc esi

        ;eax -> numar curent

        mov word [edi], ax
        add edi, 2
    loop populareVector

    ;for(int i = 0; i < 9; i++)
    ;{
    ;    for (int j = i + 1; j < 10; j++)
    ;        if(v[i] < v[j])
    ;        swap
    ;}

    ;;esi = i
    ;;edi = j

    mov esi, 0  ; i = 0
    xor eax, eax
    xor ebx, ebx
outer_loop:
    
    mov edi, esi
    inc edi     ;j = i + 1
    
    inner_loop:
        mov ax, [vector + esi * 2]
        mov bx, [vector + edi * 2]
        cmp ax, bx      ; if vector[i] < vector[j]
        jle do_not_swap
                        ;swap
        mov ax, [vector + esi * 2]
        mov bx, [vector + edi * 2]
        mov [vector + esi * 2], bx
        mov [vector + edi * 2], ax

        do_not_swap:
        inc edi             ;j++
        cmp edi, 10         ;j < 10
        jne inner_loop

    inc esi                 ;i++
    cmp esi, 9              ;i<9
    jne outer_loop


    ;creare fisier
    mov  eax, 8
    mov  ebx, fileOut
    mov  ecx, 666o     
    int  0x80            
    
    mov [fdOut], al

    mov ecx, 10
    mov esi, vector
    printVector:
    xor eax, eax
    mov ax, [esi]
    push ecx
    call binasc

    mov eax, ' '
    mov [cifra], eax
    mov eax, 0x04
    xor ebx, ebx
    mov bl, [fdOut]         ;;;;File descriptor trebuie definit inainte
    mov ecx, cifra
    mov edx, 1
    int 0x80
    pop ecx
    add esi, 2

    loop printVector


    ;inchidere fisier
   mov eax, 6
   xor ebx, ebx
   mov bl, [fdOut]
   int 0x80

;;;;;;;;;;;;Gata
    mov eax, 0x01
    xor ebx, ebx
    int 0x80
;;;;;;;;;;;;


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

binasc: ;0-255(octet)
    push ebp
    mov ebp, esp

    mov ebx, 0x0a
    xor ecx, ecx
creare_sir:
    xor edx, edx
    div ebx ; eax -> catul, edx -> restul
    add edx, 0x30
    push edx        ;push pe stiva
    inc ecx
    cmp eax, 0x00
    jne creare_sir

afisare_sir:
    pop edx             ;pop de pe stiva, in edx va fi valoarea care era pe stiva
    mov byte [cifra], dl
    push ecx
    mov eax, 0x04
    xor ebx, ebx
    mov bl, [fdOut]         ;;;;File descriptor trebuie definit inainte
    mov ecx, cifra
    mov edx, 1
    int 0x80
    pop ecx
    loop afisare_sir

    mov esp, ebp
    pop ebp
    ret