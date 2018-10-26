	#include p18f87k22.inc
	
	keypad	   res 1	    ; Reserve 1 byte for keypad press setting
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	bsf	PADCFG1, REPU, banked	; Enable pull-up resistors on PORT E
	movlw   0x0F		    ; 0000 1111
	movwf	TRISE, ACCESS	    ; Port E <7:4> outputs <3:0> inputs

	movlw	0x00
	movwf	PORTE, ACCESS	    ; Output 0 on pins <7:4> of PORT E (can do anything about the lower 4 pins)
	
	movff	PORTE, W	    ; Read input pins of PORT E
	andlw	0xF0		    ; 1111 0000
	movwf	keypad		    ; Add row setting info onto upper nibble of keypad
	
	movlw	0xF0		    ; 1111 0000
	movwf	TRISE, ACCESS	    ; Port E <7:4> inputs <3:0> outputs
	
	movlw	0x00
	movwf	PORTE, ACCESS	    ; Output 0 on pins <3:0> of PORT E (can do anything about the upper 4 pins)
	
	andlw	0x0F		    ; 0000 1111
	addwf	keypad		    ; Add column setting info onto lower nibble of keypad
	
	
	movlw	0xFF		    
	movwf	TRISD, ACCESS	    ; PORT D all inputs
	movff	keypad, PORTD	    ; Send keypad setting info to PORT D
	
	end
