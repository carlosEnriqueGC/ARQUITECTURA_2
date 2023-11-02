stack segment para stack
    db 64 dup (' ')
stack ends 

data segment para 'data'  
    
    window_width dw 140h    ; ancho de la pantalla (320 pixeles)
    window_height dw 0C8h   ; altura de la pantalla (200 pixeles)
    window_bounds dw 6      ; utilizada para colisiones tempranas (verifica)
    
    time_aux db 0  ; variable utilizada para verificar si el tiempo ha cambiado
    
    ball_x dw 0Ah ; posicion x (columna) de la pelota
    ball_y dw 0Ah ; posicion y (linea) de la pelota    
    ball_size dw 04h ;dimension de la pelota
    ball_velocity_x dw 08h ;x (horizontal) velocidad de la pelota  (05h)
    ball_velocity_y dw 08h ;y (vertical) velocidad de la pelota    (02h)
    
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
        
        call clear_screen
        
        check_time:     
        
            mov ah, 2Ch ; obtener tiempo del sistema
            int 21h 
            
            cmp dl, time_aux
            je check_time
            
            mov time_aux, dl ; actualiza el tiempo
            
            
            call clear_screen  
            
            call move_ball                                 
            call draw_ball
            
            jmp check_time                                                  
                                                          
        ret
    main endp 
                
    move_ball proc near
        
        mov ax, ball_velocity_x  
        add ball_x, ax          ; mueve la pelota en horizontal
        
        mov ax, window_bounds
        cmp ball_x, ax
        jl neg_velocity_x
        
        mov ax, window_width
        sub ax, ball_size
        sub ax, window_bounds
        cmp ball_x, ax
        jg neg_velocity_x
        
        
        mov ax, ball_velocity_y 
        add ball_y, ax          ; mueve la pelota en vertical
         
        mov ax, window_bounds 
        cmp ball_y, ax
        jl neg_velocity_y
        
        mov ax, window_height 
        sub ax, ball_size 
        sub ax, window_bounds
        cmp ball_y, ax
        jg neg_velocity_y
        
        ret 
        
        neg_velocity_x:
            neg ball_velocity_x
            ret 
            
        neg_velocity_y:
            neg ball_velocity_y
            ret
                            
    move_ball endp            
                            
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
    
    
    clear_screen proc near 
        
        mov ah, 00h   ; configuracion de modo video
        mov al, 13h   ; cambiamos modo de video
        int 10h       ; ejecutamos las configuraciones
        
        ;mov ah, 0Bh  ;configuracion del color de fondo
        ;mov bh, 00h  
        ;mov bl, 00h  
        ;int 10h
        
        ret        
    clear_screen endp
    
code ends

ends