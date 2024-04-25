; COMPILAR :
; 1- nasm fichero.asm -f obj
; 2- alink fichero.obj -oEXE

;********************************************************************************************
; 25 Abril 2024
; -------------
; Ejemplo en Java
; ---------------
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

; ESTE PROGRAMA ES LA SUCESION DE FIBONACCI EN ASM. ES UNA PRÁCTICA MUY INTERESANTE PORQUE
; TE DAS CUENTA DE COMO FUNCIONA UN ORDENADOR POR DENTRO Y TIENES QUE HACER TODO PARA PODER
; VER LOS DATOS, DESDE LA RUTINA DE IMPRESION ( AUNQUE USAS LA INT 21 ) HASTA MOVER LOS
; DATOS EN MEMORIA. SEGURAMENTE NO ES EL MEJOR CÓDIGO DEL MUNDO RESPECTO A ESTE EJERCICIO
; PERO LO HE HECHO DESDE 0 , DANDOME GOLPES POR LO TANTO ESTOY MUY ORGULLOSO.
; A SEGUIR APRENDIENDO ENSAMBLADOR.
;********************************************************************************************

; DATA
segment DATOS
	adios              DB   'Fin de la sucesion $'  ; cadena para mostrar fin de sucesion
	first_number       DB   '1 $'					; cadena para mostrar el numero 1 para la primera iteracion
	cadena             RESB 20   					; espacio que tendrá los digitos del numero  
	num_a 			   DW   1     					; num_a
	num_b 			   DW   1     					; num_b
	num_c 			   DW   0     					; acumulador
	contador           DW   0      					; guardaremos cuantas iteraciones (divisiones) se hicieron
	contador_fibos     DW   0      					; contador para controlar cuantas vueltas llevamos
	total_fibos        DW   50      				; total de vueltas fibonaccis que queremos hacers
	contadorParaCadena DW   0      					; lo usaremos para desplazarnos byte a byte en  
	nextCociente       DW   0      					; NUMERO A VISUALIZAR EN PANTALLA
; END DATA	

; STACK
segment PILA stack					; segmento de pila
		resb 256			    	; reservamos 256 bytes
InicioPila:
	;Aqui están los valores
	; END STACK

; START CODE
segment CODIGO
									; empieza el codigo del programa
..start:							; punto de entrada MAIN
MOV AX,DATOS                		; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
MOV DS,AX  							; ponemos DS apuntando a nuestro segmento de datos
XOR AX,AX
LEA DX,[first_number]               ; METEMOS EN DX EL OFFSET DE cadena
MOV AH,09h                  		; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
INT 21h                     		; EJECUTAMOS 



									; en el inicio , hay que darle unos valores a A y B , que son 1 y 1 para que haya un inicio de suma8
XOR AX,AX                   		; ponemos AX a 0
MOV AX,DATOS                		; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
MOV DS,AX  							; ponemos DS apuntando a nuestro segmento de datos
XOR AX,AX                   		; ponemos AX a 0
MOV AX,[num_a]    					; ponemos numero a en AX
XOR BX,BX							; ponemos BX a cero
MOV BX,[num_b]    					; ponemos numero b en BX


