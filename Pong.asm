
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

STACK SEGMENT PARA STACK
	DB 64 DUP (' ')
STACK ENDS

DATA SEGMENT PARA 'DATA'
	
	
	; Declaración de variables de datos

	WINDOW_WIDTH DW 140h           ; Ancho de la ventana (320 pixeles)
	WINDOW_HEIGHT DW 0C8h          ; Alto de la ventana (200 pixeles)
	WINDOW_BOUNDS DW 6             ; Variable utilizada para verificar colisiones tempranas

	TIME_AUX DB 0                  ; Variable utilizada al verificar si ha cambiado el tiempo
	GAME_ACTIVE DB 1               ; ¿Esta el juego activo? (1 -> Si, 0 -> No (juego terminado))
	EXITING_GAME DB 0              ; Indica si el juego está saliendo
	WINNER_INDEX DB 0              ; indice del ganador (1 -> jugador uno, 2 -> jugador dos)
	CURRENT_SCENE DB 0             ; indice de la escena actual (0 -> menú principal, 1 -> juego)
	
    TEXT_PLAYER_ONE_POINTS DB '0','$'                       ; Texto con los puntos del jugador uno
    TEXT_PLAYER_TWO_POINTS DB '0','$'                       ; Texto con los puntos del jugador dos
    TEXT_GAME_OVER_TITLE DB 'FIN DEL JUEGO','$'              ; Texto con el titulo del menu de fin del juego
    TEXT_GAME_OVER_WINNER DB 'El Jugador 0 gano','$'         ; Texto con el mensaje del ganador
    TEXT_GAME_OVER_PLAY_AGAIN DB 'Presiona R para jugar de nuevo','$' ; Texto con el mensaje para jugar de nuevo en el fin del juego
    TEXT_GAME_OVER_MAIN_MENU DB 'Presiona E para regresar al menu principal','$' ; Texto con el mensaje para regresar al menu principal en el fin del juego
    TEXT_MAIN_MENU_TITLE DB 'MENU PRINCIPAL','$'             ; Texto con el titulo del menu principal
    TEXT_MAIN_MENU_SINGLEPLAYER DB 'UN JUGADOR - Tecla S','$' ; Texto con el mensaje de un jugador en el menu principal
    TEXT_MAIN_MENU_MULTIPLAYER DB 'MULTIJUGADOR - Tecla M','$' ; Texto con el mensaje de multijugador en el menu principal
    TEXT_MAIN_MENU_EXIT DB 'SALIR DEL JUEGO - Tecla 0','$'   ; Texto con el mensaje de salir del juego
	
	BALL_ORIGINAL_X DW 0A0h              ; Posicion X de la pelota al comienzo del juego
	BALL_ORIGINAL_Y DW 64h               ; Posicion Y de la pelota al comienzo del juego
	BALL_X DW 0A0h                       ; Posicion X actual (columna) de la pelota
	BALL_Y DW 64h                        ; Posicion Y actual (linea) de la pelota
	BALL_SIZE DW 06h                     ; Tamano de la pelota (cuantos píxeles tiene de ancho y alto)
	BALL_VELOCITY_X DW 05h               ; Velocidad X (horizontal) de la pelota
	BALL_VELOCITY_Y DW 02h               ; Velocidad Y (vertical) de la pelota
	
	PADDLE_LEFT_X DW 0Ah                 ; Posicion X actual de la paleta izquierda
	PADDLE_LEFT_Y DW 55h                 ; Posicion Y actual de la paleta izquierda
	PLAYER_ONE_POINTS DB 0              ; Puntos actuales del jugador izquierdo (jugador uno)
	
	PADDLE_RIGHT_X DW 130h               ; Posicion X actual de la paleta derecha
	PADDLE_RIGHT_Y DW 55h                ; Posicion Y actual de la paleta derecha
	PLAYER_TWO_POINTS DB 0             ; Puntos actuales del jugador derecho (jugador dos)
	
	PADDLE_WIDTH DW 06h                  ; Ancho predeterminado de la paleta
	PADDLE_HEIGHT DW 25h                 ; Alto predeterminado de la paleta
	PADDLE_VELOCITY DW 0Fh               ; Velocidad predeterminada de la paleta

DATA ENDS

