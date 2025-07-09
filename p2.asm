BITS 32
section .text
	global _start


_start:
	mov ecx,4 ; linii
	mov esi,matrice_initiala
	mov edi,matrice_transpusa
	
	call mutare_mat_in_transpusa
	
	mov ecx,16
	mov edi,matrice_transpusa
	call print_matrice

	mov eax,1
	xor ebx,ebx
	int 0x80

mutare_mat_in_transpusa:
	push ecx
	mov ecx,4
	call mutare_coloane
	pop ecx
	loop mutare_mat_in_transpusa
	ret

mutare_coloane:
	xor eax,eax
	mov al,[esi]
	add al,48
	mov [edi],al
	inc edi
	inc esi
	loop mutare_coloane	
	ret

print_matrice:
	push ecx
	mov eax,4
	mov ebx,1
	mov ecx,edi
	mov edx,1
	int 0x80
	inc edi
	pop ecx
	loop print_matrice
	ret
	

	





section .data
	matrice_initiala db 10h, 11h, 12h, 13h
			 db 14h, 15h, 16h, 17h
			 db 18h, 19h, 1Ah, 1Bh
			 db 1Ch, 1Dh, 1Eh, 1Fh
	matrice_transpusa db 16 dup(0)
