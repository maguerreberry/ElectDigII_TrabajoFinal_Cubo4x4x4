#include "p16F887.inc"

; CONFIG1
; __config 0xFFF7
 __CONFIG _CONFIG1, _FOSC_EXTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

		    org 0x00
		    call Configinicial 
		    goto Inicio
		    org 0x04
		    goto Interruption

Configinicial	    ;-------Port  Config
		    banksel TRISB
		    movlw   b'00001111' ; en el puerto B va el teclado, el pin RB0 no va a ser usado
		    movwf   TRISB
		    clrf    TRISC
		    clrf    TRISD
		    ;-------Interruption   Config
		    movlw   b'10101000' ;interrumpo por TMR0 y RB4/RB7
		    movwf   INTCON
		    movlw   b'00000000' ;PS=2
		    movwf   OPTION_REG
		    movlw   0xF0 ;Interrumpo por cambio en los pines RB4 a RB7
		    movwf   IOCB
		    ;-------ADC Config
		    movlw   0x1F    ; RA0 va a ser para el canal de conversion, RA1 a RA4 van a ser usados para controlar la multiplexacion de los pisos del cubo
		    movwf   TRISA
		    banksel ANSEL
		    movlw   0x01    ;usa el AN0 como unica entrada analogica
		    movwf   ANSEL
		    clrf    ANSELH
		    banksel ADCON1
		    movlw   b'00000000' ; Jutificado a la izq (msb en ADRESH)/con ambos voltajes de refernecia tomados internamente
		    movwf   ADCON1
		    banksel ADCON0
		    movlw   b'11000001';Conversion Clock = FRC / El canal 0 esta seleccionado / AD Converter Enable
		    movwf   ADCON0
		    bcf	    STATUS, RP0 ; vuelvo al banco 0
		    bcf	    STATUS, RP1
		    clrf    PORTA
		    clrf    PORTB
		    clrf    PORTC
		    clrf    PORTD   
		    return
		 
Inicio		    clrf    leds0_7
		    clrf    leds8_15
		    clrf    piso0
		    clrf    piso1
		    clrf    piso2
		    clrf    piso3
		    clrf    numTeclado
		    clrf    brillo
		    movlw   .6
		    movwf   TMR0 ; Periodo TMR0 = 500 us
Loop		    nop
		    goto    Loop
		    
Interruption	    btfsc   INTCON,T0IF
		    goto    InterrTMR0
		    goto    InterrRBIE
Volver		    retfie
		    
InterrTMR0	    bcf	    INTCON,T0IF
		    