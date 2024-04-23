; COMPILAR :
; 1- nasm fichero.asm -f obj
; 2- alink fichero.obj -oEXE
	
segment DATOS

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
	nextCociente       DW 44267  ; NUMERO A VISUALIZAR EN PANTALLA

segment PILA stack
		resb 256
	InicioPila:
		;Aqui están los valores

segment CODIGO

..start:
; ----- START FIBO LOOP

	XOR CX,CX
	MOV CX,10 ; 10 iteraciones fibonacci
	XOR AX,AX
	MOV AX,1
	MOV [num_a],AX    ; ponemos numero a
	XOR BX,BX
	MOV BX,1
	MOV [num_b],BX    ; ponemos numero b

	
suma_fibo:

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

	XOR AX,AX
	MOV AX,[num_a]    ; ponemos numero a
	MOV BX,[num_b]    ; ponemos numero b
	ADD AX,BX         ; sumamos a+b
	
	PUSH AX           ; guardamos AX en pila para luego visualizar numero
	
	MOV [num_c],AX    ; c = a + b . ponemos en num_c el total de la suma
	MOV AX,[num_b]    ; ponemos en AX el valor de B
	
	MOV[num_a],AX     ; a=b ponemos el valor de BX
	MOV AX,[num_c]    ; metemos en AX valor de C
	
	MOV [num_b],AX;   ; b = c
	
	POP AX            ; sacamos AX en pila que tiene el numero para sumar 
					  ; para luego visualizar numero
					  
	DEC CX            ; incrementamos contador para seguir dando iteraciones hasta 10
	CMP CX,0
	MOV AX,[nextCociente]       ; ponemos en AX el numero que queremos dividir para empezar las iteraciones de division.
	JE FIN
	JNE suma_fibo
					  
    
	;CALL MUESTRA_NUMERO




CALL FIN
	
FIN:                            ; fin programa
	MOV AH,4Ch                  ; Servicio DOS para finalizar un programa 
	INT 21h						; lanzamos la int 21h para ejecutarlo.
	