CODE SEGMENT PARA 'CODE'

	MAIN PROC FAR
	ASSUME CS:CODE,DS:DATA,SS:STACK      ; Asigna los segmentos CS, DS y SS respectivamente
	PUSH DS                              ; Guarda DS en la pila
	SUB AX,AX                            ; Limpia el registro AX
	PUSH AX                              ; Guarda AX en la pila
	MOV AX,DATA                          ; Carga en AX el contenido del segmento DATA
	MOV DS,AX                            ; Establece DS con el contenido de AX
	POP AX                               ; Restaura el valor superior de la pila en el registro AX
	POP AX                               ; Restaura el valor superior de la pila en el registro AX
		
		CALL CLEAR_SCREEN                ; Configura las configuraciones iniciales del modo de video
		
		CHECK_TIME:                      ; Bucle de verificación de tiempo
			
			CMP EXITING_GAME,01h
			JE START_EXIT_PROCESS
			
			CMP CURRENT_SCENE,00h
			JE SHOW_MAIN_MENU
			
			CMP GAME_ACTIVE,00h
			JE SHOW_GAME_OVER
			
			MOV AH,2Ch 					 ; Obtiene la hora del sistema
			INT 21h    					 ; CH = hora, CL = minutos, DH = segundos, DL = 1/100 de segundos
			
			CMP DL,TIME_AUX  			 ; ¿La hora actual es igual a la anterior (TIME_AUX)?
			JE CHECK_TIME    		     ; Si es igual, vuelve a verificar
			
			; Si llega a este punto, es porque el tiempo ha pasado
  
			MOV TIME_AUX,DL              ; Actualiza el tiempo
			
			CALL CLEAR_SCREEN            ; Limpia la pantalla reiniciando el modo de video
			
			CALL MOVE_BALL               ; Mueve la pelota y maneja las colisiones
			CALL DRAW_BALL               ; Dibuja la pelota en la pantalla
			
			CALL MOVE_PADDLES            ; Mueve las paletas de los jugadores
			CALL DRAW_PADDLES            ; Dibuja las paletas en la pantalla
			
			CALL DRAW_UI                 ; Dibuja la interfaz de usuario (puntos)
			
			JMP CHECK_TIME              ; Continúa en el bucle de verificación de tiempo

          SHOW_GAME_OVER:
				CALL DRAW_GAME_OVER_MENU
				JMP CHECK_TIME
				
			SHOW_MAIN_MENU:
				CALL DRAW_MAIN_MENU
				JMP CHECK_TIME
				
			START_EXIT_PROCESS:
				CALL CONCLUDE_EXIT_GAME
				
		RET		
	MAIN ENDP

MOVE_BALL PROC NEAR                  ; Proceso el movimiento de la pelota

;       Mueve la pelota horizontalmente
        MOV AX, BALL_VELOCITY_X
        ADD BALL_X, AX

;       Comprueba si la pelota ha pasado el límite izquierdo (BALL_X < 0 + WINDOW_BOUNDS)
;       Si está colisionando, reinicia su posicion
        MOV AX, WINDOW_BOUNDS
        CMP BALL_X, AX                    ; Se compara BALL_X con el limite izquierdo de la pantalla (0 + WINDOW_BOUNDS)
        JL GIVE_POINT_TO_PLAYER_TWO       ; Si es menor, da un punto al jugador dos y reinicia la posicion de la pelota

;       Comprueba si la pelota ha pasado el límite derecho (BALL_X > WINDOW_WIDTH - BALL_SIZE - WINDOW_BOUNDS)
;       Si está colisionando, reinicia su posicion
        MOV AX, WINDOW_WIDTH
        SUB AX, BALL_SIZE
        SUB AX, WINDOW_BOUNDS
        CMP BALL_X, AX	                ; Se compara BALL_X con el límite derecho de la pantalla (BALL_X > WINDOW_WIDTH - BALL_SIZE - WINDOW_BOUNDS)
        JG GIVE_POINT_TO_PLAYER_ONE       ; Si es mayor, da un punto al jugador uno y reinicia la posicion de la pelota
        JMP MOVE_BALL_VERTICALLY

