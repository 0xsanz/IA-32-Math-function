;Practica 2 de Arquitectura y Organización de Computadoras
;2ºCurso,Grado en Ingeniería Informática
;Pablo García Sanz

global calculo
extern x
extern y

segment .data
	;Definimos la constante UNO con valor 1.0
	UNO dd 1.0	

segment .bss
	;Palabra de control utilizada para realizar el truncamiento
	cword resw 1
	;Palabra reservada para hacer los cálculos más legibles.
	op1 resd 1

segment .text

calculo:
	;st0=x
	fld dword[x]
	;st0=| x |
	fabs
	;st0 > 1
	fcom dword[UNO]
	fstsw ax
	sahf
	
	;st0 <= 1 ---> else:
	jna else

	;Si | x | >1  continua ...
	;st0 = x , st1 = | x |
	fld dword[x]
	;st0 = x²
	fmul st0,st0
	;st0 = x²-1
	fsub dword[UNO]
	;st0 = sqrt(x²-1)
	fsqrt
	;st0 = x, st1 = sqrt( x²-1 ), st2 = | x |
	fld dword[x]
	;st0 = sin( x )
	fsin
	;st0 = sin( x )/sqrt( x²-1 )
	fdiv st0,st1
	
	;Guardamos st0 en memoria-->M[ op1 ] = st0 = sin( x )/sqrt( x²-1 )
	fst dword[op1]
	
	;Modiica los 2 bits de control de redondeo,para truncar
	;Carga la palabra de control
	fstcw word[cword]
	;Pone los dos bits de redondeo a 11
	or word[cword],11
	;Guarda la nueva palabra de control
	fldcw word[cword]
	;st0 = log2( e )
	fldl2e
	;st0 = x*log2( e )
	fmul dword[x]
	;st0 = x*log2( e ), st1 duplicado de st0
	fld st0
	;E parte entera del exponente
	;D parte decimal del exponente
	;Extraemos la parte entera del exponente
	;st0 = E
	frndint
	;st1 = exponente-E = D
	fsub st1,st0
	;st0 = D, st1 = E
	fxch
	;st0 = 2^(D)-1
	f2xm1
	;st0 = 2^1
	fld1
	fadd
	; st0 = E , st1 = 2^( D )
	fxch
	; st0 = 1 .0 , st1 = E , st2 = 2^( D )
	fld1
	fscale
	fmul st0,st2
	
	fmul dword[op1]
	;y = sin(x)/sqrt(x²-1)*e^x
	fst dword[y]
	;Devolvemos el control al programa que efectuó la llamada
	ret

;|x|<=1
else:	
	;st0=1
	fld1
	;y=1
	fst dword[y]
	ret
	
