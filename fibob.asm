; COMSTACK_SEGMENTR :
; 1- nasm fichero.asm -f obj
; 2- alink fichero.obj -oEXE

;********************************************************************************************
; 25 Abril 2024
; -------------
; Ejemplo en Java
; ---------------
; 	int a = 1;
; 	int b = 1;
; 	int c = 0;
; 	System.out.println(a);
; 	for(int i = 0 ; i < 20 ; i++) {
; 		c = a + b;
; 		System.out.println(c);
; 		a = b;
; 		b = c;
; }

; ESTE PROGRAMA ES LA SUCESION DE FIBONACCI EN ASM. ES UNA PRÁCTICA MUY INTERESANTE PORQUE
; TE DAS CUENTA DE COMO FUNCIONA UN ORDENADOR POR DENTRO Y TIENES QUE HACER TODO PARA PODER
; VER LOS DATA_SEGMENT, DESDE LA RUTINA DE IMPRESION ( AUNQUE USAS LA INT 21 ) HASTA MOVER LOS
; DATA_SEGMENT EN MEMORIA. SEGURAMENTE NO ES EL MEJOR CÓDIGO DEL MUNDO RESPECTO A ESTE EJERCICIO
; PERO LO HE HECHO DESDE 0 , DANDOME GOLPES POR LO TANTO ESTOY MUY ORGULLOSO.
; A SEGUIR APRENDIENDO ENSAMBLADOR.
;********************************************************************************************

; DATA
segment DATA_SEGMENT
	bye_bye               DB   'FIBONACCI ENDS$' 	   ; string para mostrar fin de sucesion
	first_number          DB   '1 $'				   ; string para mostrar el numero 1 para la primera iteracion
	string_number         RESB 20   				   ; espacio que tendrá los digitos del numero  
	num_a 			      DW   1     				   ; num_a
	num_b 			      DW   1     				   ; num_b
	num_c 			      DW   0     				   ; acumulador
	division_counter      DW   0      				   ; guardaremos cuantas iteraciones (divisiones) se hicieron
	counter_iter_fibos    DW   0      				   ; counter para controlar cuantas vueltas llevamos
	total_iters           DW   5      				   ; total de vueltas fibonaccis que queremos hacers
	pointer_string_number DW   0      				   ; lo usaremos para desplazarnos byte a byte en  
	next_quotient         DW   0      				   ; NUMERO A VISUALIZAR EN PANTALLA
; END DATA	

; STACK
segment STACK_SEGMENT stack				; segmento de STACK_SEGMENT
		resb 256			    		; reservamos 256 bytes
START_STACK_SEGMENT:
	; Aqui están los valores
	; END STACK

; START CODE
segment CODE_SEGMENT
										; empieza el CODE_SEGMENT del programa
..start:								; punto de entrada MAIN
	MOV AX,DATA_SEGMENT                	; queremos situarnos en el segmento de DATA_SEGMENT ( donde están las variables/espacios de memoria)
	MOV DS,AX  							; ponemos DS apuntando a nuestro segmento de DATA_SEGMENT
	XOR AX,AX							; ponemos AX a 0
	LEA DX,[first_number]               ; METEMOS EN DX EL OFFSET DE string_number para mostrar el 1
	MOV AH,09h                  		; INVOCAMOS AL SERVICIO DE IMPRIMIR string_number EN PANTALLA
	INT 21h                     		; EJECUTAMOS 

										; Una vez impreso el numero 1 ... empieza la fiesta.
										; en el inicio , hay que darle unos valores a A y B , que son 1 y 1 para que haya un inicio de suma

