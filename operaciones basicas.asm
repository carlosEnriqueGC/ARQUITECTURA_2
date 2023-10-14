org 100h
 
;variables


video:
    mov ah,00h
    mov al,00h         ;configurar video
    int 10h
    jmp principal

principal: 

    mov ax, 00h
    mov bx, 00h
    mov cx, 00h
    mov dx, 00h 

    mov ax,1            ;limpiar pantalla
    int 10h
     
    mov ah, 09h
    mov dx, offset menu
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
    cmp [opcion], 020h
    je fin

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
       
    jmp principal
           
    

resta:
 
     mov ax,2
    int 10h    ; aqui se expande la pantalla para mayor visualizacion 
    
    ;primero numero 
    mov ah,09h
    lea dx, msg
    int 21h
    
    
    mov ah,01h
    int 21h
    sub al,'0'
    
    mov [c1_num1],al 
    
    mov ah,01h
    int 21h
    sub al,'0'
    
    mov [c2_num1],al 
    
    ;segundo numero 
    mov ah,09h
    lea dx, msge
    int 21h
    
     mov ah,09h
    lea dx, msg
    int 21h
    
    
    mov ah,01h
    int 21h
    sub al,'0'
    
    mov [c1_num2],al 
    
    mov ah,01h
    int 21h
    sub al,'0'
    
    mov [c2_num2],al 
    
    ; Proceso de resta
    mov al, 00h

    mov bl, [c1_num1]
    mov cl, [c2_num1]
    mov al, [c1_num2]
    mov dl, [c2_num2]

    sub bl, al
    sub cl, dl

    ; Convertir BL y CL de ASCII a valores numéricos
    add bl, '0'
    add cl, '0'
        
    ; Mostrar mensaje para el resultado de la resta
    mov ah, 09h
    lea dx, msge
    int 21h
           
    mov ah, 09h
    lea dx, msgr
    int 21h  
   
      ; Mostrar el resultado de la resta en BL y CL
    mov ah, 02h
    mov dl, bl
    int 21h

    mov ah, 02h
    mov dl, cl
    int 21h
   
  
        
               
    ; Esperar a que se presione una tecla antes de salir
    mov ah, 0
    int 16h

    jmp principal


multi:
     mov ax,2
    int 10h    ; aqui se expande la pantalla para mayor visualizacion 
    
    
    
    
    
    ; Esperar a que se presione una tecla antes de salir
    mov ah, 0
    int 16h

    jmp principal
   
fin:
   mov ax, 1
   int 10h
   
   mov ah, 09h
   mov dx, offset msgf
   int 21h    
   
   
   mov ah,0
   int 16h
   ret
   
   
    
    opcion db 0  
    c1_num1 db 0 ; usados para la resta
    c2_num1 db 0 ; usados para la resta
    c1_num2 db 0 ; usados para la resta
    c2_num2 db 0 ; usados para la resta 
   
    resultado1  db 0
    menu db " Practica P2 operaciones de 2 numeros",13,10," Menu de opciones: ",13,10,"  1. suma",13,10,"  2. resta",13,10,"  3. multiplicacion",13,10," Tecla espacio para salir",13,10," Opcion: $" 
                                      
    msg db " Ingrese un numero (puede ser de dos cifras): $" 
    msge db "  ",13,10,"$"
    msgr db " Resultado: $" 
    msgf db " Adios :) $"
