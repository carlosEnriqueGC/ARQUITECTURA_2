org 100h
 
;variables


video:
    mov ah,00h
    mov al,00h         ;configurar video
    int 10h
    jmp Submenu1

Submenu1: 

    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h 

    mov ax,1            ;limpiar pantalla
    int 10h
     
    mov ah, 09h
    lea dx, menu
    int 21h

    mov ah,01h
    int 21h
    
    mov [opcion],al
   
    cmp [opcion], '1'
    je suma
    
    cmp [opcion], '2'
    je resta
     cmp [opcion], '3'
    je multi
    cmp [opcion], '4'
    je salida
    
    jmp error

suma: 
    
   mov ax,2
   int 10h 
    
    ;primero numero 
    mov ah,09h
    lea dx, msg
    int 21h
    
    mov ah,01h
    int 21h
    sub al,30h
    
    mov bl,al 
   
    
    mov ah,01h
    int 21h
    sub al,30h
    mov cl,al
              
    mov ah,09h
    lea dx, msge 
    int 21h          
                    
    ; ingresa segundo numero
    mov ah,09h
    lea dx, msg
    int 21h
    
    mov ah,01h
    int 21h
    sub al,30h 
    add bl,al 
    
    mov ah,01h
    int 21h
    sub al,30h
    
    add cl,al
    
    mov ah,09h
    lea dx, msge 
    int 21h 
    
    mov ah,09h
    lea dx,msgr 
    int 21h
    
     ;suma 
    mov ax,cx
    
    aam
    
    mov cx,ax
    
    add bl,ch
    mov ax,bx
    
    aam
    mov bx,ax
    
    mov ah,02h
    mov dl,bh
    add dl,30h
    int 21h
    
    mov ah,02h
    mov dl,bl
    add dl,30h
    int 21h 
    
    mov ah,02h
    mov dl,cl
    add dl,30h
    int 21h
    
    mov ah,01h
    int 21h
    
    
        
    
    mov ah, 0
    int 16h 
       
    jmp Submenu1
           
    

resta:
 
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
    lea dx, msge
    int 21h
    
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
    
                 
    ; Esperar a que se presione una tecla antes de salir
    mov ah, 0
    int 16h

    jmp Submenu1


multi:
    mov ax,2
    int 10h    ; aqui se expande la pantalla para mayor visualizacion 
    
          
    numero macro var
       mov ah,01h         ;Function(character read)
       int 21h            ;Interruption DOS functions
       sub al,30h         ;Convertimos a decimal
       mov var,al         ;Almacenamos en varible
    endm
    
    caracter macro chr
       mov ah,02h         ;Function(character to send to standard output)
       mov dl,chr         ;Caracter a imprimir en pantalla
       int 21h            ;Interruption DOS functions
    endm
    
    multiplicar macro var1, var2
       mov al,var1
       mov bl,var2
       mul bl
    endm
    
    separar macro alta, baja
       mov ah,00h          ;Se limpia la parte alta de ax
       AAM                 ;Separa el registro ax en su parte alta y baja
       mov alta,ah
       mov baja,al
    endm
    
    resultado macro var
       mov ah,02h 
       mov dl,var
       add dl,30h
       int 21h
    endm
    
     ;Definicion de datos(variables), donde se almacenara informacion
       ;Variables del primer numero ingresado
       unidades_n1      db ? 
       decenas_n1       db ?
       
       ;Variables del segundo numero ingresado 
       unidades_n2      db ?
       decenas_n2       db ?
       
       ;Variables temporales para los resultados de la primera multiplicacion
       res_temp_dec_n1  db ?
       res_temp_cen_n1  db ?
       
       ;Variables temporales para los resultados de la segunda multiplicacion
       res_temp_dec_n2  db ?
       res_temp_cen_n2  db ?
       
       ;Variables para los resultados 
       res_unidades     db ?
       res_decenas      db ?
       res_centenas     db ?
       res_uni_millar   db ?
       
       ;Variable de acarreo en multiplicacion
       acarreo_mul      db 0
       
       ;Variable de acarreo en suma
       acarreo_suma     db 0
    
      
       
    
       
       mov ah,00h         ;Function(Set video mode)
       mov al,03          ;Mode 80x25 8x8 16
       int 10h            ;Interruption Video
    
       numero decenas_n1
       numero unidades_n1
       caracter '*'
       numero decenas_n2 
       numero unidades_n2
       caracter '='
     
       ;Realizamos las operaciones   
       
       ;Primera multiplicacion
       multiplicar unidades_n1, unidades_n2  
       separar acarreo_mul, res_unidades 
    
       
       ;Segunda multiplicacion
       multiplicar decenas_n1, unidades_n2   
       mov res_temp_dec_n1,al   
       mov bl,acarreo_mul       
       add res_temp_dec_n1,bl 
       mov al,res_temp_dec_n1
       separar res_temp_cen_n1, res_temp_dec_n1      
        
       ;Tercera multiplicacion
       multiplicar unidades_n1, decenas_n2
       separar acarreo_mul, res_temp_dec_n2
       ;Suma -> Decenas         
       mov bl, res_temp_dec_n1  
       add res_temp_dec_n2,bl   
       mov al, res_temp_dec_n2      
       separar acarreo_suma, res_decenas
       
       ;Cuarta multiplicacion
       multiplicar decenas_n1, decenas_n2   
       mov res_temp_cen_n2,al    
       mov bl,acarreo_mul       
       add res_temp_cen_n2,bl             
       mov al,res_temp_cen_n2
       separar res_uni_millar, res_temp_cen_n2     
       ;Suma -> Centenas        
       mov bl, res_temp_cen_n1  
       add res_temp_cen_n2, bl  
       mov bl, acarreo_suma     
       add res_temp_cen_n2,bl               
       mov al,res_temp_cen_n2  
       separar acarreo_suma, res_centenas 
       
       ;Acarreo para unidades de millar                         
       mov bl, acarreo_suma     
       add res_uni_millar, bl   
     
       ;Mostramos resultados
       resultado res_uni_millar   
       resultado res_centenas   
       resultado res_decenas 
       resultado res_unidades
           

    ; Esperar a que se presione una tecla antes de salir
    mov ah, 0
    int 16h

    jmp Submenu1
   
salida:
   mov ax, 1
   int 10h
   
   ret
   
error:
   mov ax, 2
   int 10h
   
   
   mov ah, 09h
   lea dx, msgError
   int 21h
           
   mov ah, 0
   int 16h
   jmp Submenu1
   
;variables    
    opcion db 0  
    c1_num1 db 0 ; usados para la resta
    c2_num1 db 0 ; usados para la resta
    c1_num2 db 0 ; usados para la resta
    c2_num2 db 0 ; usados para la resta 
   
    resultado1  db 0
    menu db " Operaciones Basicas",13,10," Submenu: ",13,10," 1. suma",13,10," 2. resta",13,10," 3. multiplicacion",13,10," 4. regresar al menu principal",13,10," Opcion: $" 
                                      
    msg db " Ingrese un numero (puede ser de dos cifras): $" 
    msge db "  ",13,10,"$"
    msgr db " Resultado: $"
    msgError db " Ups has ingresado un numero invalido o una letra $" 

