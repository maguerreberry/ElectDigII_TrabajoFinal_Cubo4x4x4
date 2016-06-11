; PIC16F887 Configuration Bit Settings
; ASM source line config statements
#include "p16F887.inc"
; CONFIG1
; __config 0xFFF5
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
		    led	    equ	    0x20
		    org 0x00
		    goto Inicio
		    org 0x04
		    goto Interruption

Inicio		    ;-------Port  Config
		    banksel TRISB
		    movlw   b'00000001' ; en el puerto B va el teclado, el pin RB0 no va a ser usado
		    movwf   TRISB
		    clrf    TRISD
		    ;-------Interruption   Config
		    movlw   b'10010000' ;interrumpo por RB0
		    movwf   INTCON
		    movlw   b'100000111' ;ps=512
		    movwf   OPTION_REG
		    banksel ANSEL
		    clrf    ANSEL
		    banksel ANSELH
		    clrf    ANSELH
		    bcf	    STATUS, RP0 ; vuelvo al banco 0
		    bcf	    STATUS, RP1
		    clrf    PORTB
		    movlw   0x03
		    movwf   PORTD   
	    	    clrf    led
		    
Loop		    nop
		    goto    Loop
		    
Interruption	    btfsc   INTCON,INTF
		    goto    InterrRB0
Volver		    retfie

InterrRB0	    bcf	INTCON, INTF
		    movlw  .6
		    movwf   TMR0   ;periodo 128 mseg
Loop1		    btfss   INTCON,T0IF
		    goto    Loop1
		    bcf	    INTCON,T0IF
		    call    qLed
		    movwf   PORTD
		    incf    led
		    movlw   .8
		    xorwf   led,w
		    btfsc   STATUS,Z
		    clrf    led
		    goto    Volver
		    
qLed		    movf    led,w
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