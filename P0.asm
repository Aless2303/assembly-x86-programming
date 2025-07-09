BITS 32

%include 'functions.asm'


section .data
    table times 9 db 0x5F ; _
    rand db 0 ; 0/1
    msgJucator1 db "Jucatorul 1(X)", 0
    msgJucator2 db "Jucatorul 2(0)", 0
    msgWin db "A castigat!", 0
    msgInvalid db "Optiune invalida(1<=N<=3)!", 0
    msgLinie db "Linie=", 0
    msgColoana db "Coloana=", 0
    msgCheck db "Pozitie deja completata!",0
    msgRemiza db "Remiza!", 0
section .bss
    optiune resb 3
section .text
    global _start

_start:

    .loopGame:
        call _printTable
        call _insert
        call _checkWin
        jmp .loopGame


.exit:
    call exit


; take eax as parameter 
; returns in edx 1 true / 0 false
_checkPosition:

    push ebp
    mov ebp, esp

    mov bl, [table + eax]
    cmp bl, byte 0x5F
    jne .checkFalse 

    .checkTrue:
        mov edx, 1
        jmp .checkExit

    .checkFalse:
        mov edx, 0
        jmp .checkExit
    
    .checkExit:


    mov esp, ebp
    pop ebp
ret
_insert:
    push ebp
    mov ebp, esp

    cmp [rand], byte 1
    je .msgPlayer2
    
    .msgPlayer1:
        mov esi, msgJucator1
        call string.PrintEndl


        jmp .msgExit
    .msgPlayer2:
        mov esi, msgJucator2
        call string.PrintEndl
        
        jmp .msgExit
    .msgExit:

        jmp .readLine

    .checkInalid:
        mov esi, msgCheck
        call string.PrintEndl

    .invalidLine:
        mov esi, msgInvalid
        call string.PrintEndl
    
    .readLine:


        mov esi, msgLinie
        call string.Print

        mov esi, optiune
        mov edx, 2
        call string.Read

        ; iesire din joc
        cmp [optiune], byte 'Q'
        je _start.exit  
        
        call string.atoi

        mov ebx, 1
        mov ecx, 3

        call compare

        cmp edx, 1
        jne .invalidLine


    push eax ; am linia
    jmp .readColumn
    ;  COLOANAAAA!!!!!!!!!


    .invalidColumn:
        mov esi, msgInvalid
        call string.PrintEndl
    
    .readColumn:


        mov esi, msgColoana
        call string.Print

        mov esi, optiune
        mov edx, 2
        call string.Read

        ; iesire din joc
        cmp [optiune], byte 'Q'
        je _start.exit


        call string.atoi

        mov ebx, 1
        mov ecx, 3

        call compare

        cmp edx, 1
        jne .invalidColumn

    mov ebx, eax
    pop eax ; index coloana

    dec eax
    dec ebx

    mov ecx, 3
    mul ecx

    add eax, ebx
    call _checkPosition

    cmp edx, 0x00
    je .checkInalid

    call _insertInTable

    mov esp, ebp
    pop ebp
ret

_checkWin:

    push ebp
    mov ebp, esp

    
    xor ecx, ecx
    .remiza:

        cmp [table + ecx], byte '_'
        je .exitDraw

        inc ecx
        cmp ecx, 9
        jl .remiza

    mov esi, msgRemiza
    call string.PrintEndl
    call _start.exit
    
    .exitDraw:



    mov esp, ebp
    pop ebp
    ret

; takes parameter eax
_insertInTable:
    push ebp
    mov ebp, esp

    cmp [rand], byte 0x00
    jne .insertPlayer2

    .insertPlayer1:
        mov [table + eax], byte 'X'
        mov [rand], byte 0x01
        jmp .insertExit
    .insertPlayer2:
        mov [table + eax], byte 'O'
        mov [rand], byte 0x00
        jmp .insertExit
    .insertExit:

    mov esp, ebp
    pop ebp

ret
_printTable:

    push ebp
    mov ebp, esp

    xor edx, edx ; i
    xor ecx, ecx ; j
    mov esi, table

    .loopPrintLine:

        xor ecx, ecx
        .loopPrintColumn:

            mov al, byte [esi]
            call char.Print
            mov al, 0x20
            call char.Print
            
            inc esi
            inc ecx
            cmp ecx, 3
            jl .loopPrintColumn

        call char.NewLine

        inc edx
        cmp edx, 3
    jl .loopPrintLine

    mov esp, ebp
    pop ebp
ret
