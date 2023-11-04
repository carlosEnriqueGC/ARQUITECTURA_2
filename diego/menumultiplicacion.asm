
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

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
           

   
 
   
   
   
 
    
                   
ret

opcion db 0


msgm db "Operacion de Aritmeticas", 13, 10, "Sub-menu", 13, 10, "opciones:", 13, 10, " 1. Multiplicacion", 13, 10, " 2. Regresar al menu principal", 13, 10, "opcion: $"


 salir:
    mov ax, 1
    int 10h  
 .exit
end
