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

        push eax

        ;incrementez contorul, cate numere am in stiva
        mov eax,[contor]
        inc eax
        mov [contor],eax


        ;call string.PrintNumberEndl
        
        inc ecx
        cmp ecx,10
        jl bucla


    ;ordonez stiva total
    call ordoneaza_stiva
    ;afisez stiva
    mov ecx,[contor]

    ;deschid fisierul cu fileOpen
    mov esi,file_out
    mov eax,1
    call fileOpen



    ;salvez fileDescriptorul
    mov [fd],eax

    afiseaza:
        pop eax
        call print_nr_in_file
        loop afiseaza

    ;inchid fisierul
    call fileClose



    inchidere:
    mov eax,1
    xor ebx,ebx
    int 0x80


;variabile necesare jos in .data: 
;     fd db 0
;     caracter db 0

;Afiseaza numarul din registrul eax in fisierul cu respectivul fd(file descriptor)
;!NU SCRIE CU APPEND, DESCHIZI FISIERUL SI STERGE TOT CE E IN EL
;Ca sa mearga: deschizi fisierul inainte 
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



ordoneaza_stiva:
    push ebp
    mov ebp, esp

    push ebx
    push edx
    push eax
    push edi 
    push esi
    push ecx

    mov ecx, [contor]
    dec ecx

    ordonare_externa:
        xor edx, edx
    ordonare_interna:
        cmp edx,ecx
        je noswap

        lea eax, [ebp + 8 + edx * 4]
        lea ebx, [eax + 4]
    
        mov esi, [eax]
        mov edi, [ebx]
    
        cmp esi, edi
        jle noswap
    
    ; Swap
        mov [eax], edi
        mov [ebx], esi

    noswap:
        inc edx
        cmp edx, ecx
        jl ordonare_interna

        dec ecx
        jns ordonare_externa

    pop ecx
    pop esi
    pop edi
    pop eax
    pop edx
    pop ebx

    mov esp, ebp
    pop ebp
    ret



ordoneaza_stiva2:
    push ebp
    mov ebp, esp

    push ebx
    push edx
    push eax
    push edi 
    push esi
    push ecx

    mov ecx, [contor]
    dec ecx


    xor edx, edx
    ordonare_interna2:
        cmp edx,ecx
        je noswap2

        lea eax, [ebp + 8 + edx * 4]
        lea ebx, [eax + 4]
    
        mov esi, [eax]
        mov edi, [ebx]
    
        cmp esi, edi
        jle noswap2
    
    ; Swap2
        mov [eax], edi
        mov [ebx], esi

    noswap2:
        inc edx
        cmp edx, ecx
        jl ordonare_interna2


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
	file_name_in db 'in1.txt' ,0
    file_out db 'out.txt', 0
    contor db 0
    fd db 0
    nr_cifre db 0 ;3 
    rezultat db 10 dup(0)
    suma db 0
    caracter db 0

section .bss
    val_int resb 10
    buffer resb 60
	fd_out resb 1
	fd_in resb 1


