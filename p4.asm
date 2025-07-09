BITS 32
section .text
	global _start



_start:
	mov esi,matrice_initiala
	

	xor eax,eax
	mov ebx,4 ;a cata coloana o adunam
	add esi,ebx
	dec esi
	mov ecx,nr_linii
	call adunare_coloana

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


adunare_coloana:
	xor ebx,ebx
	mov bl,[esi]
	add eax,ebx
	add esi,4
	loop adunare_coloana
	ret
	



section .data
	matrice_initiala db 10h, 11h, 12h, 13h
                         db 14h, 15h, 16h, 17h
                         db 18h, 19h, 1Ah, 1Bh
                         db 1Ch, 1Dh, 1Eh, 1Fh
	caracter db 0	
	nr_linii equ 4


