;Takes al as param
;Returns in al hexa
convertToAsciiFromHexa:
    push ebp
    mov ebp, esp 

    cmp eax, 0x09
    jle .numtoascii

    .lettertoascii:
        add eax, 87
        jmp .convexit

    .numtoascii:
        add eax, 0x30
        jmp .convexit

    .convexit:

    mov esp, ebp
    pop ebp
    ret

; Takes esi as parameter (string)
; Takes edi as parameter (destination)
; Takes eax as parameter (separator)
; Takes edx as parameter (offset)
; returns in edx last position to start from in vector
; returns in edi word until eax
strtok:
    push ebp
    mov ebp, esp

    push eax
    push ebx
    push ecx

    ; Keep the separator in ebx
    xor ebx, ebx
    mov ebx, eax

    ; Get the length in eax
    call string.Length

    ; Start from offset
    mov ecx, edx
    .loop:
        ; in bl is the ascii code for the separator
        cmp [esi + ecx], bl
        je .end

        cmp [esi + ecx], byte 0x00
        je .end

        push ebx
        mov bl, byte [esi + ecx]

        ; Offset for edi
        mov eax, ecx
        sub eax, edx

        mov [edi + eax], bl
        inc ecx

        pop ebx

        jmp .loop

    .end:
        ; Put 0x00 at the final so that we don t need to reset everytime edi
        mov eax, ecx
        sub eax, edx
        mov [edi + eax], byte 0x00

        ; For the next offset (Does NOT read the separator)
        inc ecx
        mov edx, ecx

    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp
    ret

; Reads from the last file opened
; Takes edi as buffer to read
fileReadLine:
    push ebp
    mov ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push esi 
    push edi

    mov ecx, 0
    .readLoop:
        mov ebx, eax

        push eax
        push ecx

        mov eax, 3
        mov edx, 1
        lea ecx, [edi + ecx]
        int 0x80 ; sys call

        pop ecx
        pop eax

        cmp [edi + ecx], byte 0x0a ; Compare with newline
        je .endNl

        cmp [edi + ecx], byte 0x00 ; compare with endoffile
        je .end

        inc ecx

        jmp .readLoop

    .endNl:
        mov [edi + ecx], byte 0x00

    .end:

    pop edi 
    pop esi 
    pop edx
    pop ecx 
    pop ebx 
    pop eax

    mov esp, ebp
    pop ebp
    ret

; Takes eax as parameter (file descriptor)
; Takes edx for where to be in the file
fileCursor:
    push ebp
    mov ebp, esp 

    push eax
    push ebx
    push ecx
    push edx

    mov ebx, eax
    mov ecx, edx
    mov eax, 19
    mov edx, 0
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp
    ret


; Takes eax as parameter (file descriptor)
fileClose:
    push ebp
    mov ebp, esp 

    push ebx

    mov ebx, eax
    mov eax, 0x06
    int 0x80

    pop ebx

    mov esp, ebp
    pop ebp
    ret

; Takes esi as parameter (Content readed)
; Takes eax as file descriptor
; Takes edx for dimension to read
fileRead:
    push ebp
    mov ebp, esp 

    push ebx
    push ecx

    mov ebx, eax
    mov ecx, esi
    mov eax, 0x03 ; Sys read
    int 0x80

    pop ecx
    pop ebx

    mov esp, ebp
    pop ebp
    ret

; Takes esi as parameter (filename)
; Takes eax as parameter (0 for read, 1 for write, 2 for read/write)
; Returns in eax file descriptor
fileOpen:
    push ebp
    mov ebp, esp

    push ebx
    push ecx
    push edx

    mov ecx, eax
    mov ebx, esi 
    mov eax, 0x05
    mov edx, 666o
    int 0x80

    pop edx
    pop ecx
    pop ebx

    mov esp, ebp
    pop ebp
    ret

; Takes esi as parameter (content to write)
; Takes eax as parameter (file descriptor)
fileWrite:
    push ebp
    mov ebp, esp

    push eax
    push ebx
    push ecx
    push edx

    mov ebx, eax ; file descriptor
    call string.Length
    mov edx, eax ; length of content
    mov ecx, esi
    mov eax, 0x04 ; Sys write
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax

    mov esp, ebp
    pop ebp
    ret

; Takes esi as parameter (filename)
; Returns in eax file descriptor
fileCreate:
    push ebp
    mov ebp, esp 

    push ebx
    push ecx

    mov eax, 0x08 ; Create
    mov ebx, esi ; Address of filename
    mov ecx, 666o ; Permissions
    int 0x80

    pop ecx
    pop ebx

    mov esp, ebp
    pop ebp
    ret

; Takes 3 parameters: eax, ebx, ecx
; Checks if eax is in limit of ebx and ecx, eax >= ebx, eax =< ecx
; Returns in edx 1 for true, 0 for false

compare:
    push ebp
    mov ebp, esp

    cmp eax, ebx
    jl .endCompareFalse

    cmp eax, ecx
    jg .endCompareFalse

    jmp .endCompareTrue

    .endCompareFalse:
        mov edx, 0
        jmp .endCompare

    .endCompareTrue:
        mov edx, 1
        jmp .endCompare

    .endCompare:

    mov esp, ebp
    pop ebp
    ret

math:
    ; Takes two parameters, eax for the number, ecx for the power
    ; Returns in eax the value
    .pow:
        push ebp
        mov ebp, esp

        push ebx
        push ecx
        push edx

        mov ebx, eax
        mov eax, 1

        ._pLoop:
            mul ebx
            dec ecx

            cmp ecx, 0
            jne ._pLoop

        pop edx
        pop ecx
        pop ebx

        mov esp, ebp
        pop ebp
        ret

