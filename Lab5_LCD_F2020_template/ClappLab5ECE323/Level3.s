 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 EXPORT Level3
 IMPORT LCD_command
 IMPORT print_string
 IMPORT BusyWait
 IMPORT string_length
 IMPORT Level3_print_string
	
CLEAR       EQU		0X01
HOME        EQU		0X02
LCD_ON      EQU		0X0C
BLINK       EQU		0X0F
CURSOR_ON   EQU		0X0E
LEFT        EQU		0X10
RIGHT       EQU		0X14
NEXT_LINE   EQU		0xC0
FOURBIT     EQU		0x28   ;0b00101000 = 0x28
LCD_OFF     EQU		0x0A

CLK_FREQ	EQU		12000000	;12 MHz clock
CYCperLOOP	EQU		4			;4 clock cycles per BusyWait loop
loopsPERsec  EQU	CLK_FREQ / CYCperLOOP	;Number of busyWait loops per second
UPDATEfreq	  EQU	5	;Update frequency in Hz
DELAY		EQU		loopsPERsec / UPDATEfreq	;Parameter to BusyWait

FIRST_ADDRESS	RN	7	;Address of first byte in string
NULL_ADDRESS	RN	5	;Address of null byte in string
START_ADDRESS	RN	6	;Address of first byte to print in string
	
Level3
	PUSH{R0-R7, LR}
	;First, find string length
	LDR FIRST_ADDRESS, =string
	BL string_length	;Stores length of string in R6
	
	;Get index of null byte
	ADDS NULL_ADDRESS, FIRST_ADDRESS, R6
	
	;First iteration: Starts printing at first address
	MOVS START_ADDRESS, FIRST_ADDRESS
	

infiniteLoop
	;Print chars
	BL Level3_print_string
	
	;Wait a half second
	LDR R3, =(DELAY)
	BL BusyWait
	
	;Clear display
	MOVS R0, #CLEAR
	MOVS R1, #0
	BL LCD_command
	
	;Increment start address
	ADDS START_ADDRESS, START_ADDRESS, #1
	;If start address is null byte, loop back around to first
	CMP START_ADDRESS, NULL_ADDRESS
	BNE infiniteLoop
	
	MOVS START_ADDRESS, FIRST_ADDRESS ;Reset start address to first byte
	
	BL infiniteLoop

	POP{R0-R7, PC}
string 	DCB "A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ",0
	ALIGN
	END
