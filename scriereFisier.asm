BITS 32

%include 'functions.asm'

section .text
    global _start


%define SYS_OPEN 5
%define SYS_STAT 106
%define SYS_READ 3
%define SYS_WRITE 4
%define SYS_CLOSE 6



_start:
    mov eax,53
    mov [alesia],eax

    mov esi,file_out
    mov eax,2
    call fileOpen
    mov [fd],eax

    mov esi,string_afisare  
    mov eax,[fd]
    call fileWrite

    mov eax,1
    xor ebx,ebx
    int 0x80


section .data
    file_out db 'fileOUT.txt', 0
    string_afisare db 'Alesia e frumoasa tare.', 0
    fd db 0
    alesia db 0


section .bss
    val_int resb 10
    buffer resb 1024
	fd_in resb 1
    fd_out resb 1



