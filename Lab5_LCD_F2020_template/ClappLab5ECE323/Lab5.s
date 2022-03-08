 AREA FLASH, CODE, READONLY
 EXPORT __main
 INCLUDE	LPC11xx.inc
 IMPORT BusyWait
 IMPORT LCD_command	 
 IMPORT CONFIG_INIT
 IMPORT CONFIG_DIR
 IMPORT print_string
 IMPORT LCD_init
 IMPORT Level1
 IMPORT Level2
 IMPORT Level3

	EXPORT SystemInit
	ENTRY
   
       
; System Init routine
SystemInit    
CLEAR       EQU		0X01
HOME        EQU		0X02
LCD_ON      EQU		0X0C
BLINK       EQU		0X0F
CURSOR_ON   EQU		0X0E
LEFT        EQU		0X10
RIGHT       EQU		0X14
NEXT_LINE   EQU		0xC0
FOURBIT     EQU		0x28    ;0b00101000 = 0x28
LCD_OFF     EQU		0x0A

DELAY		EQU		500
RS_DATA		EQU		1	;RS = 1 for Data mode
RS_CMD		EQU		0	;RS = 0 for command mode

SIG_EN		RN	7
payload		RN	6

; __main routine starts here
__main
		
	;;===================Configure pins 0.1, 0.2, 0.3, 0.4, 0.7 and 1.8 as IOCON=======================
	
	BL CONFIG_INIT
	
	;;=======================configure the direction of pins 0.1, 0.2, 0.3, 0.4, 0.7 and 1.8 as output====================
	
	BL CONFIG_DIR	;Configure direction of pins
	
	BL LCD_init		;Initialize LCD display

	;Load input strings for Level 1
	LDR 		R3, =(string1)
	LDR			R4, =(string2)
	
;	BL Level1

;	BL Level2

	BL Level3

end 
	B end
		
string1		DCB		"Hello, ECE 323", 0
string2		DCB		"Brent Clapp", 0
	ALIGN

 END; End of File