FIBONACCI:								; Etiqueta de fibonacci, para cada iteración. Es el inicio del "bucle"
	XOR AX,AX                   		; ponemos AX a 0
	MOV AX,DATA_SEGMENT                	; queremos situarnos en el segmento de DATA_SEGMENT ( donde están las variables/espacios de memoria)
	MOV DS,AX  							; ponemos DS apuntando al segmento de DATA_SEGMENT
	XOR AX,AX                   		; ponemos AX a 0
	MOV AX,[num_a]    					; ponemos en AX numero a
	XOR BX,BX							; ponemos BX a 0
	MOV BX,[num_b]    					; ponemos BX numero b
	ADD AX,BX ; a + b 					; SE HACE LA SUMA , es el NUCLEO de todo esto	
	MOV [next_quotient],AX       		; ponemos en next_quotient el resultado de la suma, que la rutina PRINT_NUMBER la necesita para mostrarlo.
	MOV [num_c],AX    					; c = a + b . ponemos en num_c el total de la suma que está guardado en AX

	CALL PRINT_NUMBER					; IMPRIMIMOS NUMERO CON LA RUTINA DE IMPRESION. La rutina imprime el valorq que esté en la variable next_quotient
									
										; una vez se imprimió el número, los contadores están con sus ultimos valores
										; por lo tanto hay que situar sus punteros para volver a situarnos en su primera posicion
										; para machacar su antiguo contenido, poniendolos a 0.
	XOR AX,AX          					; ponemos AX a 0
	MOV [division_counter],AX  			; ponemos el contador de divisiones 0
	MOV [pointer_string_number],AX 		; ponemos el contador para string_number a 0


	; intercambio de numeros
	XOR AX,AX                   		; ponemos AX a 0
	MOV AX,DATA_SEGMENT                	; queremos situarnos en el segmento de DATA_SEGMENT ( donde están las variables/espacios de memoria)
	MOV DS,AX							; ponemos DS apuntado a DATA_SEGMENT
	XOR AX,AX							; ponemos AX a 0
	MOV AX,[num_b]    					; ponemos en AX el valor de B
	MOV[num_a],AX     					; a=b ponemos el valor de BX
	XOR BX,BX							; ponemos BX a 0
	MOV BX,[num_c]    					; metemos en AX valor de C
	MOV [num_b],BX;   					; b = c
	; fin intercambio de numeros


	XOR AX,AX                   		; ponemos AX a 0
	MOV AX,DATA_SEGMENT                	; queremos situarnos en el segmento de DATA_SEGMENT ( donde están las variables/espacios de memoria)
	MOV DS,AX  						    ; ponemos DS apuntando al segmento de DATA_SEGMENT
	XOR CX,CX							; ponemos CX ( contador ) a 0
	MOV CX,[counter_iter_fibos]			; ponemos en CX el contador de iteraciones, para luego sumarle 1 vuelta mas
	INC CX								; incrementamos una vuelta , sumando 1 a CX
	MOV [counter_iter_fibos],CX			; ponemos a counter_iter_fibos el nuevo valor , es decir 1 vuelta más
	MOV BX,[counter_iter_fibos]			; ponemos en BX el nuevo valor de counter_iter_fibos para comparar si ya llegamos al total de iteraciones
	MOV AX,[total_iters]			    ; ponemos en AX el total de iteraciones
	CMP AX,BX							; ¿AX es igual a BX ? Es decir, ¿ el contador de iteraciones ya es igual al total de iteracioens ?
JNE FIBONACCI							; si NO ES IGUAL , sigue iterando , por lo tanto vuelve al  la etiqueta FIBONACCI

CALL FIN 								;cerramos y finalizamos el programa


