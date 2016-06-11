;-----------------------------------------------------------------------------------------------;
;		LED	cube																				;
;		--------																				;
;																								;
;	Author: Craig Smith																			;
;	Date:	June 2008																			;
;																								;
;	4MHz internal resonator used 																;
;																								;
;																								;
;	3 layers of 3 x 3 LEDs																		;
;																								;
;	RB6	-	Top layer common																	;
;	RB6	-	Middle layer common																	;
;	RB7	-	Bottom layer common																	;
;																								;
;																								;
;	Each layer of LED's Anodes																	;																							;
;																								;
;		RC1			RC0			RB4																;
;																								;
;																								;
;		RC4			RC3			RC2																;
;																								;
;																								;
;		RC7			RC6			RC5																;
;																								;
;	4 registers are used to hold the patterns for the LEDs										;
;																								;
;	Layer1 - Top layer (8 Leds)																	;
;	Layer2 - Middle layer (8 Leds)																;
;	Layer3 - Bottom layer (8 Leds)																;
;	Layer4 - bits 7,6 and 5 hold the 9th LED for top, middle and bottom, bits 4 and 3 hold the	;
;			 brightness (how long it is on for), bits 2,1 and 0 is the time the specific		;
;			 pattern is on until the next one is retrieved										;
;																								;
;	There are 4 look-up tables Table1, Table2, Table3 and Table4. These are for each layer		;
;	giving a total of 255 different patterns.													;
;-----------------------------------------------------------------------------------------------;



#include <p16F690.inc>
    __config (_INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _BOR_OFF & _IESO_OFF & _FCMEN_OFF)


cblock 0x20
	Delay1					; delay loop 1
	Delay2					; delay loop 2
	Delay3					; delay loop 3
	TimeDelay				; time delay x 0.001 s
	EndCount				; used to tell PIC the end of the table is reached
	Counter					; used as table counter
	Layer1					; top layer
	Layer2					; middle layer
	Layer3					; bottom layer
	Layer4					; 9th Led on each layer, brightness, and time
	Brightness				; LED brightness
	Time					; time for each pattern to stay
	Temp					; temp register
endc

	org 0
	goto	Start			; jump to Start



;-----------------------------------------------------------------------------------------------;
; Subroutines are here at the top																;
;-----------------------------------------------------------------------------------------------;

;-----------------------------------------------------------------------------------------------;
; BigSmall sub routine																			;
;-----------------------------------------------------------------------------------------------;
BigSmall:
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	return



;-----------------------------------------------------------------------------------------------;
; FlashingLines sub routine																			;
;-----------------------------------------------------------------------------------------------;
FlashingLines:
	movlw	b'00100100'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'01001001'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'10010010'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000011'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00011100'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'11100000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'10010010'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'01001001'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00100100'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'11100000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00011100'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000011'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	return


;-----------------------------------------------------------------------------------------------;
; LayerBrightness sub routine																			;
;-----------------------------------------------------------------------------------------------;
LayerBrightness:
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10000000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01000000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00100000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01001000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00001000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10010000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00010000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01010000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00010000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10010000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00010000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01010000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00010000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00101000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00001000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01001000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00001000'
	movwf	Layer4
	call	Output
	return


;-----------------------------------------------------------------------------------------------;
; CubeFill sub routine																			;
;-----------------------------------------------------------------------------------------------;
CubeFill:
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00100000'
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'01100000'
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11100000'
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11110000'
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11110010'
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11110011'
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11110011'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11110111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00100000'
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'01100000'
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11100000'
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11110000'
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11110010'
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11110011'
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11110011'
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11110111'
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'00100000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'01100000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'11100000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'11110000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'11110010'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'11110011'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111000'
	movwf	Layer4
	call	Output
	movlw	b'11110011'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11110111'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11011111'
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'10011111'
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00011111'
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00001111'
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00001101'
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00001100'
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00001100'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00001000'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'11011111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'10011111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00011111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00001111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00001101'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00001100'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'11011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00001100'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'11011111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'10011111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'00011111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'00001111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'00001101'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'00001100'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011000'
	movwf	Layer4
	call	Output
	movlw	b'00001100'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011000'
	movwf	Layer4
	call	Output
	return

