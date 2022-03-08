 AREA FLASH, CODE, READONLY
 EXPORT __main
 INCLUDE LPC11xx.inc
 IMPORT PIOINT0_IRQHandler
 IMPORT LCD_init
 IMPORT LCD_command
 IMPORT BusyWait
 IMPORT Keypad_init
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT convertKeyNum

 EXPORT __use_two_region_memory

__use_two_region_memory EQU 0
    EXPORT SystemInit
    
   
	ENTRY

SystemInit 
   
CHARS_PRINTED	RN	5
NEW_CHAR		RN	6
KEY_NUM			RN	7
CHAR_ASCII		RN	0
   
; __main routine starts here
__main

	LDR R0, =(SYSAHBCLKCTRL); SYSAHBCLKCTRL, address 0x4004 8080
    ; Load R1 with the value of SYSAHBCLKCTRL
    LDR R1, [R0];
    ; Load the bit pattern to enable clock for I/O config block(bit 16), GPIO(bit 6)
    LDR R2, =( 0x00010040 );
    ; Apply bitwise OR between R1(value of SYSAHBCLKCTRL) and R2(new bit pattern)
    ; and save the result into R1
    ORRS R1, R2;
    ; Store the new value of R1 into SYSAHBCLKCTRL
    STR R1, [R0];
	
	BL LCD_init
	
	BL Keypad_init

	MOVS CHARS_PRINTED, #0	;Initialize number of characters printed to 0
;Check if new character from keypad. If yes, then print it
check
	CMP NEW_CHAR, #1	;Check NEW_CHAR flag
	BNE check
	
	BL LCD_config_dir	;Set configuration for writing to LCD
	MOVS NEW_CHAR, #0	;Clear NEW_CHAR flag
;Check if keypad needs to move to next line or clear
	CMP CHARS_PRINTED, #16	;Check if need to move to next line
	BEQ next_line
	
	CMP CHARS_PRINTED, #32	;Check if need to clear
	BLT LCDprint			;If less than 32, then no clearance needed

clear_display
	MOVS CHARS_PRINTED, #0	;Reset number of characters printed on display
	MOVS 	R1, #0x0			;Indicate commands to LCD
	MOVS	R0, #0x1		 	;clear LCD
    BL 		LCD_command
	
	MOVS 	R0, #0x2			;return home
    BL 		LCD_command

	BL LCDprint				;Go print new character to LCD
	
next_line
	MOVS R1, #0x0			;Indicate commands to LCD
	MOVS R0, #0xC0			;Go to next line
	BL LCD_command

LCDprint
	BL convertKeyNum	;Convert from key number (R7) to ASCII code (R0)
	MOVS R1, #1			;Indicate writing data to LCD
	BL LCD_command
	ADDS CHARS_PRINTED, #1
LCDdone
	BL Keypad_config_dir ;Reset pin directions to read from keypad
	BL check
end 
	B end


	END; End of File
