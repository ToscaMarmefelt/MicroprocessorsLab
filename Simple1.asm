	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw   0xFF
	movwf	TRISD, ACCESS	    ; Port D all inputs
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port C all outputs
	bra 	test
loop	movlw	0xFF		    ; select how long the delay will be
	movwf	0x20		    ; Make 0x20 counter
	call	delay
	movff 	0x06, PORTC
	incf 	0x06, W, ACCESS
test	movwf	0x06, ACCESS	    ; Test for end of loop condition
	movlw	0xFF		    ; Set number of counts of main counter
	cpfsgt 	0x06, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start
	
delay	movlw	0xFF		    ; Select number of counts for second delay
	movwf	0x21		    ; Second counter address
	call	delay2
	decfsz	0x20		    ; Decrement value in counter until zero
	bra	delay
	return
	
delay2	decfsz	0x21		    ; Decrement value in second counter until zero
	bra	delay2		    
	return
	
	end