GIVE_POINT_TO_PLAYER_ONE:        ; Da un punto al jugador uno y reinicia la posición de la pelota
        INC PLAYER_ONE_POINTS       ; Incrementa los puntos del jugador uno
        CALL RESET_BALL_POSITION     ; Reinicia la posicion de la pelota al centro de la pantalla

        CALL UPDATE_TEXT_PLAYER_ONE_POINTS ; Actualiza el texto de los puntos del jugador uno

        CMP PLAYER_ONE_POINTS, 05h   ; Comprueba si este jugador ha alcanzado 5 puntos
        JGE GAME_OVER                ; Si los puntos de este jugador son 5 o mas, el juego ha terminado
        RET
        
		GIVE_POINT_TO_PLAYER_TWO:        ; Dar un punto al jugador dos y reiniciar la posición de la pelota
        INC PLAYER_TWO_POINTS      ; Incrementar los puntos del jugador dos
        CALL RESET_BALL_POSITION   ; Restablecer la posición de la pelota al centro de la pantalla

        CALL UPDATE_TEXT_PLAYER_TWO_POINTS ; Actualizar el texto de los puntos del jugador dos

        CMP PLAYER_TWO_POINTS, 05h  ; Comprobar si este jugador ha alcanzado 5 puntos
        JGE GAME_OVER              ; Si los puntos de este jugador son 5 o más, el juego ha terminado

			RET
			
	

GAME_OVER:                       ; Alguien ha alcanzado 5 puntos
        CMP PLAYER_ONE_POINTS, 05h    ; Comprobar qué jugador tiene 5 o mas puntos
        JNL WINNER_IS_PLAYER_ONE     ; Si el jugador uno no tiene menos de 5 puntos, es el ganador
        JMP WINNER_IS_PLAYER_TWO     ; Si no, el ganador es el jugador dos

WINNER_IS_PLAYER_ONE:
        MOV WINNER_INDEX, 01h     ; Actualizar el indice del ganador con el indice del jugador uno
        JMP CONTINUE_GAME_OVER

WINNER_IS_PLAYER_TWO:
        MOV WINNER_INDEX, 02h     ; Actualizar el indice del ganador con el indice del jugador dos
        JMP CONTINUE_GAME_OVER

CONTINUE_GAME_OVER:
        MOV PLAYER_ONE_POINTS, 00h   ; Reiniciar los puntos del jugador uno
        MOV PLAYER_TWO_POINTS, 00h   ; Reiniciar los puntos del jugador dos
        CALL UPDATE_TEXT_PLAYER_ONE_POINTS
        CALL UPDATE_TEXT_PLAYER_TWO_POINTS
        MOV GAME_ACTIVE, 00h         ; Detiene el juego
        RET	

; Mover la pelota verticalmente
MOVE_BALL_VERTICALLY:
    MOV AX, BALL_VELOCITY_Y
    ADD BALL_Y, AX

; Comprobar si la pelota ha pasado la barrera superior (BALL_Y < 0 + WINDOW_BOUNDS)
; Si hay colision, invertir la velocidad en Y
    MOV AX, WINDOW_BOUNDS
    CMP BALL_Y, AX                  ; BALL_Y se compara con la barrera superior de la pantalla (0 + WINDOW_BOUNDS)
    JL NEG_VELOCITY_Y               ; Si es menor, invertir la velocidad en Y

; Comprobar si la pelota ha pasado la barrera inferior (BALL_Y > WINDOW_HEIGHT - BALL_SIZE - WINDOW_BOUNDS)
; Si hay colisión, invertir la velocidad en Y
    MOV AX, WINDOW_HEIGHT
    SUB AX, BALL_SIZE
    SUB AX, WINDOW_BOUNDS
    CMP BALL_Y, AX                  ; BALL_Y se compara con la barrera inferior de la pantalla (BALL_Y > WINDOW_HEIGHT - BALL_SIZE - WINDOW_BOUNDS)
    JG NEG_VELOCITY_Y               ; Si es mayor, invertir la velocidad en Y

