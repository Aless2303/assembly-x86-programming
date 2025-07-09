BITS 32

section .data
    msg db "Tanase Doru", 0x00
    len equ $ - msg
    aux db len dup(0)

section .text
    global _start

_start:
    mov esi, msg
search_loop:            ;iteram pana cand gasim spatiu(' ')
    inc esi
    mov al, [esi]
    cmp al, ' '         ;eax da seg fault
    jne search_loop
    inc esi
    mov edi, aux
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
prenume_loop:           ; Punem PRENUME in aux
    mov al, [esi]
    sub al, 0x20
    mov [edi], al
    inc esi
    inc edi
    cmp byte [esi], 0x00
    jne prenume_loop

    mov byte [edi], ' '
    inc edi
    mov esi, msg        ;luam de la inceput interarea de la msg
nume_loop:              ;iteram pana gasim iarasi spatiu(' ')
    mov al, [esi]
    mov [edi], al
    inc edi
    inc esi
    cmp byte [esi], ' '
    jne nume_loop

    mov eax, 0xa        ;adaugam \n la final sa afiseze frumos
    mov [edi], al

    mov ecx, len
    mov esi, msg
    mov edi, aux
copy_loop:
    mov al, [edi]
    mov [esi], al
    inc esi
    inc edi
    loop copy_loop
    ;Afisare String
    mov al, 0x04
    mov ebx, 0x01
    mov ecx, aux
    mov edx, len
    int 0x80

    mov eax, 0x01
    xor ebx, ebx
    int 0x80