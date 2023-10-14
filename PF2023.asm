
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

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
   
    msgm db "Proyecto Universidad Mariano Galvez",13,10,"Carlos Guzman y Diego Marroquin",13,10,"opciones:",13,10," 1. ",13,10," 2. ",13,10," 3. ",13,10,"4. ",13,10,"5. ",13,10,"presione Esc para salir",13,10,"opcion: $"

    
    
    
    ret
    


