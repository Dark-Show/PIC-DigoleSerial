;*******************************************************
;OLED Commands
;*******************************************************

;**************************
;Fonts:
;0,6,10,18,51,120,123
;**************************

#include "def.inc"
 UDATA_SHR
font	res	1					; Set Font (0 default)
oledtmp	res	1

 global	OLED_Init
 global	OLED_Orgin
 global	OLED_StartScreen
 global	OLED_Clear
 global	OLED_ClearScreen
 global	OLED_Rotate180
 global	OLED_StartText
 global	OLED_SendNull
 global	OLED_NextLine
 global	OLED_EEPROM
 global OLED_DMNULL
 global OLED_DMNOT
 global OLED_DOUT
 global	OLED_TextPos
 global OLED_FillRect
 global	OLED_DrawRect
 global OLED_DrawLine
 global	OLED_HEX
 extern	CONV_HEX
 extern	Delay1000
 extern	Delay125
 extern	UART_SendByte
 extern	EEPROM_Read
 extern ee_dat
 extern	baud

 code

OLED_Init
		call	Delay1000		; Delay for Boot Screen
		call	Delay1000
		movlw	0x18			; 9600bps
		movwf	baud
		call	OLED_SetBaud19.2k
		movlw	0x0A			; 19200bps
		movwf	baud
		call	OLED_Clear
		;call	OLED_Rotate180
		return
OLED_SetBaud19.2k
		movlw	"S"
		call 	UART_SendByte
		movlw	"B"
		call 	UART_SendByte
		movlw	"1"
		call 	UART_SendByte
		movlw	"9"
		call 	UART_SendByte
		movlw	"2"
		call 	UART_SendByte
		movlw	"0"
		call 	UART_SendByte
		movlw	"0"
		call 	UART_SendByte
		call 	OLED_SendNull
		return
OLED_FillRect	;FR(X,Y,X2,Y2)
		movlw	"F"
		call 	UART_SendByte
		movlw	"R"
		call 	UART_SendByte
		return
OLED_DrawRect	;DR(X,Y,X2,Y2)
		movlw	"D"
		call 	UART_SendByte
		movlw	"R"
		call 	UART_SendByte
		return
OLED_DrawLine	;LN(X,Y,X2,Y2)
		movlw	"L"
		call 	UART_SendByte
		movlw	"N"
		call 	UART_SendByte
		return
OLED_DOUT		;DOUT(00011111)
		movlw	"D"
		call 	UART_SendByte
		movlw	"O"
		call 	UART_SendByte
		movlw	"U"
		call 	UART_SendByte
		movlw	"T"
		call 	UART_SendByte
		return
OLED_Orgin
		movlw	"T"
		call 	UART_SendByte
		movlw	"P"
		call 	UART_SendByte
		movlw	0x00
		call 	UART_SendByte
		movlw	0x00
		call 	UART_SendByte
		return
OLED_TextPos
		movlw	"T"
		call 	UART_SendByte
		movlw	"P"
		call 	UART_SendByte
		return
OLED_StartScreen
		movlw	"D"
		call 	UART_SendByte
		movlw	"S"
		call 	UART_SendByte
		movlw	"S"
		call 	UART_SendByte
		movlw	"1"
		call 	UART_SendByte
		call	Delay1000
		return
OLED_Clear
		movlw	"C"
		call 	UART_SendByte
		movlw	"L"
		call 	UART_SendByte
		return
OLED_ClearScreen
		call	OLED_CS
		call	OLED_DMNOT
		call	OLED_CS
		call	OLED_DMNULL
		return
OLED_CS
		movlw	"F"
		call 	UART_SendByte
		movlw	"R"
		call 	UART_SendByte
		movlw	0x00
		call 	UART_SendByte
		movlw	0x00
		call 	UART_SendByte
		movlw	0x80
		call 	UART_SendByte
		movlw	0x41
		call 	UART_SendByte
		return
OLED_DMNOT
		movlw	"D"
		call 	UART_SendByte
		movlw	"M"
		call 	UART_SendByte
		movlw	"!"
		call 	UART_SendByte
		return
OLED_DMNULL
		movlw	"D"
		call 	UART_SendByte
		movlw	"M"
		call 	UART_SendByte
		movlw	0x00
		call 	UART_SendByte
		return
OLED_Rotate180
		call	OLED_Clear
		movlw	"S"
		call 	UART_SendByte
		movlw	"D"
		call 	UART_SendByte
		movlw	"2"
		call 	UART_SendByte
		return
OLED_StartText
		movlw	"T"
		call 	UART_SendByte
		movlw	"T"
		call 	UART_SendByte
		return
OLED_SendNull
		movlw	0x00
		call 	UART_SendByte
		call	Delay125
		return
OLED_NextLine
		movlw	"T"
		call 	UART_SendByte
		movlw	"R"
		call 	UART_SendByte
		movlw	"T"
		call 	UART_SendByte
		return
OLED_EEPROM
		call	EEPROM_Read
		sublw	0xFF
		btfsc	STATUS,Z
		goto	$+4
		movf	ee_dat,w
		call 	UART_SendByte
		goto	OLED_EEPROM
		return
OLED_HEX
		movwf	oledtmp
		swapf	oledtmp,	w
		andlw	0x0f
		call	CONV_HEX
		call	UART_SendByte
		movf	oledtmp, w
		andlw	0x0f
		call	CONV_HEX
		call	UART_SendByte
		return
 END