string:
    ; Convert to hexa
    ; Takes esi as parameter (address of string)
    ; Takes edi as destination 
    ; Returns in edi hexa value

    ; Clears the screen
    .clearScreen:
        push ebp
        mov ebp, esp

        push ecx

        xor ecx, ecx
        ._csLoop:
            call char.NewLine

            inc ecx
            cmp ecx, 100
            jne ._csLoop

        pop ecx

        mov esp, ebp
        pop ebp
        ret

    ; Takes esi as parameter
    ; Returns the number in eax
    .atoi:
        push ebp
        mov ebp, esp

        push ebx
        push ecx
        push edx

        ; First number is already in eax
        xor eax, eax
        mov al, byte [esi]

        ; Convert to number 
        sub al, 0x30

        ; Check if the number is only 1 char long
        cmp [esi + 1], byte 0
        je ._atoiExitSingle

        mov ecx, 1
        ._atoiLoop:
            mov bl, [esi + ecx]

            ; Multiplicate the number by 10
            mov edx, 10
            mul edx

            ; Add the new number to the value
            add eax, ebx
            sub eax, 0x30

            inc ecx

            cmp [esi + ecx], byte 0
            je ._atoiExit

            cmp [esi + ecx], byte 0
            jne ._atoiLoop

        jmp ._atoiExit
        
        ._atoiExitSingle:
            mov [esi], al

        ._atoiExit:
            pop edx
            pop ecx
            pop ebx

        mov esp, ebp
        pop ebp
        ret

    ; Takes eax as input
    .PrintNumberEndl:
        push ebp
        mov ebp, esp
        push eax

        call .PrintNumber

        mov eax, 0xa
        call char.Print

        pop eax
        mov esp, ebp
        pop ebp
        ret

    ; Takes eax as input number, any length
    .PrintNumber:
        push ebp
        mov ebp, esp

        push eax
        push ebx
        push ecx
        push edx

        mov ebx, 10
        mov ecx, 0
        ._nprintLoop1:
            ; Prepare edx
            xor edx, edx

            div ebx

            push edx
            inc ecx

            cmp eax, 0x0
            jne ._nprintLoop1

        ._nprintLoop2:
            pop eax
            call char.PrintNumber

            dec ecx
            cmp ecx, 0
            jne ._nprintLoop2

        ._nprintExit:
            pop edx
            pop ecx
            pop ebx
            pop eax

        mov esp, ebp
        pop ebp
        ret

    ; Takes the string from esi and prints it with newline
    .PrintEndl:
        push ebp
        mov ebp, esp

        call .Print
        call char.NewLine

        mov esp, ebp
        pop ebp
        ret

    ; Takes the string from esi and prints it
    .Print:
        push ebp
        mov ebp, esp

        push eax
        push ebx
        push ecx
        push edx

        call .Length

        mov edx, eax
        mov eax, 4
        mov ebx, 1
        mov ecx, esi
        int 0x80

        pop edx
        pop ecx
        pop ebx
        pop eax

        mov esp, ebp
        pop ebp
        ret

    ; Reads from stdin, takes esi as parameter
    ; Reads edx values
    .Read:
        push ebp
        mov ebp, esp

        push eax
        push ebx
        push ecx
        push edx

        mov ecx, 0
        call .Length
        ._rLoopClearEsi:
            mov [esi + ecx], byte 0

            inc ecx
            cmp ecx, eax
            jle ._rLoopClearEsi

        mov eax, 3
        mov ebx, 0
        mov ecx, esi
        mov edx, edx
        int 0x80

        call .Length
        sub eax, 0x01
        mov [esi + eax], byte 0

        pop edx
        pop ecx
        pop ebx
        pop eax

        mov esp, ebp
        pop ebp
        ret

    ; Takes the string from esi
    ; Returns length of the string in eax
    .Length:
        push ebp
        mov ebp, esp

        push ebx
        push ecx
        push esi

        mov ebx, esi

        ._stringLengthLoop:
            mov cl, byte[esi]

            inc esi
            cmp cl, byte 0
            jnz ._stringLengthLoop

        sub esi, ebx
        mov eax, esi
        sub eax, 1
        
        pop esi
        pop ecx
        pop ebx

        mov esp, ebp
        pop ebp
        ret

char:
    ; Print number from eax
    .PrintNumber:
        push ebp
        mov ebp, esp

        push eax
        push ebx
        push ecx
        push edx

        push eax
        add [ebp - 4 * 5], byte 0x30
        mov eax, 4
        mov ebx, 1
        lea ecx, [ebp - 4 * 5]
        mov edx, 1
        int 0x80

        add esp, 4

        pop edx
        pop ecx
        pop ebx
        pop eax

        mov esp, ebp
        pop ebp
        ret

    ; Print new line
    .NewLine:
        push ebp
        mov ebp, esp

        push eax

        mov eax, 0xa
        call .Print

        pop eax
        
        mov esp, ebp
        pop ebp
        ret

    ; Print char from eax
    .Print:
        push ebp
        mov ebp, esp

        push eax
        push ebx
        push ecx
        push edx

        push eax
        mov eax, 4
        mov ebx, 1
        lea ecx, [ebp - 4 * 5]
        mov edx, 1
        int 0x80

        add esp, 4

        pop edx
        pop ecx
        pop ebx
        pop eax

        mov esp, ebp
        pop ebp
        ret


exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80