;-----------------------------------------------------------------------------------------------;
; SideToSide sub routine																			;
;-----------------------------------------------------------------------------------------------;
SideToSide:
	movlw	b'00000011'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111011'
	movwf	Layer4
	call	Output
	movlw	b'00000011'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00011100'
	movwf	Layer3
	movlw	b'11011011'
	movwf	Layer4
	call	Output
	movlw	b'00000011'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11100000'
	movwf	Layer3
	movlw	b'11011011'
	movwf	Layer4
	call	Output
	movlw	b'00000011'
	movwf	Layer1
	movlw	b'00011100'
	movwf	Layer2
	movlw	b'11100000'
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'00000011'
	movwf	Layer1
	movlw	b'11100000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'00011100'
	movwf	Layer1
	movlw	b'11100000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'11100000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'11100000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00011100'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'11100000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000011'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'11100000'
	movwf	Layer1
	movlw	b'00011100'
	movwf	Layer2
	movlw	b'00000011'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'11100000'
	movwf	Layer1
	movlw	b'00000011'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111011'
	movwf	Layer4
	call	Output
	movlw	b'00011100'
	movwf	Layer1
	movlw	b'00000011'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111011'
	movwf	Layer4
	call	Output
	return


;-----------------------------------------------------------------------------------------------;
; DiagAroundSides sub routine																			;
;-----------------------------------------------------------------------------------------------;
DiagAroundSides:
	movlw	b'00100000'
	movwf	Layer1
	movlw	b'01000000'
	movwf	Layer2
	movlw	b'10000000'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'01000000'
	movwf	Layer1
	movlw	b'10000000'
	movwf	Layer2
	movlw	b'00010000'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'10000000'
	movwf	Layer1
	movlw	b'00010000'
	movwf	Layer2
	movlw	b'00000010'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00010000'
	movwf	Layer1
	movlw	b'00000010'
	movwf	Layer2
	movlw	b'00000001'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00000010'
	movwf	Layer1
	movlw	b'00000001'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'00000001'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movlw	b'00000100'
	movwf	Layer3
	movlw	b'01011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00000100'
	movwf	Layer2
	movlw	b'00100000'
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'00000100'
	movwf	Layer1
	movlw	b'00100000'
	movwf	Layer2
	movlw	b'01000000'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00100000'
	return

;-----------------------------------------------------------------------------------------------;
; Firework sub routine																			;
;-----------------------------------------------------------------------------------------------;
Firework:
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00001000'
	movwf	Layer3
	movlw	b'00001111'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00001101'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00001101'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00001101'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00001101'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011100'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011100'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'10111000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'01010101'
	movwf	Layer1
	movlw	b'10110000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01011011'
	movwf	Layer4
	call	Output
	movlw	b'00010100'
	movwf	Layer1
	movlw	b'01010101'
	movwf	Layer2
	movlw	b'10110000'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00010110'
	movwf	Layer2
	movlw	b'01010101'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00010110'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	return

;-----------------------------------------------------------------------------------------------;
; CubeLight sub routine																			;
;-----------------------------------------------------------------------------------------------;
CubeLight:
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11100000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11101000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11110000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11110000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11101000'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11100000'
	movwf	Layer4
	call	Output
	return


;-----------------------------------------------------------------------------------------------;
; LineAround sub routine																			;
;-----------------------------------------------------------------------------------------------;
LineAround:
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'11111011'
	movwf	Layer4
	call	Output
	movlw	b'00000100'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00100000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'01000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'10000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00010000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00000010'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00000001'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	return

;-----------------------------------------------------------------------------------------------;
; LayerDrop sub routine																			;
;-----------------------------------------------------------------------------------------------;
LayerDrop:
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'10110110'
	movwf	Layer1
	movlw	b'01001001'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'10110110'
	movwf	Layer2
	movlw	b'01001001'
	movwf	Layer3
	movlw	b'01011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'01001001'
	movwf	Layer2
	movlw	b'10110110'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'01001001'
	movwf	Layer1
	movlw	b'10110110'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01011011'
	movwf	Layer4
	call	Output
	return

;-----------------------------------------------------------------------------------------------;
; LayerDrop2 sub routine																			;
;-----------------------------------------------------------------------------------------------;
LayerDrop2:
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movlw	b'11110111'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movlw	b'11110111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01011011'
	movwf	Layer4
	call	Output
	movlw	b'11111111'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'11110111'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11110111'
	movwf	Layer2
	movlw	b'00001000'
	movwf	Layer3
	movlw	b'01011011'
	movwf	Layer4
	call	Output
	return


;-----------------------------------------------------------------------------------------------;
; Spin sub routine																			;
;-----------------------------------------------------------------------------------------------;
Spin:
	movlw	b'01001001'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00100100'
	movwf	Layer1
	movlw	b'01001001'
	movwf	Layer2
	movlw	b'10010010'
	movwf	Layer3
	movlw	b'10011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11111111'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01011001'
	movwf	Layer4
	call	Output
	movlw	b'10010010'
	movwf	Layer1
	movlw	b'01001001'
	movwf	Layer2
	movlw	b'00100100'
	movwf	Layer3
	movlw	b'00111001'
	movwf	Layer4
	call	Output
	return

