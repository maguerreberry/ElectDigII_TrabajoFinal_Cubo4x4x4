; PIC16F887 Configuration Bit Settings
; ASM source line config statements
#include "p16F887.inc"
; CONFIG1
; __config 0xFFF5
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
		    org 0x00
		    goto Inicio
		    
Inicio		    ;-------Port  Config
		    banksel TRISB ; en el puerto B va el teclado, el pin RB0 no va a ser usado
		    clrf    TRISC
		    clrf    TRISD
		    clrf    TRISA	    
		    banksel ANSEL
		    clrf    ANSEL
		    banksel ANSELH
		    clrf    ANSELH		    
		    bcf	    STATUS, RP0 ; vuelvo al banco 0
		    bcf	    STATUS, RP1
		    movlw   0xFF
		    movwf   PORTA
		    movwf   PORTD
		    clrf    PORTC
		    bsf	    PORTC,3
		    goto    $
		    end


