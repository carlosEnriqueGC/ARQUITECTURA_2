org 100h
video:
    
    mov ah,00h
    mov al,00h
    int 10h
    
    jmp principal
    
principal:
          
    mov ax, 1
    int 10h
    
    mov ah, 09h
    mov dx, offset msgMG
    int 21h
    
    mov ah, 01h
    int 21h
    
    mov [opcionMG], al
    
    cmp [opcionMG],'1'
    je uno
    cmp [opcionMG],'2'
    je dos
    cmp [opcionMG],'3'
    je tres
    cmp [opcionMG],'4'
    je cuatro       
    cmp [opcionMG],'5'
    je salirMG                            
    
    jmp errorMG    
    
uno:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h
    
    mov ax, 1
    int 10h
    
    Submenu1:  
    
        mov ax,1            ;limpiar pantalla
        int 10h
         
        mov ah, 09h
        lea dx, SubmenuOB
        int 21h
    
        mov ah,01h
        int 21h
        
        mov [opcion1],al
       
        cmp [opcion1], '1'
        je suma
        
        cmp [opcion1], '2'
        je resta
         cmp [opcion1], '3'
        je multi
        cmp [opcion1], '4'
        je salidaSubmenu1
        
        jmp errorSubmenu1
    
    suma: 
        
       mov ax,2
       int 10h 
        
        ;primero numero 
        mov ah,09h
        lea dx, msg1
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
        lea dx, msge1 
        int 21h          
                        
        ; ingresa segundo numero
        mov ah,09h
        lea dx, msg1
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
        lea dx, msge1 
        int 21h 
        
        mov ah,09h
        lea dx,msgr1 
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
        
        ; Ingresar segundo número
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
        sub cl, ch  ; Resta los dígitos de las unidades
        sub bl, bh  ; Resta los dígitos de las decenas
        
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
    
        jmp Submenu1
    
    
    multi:
        mov ax,2
        int 10h    ; aqui se expande la pantalla para mayor visualizacion 
        
        mov ah, 09h
        lea dx, msgMulti
        int 21h
        
        mov ah, 0
        int 16h 
              
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
       
    salidaSubmenu1:
       mov ax, 1
       int 10h
       
       jmp principal
       
    errorSubmenu1:
       mov ax, 2
       int 10h
       
       
       mov ah, 09h
       lea dx, msgError
       int 21h
               
       mov ah, 0
       int 16h
       jmp Submenu1    
        
        
   
dos:  
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h
    
    mov ax, 1
    int 10h 
    
    mov ah, 09h
    lea dx, msgPA ; Imprimimos el titulo de la opcion
    int 21h
       
    mov ah, 09h
    lea dx, msgE ; separamos
    int 21h
        
    jmp inicio()
    palabra db 50h dup(?)
    aux1 db 0
    aux2 dw 0
    
    msj1:
    primero db 'Ingrese una palabra : '
    lz = $ - cod
    db 06h, '$'
    exito:
    exitomsj db 'La palabra ingresada es palindroma.'
    lz = $ - cod
    db 06h,'$'
    fallo:
    fallomsj db 'La palabra ingresada no es palindroma.'
    lz = $ - cod
    db 06h,'$'
    
    inicio():
    mov ah,9
    mov dx,offset primero
    int 21h
    
    mov bl,0dh ;esigamos la tecla enter
    mov si,00d ;inicio del contador del string
    mov ah,1
    
    lectura():
    int 21h ;lectura del caracter
    mov palabra[si],al ;almacenamos en el vector string
    inc si ;incremento variable SI
    cmp al,bl ;comparamos el caracter ingresado con el ENTER
    jne lectura()
    
    mov di,si
    dec di ;la variable si se pasa en dos posiciones, ya que almacena
    dec di ; el enter y el retorno de carro!!!, por esod ecremento dos veces
    
    mov si,00d
    
    mov aux2,di ;almacenamos el largo en una variable
    
    compara():
    
    mov al,palabra[si]
    cmp palabra[di],al ;si son distintos de inmediato no son palindromes!
    jne no_palindromo()
    
    cmp si,aux2
    je palindromo()
    
    inc si
    dec di
    
    jmp compara()
    
    no_palindromo():
    mov aux1,1
    jmp imprime()
    mensaje1():
    ;mov ah,0eh
    mov al,0ah
    int 10h
    
    mov dx,offset fallomsj
    mov ah,9
    int 21h
    jmp fin()
    
    palindromo():
    jmp imprime()
    mensaje2():
    ;mov ah,0eh
    mov al,0ah
    int 10h
    
    mov dx,offset exitomsj
    mov ah,9
    int 21h
    jmp fin()
    
    imprime():
    mov di,aux2
    mov ah,0eh
    mov al,0ah
    int 10h
    mov si,-01d
    for():
    mov ah,0eh
    inc si
    mov al,palabra[si]
    int 10h
    cmp si,di
    jne for()
    
    mov al,aux1 ;truco para saber donde debe volver!!
    cmp al,1
    je mensaje1() ;vuelve donde corresponda!!
    jmp mensaje2()
              
        
    fin():
    mov ah, 0
    int 16h   
    jmp principal
    
