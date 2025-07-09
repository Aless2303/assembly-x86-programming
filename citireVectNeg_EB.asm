BITS 32

section .data
    
    fileIn db 'in.txt', 0
    fileOut db 'out.txt', 0
    buffer db 100 dup (0)
    vector db 10 dup (0)
    fdIn db 0
    fdOut db 0
    semn db 0
    cifra db 0
    spatiu db 0x20, 0

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

    mov ecx, 0 ;;Numaram cate numere avem
    mov esi, buffer
    mov edi, vector
    populareVector: ;;;;;;;;;;;Citire elemente

        call ascbin
        inc esi
        inc ecx
        ;eax -> numar curent

        mov byte [edi], al
        inc edi
        cmp byte [esi], 0x00
    jne populareVector

    push ecx
    ;creare fisier
    mov  eax, 8
    mov  ebx, fileOut
    mov  ecx, 666o     
    int  0x80            
    
    mov [fdOut], al
    pop ecx

    
    ;;;in ecx avem nr de elemente
    mov edi, vector
    afisareVector:
        xor eax, eax
        mov al, byte [edi]
        push ecx
        call binasc
        pop ecx
        inc edi

        push ecx
        mov eax, 0x04
        xor ebx, ebx
        mov bl, [fdOut]         ;;;;File descriptor trebuie definit inainte
        mov ecx, spatiu
        mov edx, 1
        int 0x80
        pop ecx
    loop afisareVector

    ;inchidere fisier
    mov eax, 6
    xor ebx, ebx
    mov bx, [fdOut]
    int 0x80

;;;;;;;;;;;;;Gata
   mov eax, 0x01
   xor ebx, ebx
   int 0x80
;;;;;;;;;;;;;;;;;;;;;;


;mov esi buffer
ascbin:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov byte [semn], al

    mov eax, 0          ;;in eax avem valoarea finala(din ascii in binar)
    mov ebx, 10

creare_numar:
    cmp byte [esi], 0x20
    je final
    cmp byte [esi], 0x00 
    je final
    cmp byte [esi], '-'
    je negativ

    mul ebx; -> eax = eax * 10

    xor edx, edx
    mov dl, byte [esi]
    sub dl, 0x30

    add eax, edx

    inc esi
    jmp creare_numar
negativ:
    mov dl, 1
    mov byte [semn], dl
    inc esi
    jmp creare_numar

final:
    cmp byte [semn], 1
    jne returnAscbin
    neg eax

returnAscbin:

    mov esp, ebp
    pop ebp

    ret



binasc: 
    push ebp
    mov ebp, esp
    bt eax, 0x07
    jnc pozitiv

    neg al
    push eax
    mov al, '-'
    mov byte [cifra], al
    mov eax, 0x04
    xor ebx, ebx
    mov bl, [fdOut]         ;;;;File descriptor trebuie definit inainte
    mov ecx, cifra
    mov edx, 1
    int 0x80
    pop eax

    pozitiv:
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