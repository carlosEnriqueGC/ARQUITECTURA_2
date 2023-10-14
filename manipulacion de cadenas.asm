
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

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
    je palin
    cmp [opcion], 020h
    je fin

palin: 
    
  
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
     
   
   
    menu db "Manipulacion de cadenas",13,10," Menu de opciones: ",13,10,"  1. Verificacion de palabra palindroma",13,10," Tecla espacio para salir",13,10," Opcion: $" 
    msgf db "Adios $"                                 


