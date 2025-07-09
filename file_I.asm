section	.data
   file_name db 'vect.txt', 0
   msg db 'Arhitectura sistemelor de calcul', 0xa
   len equ  $-msg
 ;;;Lucru cu fisiere
section .bss
   fdOut resb 1
   fdIn  resb 1
   buffer resb  20

   ;creare fisier
   mov  eax, 8
   mov  ebx, file_name
   mov  ecx, 666o     
   int  0x80            
 
   mov [fdOut], al
 
   ;scriere in fisier
   mov	eax, 4
   xor ebx, ebx         
   mov	bl, [fdOut]  
   mov	edx, len      
   mov	ecx, msg      
   int	0x80            
 
   ;inchidere fisier
   mov eax, 6
   xor ebx, ebx
   mov bl, [fdOut]
   int 0x80
 
   ;deschidere fisier pentru citire
   mov eax, 5
   mov ebx, file_name
   mov ecx, 0            
   mov edx, 666o         
   int  0x80
 
   mov  [fdIn], al
 
   ;actualizare pozitie cursor    
   mov eax, 19
   xor ebx, ebx
   mov bl, [fdIn]
   mov ecx, 12
   mov edx, 0
   int 0x80
 
   ;citire din fisier
   mov eax, 3
   xor ebx, ebx
   mov bl, [fdIn]
   mov ecx, buffer
   mov edx, 20
   int 0x80
 
   ;inchidere fisier
   mov eax, 6
   xor ebx. ebx
   mov bl, [fdIn]
   int  0x80    
 
   ;afisare buffer in stdout
   mov eax, 4
   mov ebx, 1
   mov ecx, buffer
   mov edx, 20
   int 0x80