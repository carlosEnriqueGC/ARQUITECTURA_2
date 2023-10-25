
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

        
    

video:
    
    mov ah,00h
    mov al,00h
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
    
    cmp [opcion],'1'
    je uno
    cmp [opcion],'2'
    je dos
    cmp [opcion],'3'
    je tres
     cmp [opcion],'4'
    je cuatro  
     cmp [opcion],'5'
    je cinco     
    cmp [opcion],1Bh
    je salir                            
        
    
uno:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h
    
    video1:
    mov ah, 00h
    mov al, 00h
    int 13h
    jmp principal1

principal1:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h

    mov ax, 2
    int 10h

    mov ah, 09h
    mov dx, offset menu1
    int 21h

    mov ah, 01h
    int 21h

    mov [opcion], al

    cmp [opcion], '1'
    je suma1
    cmp [opcion], '2'
    je resta1
    cmp [opcion], '3'
    je multi1
    cmp [opcion], 020h
    je regresar

suma1:
    mov ax, 2
    int 10h

    ; Primer n�mero
    mov ah, 09h
    lea dx, msg1
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    mov ah, 01h
    int 21h
    sub al, '0'
    mov cl, al

    mov ah, 09h
    lea dx, msge1
    int 21h

    ; Ingresa el segundo n�mero
    mov ah, 09h
    lea dx, msg1
    int 21h

    mov ah, 01h
    int 21h
    sub al, '0'
    add bl, al

    mov ah, 01h
    int 21h
    sub al, '0'
    add cl, al

    mov ah, 09h
    lea dx, msge1
    int 21h

    mov ah, 09h
    lea dx, msgr1
    int 21h

    ; Suma
    mov ax, cx
    aam
    mov cx, ax
    add bl, ch
    mov ax, bx
    aam
    mov bx, ax

    mov ah, 02h
    mov dl, bh
    add dl, '0'
    int 21h

    mov ah, 02h
    mov dl, bl
    add dl, '0'
    int 21h

    mov ah, 02h
    mov dl, cl
    add dl, '0'
    int 21h

    mov ah, 01h
    int 21h

    mov ah, 0
    int 16h

    jmp principal1

resta1: 
    
     mov ax, 2
    int 10h
    
    ; Primer n�mero
    mov ah, 09h
    lea dx, msg1
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
    lea dx, msge1
    int 21h
    
    ; Ingresar segundo n�mero
    mov ah, 09h
    lea dx, msg1
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
    sub cl, ch  ; Resta los d�gitos de las unidades
    sub bl, bh  ; Resta los d�gitos de las decenas
    
    ; Manejar el acarreo
    cmp cl, 0
    jge mostrar_resultado
    dec bl
    add cl, 10
    
    mostrar_resultado:   
    
    mov ah, 09h
    lea dx, msge1
    int 21h
    
    mov ah, 09h
    lea dx, msgr1
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
    
                 
    ; Esperar a que se presione una tecla antes de salir
    mov ah, 0
    int 16h

    jmp principal1

multi1:
    mov ax, 2
    int 10h    ; aqu� se expande la pantalla para mayor visualizaci�n

    ; Esperar a que se presione una tecla antes de salir
    mov ah, 0
    int 16h

    jmp principal1

regresar:
   

    jmp principal
      
   
dos:  
       
    jmp principal
    
tres:
    jmp principal
        
cuatro:
    jmp principal
    
cinco:
    jmp principal
    
salir:
    
    ret
  
  
opcion db 0
    msgm db "Proyecto Universidad Mariano Galvez",13,10,"Carlos Guzman y Diego Marroquin",13,10,"opciones:",13,10," 1. Operaciones basicas",13,10," 2. Operaciones con cadenas",13,10," 3. ",13,10," 4. ",13,10," 5. ",13,10,"presione Esc para salir",13,10,"opcion: $"
    
    ;variables programa 1
    
    c1_num1 db 0 ; usados para la resta
    c2_num1 db 0 ; usados para la resta
    c1_num2 db 0 ; usados para la resta
    c2_num2 db 0 ; usados para la resta 
   
    resultado1  db 0
    menu1 db " Operaciones basicas",13,10," Sub-menu de opciones: ",13,10,"  1. suma",13,10,"  2. resta",13,10,"  3. multiplicacion",13,10," Tecla espacio para regresar al menu principal",13,10," Opcion: $" 
                                      
    msg1 db " Ingrese un numero (puede ser de dos cifras): $" 
    msge1 db "  ",13,10,"$"
    msgr1 db " Resultado: $" 
    msgf1 db " Adios :) $"
ret  
  


    
