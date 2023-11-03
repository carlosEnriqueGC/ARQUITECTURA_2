
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

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
    cmp al, 0        ; Compara con 0
    jl numero_invalido_inicial ; Si es menor a 0, muestra el mensaje de error
    cmp al, 2        ; Compara con 2
    jg numero_invalido_inicial ; Si es mayor a 2, muestra el mensaje de error
    mov [inicial], al  
    
    
    mov ah, 09h
    lea dx, msgE ; separamos
    int 21h

    mov ah, 09h
    lea dx, msgS ; Ingresamos el número a sumar con el inicial 
    int 21h

    mov ah, 01h
    int 21h

    sub al, '0'
    cmp al, 0       ; Compara con 0
    jl numero_invalido_sumar ; Si es menor a 0, muestra el mensaje de error
    cmp al, 2        ; Compara con 2
    jg numero_invalido_sumar ; Si es mayor a 2, muestra el mensaje de error
    mov [sumar], al
    
    
    mov ah, 09h
    lea dx, msgE ; separamos
    int 21h

    mov ah, 09h
    lea dx, msgC ; Ingresamos la cantidad de terminos a mostrar
    int 21h

    mov ah, 01h
    int 21h

    sub al, '0'
    cmp al, 0        ; Compara con 0
    jl numero_invalido_cantidad ; Si es menor a 0, muestra el mensaje de error
    cmp al, 4        ; Compara con 4
    jg numero_invalido_cantidad ; Si es mayor a 4, muestra el mensaje de error
    mov [cantidad], al  
    
    
    mov ah, 09h
    lea dx, msgE ; separamos
    int 21h

    mov [contador], 0 
    sub [cantidad], 1  ; Resta 1 a la cantidad    
    
    mov ax, 1
    int 10h   
    
    mov al, [inicial] 
    add al, '0'
    mov ah, 0Eh
    int 10h
    
    jmp bucle

bucle:
    inc [contador]

    mov al, [inicial] 
    add al, [sumar]  
    mov [inicial], al 
    
    
    add al, '0'                                    
    
    mov ah, 0Eh
    int 10h
    

    mov bl, [contador]
    mov cl, [cantidad]
    cmp bl, cl

    mov ah, 0
    int 16h

    jae principal
    
    
    mov al, 00h
    mov ah, 00h
    loop bucle

salir:
    mov ax, 1
    int 10h

numero_invalido_inicial: 
    mov ax, 2
    int 10h 

    mov ah, 09h
    lea dx, msgError
    int 21h 
    
    mov ah, 0
    int 16h
    jmp proceso

numero_invalido_sumar:  
    mov ax, 2
    int 10h 
    
    mov ah, 09h
    lea dx, msgError
    int 21h    
    
    mov ah, 0
    int 16h
    jmp proceso

numero_invalido_cantidad:  
    mov ax, 2
    int 10h 

    mov ah, 09h
    lea dx, msgError
    int 21h    
    
    mov ah, 0
    int 16h
    jmp proceso

ret

opcion db 0
inicial db 0
sumar db 0
cantidad db 0
contador db 0

msgm db "Operacion de recurrencia", 13, 10, "Sub-menu", 13, 10, "opciones:", 13, 10, " 1. Operacion Aritmetica", 13, 10, " 2. Regresar al menu principal", 13, 10, "opcion: $"
msgI db "Numero inicial (0 hasta 2): $"
msgS db "Numero a sumar (0 hasta 2): $"
msgC db "Cantidad de terminos (0 hasta 4): $" 
msgE db "  ", 13, 10, "$"
msgError db "Ups has ingresado un numero invalido o una letra", 13, 10, "$"



