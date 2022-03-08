 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT LCD_init
 IMPORT BusyWait
 IMPORT LCD_command	 
 IMPORT CONFIG_DIR
	 
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
	
LCD_init
	PUSH{R0-R7,LR}
	
	LDR R3, =1000000
	BL BusyWait
	
	MOVS R1, #0			;List of several commands. Need 0 to indicate command.
	
	MOVS	R0, #0x33			;Boot up
	BL		LCD_command
	
	MOVS	R0, #0x32			;Boot up
	BL		LCD_command
	
    MOVS	R0, #FOURBIT		;28H initialization to 2-lines
    BL 		LCD_command			;using 4-bit interface(DL = 0)

	MOVS	R0, #BLINK			;turn LCD display on, cursor on	and blink
    BL 		LCD_command
	
	MOVS	R0, #CLEAR		 	;clear LCD
    BL 		LCD_command
	
	MOVS 	R0, #HOME			;or using 02H - return home command
    BL 		LCD_command

	;==== End of LCD initialization ===========================================
	
	
	POP {R0-R7,PC}
	ALIGN
	END