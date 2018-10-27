	#include p18f87k22.inc
	
	delay_count	res 1	    ; Location for delay counter
	data_temp	res 1	    ; Reserve 1 byte in memory for temporary storage of data
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100
	
	; First 4 lines I have no clue what they are on about... 
	banksel	PADCFG1		    ; PADCFG1 is not in Access Bank
	bsf	PADCFG1, REPU, BANKED ; PORT E pull-ups on
	movlb	0x00		    ; Set BSR back to Bank 0
	setf	TRISE		    ; Tri-state PORT E
	
	
	; Set up static ports (PORT D, C, H)
start	movlw	0x00
	movwf	TRISD, ACCESS	    ; PORT D (Address/Control bus) all outputs
	
	movlw	0xFF
	movwf	TRISC, ACCESS	    ; PORT C (Memory 1 LEDs) all inputs
	movwf	TRISH, ACCESS	    ; PORT H (Memory 2 LEDs) all outputs
	
	; Write/read test routine
	movlw	0x6F		    ; Set 1st data pattern: b'1001 1111'
	call	write_1		    ; Write data pattern onto Memory 1
	movlw	0xDB		    ; Set 2nd data patterm: b'1101 1011'
	call	write_2		    ; Write 2nd data pattern onto Memory 2
	
	call	read_1		    ; Read Memory 1 (will be displayed on PORT C LEDs)
	call	read_2		    ; Read Memory 2 (displayed on PORT H LEDs)
	
	
	goto	0x00
	
	
	; SUBROUTINES
	
	; Write data in W onto Memory 1
write_1	movwf	data_temp	    ; Temporarily store data value in reserved location
	movlw	0x22		    
	movwf	PORTD, ACCESS	    ; Disable both memory outputs
	clrf	TRISE, ACCESS	    ; PORT E (Data bus) all outputs
	
	movff	data_temp, PORTE    ; Output data from temporary storage to PORT E
	call	CP_1		    ; CP1 = 1 then 0. Rest of PORT D remain unchanged. 
	return

	; Write data in W onto Memory 2
write_2	movwf	data_temp	    ; Temporarily store data value in reserved location
	movlw	0x22		    
	movwf	PORTD, ACCESS	    ; Disable both memory outputs
	clrf	TRISE, ACCESS	    ; PORT E (Data bus) all outputs
	
	movff	data_temp, PORTE    ; Output data from temporary storage to PORT E
	call	CP_2		    ; CP2 = 1 then 0. Rest of PORT D remain unchanged. 
	return
	
	; Read data from Memory 1 onto W
read_1	setf	TRISE, ACCESS	    ; PORT E (Data bus) all inputs
	movlw	0x20		    ; 0010 0000
	movwf	PORTD, ACCESS	    ; Memory 1 output enabled. OE1* = 0 and OE2* = 1. 
	call	CP_1		    ; DO WE NEED THIS to make change in OE happen????   Won't do any harm to have it there at least?
	
	movff	PORTE, data_temp    ; Read data from PORT E to data_temp
	movff	data_temp, PORTC    ; Display data on PORT C LEDs
	movlw	0x22		    ; 0010 0010
	movwf	PORTD, ACCESS	    ; Disable both memory outputs. OE1* = 1 and OE2* = 1.
	movff	data_temp, W	    ; Leave subroutine with data stored in W
	return
	
	; Read data from Memory 2 onto W
read_2	setf	TRISE, ACCESS	    ; PORT E (Data bus) all inputs
	movlw	0x02		    ; 0000 0010
	movwf	PORTD, ACCESS	    ; Memory 2 output enabled. OE1* = 1 and OE2* = 0.
	call	CP_2		    ; DO WE NEED THIS????   
	
	movff	PORTE, data_temp    ; Read data from PORT D to data_temp
	movff	data_temp, PORTH    ; Display data on PORT H LEDs
	movlw	0x22		    ; 0010 0010
	movwf	PORTD, ACCESS	    ; Disable both memory outputs. OE1* = 1 and OE2* = 1.
	movff	data_temp, W	    ; Leave subroutine with data stored in W
	return
	
	; Delay subroutine which takes 250 ns to run NOT DONE YET
delay250ns	
	movlw	0x64		    ; Count to .100
	movwf	delay_count
loop	decfsz	delay_count	    ; Decrement until 0
	bra	loop
	return
	
	; Let CP1 = 1 then 0
CP_1	movff	PORTD, W	    ; Put value of PORT D in W	    
	iorlw	0x01		    
	movwf	PORTD, ACCESS	    ; CP1 = 1. Original PORT D settings on <7:1>.
	call	delay250ns
	xorlw	0x01		    
	movwf	PORTD, ACCESS	    ; CP1 = 0. Original PORT D settings on <7:1>.
	call	delay
	return
	
	; Let CP2 = 1 then 0
CP_2	movff	PORTD, W	    ; Put value of PORT D in W	    
	iorlw	0x10		    
	movwf	PORTD, ACCESS	    ; CP2 = 1. Original PORT D settings on all other pins.
	call	delay250ns
	xorlw	0x10		    
	movwf	PORTD, ACCESS	    ; CP2 = 0. Original PORT D settings on all other pins. 
	call	delay
	return

	goto	0x00
	
	end
