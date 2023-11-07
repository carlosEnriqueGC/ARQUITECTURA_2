org 100h

mov ax, 2
int 10h

; Primer número
mov ah, 09h
lea dx, msg
int 21h

mov ah, 01h
int 21h
sub al, 30h

mov bl, al

mov ah, 01h
int 21h
sub al, 30h
mov cl, al

mov ah, 09h
lea dx, msge
int 21h

; Ingresar segundo número
mov ah, 09h
lea dx, msg
int 21h

mov ah, 01h
int 21h
sub al, 30h

mov bh, al

mov ah, 01h
int 21h
sub al, 30h
mov ch, al

; Realizar la resta
sub cl, ch  ; Resta los dígitos de las unidades
sub bl, bh  ; Resta los dígitos de las decenas

; Manejar el acarreo
cmp cl, 0
jge mostrar_resultado
dec bl
add cl, 10

mostrar_resultado:
mov ah, 09h
lea dx, msgr
int 21h

; Mostrar el resultado
mov ah, 02h
mov dl, bl
add dl, 30h
int 21h

mov ah, 02h
mov dl, cl
add dl, 30h
int 21h

mov ah, 01h
int 21h

mov ah, 0
int 16h

ret

menu db " Practica P2 operaciones de 2 numeros", 13, 10, " Menu de opciones: ", 13, 10, "  1. suma", 13, 10, "  2. resta", 13, 10, "  3. multiplicacion", 13, 10, " Tecla espacio para salir", 13, 10, " Opcion: $"

msg db " Ingrese un numero (puede ser de dos cifras): $"
msge db "  ", 13, 10, "$"
msgr db " Resultado: $"
msgf db " Adios :) $"

