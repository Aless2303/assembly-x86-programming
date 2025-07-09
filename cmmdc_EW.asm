BITS 32

section .data
    fileIn db 'in.txt', 0
    fileOut db 'out.txt', 0
    fdIn db 0
    fdOut db 0
    buffer db 10
    num1 dw 0
    num2 dw 0
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
    mov edx, 20
    int 0x80
    
    ;inchidere fisier
    mov eax, 6
    xor ebx, ebx
    mov bl, [fdIn]
    int  0x80    

    mov ecx, 2 ;;stim ca avem FIX 2 elemente din matrice
    mov esi, buffer
    mov edi, num1
populareVector:

    call ascbin
    inc esi

    ;eax -> numar curent

    mov word [edi], ax
    mov edi, num2
    loop populareVector


    mov ax, word [num1]
    mov bx, word [num2]

cmmdcLoop:
    cmp ax, bx
    je cmmdcFinal

    cmp ax, bx
    jg bigger
    sub bx, ax

    jmp cmmdcLoop
bigger:
    sub ax, bx

    jmp cmmdcLoop

cmmdcFinal:
    push eax
    ;creare fisier
    mov  eax, 8
    mov  ebx, fileOut
    mov  ecx, 666o     
    int  0x80            
    
    mov [fdOut], al    
    pop eax     
    
    call binasc

    ;inchidere fisier
    mov eax, 6
    xor ebx, ebx
    mov bl, [fdOut]
    int 0x80

;;;;;;;;;;;;;;;;;::Gata
   mov eax, 0x01
   xor ebx, ebx
   int 0x80
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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