#include "def.inc"

 UDATA_SHR
d1	res	1		; Timer Var
d2	res	1		; Timer Var
d3	res	1		; Timer Var

 global	var_delay
 global	Delay125
 global	Delay1000
 code

var_delay
		movwf	d1
BD0
		nop
		decfsz	d1, f
		goto	BD0
		return
Delay125
		movlw	0x0F
		movwf	d1
		movlw	0x28
		movwf	d2
d125
		decfsz	d1, f
		goto	$+2
		decfsz	d2, f
		goto	d125
		return

Delay1000
		movlw	0x08
		movwf	d1
		movlw	0x2F
		movwf	d2
		movlw	0x03
		movwf	d3
d1000
		decfsz	d1, f
		goto	$+2
		decfsz	d2, f
		goto	$+2
		decfsz	d3, f
		goto	d1000
		return

 END