stack segment para stack
    db 64 dup (' ')
stack ends 

data segment para 'data'  
    
    window_width dw 140h    ; ancho de la pantalla (320 pixeles)
    window_height dw 0C8h   ; altura de la pantalla (200 pixeles)
    window_bounds dw 6      ; utilizada para colisiones tempranas (verifica)
    
    time_aux db 0  ; variable utilizada para verificar si el tiempo ha cambiado
    
    ball_original_x dw 0A0h     
    ball_original_y dw 64h
    ball_x dw 0A0h ; posicion x (columna) de la pelota
    ball_y dw 64h ; posicion y (linea) de la pelota    
    ball_size dw 04h ;dimension de la pelota
    ball_velocity_x dw 08h ;x (horizontal) velocidad de la pelota  (05h)
    ball_velocity_y dw 08h ;y (vertical) velocidad de la pelota    (02h)
    
    paddle_left_x dw 0Ah
    paddle_left_y dw 0Ah 
    
    paddle_right_x dw 130h
    paddle_right_y dw 0Ah
    
    paddle_width dw 05h
    paddle_height dw 1Fh
    paddle_velocity dw 05h
    
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
            
            call move_paddles
            call draw_paddles
            
            jmp check_time                                                  
                                                          
        ret
    main endp 
                
    move_ball proc near
        
        mov ax, ball_velocity_x  
        add ball_x, ax          ; mueve la pelota en horizontal
        
        mov ax, window_bounds
        cmp ball_x, ax
        jl reset_position
        
        mov ax, window_width
        sub ax, ball_size
        sub ax, window_bounds
        cmp ball_x, ax
        jg reset_position
        
        
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
        
        reset_position:
            call reset_ball_position
            ret 
            
        neg_velocity_y:
            neg ball_velocity_y
            ret
                            
    move_ball endp 
    
    move_paddles proc near
        
        ;movimiento de paleta (derecha)
        
        
        mov ah, 01h
        int 16h
        jz check_right_paddle_movement
        
        
        mov ah, 00h
        int 16h
        
        ;para mover arriba "w" o "W"
        cmp al, 77h ; "w"
        je move_left_paddle_up          
        cmp al, 57h ; "W"
        je move_left_paddle_up
        
        ;para mover abajo "s" o "S"
        cmp al, 73h ; "s"
        je move_left_paddle_down          
        cmp al, 53h ; "S"
        je move_left_paddle_down
        jmp check_right_paddle_movement
        
        move_left_paddle_up:
            mov ax, paddle_velocity
            sub paddle_left_y, ax
            
            mov ax, window_bounds 
            cmp paddle_left_y, ax 
            jl fix_paddle_left_top_position
            jmp check_right_paddle_movement
            
            fix_paddle_left_top_position:
                mov ax,  window_bounds
                mov paddle_left_y, ax
                jmp check_right_paddle_movement
        
        move_left_paddle_down:
            mov ax, paddle_velocity
            add paddle_left_y, ax
            mov ax, window_height
            sub ax, window_bounds 
            sub ax, paddle_height
            cmp paddle_left_y, ax
            jg fix_paddle_left_bottom_position  
            jmp check_right_paddle_movement
        
            fix_paddle_left_bottom_position:
                mov paddle_left_y, ax
                jmp check_right_paddle_movement
        
        check_right_paddle_movement:
        
        ret
    
    move_paddles endp
    
    reset_ball_position proc near
        
        mov ax, ball_original_x
        mov ball_x, ax
        
        mov ax, ball_original_y
        mov ball_y, ax
        
        ret
    reset_ball_position endp
                            
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
    
    draw_paddles proc near
        
        mov cx, paddle_left_x
        mov dx, paddle_left_y
        
        draw_paddle_left_horizontal: 
            mov ah, 0Ch   ; configuracion del pixel
            mov al, 0Fh   ; color para el pixel
            mov bh, 00h   ; numero de pagina
            int 10h       ; ejecutamos las configuraciones
            
            inc cx        ; cx = cx + 1
            mov ax, cx 
            sub ax, paddle_left_x
            cmp ax, paddle_width
            jng draw_paddle_left_horizontal
            
            mov cx, paddle_left_x
            inc dx
            
            mov ax, dx
            sub ax, paddle_left_y
            cmp ax, paddle_height
            jng draw_paddle_left_horizontal  
            
            
            mov cx, paddle_right_x
            mov dx, paddle_right_y
        
        draw_paddle_right_horizontal: 
            mov ah, 0Ch   ; configuracion del pixel
            mov al, 0Fh   ; color para el pixel
            mov bh, 00h   ; numero de pagina
            int 10h       ; ejecutamos las configuraciones
            
            inc cx        ; cx = cx + 1
            mov ax, cx 
            sub ax, paddle_right_x
            cmp ax, paddle_width
            jng draw_paddle_right_horizontal
            
            mov cx, paddle_right_x
            inc dx
            
            mov ax, dx
            sub ax, paddle_right_y
            cmp ax, paddle_height
            jng draw_paddle_right_horizontal    
        
        ret
    draw_paddles endp
    
    
    
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