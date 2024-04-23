; COMPILAR :
; 1- nasm fichero.asm -f obj
; 2- alink fichero.obj -oEXE
	
segment DATOS
	msg                DB 'DIVIDIENDO...! $'

	num_a 			   DW 1     ; num_a
	num_b 			   DW 1     ; num_b
	num_c 			   DW 0     ; acumulador
	
	num_a_aux		   DW 0     ; num_a
	num_b_aux		   DW 0     ; num_b
	num_c_aux		   DW 0     ; acumulador

	cadena             RESB 50   ; espacio que tendrá los digitos del numero  
	contador           DW 0      ; guardaremos cuantas iteraciones (divisiones) se hicieron
	contadorIters      DW 0      ; guardaremos cuantas iteraciones (divisiones) se hicieron
	resto              DW 0      ; guardaremos el resto de cada division aqui
	contadorParaCadena DW 0      ; lo usaremos para desplazarnos byte a byte en  
	;nextCociente       DW 44267  ; NUMERO A VISUALIZAR EN PANTALLA
	nextCociente       DW   ; NUMERO A VISUALIZAR EN PANTALLA

segment PILA stack
		resb 256
	InicioPila:
		;Aqui están los valores

segment CODIGO

..start:
; ----- START FIBO LOOP

XOR CX,CX
MOV CX,3

fibo:
	XOR AX,AX        ; ponemos AX a 0
	MOV AX,DATOS     ; ponemos en AX con el segmento de datos
	MOV DS,AX        ; seteamos donde está el segmento de datos

	XOR AX,AX
	MOV AX,[num_a]    ; ponemos numero a
	MOV BX,[num_b]    ; ponemos numero b
	ADD AX,BX         ; sumamos a+b
		
	; AQUI HAY QUE IMPRIMIR EL NUMERO !!!
		MOV [nextCociente],AX       ; ponemos en AX el numero que queremos dividir para empezar las iteraciones de division.
		
		CALL CREATE_NUMBER_BY_DIVISIONS                   ; llamamos a create number . Formará el número desde la PILA

	;FIN AQUI HAY QUE IMPRIMIR EL NUMERO !!!
	

	MOV [num_c],AX    ; c = a + b . ponemos en num_c el total de la suma
	MOV AX,[num_b]    ; ponemos en AX el valor de B
	MOV[num_a],AX     ; a=b ponemos el valor de BX
	MOV AX,[num_c]    ; metemos en AX valor de C
	MOV [num_b],AX;   ; b = c
						  
	;DEC CX            ; incrementamos contador para seguir dando iteraciones hasta 10
	;CMP CX,0
	;JNE fibo
	LOOP fibo
	CALL FIN           ; fin programa
	
;Aqui ya next cociente tiene el numero a mostrar , el resultado de la correspondiente suma
;en cada iteracion	
CREATE_NUMBER_BY_DIVISIONS
	;hay que pillar el numero que esta almacenado en 
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	
	CALL PRINT_TEST
	
	POP DX
	POP CX
	POP BX
	POP AX

RET	
	
	
	
	
FIN: 
	;CALL PRINT_TEST
                           ; fin programa
	MOV AH,4Ch                  ; Servicio DOS para finalizar un programa 
	INT 21h						; lanzamos la int 21h para ejecutarlo.
	
PRINT_TEST:

	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	MOV AX,DATOS 
	MOV DS,AX       		    ; METEMOS EN DS EL SEGMENTO DE LA VARAIBLE cadena
	LEA DX,[msg]             ; METEMOS EN DX EL OFFSET DE cadena
	MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR		
	
	
	
	POP DX
	POP CX
	POP BX
	POP AX
	
	RET
	
	
