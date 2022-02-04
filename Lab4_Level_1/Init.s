 ;This subroutine performs initialization of io pins on LPC1114
 AREA program, CODE, READONLY
 EXPORT Init
 INCLUDE	LPC11xx.inc

Init
	PUSH {R0-R7, LR}
	
	; page 33
	LDR R0, =(SYSAHBCLKCTRL); Use lower case to search in data sheet: SYSAHBCLKCTRL, address 0x4004 8080
    ; Load R1 with the value of SYSAHBCLKCTRL
    LDR R1, [R0];
    ; Load the bit pattern to enable clock for I/O config block(bit 16), GPIO(bit 6)
    LDR R2, =( 0x00010040 );
    ; Apply bitwise OR between R1(value of SYSAHBCLKCTRL) and R2(new bit pattern)
    ; and save the result into R1
    ORRS R1, R2;
    ; Store the new value of R1 into SYSAHBCLKCTRL
    STR R1, [R0];
	
	
	; Load the address of IOCON_PIO1_5 into R0, Table 96, page 102
    LDR R0, =(IOCON_PIO1_5); IOCON_PIO1_5, address 0x4004 4094
    ; Load the value of IOCON_PIO1_5 into R1
    LDR R1, [R0];
     ; Load R2 with 0x8 (bits 2:0 are zeros)
    LDR R2, =(0x8);
    ; Apply OR operation between R1 and R2
    ORRS R1, R2;
    ; Store the new value of R1 into IOCON_PIO1_5
    STR R1, [R0];
	 
	 
	; Load the address of IOCON_PIO1_6 into R0, table 97, page 103
    LDR R0, =(IOCON_PIO1_6); IOCON_PIO1_6, address 0x4004 40A4
    ; Load the value of IOCON_PIO1_6 into R1
    LDR R1, [R0];
    ; Load R2 with 0x8 (bits 2:0 are zeros)
    LDR R2, =(0x8);
    ; Apply AND operation between R1 and R2
    ORRS R1, R2;
    ; Store the new value of R1 into IOCON_PIO1_6
    STR R1, [R0];
	
	
	; page 123, Load the address of IOCON_PIO1_7 into R0
    LDR R0, =(IOCON_PIO1_7); IOCON_PIO1_7, address 0x4004 4094
    ; Load the value of IOCON_PIO1_7 into R1
    LDR R1, [R0];
    ; Load R2 with 0x8 (bits 2:0 are zeros)
    LDR R2, =(0x00000008);
    ; Apply AND operation between R1 and R2
    ORRS R1, R2;
    ; Store the new value of R1 into IOCON_PIO1_7
    STR R1, [R0];
	
	;Configure IOCON_PIO1_8 as IO pin
	LDR R0, =(IOCON_PIO1_8); IOCON_PIO1_8, address 0x4004 4094
    ; Load the value of IOCON_PIO1_8 into R1
    LDR R1, [R0];
    ; Load R2 with 0x8 (bits 2:0 are zeros)
    LDR R2, =(0x00000008);
    ; Apply AND operation between R1 and R2
    ORRS R1, R2;
    ; Store the new value of R1 into IOCON_PIO1_8
    STR R1, [R0];
	
	;Configure IOCON_PIO0_6 as IO pin
    LDR R0, =(IOCON_PIO0_6); IOCON_PIO0_6, address 0x4004 4094
    ; Load the value of IOCON_PIO0_6 into R1
    LDR R1, [R0];
    ; Load R2 with 0x8 (bits 2:0 are zeros)
    LDR R2, =(0x00000008);
    ; Apply AND operation between R1 and R2
    ORRS R1, R2;
    ; Store the new value of R1 into IOCON_PIO0_6
    STR R1, [R0];
	
	; Set bit 5,6 and 7 of GPIO1 data direction register to set PIO1_5, PIO1_6, PIO1_7 pin as output
    ; Chapter 12
    ; Load the address of GPIO1DIR into R0
    LDR R0, =(GPIO1DIR); GPIO1DIR, address 0x5001 8000, page 193, table 175
    ; Load the value of GPIO1DIR into R1
    LDR R1, [R0];
    MOVS R2, #(0x7) ;
	; Load a bit pattern 0x00000007 into R2  and shift left by 5 position to set bit 5, 6, and 7 
	MOVS R2, R2, LSL #5
    ; Apply bitwise OR operation between R1(value of GPIO1DIR) and R2(bit pattern)
    ORRS R1, R2;
    ; Store the new value of R1 into GPIO1DIR;
    STR R1, [R0];

	;Set bit 6 of GPIO0 to configure PIO0_6 as output pin
	LDR R0, =(GPIO0DIR) ;Get address of GPIO0DIR in R0
	;Load value of direction register into R1
	LDR R1, [R0];
	;Set bit 6 of direction register
	MOVS R2, #(0x40)
	ORRS R1, R2
	;Store updated value back into GPIO0DIR
	STR R1, [R0]

	POP {R0-R7, PC}

 END