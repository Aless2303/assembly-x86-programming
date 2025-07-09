BITS 32

section .data
    file_name db 'vect.txt', 0
    msg db 'Arhitectura sistemelor de calcul', 0xa
    len equ  $-msg
    vector dw 10 dup(0)
    numar dw  0
    asciiNumber db 5 dup(0) ;;Aici se va salva numarul care va fi convertit din ascii in binar
    endl db 0x0a
    filePrintBuffer db 60 dup(0)
section .bss
    fd_out resb 1
    fd_in  resb 1
    buffer resb  60

section .text
    global _start


ascbin:
    push ebp
    
    mov ebp, esp
 
    mov     ecx, [ebp+12]
    mov     bx, 10
    mov     esi, [ebp+8]

    mov word [numar], 0
 
next_char:
    mov     ax, word [numar]
    mul     bx
    xor     edx, edx
    mov     dl, byte [esi]
    sub     dl, '0'
    add     eax, edx
    mov     word [numar], ax
    inc     esi 
    cmp     byte [esi], 0x0a
    je      end_string
    loop    next_char
 
end_string:
    mov esp, ebp
    pop ebp
    ret

binasc:
    push ebp
    mov ebp, esp

    mov ax, word [ebp + 8]            ; In ax avem rezultatul (ax ptr ca e word)
    mov cx, 0x0a               
    xor esi, esi
    init_loop:
        xor dx, dx                    ; Facem dx 0 
        div cx                         ; Facem impartire cu 10  

        add dl, '0'                     ; Adaugam 0x30
        push edx       ; Inseram valoarea pe indexul care trebuie
        inc esi                         ; Creste indexul

    cmp ax, 0
    jnz init_loop


    mov ecx, esi    ;;in esi este numarul de caractere pe care le avem
    mov esi, 0      ;;in esi acum vom avea indexul la care suntem
    store_loop:
        mov al, byte [esp]
        mov [asciiNumber + esi], al
        inc esi
        pop edx
        cmp esi, ecx
    jne store_loop

    mov edx, ecx

    mov esp, ebp
    pop ebp
    ret

_start:
    ;deschidere fisier pentru citire
    mov eax, 5
    mov ebx, file_name
    mov ecx, 0            
    mov edx, 666o         
    int  0x80
    
    mov  [fd_in], eax

    ;citire din fisier
    mov eax, 3
    mov ebx, [fd_in]
    mov ecx, buffer
    mov edx, 60
    int 0x80   

    ;Afisare la ecran mesajul citit din fisier
    ;mov eax, 4
    ;mov ebx, 1
    ;mov ecx, buffer
    ;mov edx, 60
    ;int 0x80

    ;inchidere fisier
    mov eax, 6
    mov ebx, [fd_in]
    int  0x80 

    mov ecx, 10     ;;iteram printre cele 10 numere
    mov esi, buffer ;;tinem cont pe ce pozitie ne aflam
    mov edi, 0      ;;index pentru vectorul vector
iterate_ascii_numbers:
    push ecx
    mov edx, 0      ;;aici se numara cate cifre are numarul
    
count_digits_of_number:
    mov al, byte [esi]
    mov [asciiNumber + edx * 1], al ;;salvam cifrele numarului in vectorul asciiNumber
    inc edx
    inc esi
    cmp byte [esi], ' '
    je end_count  ;;Daca nu am gasit spatiu inseamna ca numarul mai are cifre
    cmp byte [esi], 0x00
    je end_count  
    jmp count_digits_of_number

end_count:
    inc esi     ;;incrementam esi ca sa treme peste spatiu
    mov ecx, asciiNumber
    push esi    ;;push la esi pentru ca e folosit in functie :(
    push edx    ;;prima data se da dimeansiunea apoi adresa numarului
    push ecx    ;;dam parametri la functie
    call ascbin
    pop ecx
    pop edx
    pop esi

    ;;in numar avem stocat valoarea in binar

    mov ax, [numar]
    mov [vector + edi * 2], ax ;;introducem in vector valorile in binar
    inc edi                     ;;incrementam indexul

    pop ecx
    loop iterate_ascii_numbers


    ;for(int i = 0; i < 9; i++)
    ;{
    ;    for (int j = i + 1; j < 10; j++)
    ;        if(v[i] < v[j])
    ;        swap
    ;}

    ;;esi = i
    ;;edi = j

    mov esi, 0  ; i = 0
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


;;Transformare inapoi din binar in ascii
    mov ecx, 10
    mov esi, 0
print_vector:
    mov edx, 10
    sub edx, ecx

    mov ax, word [vector + edx * 2]
    push ecx            ;;push ecx pentru ca functia binsac foloseste ecx
    push esi            ;;push esi pentru ca functia foloseste esi
    push ax
    call binasc
    pop ax
    pop esi
    mov ecx, edx    ;;Luam numerele din asciiNumber si le bagam in buffer
    mov ebx, 0      ;;Index pentru asciiNumber
copy_number:
    mov eax, [asciiNumber + ebx]
    mov [filePrintBuffer + esi], eax
    inc esi
    inc ebx

    loop copy_number
    mov byte [filePrintBuffer + esi], ' '
    inc esi


    pop ecx

    mov eax, 0x04
    mov ebx, 0x01
    push ecx
    mov ecx, asciiNumber
    int 0x80

    mov eax, 0x04
    mov ebx, 0x01
    mov ecx, endl
    mov edx, 0x01
    int 0x80
    pop ecx

    loop print_vector

    ;;deschidere fisier
    mov eax, 5
    mov ebx, file_name
    mov ecx, 1            
    mov edx, 666o         
    int  0x80

    mov [fd_out], eax
    ;scriere in fisier
    mov	eax, 4         
    mov	ebx, [fd_out]  
    mov	edx, esi      
    mov	ecx, filePrintBuffer     
    int	0x80            
    
    ;inchidere fisier
    mov eax, 6
    mov ebx, [fd_out]
    int 0x80

    ;sys_exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