; Comprobar si la pelota está colisionando con la paleta derecha
; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
; BALL_X + BALL_SIZE > PADDLE_RIGHT_X && BALL_X < PADDLE_RIGHT_X + PADDLE_WIDTH
; && BALL_Y + BALL_SIZE > PADDLE_RIGHT_Y && BALL_Y < PADDLE_RIGHT_Y + PADDLE_HEIGHT

    MOV AX, BALL_X
    ADD AX, BALL_SIZE
    CMP AX, PADDLE_RIGHT_X
    JNG CHECK_COLLISION_WITH_LEFT_PADDLE ; Si no hay colision, verificar las colisiones con la paleta izquierda
    
	MOV AX, PADDLE_RIGHT_X
    ADD AX, PADDLE_WIDTH
    CMP BALL_X, AX
    JNL CHECK_COLLISION_WITH_LEFT_PADDLE  ; Si no hay colision, verificar las colisiones con la paleta izquierda
    
    MOV AX, BALL_Y
    ADD AX, BALL_SIZE
    CMP AX, PADDLE_RIGHT_Y
    JNG CHECK_COLLISION_WITH_LEFT_PADDLE  ; Si no hay colision, verificar las colisiones con la paleta izquierda
    
    MOV AX, PADDLE_RIGHT_Y
    ADD AX, PADDLE_HEIGHT
    CMP BALL_Y, AX
    JNL CHECK_COLLISION_WITH_LEFT_PADDLE  ; Si no hay colision, verificar las colisiones con la paleta izquierda
    
    ; Si llega a este punto, la pelota esta colisionando con la paleta derecha
    JMP NEG_VELOCITY_X
    
    ; Comprobar si la pelota está colisionando con la paleta izquierda
    CHECK_COLLISION_WITH_LEFT_PADDLE:
    ; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
    ; BALL_X + BALL_SIZE > PADDLE_LEFT_X && BALL_X < PADDLE_LEFT_X + PADDLE_WIDTH
    ; && BALL_Y + BALL_SIZE > PADDLE_LEFT_Y && BALL_Y < PADDLE_LEFT_Y + PADDLE_HEIGHT

    MOV AX, BALL_X
    ADD AX, BALL_SIZE
    CMP AX, PADDLE_LEFT_X
    JNG EXIT_COLLISION_CHECK  ; Si no hay colision, salir de la comprobacion de colisión
		
		MOV AX,PADDLE_LEFT_X
		ADD AX,PADDLE_WIDTH
		CMP BALL_X,AX
		JNL EXIT_COLLISION_CHECK  
		
		MOV AX,BALL_Y
		ADD AX,BALL_SIZE
		CMP AX,PADDLE_LEFT_Y
		JNG EXIT_COLLISION_CHECK  
		
		MOV AX,PADDLE_LEFT_Y
		ADD AX,PADDLE_HEIGHT
		CMP BALL_Y,AX
		JNL EXIT_COLLISION_CHECK  
		
;       If it reaches this point, the ball is colliding with the left paddle	

		JMP NEG_VELOCITY_X
		
		NEG_VELOCITY_Y:
    NEG BALL_VELOCITY_Y   ; Invierte la velocidad en Y de la pelota (BALL_VELOCITY_Y = -BALL_VELOCITY_Y)
    RET
    NEG_VELOCITY_X:
    NEG BALL_VELOCITY_X   ; Invierte la velocidad horizontal de la pelota
    RET
			
		EXIT_COLLISION_CHECK:
			RET
	MOVE_BALL ENDP
	
	MOVE_PADDLES PROC NEAR               ; Proceso de movimiento de las paletas

    ; Movimiento de la paleta izquierda
    
    ; Comprueba si se está presionando alguna tecla (si no, verifica la paleta derecha)
    MOV AH, 01h
    INT 16h
    JZ CHECK_RIGHT_PADDLE_MOVEMENT ; ZF = 1, JZ -> Salta si es Cero
    
    ; Comprueba qué tecla se ha presionado (AL = carácter ASCII)
    MOV AH, 00h
    INT 16h
    
    ; Si es 'w' o 'W', mueve hacia arriba
    CMP AL, 77h ; 'w'
    JE MOVE_LEFT_PADDLE_UP
    CMP AL, 57h ; 'W'
    JE MOVE_LEFT_PADDLE_UP
    
    ; Si es 's' o 'S', mueve hacia abajo
    CMP AL, 73h ; 's'
    JE MOVE_LEFT_PADDLE_DOWN
    CMP AL, 53h ; 'S'
    JE MOVE_LEFT_PADDLE_DOWN
    JMP CHECK_RIGHT_PADDLE_MOVEMENT

		MOVE_LEFT_PADDLE_UP:
			MOV AX,PADDLE_VELOCITY
			SUB PADDLE_LEFT_Y,AX
			
			MOV AX,WINDOW_BOUNDS
			CMP PADDLE_LEFT_Y,AX
			JL FIX_PADDLE_LEFT_TOP_POSITION
			JMP CHECK_RIGHT_PADDLE_MOVEMENT
			
			FIX_PADDLE_LEFT_TOP_POSITION:
				MOV PADDLE_LEFT_Y,AX
				JMP CHECK_RIGHT_PADDLE_MOVEMENT
			
		MOVE_LEFT_PADDLE_DOWN:
			MOV AX,PADDLE_VELOCITY
			ADD PADDLE_LEFT_Y,AX
			MOV AX,WINDOW_HEIGHT
			SUB AX,WINDOW_BOUNDS
			SUB AX,PADDLE_HEIGHT
			CMP PADDLE_LEFT_Y,AX
			JG FIX_PADDLE_LEFT_BOTTOM_POSITION
			JMP CHECK_RIGHT_PADDLE_MOVEMENT
			
			FIX_PADDLE_LEFT_BOTTOM_POSITION:
				MOV PADDLE_LEFT_Y,AX
				JMP CHECK_RIGHT_PADDLE_MOVEMENT
		
		
