; PIC16F887 Configuration Bit Settings

; ASM source line config statements

#include "p16F887.inc"

; CONFIG1
; __config 0xEFF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

 udata 0x22
 PORT res 1
 DATO res 1
 ERR_F res 1
 ERR_OR res 1
    ORG 0x00
 GOTO	INICIO
 ;   ORG	0x04
; GOTO	ISR
INICIO:				;-----------------BANK0
 BSF	STATUS,RP0	;-----------------BANK1
 MOVLW	b'00000000'	;Ver SENDB
 MOVWF	TXSTA
 MOVLW	.25		;Elijo velocidad de transmsion de 2400 baudios
 MOVWF	SPBRG
 CLRF	TRISC	
 CLRF	TRISA
 CLRF	TRISD
 BSF	STATUS,RP1	;-----------------BANK3
 BCF	BAUDCTL,BRG16
 BCF	STATUS,RP0
 BCF	STATUS,RP1	;-----------------BANK0
 MOVLW	b'10010000'
 MOVWF	RCSTA
 CLRF	PORTC
 movlw	0xff
 movwf	PORTA
 movwf	PORTD

POLL: 
 BTFSC	RCSTA,OERR
 GOTO	ERR_O 
 BTFSS	PIR1,RCIF
 GOTO	POLL
 BTFSC	RCSTA,FERR
 INCF	ERR_F,f
 MOVF	RCREG,W
 MOVWF	DATO
 MOVLW	0x0F
 ANDWF	DATO,F
 call	TEST
 MOVWF  PORTC
 GOTO   POLL
 
TEST:
    movf    DATO,w
    addwf   PCL,f
    retlw   b'00000001'
    retlw   b'00000010'
    retlw   b'00000100'
    retlw   b'00001000'
     
ERR_O:
    INCF    ERR_OR,F
    BCF	    RCSTA,CREN
    BSF	    RCSTA,CREN
    GOTO    POLL

    END