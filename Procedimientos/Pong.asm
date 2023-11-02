stack segment para stack
    db 64 dup (' ')
stack ends 

data segment para 'data'  
    
    ball_x dw 0Ah ; posicion x (columna) de la pelota
    ball_y dw 0Ah ; posicion y (linea) de la pelota    
    ball_size dw 04h ;dimension de la pelota
    
data ends

code segment para 'code'   
    
    main proc far    
    assume cs:code,ds:data,ss:stack ; Esto establece los segmentos de codigo (cs), datos (ds) y pila (ss) que se utilizaran.
    push ds                         ; Guarda el valor actual del segmento de datos (ds) en la pila
    sub ax, ax                      ; Borra el registro ax (pone su valor en cero).
    push ax                         ; Guarda el valor cero en la pila.
    mov ax, data                    ; Carga el segmento de datos (ds) con el valor de "data".
    mov ds, ax                      ; Establece el segmento de datos (ds) con el valor cargado en "ax".
    pop ax                          ; Restaura el valor cero desde la pila al registro "ax".
    pop ax                          ; Restaura el valor anterior del segmento de datos (ds) desde la pila
        
        mov ah, 00h   ; configuracion de modo video
        mov al, 13h   ; cambiamos modo de video
        int 10h       ; ejecutamos las configuraciones
        
        ;mov ah, 0Bh  ;configuracion del color de fondo
        ;mov bh, 00h  
        ;mov bl, 00h  
        ;int 10h      
        
        mov ah, 0Ch   ; configuracion del pixel
        mov al, 0Fh   ; color para el pixel
        mov bh, 00h   ; numero de pagina
        mov cx, ball_x   ; establecemos la columna (x) 
        mov dx, ball_y   ; establecmos la linea (y)
        int 10h       ; ejecutamos las configuraciones
                                                          
        call draw_ball                                                  
                                                          
        ret
    main endp 
    
    draw_ball proc near  
        
        mov cx, ball_x   ; establecemos la posicion inicial columna (x) 
        mov dx, ball_y   ; establecmos la posicion inicial linea (y)
        
        draw_ball_horizontal:
        
            mov ah, 0Ch   ; configuracion del pixel
            mov al, 0Fh   ; color para el pixel
            mov bh, 00h   ; numero de pagina
            int 10h       ; ejecutamos las configuraciones
            
            inc cx        ; cx = cx + 1
            mov ax, cx 
            sub ax, ball_x
            cmp ax, ball_size
            jng draw_ball_horizontal 
            
            mov cx, ball_x
            inc dx
            
            mov ax, dx
            sub ax, ball_y
            cmp ax, ball_size
            jng draw_ball_horizontal
            
       
        
                    
        ret
    draw_ball endp
    
code ends

ends