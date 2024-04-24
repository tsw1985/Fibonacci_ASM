; COMPILAR :
; 1- nasm fichero.asm -f obj
; 2- alink fichero.obj -oEXE
	
segment DATOS
	msg                DB 'DIVIDIENDO...! $'
	msg2               DB 'CREATE_NUMBER_BY_DIVISIONS...! $'
	msg3               DB 'RESTOS DEL NUMERO GUARDADOS EN PILA...! $'
	msg4               DB 'Haciendo intercambio de valores ...$'

	num_a 			   DW 1     ; num_a
	num_b 			   DW 1     ; num_b
	num_c 			   DW 0     ; acumulador
	
	num_a_aux		   DW 0     ; num_a
	num_b_aux		   DW 0     ; num_b
	num_c_aux		   DW 0     ; acumulador

	cadena             RESB 50   ; espacio que tendrá los digitos del numero  
	contador           DW 0      ; guardaremos cuantas iteraciones (divisiones) se hicieron
	vueltas_fibo       DW 4      ; guardaremos cuantas iteraciones (divisiones) se hicieron
	contador_vueltas_fibo DW 0
	resto              DW 0      ; guardaremos el resto de cada division aqui
	contadorParaCadena DW 0      ; lo usaremos para desplazarnos byte a byte en  
	;nextCociente      DW 44267  ; NUMERO A VISUALIZAR EN PANTALLA
	nextCociente       DW 0  ; NUMERO A VISUALIZAR EN PANTALLA

segment PILA stack
		resb 256
	InicioPila:
		;Aqui están los valores

segment CODIGO

..start:
; ----- START FIBO LOOP

XOR AX,AX        ; ponemos AX a 0
MOV AX,DATOS     ; ponemos en AX con el segmento de datos
MOV DS,AX        ; seteamos donde está el segmento de datos
XOR CX,CX
MOV CX,[contador_vueltas_fibo]

fibo:

	XOR AX,AX        ; ponemos AX a 0
	MOV AX,DATOS     ; ponemos en AX con el segmento de datos
	MOV DS,AX        ; seteamos donde está el segmento de datos
	
	MOV AX,[num_a]    ; ponemos numero a
	MOV BX,[num_b]    ; ponemos numero b
	ADD AX,BX         ; sumamos a+b
		
	; AQUI HAY QUE IMPRIMIR EL NUMERO !!!
		MOV [nextCociente],AX       ; ponemos en AX el numero que queremos dividir para empezar las iteraciones de division.
		CALL PRINT_TEST
		CALL CREATE_NUMBER_BY_DIVISIONS ; llamamos a create number . Formará el número desde la PILA
		;CALL PRINT_INTERCAMBIO
		
		;CALL PRINT_FIN_CALCULAR_RESTOS ; mostramos restos ya guardamos
		;CALL PROCESO_IMPRIMIR_NUMERO
	;FIN AQUI HAY QUE IMPRIMIR EL NUMERO !!!
	

	MOV [num_c],AX    ; c = a + b . ponemos en num_c el total de la suma
	MOV AX,[num_b]    ; ponemos en AX el valor de B
	MOV[num_a],AX     ; a=b ponemos el valor de BX
	MOV AX,[num_c]    ; metemos en AX valor de C
	MOV [num_b],AX;   ; b = c
	
	;LOOP fibo
	
	
	XOR AX,AX             ; ponemos AX a 0
	MOV AX,DATOS          ; ponemos en AX con el segmento de datos
	MOV DS,AX             ; seteamos donde está el segmento de datos
	INC CX
	MOV [contador_vueltas_fibo],CX
	XOR AX,AX
	MOV AX,[contador_vueltas_fibo]
	MOV BX,[vueltas_fibo]
	CMP AX,BX  ; ¿ Ya el contador de vueltas fibo es igual al total de vueltas?
	JNE fibo

	
	CALL FIN           ; fin programa
	

	

	
;Aqui ya next cociente tiene el numero a mostrar , el resultado de la correspondiente suma
;en cada iteracion	
CREATE_NUMBER_BY_DIVISIONS:
	;hay que pillar el numero que esta almacenado en 
	;CALL PRINT_TEST_DIV
	
	;PUSH AX
	;PUSH BX
	;PUSH CX
	;PUSH DX

	CONTINUE_CALC:	
	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX                   ; ponemos DS con AX
	MOV AX,[nextCociente]       ; (ignorada)
	
	; mete los restos del numero en la stack para visualizarlo luego ( 12345 = 54321 )	
	; DIVISION
	MOV BX,10   				; Dividimos el numero que hay en 'nextCociente' / 10
	XOR DX,DX           		; aqui irá el resto
	DIV BX              		; ejecutamos la division . La instrucción DIV que 
								; guardará en AX el cociente y el resto en DX.
								
	MOV [nextCociente], AX		; segun dividimos metemos en nextCociente el cociente
	
	PUSH DX             		; guardamos resto en PILA que está en DX
	; FIN DIVISION

	; CONTADORES
	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX                   ; ponemos DS con AX
	MOV CX,[contador]   		; ponemos el valor de contador en CX
	INC CX              		; incrementamos CX para ir guardando cuantos numeros van
	MOV [contador],CX     		; guardo en contador las iteraciones

	; FIN CONTADORES

	; COMPROBACIONES
	MOV AX,[nextCociente]  	    ; PONEMOS DE NUEVO AX con el valor del cociente actual
	CMP AX,0 					; ¿ ya el cociente es 0 ?
	JNE CONTINUE_CALC      		; ¿ no ? sigue dividiendo
	;JE PRINT_FIN_CALCULAR_RESTOS           ; ¿ si ? pues vamos a sacar los numeros
	
	;POP DX
	;POP CX
	;POP BX
	;POP AX

