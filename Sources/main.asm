;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            
;
; export symbols
;
            XDEF _Startup
            ABSENTRY _Startup

;
; variable/data section
;
            ORG    $60         	; Insert your data definition here
M60: DS.B   1					; Dato
M61: DS.B   1					; MSB
M62: DS.B   1					; LSB

;
; code section
;
            ORG    ROMStart
            

_Startup:
			LDA	   	#$12			; Inmediato 	A=$12 hexa Quitar el WATCHDOG
			STA		SOPT1			; Directo 	Guardar A en SOPT1
			
			LDX		#$60			; Cargar X con la direccion a la que apuntara
			MOV		#$5A, M60		; Mover a M60 el valor inmediato 5A hexadecimal
reinicio:
			LDA		M60				; Cargar dato en acumulador
			CBEQX 	#$61,intercambiar_nibbles_acumulador
			CBEQX 	#$62,mainLoop	; Fin
continuar:
			AND		#$F0			; Nibble correspondiente de M60 en acumulador
			NSA						; Intercambiar nibbles acumulador
			STA		1,X				; Guardar temporalmente en memoria
			
			SUB		#$09			; Restar 9, si da cero o negativo es un dato igual a nueve o menor
			BLE 	menor_igual_a_9	; menor o igual a 9
			BHI 	mayor_a_9		; mayor a 9
intercambiar_nibbles_acumulador:
			NSA						; Intercambiar nibbles acumulador
			BRA		continuar
menor_igual_a_9:
			LDA		1,X				; Cargar dato de memoria en acumulador
			ADD		#$30			; Sumar #$30
			STA		1,X				; Guardar en memoria
			INCX					; Incrementar X
			BRA		reinicio
mayor_a_9:
			LDA		1,X				; Cargar dato de memoria en acumulador
			ADD		#$37			; Sumar #$37
			STA		1,X				; Guardar en memoria
			INCX					; Incrementar X
			BRA		reinicio
mainLoop:
            BRA    mainLoop
			
;**************************************************************
;* spurious - Spurious Interrupt Service Routine.             *
;*             (unwanted interrupt)                           *
;**************************************************************

spurious:				; placed here so that security value
			NOP			; does not change all the time.
			RTI

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************

            ORG	$FFFA

			DC.W  spurious			;
			DC.W  spurious			; SWI
			DC.W  _Startup			; Reset
