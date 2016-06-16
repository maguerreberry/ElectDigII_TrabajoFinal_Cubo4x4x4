; PIC16F887 Configuration Bit Settings
; ASM source line config statements
#include "p16F887.inc"
; CONFIG1
; __config 0xFFF5
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
		    numPiso    equ    0x20
		    org 0x00
		    goto Inicio
		    
Inicio		    ;;;; PUERTO SERIE
		    ;Transmición
		    banksel TXSTA
		    ;bsf	    TXSTA,TXEN ;haabilita transmicion
		    bcf	    TXSTA,SYNC
		    bcf	    TXSTA,TX9
		    bsf	    TXSTA,BRGH
		    ;Recepción
		    banksel RCSTA
		    ;bsf	    RCSTA,CREN ;habilita recepcion
		    bsf	    RCSTA,SPEN
		    bcf	    RCSTA,RX9
		    bcf     RCSTA, ADDEN 
		    ;Baud Rate 9600
		    banksel BAUDCTL
		    bsf	    BAUDCTL,BRG16
		    banksel SPBRG
		    movlw   .103
		    movwf   SPBRG
		    clrf    SPBRGH
		    
		    ;;; INTERRUPCIONES
		    
		    ;movlw   b'11000000' ;PEIE seteado
		    ;movwf   INTCON
		    ;banksel PIE1
		    ;movlw   b'01100000' ;Interrumpo por transmisicion y recepcion
		    ;movwf   PIE1
		    
		    bcf	STATUS,RP0
		    bcf	STATUS,RP1 ;Tamos en le banco cero
		    		    
		    bsf	    RCSTA,CREN
LOOP		    btfss   PIR1,RCIF
		    goto    LOOP
		    movf    RCREG,w
		    movwf   TXREG
		    banksel TXSTA
		    bsf	    TXSTA,TXEN 
		    goto    LOOP
		    end
		    