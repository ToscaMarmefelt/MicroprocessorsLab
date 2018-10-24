	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw   0x00
	movwf	TRISD, ACCESS	    ; Port D all outputs
	movlw 	0x00
	movwf	TRISE, ACCESS	    ; Port E all outputs
	
	movlw	0xFF		    ; Number of times go through loop
	movwf	0x06		    ; Create counter at 0x06 
	
clock	movlw	0xF0
	movwf	PORTE, ACCESS	    ; Data to PORT E   
	call	CP_pulse	    ; Data stored internally on rising edge of clock pulse
	call	OE_low		    ; Data outputted to Q0
	
	movlw	0x0F
	movwf	PORTE, ACCESS	    ; Data to PORT E  
	call	CP_pulse	    ; Data stored internally on rising edge of clock pulse
	;call	OE_low		    ; Data outputted to Q0. NO NEED TO MAKE LOW AGAIN AS ALREADY LOW
	
	decfsz	0x06, F, ACCESS	    ; Repeat clock loop until counter is equal to zero
	bra	clock
	
	goto	0x0
	
CP_pulse movfw	PORTD, ACCESS		    
	iorlw	0x01		    ; Original PORT D settings on <7:1> but pin 0 is set to 1
	movwf	PORTD, ACCESS
	xorlw	0x01
	movwf	PORTD, ACCESS	    ; Original PORT D settings on <7:1> but pin 0 is set to 0
	return
	
OE_high	movfw	PORTD, ACCESS
	iorlw	0x02		    ; Original PORT D settngs on all pins but 1 kept, pin 1 is set to 1
	movwf	PORTD, ACCESS
	return
	
OE_low	movfw	PORTD, ACCESS
	xorlw	0x02		    ; Original PORT D settngs on all pins but 1 kept, pin 1 is set to 0
	movwf	PORTD, ACCESS
	return
	
	end
