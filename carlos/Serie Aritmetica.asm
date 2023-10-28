
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
;carlos enrique
video:
    mov ah, 00h
    mov al, 03h ; Cambiado a modo de vídeo 3 (80x25)
    int 10h

    jmp principal

principal:
    mov ax, 1
    int 10h

    mov ah, 09h
    mov dx, offset msgm
    int 21h

    mov ah, 01h
    int 21h

    mov [opcion], al

    cmp [opcion], '1'
    je proceso
    cmp [opcion], '2'
    je salir

proceso:
    mov ax, 1
    int 10h

    mov ah, 09h
    lea dx, msgI ; Ingresamos el número inicial
    int 21h

    mov ah, 01h
    int 21h

    sub al, '0'
    mov [inicial], al

    mov ah, 09h
    lea dx, msgS ; Ingresamos el número a sumar con el inicial
    int 21h

    mov ah, 01h
    int 21h

    sub al, '0'
    mov [sumar], al

    mov ah, 09h
    lea dx, msgC ; Ingresamos la cantidad de términos a mostrar
    int 21h

    mov ah, 01h
    int 21h

    sub al, '0'
    mov [cantidad], al

    mov [contador], 0     
    
    
    
    mov ax, 1
    int 10h

    jmp bucle

bucle:
    inc [contador]

    mov al, [inicial] 
    add al, [sumar]  
    add al, '0'   ; este es la solucion de que el programa no muestra nada

    mov ah, 0Eh
    int 10h

    mov bl, [contador]
    mov cl, [cantidad]
    cmp bl, cl

    mov ah, 0
    int 16h

    jae principal

    loop bucle

salir:
    mov ax, 1
    int 10h

ret

opcion db 0
inicial db 0
sumar db 0
cantidad db 0
contador db 0

msgm db "Operacion de recurrencia", 13, 10, "Sub-menú", 13, 10, "opciones:", 13, 10, " 1. Operacion Aritmetica", 13, 10, " 2. Regresar al menu principal", 13, 10, "opcion: $"
msgI db "Numero inicial: $ "
msgS db "Numero a sumar: $ "
msgC db "Cantidad de términos: $ "