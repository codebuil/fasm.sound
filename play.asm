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
frequency_C:  dw 400
frequency_D:  dw 500
frequency_E:  dw 600
frequency_F:  dw 700
frequency_G:  dw 800
frequency_B:  dw 900
frequency_A:  dw 1000
; Duracao das notas
duration_whole:  dd 2000
duration_half:   dd 1000
duration_quarter: dd 500

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

    push eax ; frequencia da nota
   push ebx ; duracao da nota

    ; Ativa o speaker
    in al, 0x61
    or al, 3
    out  0x61, al

    noteLoop:
        ; Gera o som da nota
        pop eax
        pop ebx
        push eax
        mov edx,0
        mov ecx,0
        mov eax,1193181
        idiv ebx
        mov dx,ax
        mov al,0xb6
        out 43h, al
        mov al, dl
        out 42h, al
        mov al, dh
        out 42h, al
        pop ecx
        waitLoop3:
        mov ebx,10000
        waitLoop:
            dec ebx
            jnz waitLoop
           dec ecx
           jnz waitLoop3

        ; Desativa o speaker
        in al,  0x61
        and al, 0xFC
        out  0x61, al

    ; Restaura o registrador
    pop edx
    pop ecx
    pop ebx
    ret
pauses:
        mov ecx,eax
        waitLoop33:
        mov ebx,10000
        waitLoop333:
            dec ebx
            jnz waitLoop333
           dec ecx
           jnz waitLoop33
           ret
_start:
    ; Toca a nota C por 1 segundo
    mov eax, frequency_C
    mov ebx, duration_whole
    call playNote
    mov eax,duration_quarter
    call pauses

    ; Toca a nota D por 1/2 segundo
    mov eax, frequency_D
    mov ebx, duration_half
    call playNote
    mov eax,duration_quarter
    call pauses

    ; Toca a nota E por 1/4 segundo
    mov eax, frequency_E
    mov ebx, duration_quarter
    call playNote
    mov eax,duration_quarter
    call pauses
    ; Sair do programa
    mov eax, 1
    xor ebx, ebx
   mov ax,0
int 0x21
