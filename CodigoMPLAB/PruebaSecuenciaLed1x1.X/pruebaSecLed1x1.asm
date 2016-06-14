; PIC16F887 Configuration Bit Settings
; ASM source line config statements
#include "p16F887.inc"
; CONFIG1
; __config 0xFFF5
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
		    udata	0x20
		    numPiso	res 1
		    contaLed    res 1
		    org 0x00
		    goto Inicio
		    org 0x04
		    goto ISR

Inicio		    ;-------Port  Config
		    banksel TRISB ; en el puerto B va el teclado, el pin RB0 no va a ser usado
		    clrf    TRISC
		    clrf    TRISD
		    clrf    TRISA
		    movlw   b'10100000' ;interrumpo por TMR0
		    movwf   INTCON
		    movlw   b'00000111' ;PS=32
		    movwf   OPTION_REG		    
		    banksel ANSEL
		    clrf    ANSEL
		    banksel ANSELH
		    clrf    ANSELH		    
		    bcf	    STATUS, RP0 ; vuelvo al banco 0
		    bcf	    STATUS, RP1
		    clrf    PORTA
		    clrf    PORTC
		    clrf    PORTD
	    	    clrf    numPiso
		    clrf    contaLed
		    movlw   .6
		    movwf   TMR0
Loop1		    nop
		    goto    Loop1
		    
		    
ISR		    btfss   INTCON,T0IF
		    goto    Volver
		    bcf	    INTCON,T0IF
		    call    SelectPiso
		    movwf   PORTC
		    call    SelectLedOn
		    movwf   PORTD
		    movwf   PORTA		    
		    incf    numPiso,f
		    movlw   .4
		    xorwf   numPiso,w ; chequeo q no me pase de los 4 pisos 
		    btfss   STATUS,Z
		    goto    Volver
		    clrf    numPiso
		    incf    contaLed,f
		    movlw   .8
		    xorwf   contaLed,w
		    btfsc   STATUS,Z
		    clrf    contaLed
Volver		    movlw   .6
		    movwf   TMR0
		    retfie
		    
SelectPiso	    movf    numPiso,w ; Selecciona el piso a prenderse
		    addwf   PCL,f
		    retlw   b'00000001' 
		    retlw   b'00000010'
		    retlw   b'00000100'
		    retlw   b'00001000'

SelectLedOn
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

		    end
		    
		    
		    
		    
		    
		    
		    
		    





