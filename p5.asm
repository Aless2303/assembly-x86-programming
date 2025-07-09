BITS 32
section .text
	global _start




ridicare:
	;prolog
	push ebp
	mov ebp,esp

	;variabila b(puterea) este la [ebp+8]
	;variabila a(baza) este la [ebp+12]

	mov eax,1
	mov ecx,[ebp+8]

	bucla:
		mul dword [ebp+12]
		loop bucla



	;epilog
	mov esp,ebp
	pop ebp
	ret




_start:
	push 3 ;baza
	push 2 ;putere

	call ridicare
	add esp,8

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


