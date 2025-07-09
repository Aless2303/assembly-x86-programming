BITS 32
section .text
        global _start


_start:
        xor eax,eax
        mov ecx,5
        mov esi, array
        call adunare_array
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
		



        mov eax,1
        xor ebx,ebx
        int 0x80

adunare_array:
        xor ebx,ebx
        mov ebx,[esi]
        add eax,ebx
        add esi,4
        loop adunare_array
        ret


section .data
        array dd 1,2,3,4,5
	caracter db 0