tres:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h
    
    
    ;aqui iria el juego pero tengo miedo XD
    
    
    mov ah, 0
    int 16h 
    jmp principal
        
cuatro:
    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h
    
    
    mov ax, 1
    int 10h   
    
    mov ah, 09h
    lea dx, msgSA ; Imprimimos el titulo de la opcion
    int 21h
       
    mov ah, 09h
    lea dx, msgE ; separamos
    int 21h
    
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



    numero_invalido_inicial: 
        mov ax, 2
        int 10h 
    
        mov ah, 09h
        lea dx, msgErrorMG
        int 21h 
        
        mov ah, 0
        int 16h
        jmp cuatro
    
    numero_invalido_sumar:  
        mov ax, 2
        int 10h 
        
        mov ah, 09h
        lea dx, msgErrorMG
        int 21h    
        
        mov ah, 0
        int 16h
        jmp cuatro
    
    numero_invalido_cantidad:  
        mov ax, 2
        int 10h 
    
        mov ah, 09h
        lea dx, msgErrorMG
        int 21h    
        
        mov ah, 0
        int 16h
        jmp cuatro 
     
    
salirMG:
    
    mov ax, 2
    int 10h
       
    mov ah, 09h
    lea dx, msgSalidaMG
    int 21h
    
    mov ah, 0
    int 16h 
    
    
    ret
      
      
errorMG:
     mov ax, 2
     int 10h
       
     mov ah, 09h
     lea dx, msgErrorMG
     int 21h
               
     mov ah, 0
     int 16h
     jmp principal
     
;ZONA DE VARIABLES


    opcionMG db 0
    msgMG db "Proyecto Universidad Mariano Galvez",13,10,"Carlos Guzman y Diego Marroquin",13,10,"opciones:",13,10," 1. Operaciones basicas",13,10," 2. Palabra Palindroma",13,10," 3. Juego (pong)",13,10," 4. Serie Aritmetica",13,10," 5. Salida del programa",13,10,"opcion: $"
    msgErrorMG db " Ups has ingresado un numero invalido o una letra $"
    msgSalidaMG db " Fin del proyecto Gracias $"
    
;variables extras de palabra palindroma

    msgPA db "Palabra palindroma $"
    
     
;variables Operaciones Basicas 

    opcion1 db 0  
    resultado1  db 0
    SubmenuOB db " Operaciones Basicas",13,10," Submenu: ",13,10," 1. suma",13,10," 2. resta",13,10," 3. multiplicacion",13,10," 4. regresar al menu principal",13,10," Opcion: $"                                    
    msg1 db " Ingrese un numero (puede ser de dos cifras): $" 
    msge1 db "  ",13,10,"$"
    msgr1 db " Resultado: $"
    msgError db " Ups has ingresado un numero invalido o una letra $" 
    msgMulti db "Ingrese el primer numero seguido del segundo numero (sin espacios, los numeros  son de dos cifras).",13,10,"Ejemplo 1: 74*05=0370 ",13,10,"Ejemplo 2: 25*25=0625",13,10,"Presione cualquier tecla para continuar.$"

;variables Serie Aritmetica

    inicial db 0
    sumar db 0
    cantidad db 0
    contador db 0
    msgSA db "Serie Aritmetica $"
    msgI db "Numero inicial (0 hasta 2): $"
    msgS db "Numero a sumar (0 hasta 2): $"
    msgC db "Cantidad de terminos (0 hasta 4): $" 
    msgE db "  ", 13, 10, "$"
    
    ret