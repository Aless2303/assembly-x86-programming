section	.text
   global _start


	%define SYS_OPEN 5
   	%define SYS_STAT 106
   	%define SYS_READ 3
   	%define SYS_WRITE 4
  	%define SYS_CLOSE 6



_start:
	;deschidere fisier pentru citire
	mov eax, SYS_OPEN
	mov ebx, file_name_in
	mov ecx,0
	mov edx,666o
	int 0x80

	mov [fd_in],eax
	
	;informatii despre fisier
	mov eax,SYS_STAT
	mov ebx, file_name_in
	mov ecx,stat_buffer
	int 0x80

	;dimensiunea fisierului se afla la offsetul 48 in str stat
	mov eax, [stat_buffer + 48]
   	mov dword [file_size], eax
	
	
	;citire din fisier
	mov eax, SYS_READ
	mov ebx, [fd_in]
	mov ecx,buffer
	mov edx,60
	int 0x80
	
	;inchidere fisier
	mov eax,SYS_CLOSE
	mov ebx,[fd_in]
	int 0x80

	
	;incep crearea vectorului vector_int
	;incarc adresa de inceput a vectorului_int in registru
	lea esi, [vector_int]
	mov dword [index], 0


	;conversie buffer din ascii in int-uri:
	mov ecx,buffer
	convert_loop:
		mov al,byte[ecx]
		cmp al,0 ;verific daca am terminat bufferul
		je end_convert_loop
		cmp al,32
		je skip_space
		call atoi
	skip_space:
		mov edi,[index]
		mov dword [esi+edi*4],eax
		inc dword [index]
		inc ecx
		jmp convert_loop
	end_convert_loop:
	mov edi,[index]
        mov dword [esi+edi*4],eax
        inc dword [index]

	
	;afisare vector_int:
	lea esi,[vector_int]
	mov ecx,0


	;continuare afisare:
	print_loop:
		cmp ecx,[index]
		je end_loop
		
		mov eax,[esi+ecx*4]
		call print_nr				
		
		inc ecx
		jmp print_loop
	end_loop:



	;terminare program:
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




atoi:
	xor eax,eax
	mov edi,ecx
atoi_loop:
	movzx edx,byte [edi]
	test edx,edx ;verific daca am ajuns la finalul sirului
	jz atoi_done
	cmp edx,'0'
	jb atoi_done
	cmp edx, '9'
	ja atoi_done
	sub edx,'0'
	imul eax,10
	add eax,edx
	inc edi
	jmp atoi_loop
atoi_done:
	ret	
	







section .data
	file_name_in db 'in1.txt' ,0
	file_name_out db 'out1.txt' ,0
	file_size dd 0
	vector_int dd 10 dup(0)
	index dd 0
	caracter db 0



section .bss
	stat_buffer resb 144
	fd_out resb 1
	fd_in resb 1
	buffer resb 60