RET



;------------------- *********** ---------------------
PROCESO_IMPRIMIR_NUMERO:

	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX


	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX                   ; ponemos DS con AX

	XOR CX,CX				    ; Ponemos CX a 0
	MOV CX,[contador] 			; ponemos el contador de CX con el total de iteraciones de division
								; ya que la instruccion LOOP necesita que CX tenga el numero de iteraciones

SACA_RESTO: 					; GUARDAR DIGITO ASCII EN variable CADENA
	
	POP DX					    ; Sacamos 1 valor de la pila y lo guardamos DX , aquí estan los numeros
							    ; apilados de detras a delante 68322 (22386)

	ADD DX,'0'      		    ; DX contiene el numero guardado pero necesitamos pasarlos a codigo ASCII
							    ; para ello sumamos el 0 (48 en decimal) y obtenemos el digito ASCII que equivale
							    ; a ese NUMERO
							
	MOV BX,[contadorParaCadena] ; ponemos en BX el contador para cadena ( estará a 0 ). Es donde almacenaremos los 
							    ; numeros para luego pasar su segmento y desplazamiento a la funcion 9h int 21 
								; (imprimir cadena).
	
	MOV [cadena + BX],DX 	    ; Una vez situados en el segmento de DATOS accedemos a la variable cadena 
								;( espacio de bytes) donde iremos poniendo nuestros numeros para luego verlos.
                                ; Iremos avanzando posicion a posicion con BX. [0][1][2][3] ... y poniendo
								; el resultado de la suma de DX + '0'.

	
	INC BX                      ; incrementamos BX para que en la siguiente vuelta sea +1
	MOV [contadorParaCadena],BX ; guardamos en el contador su numero valor incrementado +1
LOOP SACA_RESTO

	
	INC BX                      ; le sumo 1 más para añadir el caracter $ que indica fin de cadena 
	MOV AL,'$'                  ; añadimos el $ al final de la CADENA ,uso AL para guardar el caracter $
	MOV [cadena + BX],AL 	    ; GUARDAMOS EL VALOR $ en el final de la cadena.
	
	POP DX
	POP CX
	POP BX
	POP AX

RET



; CALL PRINT_NUMBER               ; imprimimos ya el numero
; PRINT_NUMBER:
	
	; PUSH AX						; Guardamos en la pila los registros usados.
	; PUSH BX
	; PUSH CX
	; PUSH DX
	
	; MOV AX,DATOS 
	; MOV DS,AX       		    ; METEMOS EN DS EL SEGMENTO DE LA VARAIBLE cadena
	; LEA DX,[cadena]             ; METEMOS EN DX EL OFFSET DE cadena
	; MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	; INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR

	; POP DX						; cuando terminemos de usar nuestras funciones volvemos
	; POP CX                      ; a recuperar los valores de los registros. Es una buena práctica
	; POP BX                      ; hace esto en las funciones según Peter Norton.
	; POP AX
	; RET						    ; cuando terminemos, pues retornamos

;---------------------- *************** ------------------

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
	
PRINT_TEST_DIV:

	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	MOV AX,DATOS 
	MOV DS,AX       		    ; METEMOS EN DS EL SEGMENTO DE LA VARAIBLE cadena
	LEA DX,[msg2]             ; METEMOS EN DX EL OFFSET DE cadena
	MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR		
	
	POP DX
	POP CX
	POP BX
	POP AX
	
	RET	
	
PRINT_FIN_CALCULAR_RESTOS:

	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	MOV AX,DATOS 
	MOV DS,AX       		    ; METEMOS EN DS EL SEGMENTO DE LA VARAIBLE cadena
	LEA DX,[msg3]             ; METEMOS EN DX EL OFFSET DE cadena
	MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR		
	
	POP DX
	POP CX
	POP BX
	POP AX
	
	RET		
	
PRINT_INTERCAMBIO:

	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	MOV AX,DATOS 
	MOV DS,AX       		    ; METEMOS EN DS EL SEGMENTO DE LA VARAIBLE cadena
	LEA DX,[msg4]             ; METEMOS EN DX EL OFFSET DE cadena
	MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR		
	
	POP DX
	POP CX
	POP BX
	POP AX
	
	RET		
	
	
