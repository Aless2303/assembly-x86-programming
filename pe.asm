section .text
   global _start


        %define SYS_OPEN 5
        %define SYS_STAT 106
        %define SYS_READ 3
        %define SYS_WRITE 4
        %define SYS_CLOSE 6




_start:
	;deschidere fisier citire
	mov eax,SYS_OPEN
	mov ebx, file_name_in
	mov ecx,0
	mov edx, 666o
	int 0x80
	mov [fd_in],eax


	mov eax,SYS_STAT
	mov ebx,file_name_in
	mov ecx,stat_buffer
	int 0x80

	mov eax, [stat_buffer+48]
	mov dword [file_size],eax


	;citire din fisier
	mov eax,SYS_READ
	mov ebx,[fd_in]
	mov ecx,buffer
	mov edx,file_size
	int 0x80


	;afisare buffer
	mov eax,SYS_WRITE
	mov ebx,1
	mov ecx,buffer
	mov edx,file_size
	int 0x80


	mov eax,SYS_CLOSE
	mov ebx,[fd_in]
	int 0x80


	;formare vector
	mov esi,buffer
	mov edi,numbers

	convert_loop:
		mov edx,0
		mov eax,0
	read_digit_loop:
		lodsb
		cmp al,10
		je convert_complete
		cmp al,' '
		je convert_complete
		
		sub al,'0'
		imul edx,edx,10
		add edx,eax
		jmp read_digit_loop
	
	convert_complete:
		;am convertit numarul in eax
		mov [edi],edx
		add edi,4
		cmp al,10
		je end_convert_loop

		jmp convert_loop
	end_convert_loop:
	

	call buuble_sort

	mov esi,numbers
	mov ecx,10
	loop_start:
		mov eax,[esi]
		push ecx
		call print_nr

		mov eax,4
		mov ebx,1
		mov ecx,32
		mov edx,1
		int 0x80

		pop ecx
		add esi,4
		loop loop_start
	

	;;deschidere fisier out
	mov eax,4
	mov ebx,file_name_out
	mov ecx,0
	mov edx,666o
	int 0x80
	mov [fd_out],eax

	mov eax,4
	mov ebx,[fd_in]
	mov edx,file_size
	mov ecx,buffer
	int 0x80
	
	


	exit_program:
	mov eax,1
	xor ebx,ebx
	int 0x80



buuble_sort:
	mov ecx,9
	for1:
		mov esi,numbers	
		push ecx
		mov ecx,9
		for2:
			mov eax,[esi]
			cmp eax,[esi+4]
			jg swap
			return_from_swap:
			add esi,4
			loop for2
		

		pop ecx
		loop for1
	ret



swap:
	;interschimb ce am in eax
	mov edx,[esi+4]
	mov [esi],edx
	mov [esi+4],eax
	

	jmp return_from_swap



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
        file_name_in db 'in1.txt' ,0
        file_name_out db 'out1.txt' ,0
        file_size dd 0
	stat_buffer resb 144
        caracter db 0
	numbers times 10 db 0
	separator db " ",0 
	

section .bss
        fd_out resb 1
        fd_in resb 1
        buffer resb 60






