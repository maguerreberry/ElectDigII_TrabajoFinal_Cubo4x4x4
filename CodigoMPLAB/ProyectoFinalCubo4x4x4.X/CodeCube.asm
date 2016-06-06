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
		    movlw   b'00000011' ;PS=16
		    movwf   OPTION_REG
		    movlw   0xF0 ;Interrumpo por cambio en los pines RB4 a RB7
		    movwf   IOCB
		    ;-------ADC Config
		    movlw   0x01    ; RA0 va a ser para el canal de conversion, RA1 a RA4 van a ser usados para controlar la multiplexacion de los pisos del cubo
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
		    clrf    numPiso
		    clrf    numTeclado
		    clrf    brillo
		    movlw   .6
		    movwf   TMR0 ; Periodo TMR0 = 4 ms, ver Prescaler
Loop		    nop
		    goto    Loop
		    
Interruption	    btfsc   INTCON,T0IF
		    goto    InterrTMR0
		    goto    InterrRBIE
Volver		    retfie
		    
InterrTMR0	    bcf	    INTCON,T0IF ;cada 4 ms cambiamos de piso
		    call    SelectSeq
		    call    SelectBrillo
		    goto    Volver
		    
SelectBrillo	    bsf	    ADCON0,1 ;comienza la conversion
Loop1		    banksel ADCON0
		    btfsc   ADCON0,1
		    goto    Loop1
		    banksel ADRESH
		    btfsc   ADRESH,6
		    goto    BrilloAlto 
		    goto    BrilloBajo 		    
		    		    	    
SelectSeq	    movf    numTeclado
		    addwf   PCL,f
		    call    TodoON
		    return
		    call    MitadON
		    return
		    call    Piso1y3ON
		    return
		    
TodoON		    ;Esta secuencia prende todo el cubo
		    call    SelectPiso
		    movwf   PORTA
		    incf    numPiso,f
		    movlw   .4
		    xorwf   numPiso,w ; chequeo q no me pase de los 4 pisos 
		    btfsc   STATUS,z
		    clrf    numPiso
		    movlw   0xFF
		    movwf   PORTD
		    movwf   PORTC
		    return

MitadON		    ;Esta secuencia prende la mitad del cubo
		    call    SelectPiso
		    movwf   PORTA
		    incf    numPiso,f
		    movlw   .4
		    xorwf   numPiso,w ; chequeo q no me pase de los 4 pisos 
		    btfsc   STATUS,z
		    clrf    numPiso
		    movlw   0xFF
		    movwf   PORTD
		    clrf    PORTC
		    return

Piso1y3ON	    ;Esta secuencia prende SOLO los pisos 1 y 3
		    call    SelectPiso 
		    movwf   PORTA
		    incf    numPiso,f
		    movlw   .4
		    xorwf   numPiso,w ; chequeo q no me pase de los 4 pisos 
		    btfsc   STATUS,z
		    clrf    numPiso
		    btfsc   numPiso,0
		    goto    PisoPrendido
		    goto    PisoApagado
PisoPrendido	    movlw   0xFF
		    movwf   PORTD
		    movwf   PORTC
		    goto    FinPiso1y3ON
PisoApagado	    clrf    PORTD
		    clrf    PORTC
FinPiso1y3ON	    return		    
		    
SelectPiso	    movf    numPiso ; Selecciona el piso a prenderse
		    addwf   PCL,f
		    retlw   b'00000010' ; el RA0 es para el ADC
		    retlw   b'00000100'
		    retlw   b'00001000'
		    retlw   b'00010000'
		    