;      ; Movimiento de la paleta derecha
CHECK_RIGHT_PADDLE_MOVEMENT:

    ; Si es 'o' o 'O', mueve hacia arriba
    CMP AL, 6Fh ; 'o'
    JE MOVE_RIGHT_PADDLE_UP
    CMP AL, 4Fh ; 'O'
    JE MOVE_RIGHT_PADDLE_UP
    
    ; Si es 'l' o 'L', mueve hacia abajo
    CMP AL, 6Ch ; 'l'
    JE MOVE_RIGHT_PADDLE_DOWN
    CMP AL, 4Ch ; 'L'
    JE MOVE_RIGHT_PADDLE_DOWN
    JMP EXIT_PADDLE_MOVEMENT

			MOVE_RIGHT_PADDLE_UP:
				MOV AX,PADDLE_VELOCITY
				SUB PADDLE_RIGHT_Y,AX
				
				MOV AX,WINDOW_BOUNDS
				CMP PADDLE_RIGHT_Y,AX
				JL FIX_PADDLE_RIGHT_TOP_POSITION
				JMP EXIT_PADDLE_MOVEMENT
				
				FIX_PADDLE_RIGHT_TOP_POSITION:
					MOV PADDLE_RIGHT_Y,AX
					JMP EXIT_PADDLE_MOVEMENT
			
			MOVE_RIGHT_PADDLE_DOWN:
				MOV AX,PADDLE_VELOCITY
				ADD PADDLE_RIGHT_Y,AX
				MOV AX,WINDOW_HEIGHT
				SUB AX,WINDOW_BOUNDS
				SUB AX,PADDLE_HEIGHT
				CMP PADDLE_RIGHT_Y,AX
				JG FIX_PADDLE_RIGHT_BOTTOM_POSITION
				JMP EXIT_PADDLE_MOVEMENT
				
				FIX_PADDLE_RIGHT_BOTTOM_POSITION:
					MOV PADDLE_RIGHT_Y,AX
					JMP EXIT_PADDLE_MOVEMENT
		
		EXIT_PADDLE_MOVEMENT:
		
			RET
		
	MOVE_PADDLES ENDP
	
	RESET_BALL_POSITION PROC NEAR        ;"resetear la posición de la pelota a la posicion original"
		
		MOV AX,BALL_ORIGINAL_X
		MOV BALL_X,AX
		
		MOV AX,BALL_ORIGINAL_Y
		MOV BALL_Y,AX
		
		NEG BALL_VELOCITY_X
		NEG BALL_VELOCITY_Y
		
		RET
	RESET_BALL_POSITION ENDP
	
	DRAW_BALL PROC NEAR                  
		
		MOV CX,BALL_X                    ;"Establecer la columna inicial (X)"
		MOV DX,BALL_Y                   ;Establecer la línea inicial (Y)"
		
		DRAW_BALL_HORIZONTAL:
			
          MOV AH, 0Ch ; establecer la configuracion para escribir un pixel
          MOV AL, 0Fh ; elegir blanco como color
          MOV BH, 00h ; establecer el número de pagina
          INT 10h ; ejecutar la configuracion"
			
			INC CX     					 ;CX = CX + 1
			MOV AX,CX          	  		 ;CX - BALL_X > BALL_SIZE (Si Y -> avanzamos a la siguiente línea, Si N -> continuamos en la siguiente columna)
			SUB AX,BALL_X
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
			
			MOV CX,BALL_X 				 ;El registro CX vuelve a la columna inicial.
			INC DX       				 ;Avanzamos una línea.
			
			MOV AX,DX             		 ;DX - BALL_Y > BALL_SIZE (Si Y -> salimos de esta rutina, Si N -> continuamos en la siguiente línea).
			SUB AX,BALL_Y
			CMP AX,BALL_SIZE
			JNG DRAW_BALL_HORIZONTAL
		
		RET
	DRAW_BALL ENDP
	
	DRAW_PADDLES PROC NEAR
		
		MOV CX,PADDLE_LEFT_X 			 ; establece la columna inicial (X)
		MOV DX,PADDLE_LEFT_Y 			 ; establece la columna inicial (X)
		
		DRAW_PADDLE_LEFT_HORIZONTAL:
			MOV AH,0Ch 					 ;establece la configuración para escribir un pixel
			MOV AL,0Fh 					 ;elige el color blanco
			MOV BH,00h 					 ;establece el numero de página 
			INT 10h    					 ;: ejecuta la configuración
			
			INC CX     				 	 ;CX = CX + 1
			MOV AX,CX         			 ;CX - PADDLE_LEFT_X > PADDLE_WIDTH (Y -> Pasamos a la siguiente línea, N -> Continuamos en la siguiente columna
			SUB AX,PADDLE_LEFT_X
			CMP AX,PADDLE_WIDTH
			JNG DRAW_PADDLE_LEFT_HORIZONTAL
			
			MOV CX,PADDLE_LEFT_X 		 ;el registro CX vuelve a la columna inicial
             INC DX                       ; avanzamos una línea
			      				 
			
			MOV AX,DX            	     ;DX - PADDLE_LEFT_Y > PADDLE_HEIGHT (Y -> salimos de esta función, N -> continuamos en la siguiente línea
			SUB AX,PADDLE_LEFT_Y
			CMP AX,PADDLE_HEIGHT
			JNG DRAW_PADDLE_LEFT_HORIZONTAL
			
			
		MOV CX,PADDLE_RIGHT_X 			 ;establece la columna inicial (X)
		MOV DX,PADDLE_RIGHT_Y 			 ;establece la fila inicial (Y)")
		
		DRAW_PADDLE_RIGHT_HORIZONTAL:
			MOV AH,0Ch 					 ;establece la configuracion para escribir un píxel
			MOV AL,0Fh 					 ;elige el color blanco
			MOV BH,00h 					 ;establece el número de pagina
			INT 10h    					 ;ejecuta la configuracion
			
			INC CX     					 ;Incrementa el valor de CX en 1.
			MOV AX,CX         			 ;CX - PADDLE_RIGHT_X > PADDLE_WIDTH (Y -> We go to the next line,N -> We continue to the next column
			SUB AX,PADDLE_RIGHT_X
			CMP AX,PADDLE_WIDTH
			JNG DRAW_PADDLE_RIGHT_HORIZONTAL
			
			MOV CX,PADDLE_RIGHT_X		 ;Copia el valor de CX en AX
			INC DX       				 ;we advance one line
			
			MOV AX,DX            	     ;CX - PADDLE_RIGHT_X > PADDLE_WIDTH (Y -> Nos movemos a la siguiente línea, N -> Continuamos en la siguiente columna.
			SUB AX,PADDLE_RIGHT_Y
			CMP AX,PADDLE_HEIGHT
			JNG DRAW_PADDLE_RIGHT_HORIZONTAL
			
		RET
	DRAW_PADDLES ENDP
	
	DRAW_UI PROC NEAR
		
;       Draw the points of the left player (player one)
		
		MOV AH,02h                       ;Establece la posicion del cursor.
		MOV BH,00h                       ;Establece el nuumero de página
		MOV DH,04h                       ;Establece la fila. 
		MOV DL,06h						 ;Establece la columna.
		INT 10h							 
		
		MOV AH,09h                       ;Escribe una cadena en la salida estándar
		LEA DX,TEXT_PLAYER_ONE_POINTS    ;; Carga en DX un puntero a la cadena TEXT_PLAYER_ONE_POINTS
		INT 21h                          ;Imprime la cadena 
		
;       Dibuja los puntos del jugador derecho (jugador dos)
		
		MOV AH,02h                       ;Establece la posicion del cursor.
		MOV BH,00h                       ;Establece el numero de página
		MOV DH,04h                       ;Establece la fila.  
		MOV DL,1Fh						 ;Establece la columna.
		INT 10h							 
		
		MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
		LEA DX,TEXT_PLAYER_TWO_POINTS    ;give DX a pointer to the string TEXT_PLAYER_ONE_POINTS
		INT 21h                          ;print the string 
		
		RET
	DRAW_UI ENDP
	
	UPDATE_TEXT_PLAYER_ONE_POINTS PROC NEAR
		
		XOR AX,AX
		MOV AL,PLAYER_ONE_POINTS ;given, for example that P1 -> 2 points => AL,2
		
		;Antes de imprimir en la pantalla, necesitamos convertir el valor decimal en su representación de código ASCII. Esto se logra agregando 30h (30 en hexadecimal) al valor para convertirlo a su equivalente en código ASCII. Para convertir un valor ASCII nuevamente a su forma decimal, simplemente restaríamos 30h del valor ASCII.
		ADD AL,30h                       ;AL,'2'
		MOV [TEXT_PLAYER_ONE_POINTS],AL
		
		RET
	UPDATE_TEXT_PLAYER_ONE_POINTS ENDP
	
	UPDATE_TEXT_PLAYER_TWO_POINTS PROC NEAR
		
		XOR AX,AX
		MOV AL,PLAYER_TWO_POINTS ;given, for example that P2 -> 2 points => AL,2
		
		;Ahora, antes de imprimir en la pantalla, necesitamos convertir el valor decimal en su representación de código ASCII. Esto se logra agregando 30h (30 en hexadecimal) al valor para convertirlo a su equivalente en código ASCII. Para convertir un valor ASCII nuevamente a su forma decimal, simplemente restaríamos 30h del valor ASCII.
		ADD AL,30h                       ;AL,'2'
		MOV [TEXT_PLAYER_TWO_POINTS],AL
		
		RET
	UPDATE_TEXT_PLAYER_TWO_POINTS ENDP
	
	DRAW_GAME_OVER_MENU PROC NEAR        
		
		CALL CLEAR_SCREEN               

;       Shows the menu title
		MOV AH,02h                       ;Establece la posicion del cursor.
		MOV BH,00h                       ;Establece el numero de página
		MOV DH,04h                       ;Establece la fila 
		MOV DL,04h						 ;Establece la columna
		INT 10h							 
		
		MOV AH,09h                       ;Escribe una cadena en la salida estándarT
		LEA DX,TEXT_GAME_OVER_TITLE      ;Carga en DX un puntero 
		INT 21h                          

;       Shows the winner
		MOV AH,02h                       
		MOV BH,00h                       
		MOV DH,06h                        
		MOV DL,04h						 
		INT 10h							 
		
		CALL UPDATE_WINNER_TEXT
		
		MOV AH,09h                       ;Carga AH con 09h para escribir una cadena en la salida estándar
		LEA DX,TEXT_GAME_OVER_WINNER      ;Carga en DX un puntero 
		INT 21h                          
		
;       Shows the play again message
		MOV AH,02h                       
		MOV BH,00h                       
		MOV DH,08h                       
		MOV DL,04h						 
		INT 10h							 

		MOV AH,09h                       ;Carga AH con 09h para escribir una cadena en la salida estándar
		LEA DX,TEXT_GAME_OVER_PLAY_AGAIN      ;Carga en DX un puntero 
		INT 21h                          
		
;       Shows the main menu message
		MOV AH,02h                       ;Establece la posicion del cursor
		MOV BH,00h                       ;Establece el numero de página
		MOV DH,0Ah                       ;Establece la fila  
		MOV DL,04h						 ;Establece la columna
		INT 10h							 

		MOV AH,09h                       ;Carga AH con 09h para escribir una cadena en la salida estándar
		LEA DX,TEXT_GAME_OVER_MAIN_MENU      ;Carga en DX un puntero  
		INT 21h                          
		
;      Espera la pulsación de una tecla
		MOV AH,00h
		INT 16h

;       Si la tecla es 'R' o 'r', reiniciar el juego.		
		CMP AL,'R'
		JE RESTART_GAME
		CMP AL,'r'
		JE RESTART_GAME
;       Si la tecla es 'E' o 'e', regresar al menú principal.
		CMP AL,'E'
		JE EXIT_TO_MAIN_MENU
		CMP AL,'e'
		JE EXIT_TO_MAIN_MENU
		RET
		
		RESTART_GAME:
			MOV GAME_ACTIVE,01h
			RET
		
		EXIT_TO_MAIN_MENU:
			MOV GAME_ACTIVE,00h
			MOV CURRENT_SCENE,00h
			RET
			
	DRAW_GAME_OVER_MENU ENDP
	
	DRAW_MAIN_MENU PROC NEAR
		
		CALL CLEAR_SCREEN
		
;       Muestra el título del menú (menu title).
		MOV AH,02h                       
		MOV BH,00h                       
		MOV DH,04h                       
		MOV DL,04h						 
		INT 10h							 
		
		MOV AH,09h                       
		LEA DX,TEXT_MAIN_MENU_TITLE      
		INT 21h                          
		
;      Muestra el mensaje de un jugador (singleplayer)
		MOV AH,02h                      
		MOV BH,00h                       
		MOV DH,06h                        
		MOV DL,04h						 
		INT 10h							 
		
		MOV AH,09h                       
		LEA DX,TEXT_MAIN_MENU_SINGLEPLAYER      
		INT 21h                          
		
;       Muestra el mensaje de multijugador (multiplayer message).
		MOV AH,02h                       
		MOV BH,00h                       
		MOV DH,08h                       
		MOV DL,04h						 
		INT 10h							 
		
		MOV AH,09h                       ;WRITE STRING TO STANDARD OUTPUT
		LEA DX,TEXT_MAIN_MENU_MULTIPLAYER      ;give DX a pointer 
		INT 21h                          ;print the string
		
;       Muestra el mensaje de salida (exit message).
		MOV AH,02h                       
		MOV BH,00h                       
		MOV DH,0Ah                     
		MOV DL,04h						 
		INT 10h							 
		
		MOV AH,09h                       
		LEA DX,TEXT_MAIN_MENU_EXIT      
		INT 21h                          	
		
		MAIN_MENU_WAIT_FOR_KEY:
;       Espera una pulsación de tecla.
			MOV AH,00h
			INT 16h
		
;      Verifica qué tecla se presiono.
			CMP AL,'S'
			JE START_SINGLEPLAYER
			CMP AL,'s'
			JE START_SINGLEPLAYER
			CMP AL,'M'
			JE START_MULTIPLAYER
			CMP AL,'m'
			JE START_MULTIPLAYER
			CMP AL,'E'
			JE EXIT_GAME
			CMP AL,'0'
			JE EXIT_GAME
			JMP MAIN_MENU_WAIT_FOR_KEY
			
		START_SINGLEPLAYER:
			MOV CURRENT_SCENE,01h
			MOV GAME_ACTIVE,01h
			RET
		
		START_MULTIPLAYER:
			JMP MAIN_MENU_WAIT_FOR_KEY ;TODO
		
		EXIT_GAME:
			MOV EXITING_GAME,01h
			RET

	DRAW_MAIN_MENU ENDP
	
	UPDATE_WINNER_TEXT PROC NEAR
		
		MOV AL,WINNER_INDEX              ;Si el índice del ganador es 1, entonces AL se establece en 1
		ADD AL,30h                       ;AL,31h => AL,'1'
		MOV [TEXT_GAME_OVER_WINNER+7],AL ;Actualiza el índice en el texto con el caracter.
		
		RET
	UPDATE_WINNER_TEXT ENDP
	
	CLEAR_SCREEN PROC NEAR               ;Limpiar la pantalla reiniciando el modo de video.
	
			MOV AH,00h                   ;set the configuration to video mode
			MOV AL,13h                   ;Elegir el modo de video.
			INT 10h    					 ;Ejecutar la configuración 
		
			;MOV AH,0Bh 					 ;"Establecer la configuración.
			;MOV BH,00h 					 ;A color de fondo.
			;MOV BL,00h 					 ;Elige negro como color de fondo
			;INT 10h    					 ;Ejecuta la configuración."
			
			RET
			
	CLEAR_SCREEN ENDP
	
	CONCLUDE_EXIT_GAME PROC NEAR         ;Vuelve al modo de texto
		
		MOV AH,00h                   ;Establece la configuración en modo de vídeo
		MOV AL,02h                   ;Selecciona el modo de vídeo
		INT 10h    					 ;Ejecuta la configuración
		
		MOV AH,4Ch                   ;terminate program
		INT 21h

	CONCLUDE_EXIT_GAME ENDP

CODE ENDS
END