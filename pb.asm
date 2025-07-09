

section	.text
   global _start    
 
_start:             
 
   ;creare fisier
   mov  eax, 8
   mov  ebx, file_name
   mov  ecx, 666o     
   int  0x80            
 
   mov [fd_out], eax
 
   ;scriere in fisier
   mov	eax, 4         
   mov	ebx, [fd_out]  
   mov	edx, len      
   mov	ecx, msg      
   int	0x80            
 
   ;inchidere fisier
   mov eax, 6
   mov ebx, [fd_out]
   int 0x80
 
   ;deschidere fisier pentru citire
   mov eax, 5
   mov ebx, file_name
   mov ecx, 0            
   mov edx, 666o         
   int  0x80
 
   mov  [fd_in], eax
 
   ;actualizare pozitie cursor    
   mov eax, 19
   mov ebx, [fd_in]
   mov ecx, 12
   mov edx, 0
   int 0x80
 
   ;citire din fisier
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, buffer
   mov edx, 20
   int 0x80
 
   ;inchidere fisier
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80    
 
   ;afisare buffer in stdout
   mov eax, 4
   mov ebx, 1
   mov ecx, buffer
   mov edx, 20
   int 0x80
 
   mov	eax, 1  
   int	0x80   
 
section	.data
   file_name db 'in.txt', 0
   msg db 'Arhitectura sistemelor de calcul', 0xa
   len equ  $-msg
 
section .bss
   fd_out resb 1
   fd_in  resb 1
   buffer resb  20


