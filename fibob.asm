; COMPILAR :
; 1- nasm fichero.asm -f obj
; 2- alink fichero.obj -oEXE
	
segment DATOS
	msg                DB 'MOSTRANDO NUMERO$'

	num_a 			   DW 1     ; num_a
	num_b 			   DW 1     ; num_b
	num_c 			   DW 0     ; acumulador
	
	num_a_aux		   DW 0     ; num_a
	num_b_aux		   DW 0     ; num_b
	num_c_aux		   DW 0     ; acumulador

	cadena             RESB 50   ; espacio que tendrá los digitos del numero  
	contador           DW 0      ; guardaremos cuantas iteraciones (divisiones) se hicieron
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

XOR AX,AX        ; ponemos AX a 0
MOV AX,DATOS     ; ponemos en AX con el segmento de datos
MOV DS,AX        ; seteamos donde está el segmento de datos
MOV AX,3191      ; ponemos valor
MOV [nextCociente],AX  ; metemos en next cociente el valor que hay en AX

XOR CX,CX 					; inicia CX a 0
CALL GET_NUMBER;



GET_NUMBER:

	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX                   ; ponemos DS con AX
	MOV AX,[nextCociente]       ; ponemos en AX el numero que queremos dividir para empezar las iteraciones de division.
	
	; DIVISION
	MOV BX,10   				; Dividimos el numero que hay en 'nextCociente' / 10
	XOR DX,DX           		; aqui irá el resto
	DIV BX              		; ejecutamos la division . La instrucción DIV que 
								; guardará en AX el cociente y el resto en DX.
								
	MOV [nextCociente], AX		; segun dividimos metemos en nextCociente el cociente
	
	PUSH DX             		; guardamos resto en PILA que está en DX
	MOV [resto],DX      		; y tambien lo guardamos en la variable RESTO
	; FIN DIVISION

	; CONTADORES
	MOV CX,[contador]   		; ponemos el valor de contador en CX
	INC CX              		; incrementamos CX para ir guardando cuantos numeros van
	MOV [contador],CX     		; guardo en contador las iteraciones
	; FIN CONTADORES

	; COMPROBACIONES
	MOV AX,[nextCociente]  	    ; PONEMOS DE NUEVO AX con el valor del cociente actual
	CMP AX,0 					; ¿ ya el cociente es 0 ?
	JE PROCESO_IMPRIMIR_NUMERO  ; ¿ si ? pues vamos a sacar los numeros
	JNE GET_NUMBER      		; ¿ no ? sigue dividiendo

PROCESO_IMPRIMIR_NUMERO:

	XOR CX,CX				    ; Ponemos CX a 0
	MOV CX,[contador] 			; ponemos el contador de CX con el total de iteraciones de division
								; ya que la instruccion LOOP necesita que CX tenga el numero de iteraciones

SACA_RESTO: 					; GUARDAR DIGITO ASCII EN variable CADENA
	
	XOR AX,AX       		    ; ponemos AX a cero
	MOV AX,DATOS    		    ; guardamos los restos en la variable cadena para luego imprimirla
	MOV DS,AX       		    ; Nos situamos en el segmento de datos
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

CALL PRINT_NUMBER               ; imprimimos ya el numero
CALL FIN				        ; terminamos la ejecucion del programa
	

	
	
PRINT_NUMBER:
	
	PUSH AX						; Guardamos en la pila los registros usados.
	PUSH BX
	PUSH CX
	PUSH DX
	
	MOV AX,DATOS 
	MOV DS,AX       		    ; METEMOS EN DS EL SEGMENTO DE LA VARAIBLE cadena
	LEA DX,[cadena]             ; METEMOS EN DX EL OFFSET DE cadena
	MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR

	POP DX						; cuando terminemos de usar nuestras funciones volvemos
	POP CX                      ; a recuperar los valores de los registros. Es una buena práctica
	POP BX                      ; hace esto en las funciones según Peter Norton.
	POP AX
	RET						    ; cuando terminemos, pues retornamos
	
FIN:                            ; fin programa
	MOV AH,4Ch                  ; Servicio DOS para finalizar un programa 
	INT 21h						; lanzamos la int 21h para ejecutarlo.