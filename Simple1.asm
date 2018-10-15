	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw   0x00
	movwf	TRISD, ACCESS	    ; Port D all outputs
	movlw 	0x0
	movwf	TRISE, ACCESS	    ; Port E all outputs
	
oe	;movlw	0xF0
	;movwf	PORTE, ACCESS	    ; Data to be stored on external memory 
	
	movlw	0xFF
	movwf	0x06		    ; Create counter at 0x06 
	
clock	movlw	0xF0
	movwf	PORTE, ACCESS	    ; Data to Port E 
	
	movlw	0x00		    ; CP (pin 0) 0 ; OE (pin 1) 0		    
	movwf	PORTD, ACCESS	    ; Output clock value 0 to Port D
	movlw	0x03		    ; CP (pin 0) 1 ; OE (pin 1) 1
	movwf	PORTD, ACCESS	    ; Output clock value 1 to Port D 
	movlw	0xF1
	movwf	PORTE, ACCESS	    ; Data to Port E
	movlw	0x01		    ; CP (pin 0) 1 ; OE (pin 1) 0
	movwf	PORTD, ACCESS
	movlw	0x02		    ; CP (pin 0) 0 ; OE (pin 1) 1
	movwf	PORTD, ACCESS
	movlw	0x03		    ; CP (pin 0) 1 ; OE (pin 1) 1
	movWf	PORTD, ACCESS	    
	decfsz	0x06, F, ACCESS	    ; Count
	bra	clock
	
	goto	0x0
	
	end