; ********************************************************************************
; * ESTA RUTINA IMPRIME EL NUMERO QUE ESTÉ GUARDADO EN LA VARIABLE next_quotient *
; * Y LO ALMACENA EN LA VARIABLE string_number									 *
; ********************************************************************************
PRINT_NUMBER:
	XOR CX,CX 								; inicia CX a 0
	CONTINUE_DIV:							; ponemos AX a 0
		XOR AX,AX                   		; ponemos AX en el segmento de datos		
		MOV AX,DATA_SEGMENT              	; queremos situarnos en el segmento de DATA_SEGMENT ( donde están las variables/espacios de memoria)
		MOV DS,AX  							; Nos situamos en el segmento de DATA_SEGMENT
		MOV AX,[next_quotient]				; ponemos en AX el cociente a mostrar en pantalla
		MOV BX,10   						; Dividimos el numero que hay en 'next_quotient' / 10
		XOR DX,DX           				; ponemos DX a cero porque es donde irá el resto
		DIV BX              				; ejecutamos la division . La instrucción DIV que guardará en AX el cociente y el resto en DX.
		MOV [next_quotient], AX				; segun dividimos metemos en next_quotient el cociente
		PUSH DX             				; guardamos resto en STACK_SEGMENT que está en DX
		MOV CX,[division_counter]   		; ponemos el valor de counter en CX
		INC CX              				; incrementamos CX para ir guardando cuantos numeros a mostrar van a la STACK_SEGMENT
		MOV [division_counter],CX     		; guardo en counter el valor de por donde vamos ( cuantos numeros llevamos )
		MOV AX,[next_quotient]  	    	; PONEMOS DE NUEVO AX con el valor del cociente actual
		CMP AX,0 							; ¿ ya el cociente es 0 ?
		JE PRINT_NUMBER_PROCESS  			; ¿ si ? pues vamos a sacar los numeros
	JNE CONTINUE_DIV      					; ¿ no ? sigue dividiendo , vuelve a CONTINUE_DIV

	PRINT_NUMBER_PROCESS:					; A partir de aqui vamos a ir sacando los digitos almacenados en la STACK_SEGMENT de forma inversa 
											; para ir almacenandolos en string_number, que es la variable que irá a la funcion 9H de INT21h
		XOR CX,CX				    		; Ponemos CX a 0
		MOV CX,[division_counter] 			; ponemos el counter de CX con el total de iteraciones de division
											; ya que la instruccion LOOP necesita que CX tenga el numero de iteraciones

		POP_MODULE: 						; Empezamos a sacar el resto
			XOR AX,AX                   	; ponemos AX en el segmento de datos		
			MOV AX,DATA_SEGMENT             ; queremos situarnos en el segmento de DATA_SEGMENT ( donde están las variables/espacios de memoria)
			MOV DS,AX  						; Nos situamos en el segmento de DATA_SEGMENT
			POP DX					    	; Sacamos un valor de la pila y lo guardamos en DX , aquí estan los numeros apilados de detras a delante 68322 (22386)
			ADD DX,'0'      		    	; DX contiene el numero guardado pero necesitamos pasarlos a codigo ASCII para ello sumamos el 0 (48 en decimal)
											; y obtenemos el digito ASCII que equivale a ese NUMERO
									
			MOV BX,[pointer_string_number] 	; ponemos en BX el valor del pointer para string_number ( estará a 0 ). Es donde almacenaremos los 
											; numeros para luego pasar su segmento y desplazamiento a la funcion 9h int 21 (imprimir string_number).

			MOV [string_number + BX],DX 	; Una vez situados en el string_number accedemos a la variable string_number 
											;( espacio de bytes) donde iremos poniendo nuestros numeros para luego verlos,usando el puntero pointer_string_number
											; Iremos avanzando posicion a posicion con BX. [0][1][2][3] ... y poniendo el resultado de la suma de DX + '0'.
			INC BX                          ; Incrementamos BX para que en la siguiente vuelta sea +1
			MOV [pointer_string_number],BX  ; guardamos en el counter su numero valor incrementado +1
			MOV BX,[pointer_string_number]  ; ponemos en BX el puntero de divisiones para saber si ya llegó al final. Si hubieron 4 iteraciones de division, significa
											; que el numero tiene 4 digitos, por lo tanto tiene que sacar los 4 digitos de la pila, sumar un puntero para añadirlo al lado
											; del caracter anterior que esta en string_number e ir formando el numero para luego verlo en pantalla
			MOV AX,[division_counter]		; ponemos en AX el total de divisiones ( digitos que tiene ese numero )
			CMP AX,BX						; ¿el puntero es igual al total de digitos )
		JNE POP_MODULE						; si no es igual , pues sigue sacando los restos ( digitos del numero apilados )

		INC BX                      		; Como la funcion 9H necesita un $ al final de la cadena a mostrar pues le sumo 1 a BX que contiene el valor del total de digitos
		MOV AL,'$'                  		; y en esa posicion añadimos el $ al final
		MOV [string_number + BX],AL 	    ; GUARDAMOS EL VALOR $ en el final de la string_number ( lo que veremos en pantalla )
											
											
		MOV AX,DATA_SEGMENT 				; Nos situamos en el segmento de DATA_SEGMENT
		MOV DS,AX       		    		; METEMOS EN DS EL SEGMENTO DE LA VARAIBLE string_number
		LEA DX,[string_number]              ; METEMOS EN DX EL OFFSET DE string_number
		MOV AH,09h                  		; INVOCAMOS AL SERVICIO DE IMPRIMIR string_number EN PANTALLA
		INT 21h                     		; EJECUTAMOS RUTINA DE IMPRIMIR
RET						    				; cuando terminemos, pues retornamos
	
FIN:                        				; fin programa
	
	LEA DX,[bye_bye]              			; METEMOS EN DX EL OFFSET DE string_number
	MOV AH,09h                  			; INVOCAMOS AL SERVICIO DE IMPRIMIR string_number EN PANTALLA
	INT 21h                     			; EJECUTAMOS RUTINA DE IMPRIMIR FIN PROGRAMA
	MOV AH,4Ch                  			; Servicio DOS para finalizar un programa 
	INT 21h									; lanzamos la int 21h para ejecutarlo.