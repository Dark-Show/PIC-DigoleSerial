;*******************************************************
;UART Bit-Banging
;
;*******************************************************

;**************************
; Bit Delay Values @ 4MHZ
; 0x18 - 9600bps
; 0x0A - 19200bps
;**************************

#include "def.inc"
 UDATA_SHR
bit_cntr	res	1		; UART Tx Var
tx_byte		res	1		; UART Tx Byte
baud		res	1		; UART bit delay value

 global	tx_byte
 global	baud
 global	UART_SendByte
 global	UART_Init
 extern	var_delay

 code

UART_Init
		bsf		UART		; Keep UART High
		return

UART_SendByte
		movwf	tx_byte
		movlw	h'08'		; 8 Bits in a Byte
		movwf	bit_cntr	;
		bcf		UART		; Low Signals Start of Bitstream
		movf	baud,w
		call 	var_delay	; 
XT
		rrf		tx_byte,1	; MSB
		btfss	STATUS,C	; If High
		bcf		UART		; Output High
		btfsc	STATUS,C	; If Low
		bsf		UART		; Output Low
		movf	baud,w
		call	var_delay	;
		decfsz	bit_cntr,1	; Next Bit
		goto	XT			;
		bsf		UART		; End Bitstream High
		movf	baud,w
		call	var_delay	;
		return
 END
