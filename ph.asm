BITS 32

%include 'functions.asm'

section .text
    global _start


;citeste dintr-un fisier o matrice de 4 pe 4, aceasta este pusa pe o linie
;o afisezi cum trebuie in alt fisier


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

    ;citesc linia din fisier
    mov edi,buffer
    call fileReadLine

    ;;test daca este buna llinia
    ;mov esi,buffer
    ;call string.PrintEndl

    ;inchidere fisier
    mov eax,SYS_CLOSE
    mov ebx,[fd_in]
    int 0x80

    mov ebx,0
    mov [coloana],ebx

    mov esi,file_out
    mov eax,1
    call fileOpen
    mov [fd],eax

    xor edx,edx
    mov edx,0
    mov ecx,0
    mov edi, val_int
    mov esi,buffer
    mov eax,' '
    bucla_afisare:
        mov esi,buffer
        mov eax,' '
        call strtok 


        mov esi,val_int
        call string.atoi

        call string.PrintNumberEndl

        call print_nr_in_file

        cmp ecx,3
        je print_endl_in_file
        cmp ecx,7
        je print_endl_in_file
        cmp ecx,11
        je print_endl_in_file
        cmp ecx,15
        je print_endl_in_file

        back:


        inc ecx
        cmp ecx,16
        jl bucla_afisare



    mov eax,1
    xor ebx,ebx
    int 0x80

print_endl_in_file:
    ;push ebp
    ;mov ebp, esp

    push ebx
    push edx
    push eax
    push edi 
    push esi
    push ecx

    mov eax,[fd]
    mov ebx,0x0A
    mov [caracter],ebx
    mov esi,caracter   
    call fileWrite

    pop ecx
    pop esi
    pop edi
    pop eax
    pop edx
    pop ebx

    ;mov esp, ebp
    ;pop ebp
    jmp back

;variabile necesare jos in .data: 
;     fd db 0
;     caracter db 0

;Afiseaza numarul din registrul eax in fisierul cu respectivul fd(file descriptor)
;!NU SCRIE CU APPEND, DESCHIZI FISIERUL SI STERGE TOT CE E IN EL
;Ca sa mearga: deschizi fisierul inainte 
;numere sunt numere pe bune nu in ascii
; apelezi pentru toate numerele care vrei
;inchizi fisierul
print_nr_in_file:
    push ebp
    mov ebp, esp

    push ebx
    push edx
    push eax
    push edi 
    push esi
    push ecx

	mov ebx,10
        mov ecx,0
        adauga_in_stiva_nr:
                xor edx,edx
                div ebx
                push edx
                inc ecx
                cmp eax,0
                jnz adauga_in_stiva_nr

        afiseaza_stiva:
                xor ebx,ebx
                pop ebx
                push ecx

                mov eax,[fd]
                add ebx,48
                mov [caracter],ebx
                mov esi,caracter
                call fileWrite


                pop ecx
                dec ecx
                cmp ecx,0
                jnz afiseaza_stiva

    
	mov eax,[fd]
    mov ebx,0x20
    mov [caracter],ebx
    mov esi,caracter   
    call fileWrite

    
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
    file_name_in db 'Inlab8Matrice' ,0
    file_out db 'Outlab8Matrice', 0
    coloana db 0
    fd db 0
    nr_cifre db 0 ;3 
    rezultat db 10 dup(0)
    suma db 0
    caracter db 0

section .bss
    val_int resb 10
    buffer resb 1024
	fd_in resb 1
    fd_out resb 1






