BITS 32
        section .text
        global _start
 
_start: 
        call read_array
	
	mov eax,0x01
	mov ebx,0x00
	int 0x80 


_stack_chk_fail:
	
        mov eax, 0x01
        mov ebx, 0x01
        int 0x80


read_array:
        push ebp
        mov ebp, esp
 

	push dword [canary]
        sub esp, 10     ; alocare spatiu de 10 octeti pe stiva
 
        mov eax, 0x03   ; apelare sys_read
        mov ebx, 0x00   ; citire de la STDIN - consola
        mov ecx, esp    ; stocare octeti in variabila locala
        mov edx, 18     ; citirea unui numar mai mare de octeti decat dimensiunea initial alocata
        int 0x80
 

	mov eax,[ebp-4]
	cmp eax,[canary]
	jne _stack_chk_fail

        mov esp, ebp
        pop ebp
        ret
 
malicious:
        push ebp
        mov ebp, esp
 
        mov eax, 0x04
        mov ebx, 0x01
        mov ecx, sir
        mov edx, len
        int 0x80
 
        mov esp, ebp
        pop ebp
        ret
 
        section .data
sir db 'Cum ai ajuns aici?', 0
len equ $-sir
canary dd 0x557799bb
