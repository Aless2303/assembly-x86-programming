BITS 32
section .text
	global _start

_start:
	mov ebx,1


criptare_decriptare:
	mov ecx,len
	mov esi,msg	
	mov edi, cheie		
	
	push ebx
	mov eax,4
	mov ebx,1
	mov ecx,msg
	mov edx,1
	int 0x80
	
	pop ebx
	mov ecx,len
	

bucla_criptare:
	
	mov eax, [esi]
	xor eax, [edi]
	mov [esi], eax
	
	add esi,1
	loop bucla_criptare

	add ebx,1
	cmp ebx,2
	je criptare_decriptare
		
	
	mov eax,1
	mov ebx,0
	int 0x80
	



section .data
	msg db "Milea Alexandru-Nicolae",0x0a
	len equ $ - msg
	cheie db 0x55
