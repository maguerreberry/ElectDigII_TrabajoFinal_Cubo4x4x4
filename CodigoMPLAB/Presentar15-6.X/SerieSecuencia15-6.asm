; PIC16F887 Configuration Bit Settings

; ASM source line config statements

#include "p16F887.inc"

; CONFIG1
; __config 0xEFF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

udata	0x22
numPiso	  res 1
contaLed  res 1  	  
dato	  res 1
err_or 	  res 1
secuencia res 1
boliche_flag res 1
veces_on  res 1
org	 0x00
goto	 INICIO
org	 0x04
goto	 ISR
 
INICIO
;------- Port  Config
	banksel TRISB ; en el puerto B va el teclado, el pin RB0 no va a ser usado
	clrf    TRISC
	clrf    TRISD
	clrf    TRISA
;------- Config Comunicacion Serie
	bsf	STATUS,RP0	;-----------------BANK1
	movlw	b'00000000'	;Ver SENDB
	movwf	TXSTA
	movlw	.25		;Elijo velocidad de transmsion de 2400 baudios
	movwf	SPBRG
	bsf	STATUS,RP1	;-----------------BANK3
	bcf	BAUDCTL,BRG16
 	bcf	STATUS,RP0
	bcf	STATUS,RP1	;-----------------BANK0
	movlw	b'10010000'
	movwf	RCSTA	
;------- Config Interrumpciones
	banksel	OPTION_REG
	movlw   b'10100000' ;interrumpo por TMR0
	movwf   INTCON
	movlw   b'10000011' ;PS=16 
	movwf   OPTION_REG		    
	banksel ANSEL
	clrf    ANSEL
	banksel ANSELH
	clrf    ANSELH		    
;------- Inicialización Variables
	bcf	STATUS, RP0 ; vuelvo al banco 0
	bcf	STATUS, RP1
	clrf    PORTA
	clrf    PORTC
	clrf    PORTD
	clrf    numPiso
	clrf    contaLed
	clrf    dato
	clrf	secuencia
	clrf	err_or
	clrf	boliche_flag
	clrf	veces_on
        movlw   .6
	movwf   TMR0
		    
RECEPCION 
	btfsc	RCSTA,OERR
	goto	ERR_O 
	btfss	PIR1,RCIF
	goto	RECEPCION
	movf	RCREG,w
	movwf	dato		
	movlw	0x0F
	andwf	dato,f ; Los datos son enviados en ASCII
	call	SET_DATO	
	goto	RECEPCION
	
ERR_O:
	incf    err_or,f
	bcf     RCSTA,CREN
        bsf     RCSTA,CREN
	goto    RECEPCION	

SET_DATO: 
	movf	dato,w
        sublw	.4 ; Mis datos validos van entre 0 y 2 	
	btfss	STATUS,C
	return
	call	SET_SECUENCIA
	movwf   secuencia
	return

SET_SECUENCIA:	
	movf    dato,w
	addwf   PCL,f
        retlw   .0
	retlw   .1
        retlw   .2
	retlw	.3
	retlw	.4
	
ISR:
	btfss   INTCON,T0IF
	goto    VOLVER
	bcf	INTCON,T0IF
	call    GET_PISO
	movwf   PORTC	
	goto	GET_SECUENCIA	
VOLVER	
	call	SET_NUMPISO
	movlw   .6
	movwf   TMR0
	retfie

GET_PISO:
	movf    numPiso,w ; Selecciona el piso a prenderse
	addwf   PCL,f
	retlw   b'00000001' 
	retlw   b'00000010'
	retlw   b'00000100'
	retlw   b'00001000'
	
SET_NUMPISO:
	incf    numPiso,f
	movlw   .4
	xorwf   numPiso,w ; chequeo q no me pase de los 4 pisos 
	btfsc   STATUS,Z
	clrf    numPiso
	return

GET_SECUENCIA
	movf	secuencia,w
	addwf	PCL,f
	goto	PRENDE_TODO_CUBO
	goto	PRENDE_1x1
	goto	PRENDE_PERIMETRO
	goto	PRENDE_COLUM
	goto	PRENDE_BOLICHE
	
PRENDE_TODO_CUBO
	banksel	OPTION_REG
	movlw	b'10000011'; PS=16
	movwf	OPTION_REG
	bcf	STATUS,RP0
	movlw   0xFF
	movwf   PORTD
	movwf   PORTA
	goto	VOLVER
	
PRENDE_1x1 ;--- La modifique
	banksel	OPTION_REG
	movlw	b'10000111'; PS=128
	movwf	OPTION_REG
	bcf	STATUS,RP0
	call    SELECT_LED_ON
	movwf   PORTD
	movwf   PORTA
	incf    contaLed,f
        movlw   .8
        xorwf   contaLed,w
        btfsc   STATUS,Z
        clrf    contaLed
	goto	VOLVER
SELECT_LED_ON:
	movf    contaLed,w
	addwf   PCL,f
	retlw   b'00000001'
	retlw   b'00000010'
	retlw   b'00000100'
	retlw   b'00001000'
	retlw   b'00010000'
	retlw   b'00100000'
	retlw   b'01000000'
	retlw   b'10000000'
		
PRENDE_PERIMETRO
	banksel	OPTION_REG
	movlw	b'10000011' ;PS=16
	movwf	OPTION_REG
	bcf	STATUS,RP0
	movf	numPiso,w
	addwf	PCL,f
	goto	PRIMERO_ULTIMO
	goto	MEDIO
	goto	MEDIO
	goto	PRIMERO_ULTIMO
PRIMERO_ULTIMO	
	movlw   b'10011111'
	movwf   PORTA
	movlw   b'11111001'
	movwf   PORTD
	goto	VOLVER
MEDIO	
	movlw   b'00001001'
        movwf   PORTA
        movlw   b'10010000'
        movwf   PORTD
	goto	VOLVER
	
PRENDE_COLUM
	banksel	OPTION_REG
	movlw	b'10000111'; PS=128
	movwf	OPTION_REG
	bcf	STATUS,RP0
	call    SELECT_LED_ON
	movwf   PORTD
	movwf   PORTA
	movlw   .3
	xorwf   numPiso,w 
	btfss   STATUS,Z
	goto    VOLVER
	incf    contaLed,f
        movlw   .8
        xorwf   contaLed,w
        btfsc   STATUS,Z
        clrf    contaLed
	goto	VOLVER
	
PRENDE_BOLICHE
	banksel	OPTION_REG
	movlw	b'10000011'; PS=16
	movwf	OPTION_REG
	bcf	STATUS,RP0
	movlw   .3
	xorwf   numPiso,w 
	btfsc   STATUS,Z
	incf	veces_on,f
	call	SET_ON_OFF
	movwf   PORTD
	movwf   PORTA
	goto	VOLVER
SET_ON_OFF:	
	movlw	.8
	xorwf	veces_on,w
	btfsc	STATUS,Z
	clrf	veces_on
	btfsc	STATUS,Z	
	comf	boliche_flag,f
	movlw   0xFF
	btfss	boliche_flag,0
	movlw	0x00
	return
	
	
	end