
letterBias equ 0x37                 ; bias to add to 0xA for ascii 'A'

        SECTION .data
inputBuffer:
        db      0x83,0x6A,0x88,0xDE,0x9A,0xC3,0x54,0x9A
bytesToProcess:
        dd      0x8                 ; number of bytes in input buffer 

        SECTION .bss
outputBuffer:
        resb 80                     ; reserve spacaae for output

        SECTION .text
        global _start

_start:
;; output buffer to monitor
        xor edi,edi                 ; init dest. index
        xor esi,esi                 ; init source index/counter
        xor eax,eax                 ; init accumulator
        xor ecx,ecx                 ; address of byte
        xor edx,edx                 ; clear ascii result
getNextByte:
        ;; loop, process each byte from inputBuffer
        cmp esi,[bytesToProcess]    ; check if all bytes are processed
        jge printResult             ; if so, jump to printing the result

        mov al, [inputBuffer + esi] ; load current byte into AL
        inc esi                     ; move to next input byte

        mov ah, al                  ; copy al to ah
        shr ah, 4                   ; isolate
        cmp ah, 9
        jbe .highDigit              ; if <= 9, its a digit 0-9
        add ah, letterBias          ; convert 0xA-0xF to 'A' - 'F'
        jmp .storeHigh
.highDigit:
        add ah, '0'                 ; convert 0-9 to ascii '0' - '9'
.storeHigh:
        mov [outputBuffer + edi], ah ; store high as ascii
        inc edi

        mov ah, al
        and ah, 0x0F                ; mask to isolate
        cmp ah, 9
        jbe .lowDigit
        add ah, letterBias
        jmp .storeLow
.lowDigit:
        add ah, '0'
.storeLow:
        mov [outputBuffer + edi], ah ; store low as ascii
        inc edi

        ;; add space after each bytes hex output
        mov byte [outputBuffer + edi], ' '
        inc edi

        jmp getNextByte             ; repeat for next byte

printResult:
        ;; replace last space with newline and add an extra new line
        dec edi
        mov byte [outputBuffer + edi], 0x0A ; first new line
        inc edi
        mov byte [outputBuffer + edi], 0x0A ; second new line
        inc edi

        mov eax, 4                  ; syscall number for sys_write
        mov ebx, 1                  ; file descriptor 1 = stdout
        mov ecx, outputBuffer       ; pointer to output buffer
        mov edx, edi                ; number of bytes to print
        int 0x80                    ; invoke syscall

done:
        mov eax, 1                  ; syscall number for sys_exit
        xor ebx, ebx                ; status 0
        int 0x80
