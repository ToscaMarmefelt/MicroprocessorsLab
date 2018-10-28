	#include p18f87k22.inc
	
	code
	org 0x0
	goto	setup
	
	org 0x100		; Main code starts here at address 0x100

	; ******* Programme FLASH read Setup Code ****  
setup	bcf	EECON1, CFGS	; Memory selection access determined by EEPGD. CFGS = '0' (in register EECON1). 
	bsf	EECON1, EEPGD 	; Any subsequent operations will operate on program memory. EEPGD = '1' (in register EECON1).
	goto	start
	
	; ******* My data and where to put it in RAM *
myTable data	"A beautiful string of data"
	constant 	myArray=0x400	; Address in RAM for data
	constant 	counter=0x10	; Address of counter variable
	
	; ******* Main programme *********************
start 	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	.26		; 26 bytes to read
	movwf 	counter		; our counter register
loop 	tblrd*+			; move one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move read data from TABLAT to (FSR0), increment FSR0	
	decfsz	counter		; count down to zero
	bra	loop		; keep going until finished
	
	goto	0

	
SPI_MasterInit			; Set Clock edge to positive
        bsf     SSP2STAT, CKE	; CKE = '1'. SDO2 data is valid before there is a clock edge on SCK2. 
        movlw   (1<<SSPEN)|(1<<CKP)|(0x02) ; MSSP enable | CKP=1 | SPI master, clock=Fosc/64 (1MHz).
        movwf   SSP2CON1	; MSSP2 Control Register 1
        bcf     TRISC, SDO2	; SDO2 = '0' in register TRISC. SDO2 output.
        bcf     TRISC, SCK2	; SCK2 = '0' in register TRISC. SCK2 output.
        return
	
SPI_MasterTransmit		; Start transmission of data (held in W)
	movwf	SSP2BUF		; Place data held in W in SSP2 buffer register
Wait_Transmit			; Wait for transmission to complete
        btfss	PIR2, SSP2IF	; If SSP2IF in register PIR2 is set, skip the next instruction. 
        bra	Wait_Transmit
        bcf	PIR2, SSP2IF    ; Clear interrupt flag	
        return

	
	
	end
