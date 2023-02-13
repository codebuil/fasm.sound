org 0x100
push ds
mov cx,4000
mov bx,0
mov ax,0xb800
mov ds,ax
mov al,0x20
fill:
        ds
        mov [bx],al
        inc bx
        dec cx
        cmp cx,0
        jnz fill
call _start
; Definição da frequência das notas
frequency_C:  dw 262
frequency_D:  dw 294
frequency_E:  dw 330
frequency_F:  dw 349
frequency_G:  dw 392
frequency_A:  dw 440
frequency_B:  dw 494

; Duracao das notas
duration_whole:  dw 2000
duration_half:   dw 1000
duration_quarter: dw 500

; Porta para o speaker (3x64h)
speaker_port: db 0x61
dur1: dw 0
dur2: dw 0

playNote:
    ; Recebe a frequencia da nota como argumento
    ; Recebe a duração da nota como argumento
    push ebx
    push ecx
    push edx

    mov ebx, [esp + 8] ; frequencia da nota
    mov cx, [esp + 12] ; duracao da nota

    ; Ativa o speaker
    in al, 0x61
    or al, 3
    out  0x61, al

    noteLoop:
        ; Gera o som da nota
        push ecx
        push ebx
        push eax
        mov edx,0
        mov ecx,0
        mov eax,3168
        idiv ebx
        mov edx,0
        mov ecx,0
        mov ebx,7
        mov dx,ax
        pop eax
        pop ebx
        pop ecx
        out 43h, al
        mov al, dl
        out 42h, al
        mov al, dh
        out 42h, al

        ; Espera por 1/8 da duracao da nota
        push cx
        push bx
        push ax
        mov dx,0
        mov cx,0
        mov ax,cx
        mov bx,8
        idiv bx
        mov dx,ax
        pop ax
        pop bx
        pop cx
        waitLoop:
            dec dx
            jnz waitLoop

        ; Desativa o speaker
        in al,  0x61
        and al, 0xFC
        out  0x61, al

        ; Espera por 7/8 da duracao da nota
        push cx
        push bx
        push ax
        mov dx,0
        mov cx,0
        mov ax,cx
        mov bx,8
        idiv bx
        mov dx,0
        mov cx,0
        mov bx,7
        imul bx
        mov dx,ax
        pop ax
        pop bx
        pop cx
        mov bx,dur1
        cs
        mov [dur1],dx
        noteLoopss:
                cs
                mov dx,[dur1]
        waitLoop2:
            dec dx
            jnz waitLoop2

    ; Decrementa a duração da nota
     noteLoops:
    dec cx
    jnz noteLoops

    ; Restaura o registrador
    pop edx
    pop ecx
    pop ebx
    ret

_start:
    ; Toca a nota C por 1 segundo
    mov eax, frequency_C
    mov ebx, duration_whole
    call playNote

    ; Toca a nota D por 1/2 segundo
    mov eax, frequency_D
    mov ebx, duration_half
    call playNote

    ; Toca a nota E por 1/4 segundo
    mov eax, frequency_E
    mov ebx, duration_quarter
    call playNote

    ; Sair do programa
    mov eax, 1
    xor ebx, ebx
   mov ax,0
int 0x21
