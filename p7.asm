BITS 32
section .text
	global _start


_start:
	push 4
	push 9

        mov eax,dword [esp]
        call print_nr
        mov eax,dword [esp+4]
        call print_nr


	call swap
	
	mov eax,dword [esp]
	call print_nr
	mov eax,dword [esp+4]
	call print_nr
	
	add esp,8
		


	mov eax,1
	xor ebx,ebx
	int 0x80


swap:
	;prolog:
	push ebp
	mov ebp,esp

	;lea eax,[ebp+8]
	;lea ebx,[ebp+12]

	;mov ecx,[eax]
	;mov edx,[ebx]
	;mov [eax],edx
	;mov [ebx],ecx



	mov eax,[ebp+8]
	mov ecx,eax

	mov ebx,[ebp+12]
	mov edx,ebx

	mov [ebp+8],edx
	mov [ebp+12],ecx


	;epilog
	mov esp,ebp
	pop ebp
	ret



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
