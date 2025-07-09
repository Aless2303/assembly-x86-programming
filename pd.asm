    section .text
       global _start
     
    _start:
            mov     edi, v1
            mov     esi, v2
            xor     eax, eax
    .L2:
            movaps   xmm0, [edi]
            movaps   xmm1, [esi]
            addps    xmm0, xmm1
            movaps   [edi], xmm0
            add     esi, 16
            add     edi, 16
            add     eax, 1
            cmp     eax, 4
            jne     .L2
     
      ;deschidere fisier pentru scriere
       mov eax, 5
       mov ebx, file_name
       mov ecx, 101o
       mov edx, 666o
       int  0x80
     
       mov  [fd_out], eax
     
       ;scriere in fisier
       mov  eax, 4
       mov  ebx, [fd_out]
       mov  edx, 16
       mov  ecx, v1
       int  0x80
       ;inchidere fisier
       mov eax, 6
       mov ebx, [fd_out]
       int 0x80
     
       mov  eax, 1
       int  0x80
     
    section .data
       a db 1
       v1 dd 3.14, 1.5, 2.5, 3.5, 4.5, 5.5, 6.0, 7.6, 8.5, 9.5, 10.5, 11.5, 12.5, 13.5, 14.5, 15.5
       v2 dd 16.5, 17.5, 18.5, 19.5, 20.5, 21.5, 22.5, 23.5, 24.5, 25.5, 26.5, 27.5, 28.0, 29.0, 30.1, 31.2
       file_name db 'out2.txt', 0
     
    section .bss
       fd_out resb 1
