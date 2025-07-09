BITS 32

%include 'functions.asm'

section .text
    global _start

;Un fișier de intrare, e.g., in.txt, conține un vector de 10 numere despărțite prin spațiu. 
;Numerele sunt din intervalul [0, 216-1]. Scrieți un program în assembly care încarcă vectorul în memorie, 
;îl sortează și îl salvează sortat într-un fișier de ieșire, e.g., out.txt. Tot în fișierul de ieșire, pe următorul rând, 
;sunt salvate valorile minim și maxim din vectorul respectiv.


%define SYS_OPEN 5
%define SYS_STAT 106
%define SYS_READ 3
%define SYS_WRITE 4
%define SYS_CLOSE 6


_start:

    ;deschid fisierul din care o sa citesc
    mov eax,SYS_OPEN
    mov ebx, file_name_in
    mov ecx,0
    mov edx,666o
    int 0x80

    mov [fd_in],eax

    ;citesc din fisier in buffer:
    mov eax,SYS_READ   
    mov ebx, [fd_in]
    mov ecx,buffer
    mov edx,60
    int 0x80

    ;mov eax,0x04
    ;mov ebx,0x01
    ;mov ecx,buffer
    ;mov edx,60
    ;int 0x80

    ;inchidere fisier
    mov eax,SYS_CLOSE
    mov ebx,[fd_in]
    int 0x80


    mov ecx,10
    xor edx,edx
    mov ecx,0
    mov edi, val_int
    mov esi,buffer
    mov eax,' '
    bucla:
        mov esi,buffer
        mov eax,' '
        call strtok
        
        ;mov esi,val_int
        ;call string.PrintEndl

        
        mov esi,val_int
        call string.atoi

        call string.PrintNumberEndl

        terminare_atoi:
            mov [vector_int+ecx*4],eax
        
        inc ecx
        cmp ecx,10
        jl bucla

    ;mov esi,vector_int
    ;call string.PrintEndl

    mov eax,10
    mov esi,vector_int
    call Bubble_Sort_Dword


    mov eax,5
    mov esi,vector_words
    call Bubble_Sort_Word

    inchidere:
    mov eax,1
    xor ebx,ebx
    int 0x80

Bubble_Sort_Dword:
    push ebp
    mov ebp, esp

    push ebx
    push edx
    push eax
    push edi 
    push esi
    push ecx

    sort_loop:
        ; Presupunem ca nu sunt necesare schimbari
        mov ebx, 0         ; EBX va tine evidenta schimbarilor

        ; Itereaza prin vector
        mov edi, 0         ; EDI va fi indexul pentru comparare
    compare_loop:
        ; Compara elementele adiacente
        mov eax, [esi + edi*4]      ; EAX contine elementul curent
        mov edx, [esi + edi*4 + 4]  ; EDX contine urmatorul element
        
        ; Daca elementul curent este mai mare, interschimba-le
        cmp eax, edx
        jle no_swap
        ; Interschimba elementele
        mov [temp], edx
        mov [esi + edi*4 + 4], eax
        mov eax, [temp]             ; Folosim EAX pentru a muta valoarea temporara
        mov [esi + edi*4], eax
        
        ; Marcam ca a avut loc o schimbare
        inc ebx

    no_swap:
        ; Incrementam indexul
        inc edi
        cmp edi, ecx
        jl compare_loop  ; Continua daca nu am ajuns la finalul vectorului

        ; Daca au fost schimbari, repetam sortarea
        cmp ebx, 0
        jg sort_loop  ; Repeta daca au fost schimbari

        ; Daca nu au fost schimbari, sortarea este completa
 .Exit:
        pop ecx
        pop esi
        pop edi
        pop eax
        pop edx
        pop ebx

        mov esp, ebp
        pop ebp
        ret


Bubble_Sort_Word:
    push ebp
    mov ebp, esp

    push ebx
    push edx
    push eax
    push edi 
    push esi
    push ecx

    ; Initializeaza registrii necesari
    mov ecx, eax         ; ECX contine numarul de elemente din vector (specificat in EAX)
    shl ecx, 1           ; ECX *= 2, pentru ca fiecare element are 2 octeti (word)

    Word_sort_loop:
        ; Presupunem ca nu sunt necesare schimbari
        mov ebx, 0         ; EBX va tine evidenta schimbarilor

        ; Iterează prin vector
        mov edi, 0         ; EDI va fi indexul pentru comparare
    Word_compare_loop:
        ; Compară elementele adiacente
        mov ax, [esi + edi]      ; AX conține elementul curent
        mov dx, [esi + edi + 2]  ; DX conține următorul element
        
        ; Dacă elementul curent este mai mare, interschimbă-le
        cmp ax, dx
        jle Word_no_swap
        ; Interschimbă elementele
        mov [temp], dx
        mov [esi + edi + 2], ax
        mov ax, [temp]             ; Folosim AX pentru a muta valoarea temporară
        mov [esi + edi], ax
        
        ; Marcam ca a avut loc o schimbare
        inc ebx

    Word_no_swap:
        ; Incrementăm indexul
        add edi, 2
        cmp edi, ecx
        jl Word_compare_loop  ; Continuă dacă nu am ajuns la finalul vectorului

        ; Dacă au fost schimbări, repetăm sortarea
        cmp ebx, 0
        jg Word_sort_loop  ; Repetă dacă au fost schimbări

        ; Dacă nu au fost schimbări, sortarea este completă
    Word_Exit:
        pop ecx
        pop esi
        pop edi
        pop eax
        pop edx
        pop ebx

        mov esp, ebp
        pop ebp
        ret


section .data
    vector_words dw 81,14,53,23,73
	file_name_in db 'in1.txt' ,0
    ;buffer db 60 dup(0)

section .bss
    val_int resb 10
    vector_int resd 10
    buffer resb 60
	fd_out resb 1
	fd_in resb 1
    temp resw 1


