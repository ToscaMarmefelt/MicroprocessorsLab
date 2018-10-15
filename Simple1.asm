	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw   0xFF
	movwf	TRISD, ACCESS	    ; Port D all inputs
	movlw 	0x0
	movwf	TRISE, ACCESS	    ; Port E all outputs
	
	movlw	0xFF
	movwf	0x06		    ; Create counter at 0x06 
	
clock	movlw	0x02		    ; Clock (pin 0) 0 ; OE (pin 1) 1		    
	movwf	PORTD, ACCESS	    ; Output clock value 0 to Port D
	movlw	0x03		    ; Clock (pin 0) 1 ; OE (pin 1) 1
	movwf	PORTD, ACCESS	    ; Output clock value 1 to Port D (OE still 1) 
	decfsz	0x06, F, ACCESS	    ; Count
	bra	clock
	
	goto	start
	
	end
