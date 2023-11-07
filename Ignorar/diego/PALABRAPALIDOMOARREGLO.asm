
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
name "palindromo"
include 'emu8086.inc'
org 100h

jmp inicio()
palabra db 50h dup(?)
aux1 db 0
aux2 dw 0

msj1:
primero db 'Ingrese palabra: '
lz = $ - cod
db 06h, '$'
exito:
exitomsj db 'La palabra ingresada es palindrome.'
lz = $ - cod
db 06h,'$'
fallo:
fallomsj db 'La palabra ingresada no es palindrome.'
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


ret


end




