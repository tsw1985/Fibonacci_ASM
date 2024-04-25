; COMPILAR :
; 1- nasm fichero.asm -f obj
; 2- alink fichero.obj -oEXE

;***********************************************************************************
; int a = 1;
; int b = 1;
; int c = 0;
; System.out.println(a);
; for(int i = 0 ; i < 20 ; i++) {
	; c = a + b;
	; System.out.println(c);
	; a = b;
	; b = c;
; }
;***********************************************************************************

segment DATOS
	adios              DB 'Adios y gracias $'
	cadena             RESB 20   ; espacio que tendrá los digitos del numero  
	num_a 			   DW 1     ; num_a
	num_b 			   DW 1     ; num_b
	num_c 			   DW 0     ; acumulador
	contador           DW 0      ; guardaremos cuantas iteraciones (divisiones) se hicieron

	contador_fibos     DW 0      ; contador para controlar cuantas vueltas llevamos
	total_fibos        DW 10      ; total de vueltas fibonaccis que queremos hacers
	
	resto              DW 0      ; guardaremos el resto de cada division aqui
	contadorParaCadena DW 0      ; lo usaremos para desplazarnos byte a byte en  
	nextCociente       DW 0      ; NUMERO A VISUALIZAR EN PANTALLA

segment PILA stack
		resb 256
	InicioPila:
		;Aqui están los valores

segment CODIGO




..start:

	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX  
	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,[num_a]    ; ponemos numero a
	XOR BX,BX
	MOV BX,[num_b]    ; ponemos numero b


fibonacci:
;************************* ITER **************************
	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX  

	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,[num_a]    ; ponemos numero a
	XOR BX,BX
	MOV BX,[num_b]    ; ponemos numero b


;suma y guarda en el next cociente e inicia proceso de imprimir numero
	ADD AX,BX ; a + b 
	MOV [nextCociente],AX       ; ponemos en AX el numero que queremos dividir para empezar las iteraciones de division.	
	MOV [num_c],AX    ; c = a + b . ponemos en num_c el total de la suma que está guardado en AX
	CALL GET_NUMBER
	XOR AX,AX          ; ponemos AX a 0
	MOV [contador],AX  ; volvemos a poner los contadores de cadena a 0 para resetearlos
	MOV [contadorParaCadena],AX ; volvemos a poner los contadores de cadena a 0 para resetearlos
;fin suma y guarda en el next cociente e inicia proceso de imprimir numero


; intercambio de numeros



	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX
	XOR AX,AX	
	MOV AX,[num_b]    ; ponemos en AX el valor de B
	MOV[num_a],AX     ; a=b ponemos el valor de BX
	XOR BX,BX
	MOV BX,[num_c]    ; metemos en AX valor de C
	MOV [num_b],BX;   ; b = c
	
	


	;MOV [nextCociente],AX       ; ponemos en AX el numero que queremos dividir para empezar las iteraciones de division.
; fin intercambio de numeros

; incrementamos contadores de vueltas
	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX  
	
	XOR CX,CX
	MOV CX,[contador_fibos]
	INC CX
	MOV [contador_fibos],CX
	MOV BX,[contador_fibos]
	MOV AX,[total_fibos]
	CMP AX,BX
	JNE fibonacci
; fin incrementamos contadores de vueltas

;****************************** END ITER **********************

;************************************************
;*               FIN programa                   *
;************************************************

CALL FIN ;cerramos programa

GET_NUMBER:

	XOR CX,CX 					; inicia CX a 0


CONTINUE_DIV:	
	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX  
	
	MOV AX,[nextCociente]

	; DIVISION
	MOV BX,10   				; Dividimos el numero que hay en 'nextCociente' / 10
	XOR DX,DX           		; aqui irá el resto
	DIV BX              		; ejecutamos la division . La instrucción DIV que 
								; guardará en AX el cociente y el resto en DX.
								
	MOV [nextCociente], AX		; segun dividimos metemos en nextCociente el cociente
	
	PUSH DX             		; guardamos resto en PILA que está en DX
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
	JNE CONTINUE_DIV      		; ¿ no ? sigue dividiendo

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
	MOV BX,[contadorParaCadena]
	MOV AX,[contador]
	CMP AX,BX
	JNE SACA_RESTO
	
	INC BX                      ; le sumo 1 más para añadir el caracter $ que indica fin de cadena 
	MOV AL,'$'                  ; añadimos el $ al final de la CADENA ,uso AL para guardar el caracter $
	MOV [cadena + BX],AL 	    ; GUARDAMOS EL VALOR $ en el final de la cadena.

								; imprimimos ya el numero
				                ; terminamos la ejecucion del programa
	
	MOV AX,DATOS 
	MOV DS,AX       		    ; METEMOS EN DS EL SEGMENTO DE LA VARAIBLE cadena
	LEA DX,[cadena]             ; METEMOS EN DX EL OFFSET DE cadena
	MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR
	

	RET						    ; cuando terminemos, pues retornamos
	
FIN:                            ; fin programa
	
	LEA DX,[adios]             ; METEMOS EN DX EL OFFSET DE cadena
	MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR
	

	MOV AH,4Ch                  ; Servicio DOS para finalizar un programa 
	INT 21h						; lanzamos la int 21h para ejecutarlo.
	

	
	