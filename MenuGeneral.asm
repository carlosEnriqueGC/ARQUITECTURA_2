.model small
.data   

;variables generales
    opcionMG db 0
    msgMG db "  ",13,10
          db " Proyecto Universidad Mariano Galvez",13,10
          db " Carlos Guzman y Diego Marroquin",13,10
          db " Opciones:",13,10
          db "  1. Operaciones basicas",13,10
          db "  2. palabra palindroma",13,10
          db "  3. Juego (Pong)",13,10
          db "  4. Serie Aritmetica",13,10
          db "  5. salida del programa",13,10
          db " Opcion: $"
    
    msgErrorMG db "Ups, ha ingresado un numero invalido o una letra $"
    msgSalidaMG db "Fin del proyecto. Gracias $" 
    
;variables 
    
.code     

start:
    mov ah, 00h
    mov al, 00h
    int 10h

    jmp principal

principal:
    mov ax, 1
    int 10h
        
    mov ah, 09h
    lea dx, msgMG
    int 21h

    mov ah, 01h
    int 21h

    mov [opcionMG], al

    cmp [opcionMG], '1'
    je uno
    cmp [opcionMG], '2'
    je dos
    cmp [opcionMG], '3'
    je tres
    cmp [opcionMG], '4'
    je cuatro
    cmp [opcionMG], '5'
    je salirMG

    jmp errorMG

uno:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h
    
    jmp principal

dos:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h 
    
    jmp principal

tres:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h
    
    jmp principal

cuatro:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h 
    
    jmp principal


errorMG:
    mov ah, 2
    int 10h

    mov ah, 09h
    lea dx, msgErrorMG
    int 21h

    jmp principal   
    
salirMG:
       

    mov ah, 4Ch
    int 21h   ; Termina el programa


end start
