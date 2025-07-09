BITS 32
    

section .data
    fileIn db 'in.txt', 0
    fileOut db 'out.txt', 0
    buffer db 1024 dup (0)
    fdIn db 0
    fdOut db 0
    matrice db 6 dup (0)
    transpusa db 6 dup (0)
    cifra db 0
    spatiu db '   '
    endl db 0x0a
section .text
    global _start
_start:
    ; creare fisier
    mov  eax, 8
    mov  ebx, fileOut
    mov  ecx, 666o     
    int  0x80            
    
    mov [fdOut], eax
    ;deschidere fisier pentru citire
    mov eax, 5
    mov ebx, fileIn
    mov ecx, 0            
    mov edx, 666o         
    int  0x80

    mov byte [fdIn], al

    ;citire din fisier
    mov eax, 3
    xor ebx, ebx
    mov bl, [fdIn]
    mov ecx, buffer
    mov edx, 1024
    int 0x80

    ;inchidere fisier
    mov eax, 6
    xor ebx, ebx
    mov bl, [fdIn]
    int  0x80  

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

    mov ecx, 0x02
    mov eax, 0x00   ; linie
    mov ebx, 0x00   ; coloana
    mov edi, transpusa
transpun_linie:
    push ecx
    mov ecx, 0x03
    xor eax, eax
    transpun_coloana:
        xor edx, edx
        mov dl, byte [matrice + eax * 1 + ebx]
        mov byte [edi], dl
        inc edi
        add eax, 2

    loop transpun_coloana
    inc ebx
    pop ecx
    loop transpun_linie
final_program:

    call afisare_matrice

    ;bt eax, 31
    ;jnc
           
    
    ;inchidere fisier
    mov eax, 6
    mov ebx, [fdOut]
    int 0x80

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Gata
    mov eax, 0x01
    xor ebx, ebx
    int 0x80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

afisare_matrice:
    push ebp
    mov ebp, esp

    mov edi, transpusa
    mov ecx, 2
afisez_linie:
    push ecx

    mov ecx, 3
    afisez_coloana:
        mov al, byte [edi]
        push ecx
        call binasc
        inc edi

        mov eax, 0x04
        xor ebx, ebx
        mov bl, byte [fdOut]
        mov ecx, spatiu ;;;;spatiul meu este mai mare
        mov edx, 3
        int 0x80
        pop ecx
    loop afisez_coloana

    mov eax, 0x04
    xor ebx, ebx
    mov bl, byte [fdOut]
    mov ecx, endl
    mov edx, 0x01
    int 0x80


    pop ecx
    loop afisez_linie

    mov esp, ebp
    pop ebp
    ret

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


; mov al, byte [edi]
binasc: ;0-255(octet)
    push ebp
    mov ebp, esp
    mov ebx, 0x0a
    xor ecx, ecx
creare_sir:
    xor edx, edx
    div ebx ; eax -> catul, edx -> restul
    add edx, 0x30
    push edx
    inc ecx
    cmp eax, 0x00
    jne creare_sir

afisare_sir:
    pop edx
    mov byte [cifra], dl
    push ecx
    mov eax, 0x04
    xor ebx, ebx
    mov bl, [fdOut]
    mov ecx, cifra
    mov edx, 1
    int 0x80
    pop ecx
    loop afisare_sir

    mov esp, ebp
    pop ebp
    ret