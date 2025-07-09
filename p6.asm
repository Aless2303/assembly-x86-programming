BITS 32
section .text
	global _start


cmmdc:
	;prolog
	push ebp	
	mov ebp,esp


	while:
		;temp = b ([ebp+12])
		xor ebx,ebx
		mov ebx, dword [ebp+12]
		
		;b=a%b   (b = [ebp+12])
		mov eax,dword [ebp+8]
		div ebx
		mov [ebp+12],edx
		xor edx,edx		

		;a=temp(temp = ebx)
		mov [ebp+8],ebx
		cmp dword [ebp+12],0
		jg while


	
	;epilog
	mov esp,ebp
	pop ebp
	ret

_start:
	push 39 ; b
	push 26 ; a
	
	call cmmdc
	add esp,8
	
	mov eax,dword [esp-8]
	call print_nr

	mov eax,1
	xor ebx,ebx
	int 0x80

print_nr:
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

                mov ecx,ebx
                add ecx,48
                mov [caracter],ecx
                mov ecx,caracter
                mov eax,4
                mov ebx,1
                mov edx,1
                int 0x80

                pop ecx
                dec ecx
                cmp ecx,0
                jnz afiseaza_stiva
	ret



section .data
	rezultat dd 0
	caracter db 0

