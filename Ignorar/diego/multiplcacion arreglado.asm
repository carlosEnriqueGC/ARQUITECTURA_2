
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
; Dirección de inicio para este programa

otro_programa:
.stack
.data        ;definición de datos(variables), donde se almacenara información      
include "emu8086.inc"
.code
imprimir macro num  
   mov ah,02h 
   mov dl,num
   add dl,30h
   int 21h    
endm   

leernum macro
   mov ah,01h     ;Function(character read) Guarda en AL
   int 21h        ;Interruption DOS functions
   sub al,30h     ;ajustamos valores
endm        

multiplica macro valor1, valor2
   mov al,valor1  ;al=5       ;unidad del segundo numero
   mov bl,valor2  ;bl=5       ;unidad del primer numero
   mul bl       ;al=25      ;multiplicar  
endm
    
suma macro valor1, valor2
   mov al,valor1      ;al=02        ;movemos el segundo resultado de la primera mult a al
   mov bl,valor2      ;bl=0         ;movemos primer resultado de la segunda mult a bl
   add al,bl      ;al=2   
endm  

separarUnidades macro
   mov ah,00h     ;ah=00        ;limpiamos el registro ah
   aam            ;ax=01 01     ;separamos de hex a dec
endm

   chr1  db ? ;primer digito
   chr2  db ? ;segundo digito
   chr3  db ? ;multiplo
   chr4  db ?
   r1    db ? ;resultado 1
   r2    db ? ;resultado 2
   r3    db ?
   r4    db ?
   ac    db 0 ;acarreo
   ac1   db 0     
   
.startup
   ;cls
   mov ah,00h     ;Function(Set video mode)
   mov al,03      ;Mode 80x25 8x8 16
   int 10h        ;Interruption Video
   
   leernum
   mov chr1,al    ;[chr1].chr2 * chr3 = ac.r1.r2
    
   leernum
   mov chr2,al    ;chr1.[chr2] * chr3 = ac.r1.r2

   print "*"

   leernum
   mov chr3,al    ;chr1.chr2 * [chr3] = ac.r1.r2
  
   leernum
   mov chr4,al    ;chr1.chr2 * [chr3] = ac.r1.r2

   print "="
   ;Realizamos operaci?n   
  
   multiplica chr4,chr2
   separarUnidades
   mov ac1,ah   ;ac1=02     ;decenas del primera multiplicacion
   mov r4,al    ;r4=05      ;unidades del primera multiplicacion
   
   multiplica chr4,chr1
   mov r3,al    ;r3=14h     ;movemos el resultado de la operacion a r3
   mov bl,ac1   ;bl=02      ;movemos el acarreo a bl
   add r3,bl    ;r3=16h     ;sumamos resultado mas acarreo
   mov al,r3    ;al=16h     ;movemos el resultado de la suma a al
   separarUnidades
   mov r3,al    ;r3=02      ;guardamos unidades en r3
   mov ac1,ah   ;ac1=0      ;guardamos decenas en ac1
  
   multiplica chr3,chr2
   separarUnidades
   mov ac,AH      ;ac=01    ;ac = AH (Acarreo)
   mov r2,AL      ;r2=0     ;r2 = AL       (Unidad del resultado)

   multiplica chr3,chr1
   mov r1,al      ;r1=8     ;r1 = AL       (Decena del resultado)
   mov bl,ac      ;bl=01    ;BL = Acarreo anterior
   add r1,bl      ;r1=9;    ;r1 = r1+ac (r1 + Acarreo)
   separarUnidades
   mov r1,al      ;r1=09    ;r1 = AL
   mov ac,ah      ;ac=0     ;ac = AH (Acarreo para la Centena del resultado)

   mov ax,0000h   ;limpiamos ax
   
   suma r3,r2
   separarUnidades
   mov r3,al      ;r3=02        ;r3 guarda las decenas del resultado final
   mov r2,ah      ;r2=0         ;r2 se utiliza como nuevo acarreo
  
   mov ax,0000h   ;''''
   
   suma ac1,r1
   suma al,r2
   separarUnidades
   mov r1,al      ;r1=01        ;r1 guarda las centenas
   mov r2,ah      ;R2=01        ;ah se sigue utilizando como acarreo
  
   mov al,r2      ;al=01        ;movemos el acarreo a al
   mov bl,ac      ;bl=00        movemos ac a bl
   add al,bl      ;al=01        ;sumamos al a bl
   ;aam            ;separamos hex a dec
   mov ac,al      ;ac=01        mov al a ac como nuestro acarreo final
 
   ;Mostramos resultado
   imprimir ac
   imprimir r1
   imprimir r3
   imprimir r4    
   
   DEFINE_SCAN_NUM
end   
  
   
   
   
   
   
   
   
   
    