;-----------------------------------------------------------------------------------------------;
; SnakeLine sub routine																			;
;-----------------------------------------------------------------------------------------------;
SnakeLine:
	movlw	b'10010010'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'11011011'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'01101101'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011001'
	movwf	Layer4
	call	Output
	movlw	b'00100100'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'11011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'01101101'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11011011'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'10010010'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11011011'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'01101101'
	movwf	Layer3
	movlw	b'00111001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00100100'
	movwf	Layer2
	movwf	Layer3
	movlw	b'01111001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'01101101'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'01011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'11011011'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'10010010'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	return

;-----------------------------------------------------------------------------------------------;
; SpiralDown sub routine																			;
;-----------------------------------------------------------------------------------------------;
SpiralDown:
	movlw	b'00000010'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000001'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'10011001'
	movwf	Layer4
	call	Output
	movlw	b'00000100'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00100000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'01000000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'10000000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00010000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00000100'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00100000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'01000000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'10000000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00010000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00000010'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00000001'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'01011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movwf	Layer3
	movlw	b'00111001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000100'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00100000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'01000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'10000000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00010000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000010'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000001'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00001000'
	movwf	Layer3
	movlw	b'00011001'
	movwf	Layer4
	call	Output
	return

;-----------------------------------------------------------------------------------------------;
; UpAndOut sub routine																			;
;-----------------------------------------------------------------------------------------------;
UpAndOut:
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'01011101'
	movwf	Layer1
	movlw	b'00000000'
	movwf	Layer2
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'10100010'
	movwf	Layer1
	movlw	b'01010101'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'10011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'10100010'
	movwf	Layer2
	movlw	b'01010101'
	movwf	Layer3
	movlw	b'01011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11110111'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'11111111'
	movwf	Layer3
	movlw	b'00111011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00001000'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00000000'
	movwf	Layer1
	movlw	b'00001000'
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	movlw	b'00001000'
	movwf	Layer1
	movwf	Layer2
	movlw	b'00000000'
	movwf	Layer3
	movlw	b'00011011'
	movwf	Layer4
	call	Output
	return



;-----------------------------------------------------------------------------------------------;
; Output outputs the data to the LEDs. PORTB will be used to turn on transistors to ground the	;
; cathodes of the LEDs																			;
;-----------------------------------------------------------------------------------------------;
Output:
							; set the brightness
	movfw	Layer4			; put layer 4 into W
	andlw	b'00011000'		; get just bits 3 and 5
	movwf	Brightness		; put W into Brightness
	bcf		STATUS,C		; clear the carry flag
	rrf		Brightness,1	; rotate Brightness
	bcf		STATUS,C		; clear the carry flag
	rrf		Brightness,1	; and again
	bcf		STATUS,C		; clear the carry flag
	rrf		Brightness,1	; and again
	incf	Brightness,1	; add 1 to Brightess

	movfw	Layer4			; move layer 4 into W
	andlw	b'00000111'		; get just bits 0,1 and 2
	movwf	Time			; put W into Time
	incf	Time,1			; add 1 to Time
	bcf		STATUS,C		; clear the carry flag
	rlf		Time,1
	bcf		STATUS,C		; clear the carry flag
	rlf		Time,1
	bcf		STATUS,C		; clear the carry flag
	rlf		Time,1
	bcf		STATUS,C		; clear the carry flag
	rlf		Time,1
	bcf		STATUS,C		; clear the carry flag
	rlf		Time,1

Output2:
							; --- Top Layer ---
	clrf	PORTB			; clear port B
	movfw	Layer1			; move layer1 to W
	movwf	PORTC			; put W onto PortC

	btfsc	Layer4,7		; see if LED 9 should be on
	bsf		PORTB,4			; turn on LED 9

	bsf		PORTB,5			; turn on layer 1 buy outputing bit 5 of PortB

	movfw	Brightness		; put brightness into W
	call	Delay			; call the delay

							; brightness can be 1,2,3 or 4, so now we have to call the delay again
							; 4 - brightness with the LEDs off

	bcf		PORTB,5			; turn off layer 1

	movfw	Brightness		; put Brightness into W
	sublw	4				; sub W from 4
	btfss	STATUS,Z		; skip if the zero flag is set
	call	Delay			; call the delay


							; --- Middle Layer ---
	clrf	PORTB			; clear port B
	movfw	Layer2			; move layer2 to W
	movwf	PORTC			; put W onto PortC

	btfsc	Layer4,6		; see if LED 9 should be on
	bsf		PORTB,4			; turn on LED 9

	bsf		PORTB,6			; turn on layer 2 buy outputing bit 6 of PortB

	movfw	Brightness		; put brightness into W
	call	Delay			; call the delay

							; brightness can be 1,2,3 or 4, so now we have to call the delay again
							; 4 - brightness with the LEDs off

	bcf		PORTB,6			; turn off layer 2

	movfw	Brightness		; put Brightness into W
	sublw	4				; sub W from 4
	btfss	STATUS,Z		; skip if the zero flag is set
	call	Delay			; call the delay
	


							; --- Bottom Layer ---
	clrf	PORTB			; clear port B
	movfw	Layer3			; move layer3 to W
	movwf	PORTC			; put W onto PortC

	btfsc	Layer4,5		; see if LED 9 should be on
	bsf		PORTB,4			; turn on LED 9

	bsf		PORTB,7			; turn on layer 2 buy outputing bit 6 of PortB

	movfw	Brightness		; put brightness into W
	call	Delay			; call the delay

							; brightness can be 1,2,3 or 4, so now we have to call the delay again
							; 4 - brightness with the LEDs off

	bcf		PORTB,7			; turn off layer 3

	movfw	Brightness		; put Brightness into W
	sublw	4				; sub W from 4
	btfss	STATUS,Z		; skip if the zero flag is set
	call	Delay			; call the delay

	decfsz	Time			; decrement the Time regiester
	goto	Output2			; repeat
	return



