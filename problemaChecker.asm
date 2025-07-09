BITS 32
;;[source1.asm] Criptarea unui vector de octeți, de maxim 50 octeți, aflat pe prima linie a fișierului de intrare in.txt. Algoritmul de criptare se bazează 
;;pe un cifru XOR simplu care utilizează o cheie pe 2 octeți aflată în fișierul de intrare, pe al doilea rând. Salvați vectorul criptat în fișierul de ieșire 
;;out1.txt. Vectorul de intrare și cheia de criptare sunt în format ASCII iar vectorul de ieșire, i.e., vectorul criptat, trebuie salvat în format hexazecimal. 
;;Checker-ul testează programul rezultat pe 5 exemple, dintre care 3 sunt incluse în tabelul de mai jos. 
section .data
    vect db 50 dup(0)
    key db 2 dup(0)
    fileIn db 'in.txt', 0
    fileOut db 'out1.txt', 0
    char_to_print db 0
    vectHex db 100 dup(0)

section .bss
   fdOut resb 1
   fdIn  resb 1
   buffer resb  52


section .text
    global _start


_start:
    ;;;;;;;;;Prelucrare fisier IN
    ;deschidere fisier pentru citire
    mov eax, 5
    mov ebx, fileIn
    mov ecx, 0            
    mov edx, 666o         
    int  0x80
    
    mov  [fdIn], eax

    ;citire din fisier
    mov eax, 3
    xor ebx, ebx
    mov bl, [fdIn]
    mov ecx, buffer
    mov edx, 52
    int 0x80   

    ;inchidere fisier
    mov eax, 6
    xor ebx, ebx
    mov bl, [fdIn]
    int  0x80 

    mov esi, vect
    mov edi, buffer

    mov ecx, 0
readVect:       ;;;;Citire vector de caractere
    mov al, byte [edi]
    mov byte [esi], al

    inc ecx 

    inc esi
    inc edi


    cmp byte [edi], 0x0a
    jne readVect

    ;;;;;DEBUG ONLY
    ; mov eax, 0x04
    ; mov ebx, 0x01
    ; mov edx, ecx
    ; push ecx
    ; mov ecx, vect
    ; int 0x80
    ; pop ecx

    ;;;;;Inseram octetii de cheie
    inc edi
    mov esi, key
    mov al, byte [edi]
    mov byte [esi], al
    inc edi
    inc esi
    mov al, byte [edi]
    mov byte [esi], al
    ;;;;;;;;;

    mov edi, ecx
    mov esi, vect
cryptLoop:

    mov eax, edi
    sub eax, ecx
    and eax, 1
    jnz odd

    even:
        mov al, byte [esi]
        xor al, byte [key]
        mov byte [esi], al
    jmp done

    odd:
        mov al, byte [esi]
        xor al, byte [key + 1]
        mov byte [esi], al
    done:
        inc esi
    loop cryptLoop


    mov ecx, edi
    mov esi, vect
    push edi
storeCrypted:
    ;;;;;;Stocam variabila criptata din hex in vectHex
    push ecx    ;;;push ecx pt ca functia foloseste ecx
    push esi
    call mdump
    pop esi
    pop ecx
    inc esi
    loop storeCrypted


    ; mov eax, 0x04
    ; mov ebx, 0x01
    ; mov ecx, vectHex
    ; mov edx, 100
    ; int 0x80

    ;creare fisier
    mov  eax, 8
    mov  ebx, fileOut
    mov  ecx, 666o     
    int  0x80            
    
    mov [fdOut], al
    pop edi
    add edi, edi
    ;scriere in fisier
    mov	eax, 4        
    xor ebx, ebx 
    mov	bl, [fdOut]  
    mov	edx, edi      
    mov	ecx, vectHex      
    int	0x80  

    ;inchidere fisier
    mov eax, 6
    xor ebx, ebx
    mov bl, [fdOut]
    int 0x80
 

    mov eax, 0x01
    xor ebx, ebx
    int 0x80


mdump:
    push    ebp
    mov     ebp, esp
    mov     eax, [ebp + 8]

    ;;;;;;;;;;;;;;;;append la variabila vectHex
    mov edi, vectHex
    dec edi
stillIncrement:
    inc edi
    cmp byte [edi], 0
    jne stillIncrement

    mov     bl, byte [eax]
    mov     ecx, 2            ; 2 hex digits in a BYTE

dump_loop:
    rol     bl, 4            ; Rotate left by 4 bits
    mov     dl, bl            ; Lower nibble to DL
    and     dl, 0Fh           ; Mask high nibble
    add     dl, '0'           ; Convert to ASCII
    cmp     dl, '9'           ; Check if it's a digit
    jbe     print_digit       ; Jump if less than or equal to '9'
    add     dl, 39            ; Adjust for letters a-f

print_digit:
    mov     [edi], dl
    inc     edi
    loop    dump_loop

    mov     esp, ebp
    pop     ebp
    ret