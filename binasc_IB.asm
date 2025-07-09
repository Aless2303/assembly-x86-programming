
;;;Transformarea unui octet dat prin 'al' intr-o valoare ascii, si afisarea acestuia intr-un fisier

section .data
    fdOut db 0  ;;;File descriptor
    cifra db 0 ;;;cod ascii cifra curenta

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