;-----------------------------------------------------------------------------------------------;
; The Delay routine is called with a number put into the W register. This is in multiples of	;
; 100u seconds, (0.1m seconds)																	;
;-----------------------------------------------------------------------------------------------;
Delay:
	movwf	Delay3			; put W into Delay 3

Loop1:
							; After Delay2 decreses to 0, it is reset to..
	movlw	0x1				; put 1 into W
	movwf	Delay2			; put W into Delay2

Loop2:
							; After Delay1 decreses to 0, it is reset to E9h
	movlw	0x1D			; put 80 into W
	movwf	Delay1			; put W into Delay1

Loop3:
	decfsz	Delay1			; decrement Delay1
	goto	Loop3			; jump back to Loop3
	decfsz	Delay2			; decrement Delay2
	goto	Loop2			; jump back to Loop2
	decfsz	Delay3			; decrement Delay3
	goto	Loop1			; jump back to Loop1
	return



;-----------------------------------------------------------------------------------------------;
; Main program starts here																		;
;-----------------------------------------------------------------------------------------------;

Start:
	bsf		STATUS,RP0			; select register page 1
	movlw	0					; put 0 into W
	movwf	TRISC				; set portC all output
	movwf	TRISB				; set portB all outputs

	bsf		STATUS,RP1			; select Page 2,
	bcf		STATUS,RP0			; by setting RP1 in Status register and clearing RP0

	clrf	ANSEL				; select Digital I/O on port C
	clrf	ANSELH				; "		"

    bcf		STATUS,RP1			; back to Register Page 0

	bcf		EndCount,0			; reset the EndCount bit

	clrf	Counter				; clear the Counter register


Loop:
	call	CubeLight
	call	CubeLight
	call	CubeLight
	call	CubeLight
	call	CubeLight


	call	LayerDrop
	call	LayerDrop
	call	LayerDrop
	call	LayerDrop
	call	LayerDrop

	call	Spin
	call	Spin
	call	Spin
	call	Spin
	call	Spin

	call	SnakeLine
	call	SnakeLine
	call	SnakeLine
	call	SnakeLine
	call	SnakeLine

	call	LayerBrightness
	call	LayerBrightness
	call	LayerBrightness
	call	LayerBrightness
	call	LayerBrightness

	call	SpiralDown
	call	UpAndOut
	call	SpiralDown
	call	UpAndOut
	call	SpiralDown
	call	UpAndOut

	call	BigSmall
	call	BigSmall
	call	BigSmall
	call	BigSmall
	call	BigSmall
	call	BigSmall
	call	BigSmall
	call	BigSmall
	call	BigSmall
	call	BigSmall
	call	BigSmall


	call	LineAround
	call	LineAround
	call	LineAround
	call	LineAround
	call	LineAround

	call	SideToSide
	call	SideToSide
	call	SideToSide
	call	SideToSide
	call	SideToSide

	call	FlashingLines
	call	FlashingLines
	call	FlashingLines
	call	FlashingLines
	call	FlashingLines


	call	Firework
	call	Firework
	call	Firework
	call	Firework
	call	Firework

	call	DiagAroundSides
	call	DiagAroundSides
	call	DiagAroundSides
	call	DiagAroundSides
	call	DiagAroundSides

	call	LayerDrop2
	call	LayerDrop2
	call	LayerDrop2
	call	LayerDrop2
	call	LayerDrop2

	call	CubeFill
	call	CubeFill
	call	CubeFill
	call	CubeFill
	call	CubeFill
	call	CubeFill


	goto	Loop


end