fibonacci:							; Etiqueta de fibonacci, para cada iteración

	XOR AX,AX                   	; ponemos AX a 0
	MOV AX,DATOS                	; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX  						; ponemos DS apuntando al segmento de DATOS
	XOR AX,AX                   	; ponemos AX a 0
	MOV AX,[num_a]    				; ponemos en AX numero a
	XOR BX,BX						; ponemos BX a 0
	MOV BX,[num_b]    				; ponemos BX numero b
	ADD AX,BX ; a + b 				; SE HACE LA SUMA , es el NUCLEO de todo esto	
	MOV [nextCociente],AX       	; ponemos en AX el numero que queremos dividir para empezar las iteraciones de division.	
	MOV [num_c],AX    				; c = a + b . ponemos en num_c el total de la suma que está guardado en AX


									; *********************************************
	CALL PRINT_NUMBER					; IMPRIMIMOS NUMERO CON LA RUTINA DE IMPRESION
									; *********************************************

									; una vez se imprimieron las cadenas, estas quedan llenas con sus ultimos DATOS
									; por lo tanto hay que situar sus punteros para volver a situarnos en su primera posicion
									; para machacar su antiguo contenido
	XOR AX,AX          				; ponemos AX a 0
	MOV [contador],AX  				; volvemos a poner los contadores de cadena a 0 para resetearlos
	MOV [contadorParaCadena],AX 	; volvemos a poner los contadores de cadena a 0 para resetearlos


	; intercambio de numeros
	XOR AX,AX                   	; ponemos AX a 0
	MOV AX,DATOS                	; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX						; ponemos DS apuntado a DATOS
	XOR AX,AX						; ponemos AX a 0
	MOV AX,[num_b]    				; ponemos en AX el valor de B
	MOV[num_a],AX     				; a=b ponemos el valor de BX
	XOR BX,BX						; ponemos BX a 0
	MOV BX,[num_c]    				; metemos en AX valor de C
	MOV [num_b],BX;   				; b = c
	; fin intercambio de numeros


	XOR AX,AX                   	; ponemos AX a 0
	MOV AX,DATOS                	; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX  
									; incrementamos contadores de vueltas
	XOR CX,CX
	MOV CX,[contador_fibos]
	INC CX
	MOV [contador_fibos],CX
	MOV BX,[contador_fibos]
	MOV AX,[total_fibos]
	CMP AX,BX
JNE fibonacci

CALL FIN ;cerramos programa

PRINT_NUMBER:
	XOR CX,CX 					; inicia CX a 0

	CONTINUE_DIV:	
	XOR AX,AX                   ; ponemos AX a 0
	MOV AX,DATOS                ; queremos situarnos en el segmento de datos ( donde están las variables/espacios de memoria)
	MOV DS,AX  
	MOV AX,[nextCociente]
	MOV BX,10   				; Dividimos el numero que hay en 'nextCociente' / 10
	XOR DX,DX           		; aqui irá el resto
	DIV BX              		; ejecutamos la division . La instrucción DIV que 
								; guardará en AX el cociente y el resto en DX.
	MOV [nextCociente], AX		; segun dividimos metemos en nextCociente el cociente
	PUSH DX             		; guardamos resto en PILA que está en DX
	MOV CX,[contador]   		; ponemos el valor de contador en CX
	INC CX              		; incrementamos CX para ir guardando cuantos numeros van
	MOV [contador],CX     		; guardo en contador las iteraciones
	MOV AX,[nextCociente]  	    ; PONEMOS DE NUEVO AX con el valor del cociente actual
	CMP AX,0 					; ¿ ya el cociente es 0 ?
	JE PROCESO_IMPRIMIR_NUMERO  ; ¿ si ? pues vamos a sacar los numeros
	JNE CONTINUE_DIV      		; ¿ no ? sigue dividiendo

	PROCESO_IMPRIMIR_NUMERO:
	XOR CX,CX				    ; Ponemos CX a 0
	MOV CX,[contador] 			; ponemos el contador de CX con el total de iteraciones de division
								; ya que la instruccion LOOP necesita que CX tenga el numero de iteraciones

	SACA_RESTO: 				; GUARDAR DIGITO ASCII EN variable CADENA
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
RET						    	; cuando terminemos, pues retornamos
	
FIN:                        	; fin programa
	
	LEA DX,[adios]              ; METEMOS EN DX EL OFFSET DE cadena
	MOV AH,09h                  ; INVOCAMOS AL SERVICIO DE IMPRIMIR CADENA EN PANTALLA
	INT 21h                     ; EJECUTAMOS RUTINA DE IMPRIMIR FIN PROGRAMA
	MOV AH,4Ch                  ; Servicio DOS para finalizar un programa 
	INT 21h						; lanzamos la int 21h para ejecutarlo.