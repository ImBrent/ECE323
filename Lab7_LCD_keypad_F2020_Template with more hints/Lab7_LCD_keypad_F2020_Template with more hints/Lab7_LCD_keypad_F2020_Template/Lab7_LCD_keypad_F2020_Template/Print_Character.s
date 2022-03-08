;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Prints character stored in R7 to LCD, and resets R6 to 0 when done
;Once 16 characters have been printed, text is wrapped to second row
;Once 33rd character is passed, first 32 are cleared and 33rd is printed at home
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA program, CODE, READONLY
 EXPORT Print_Character
 INCLUDE LPC11xx.inc
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT convertKeyNum
 IMPORT LCD_command 
	  
CHARS_PRINTED	RN	5
NEW_CHAR		RN	6
KEY_NUM			RN	7
CHAR_ASCII		RN	0
	  
Print_Character
	PUSH{R0-R4, R7, LR}
	
	BL LCD_config_dir	;Set configuration for writing to LCD


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
	MOVS NEW_CHAR, #0	;Clear NEW_CHAR flag
	
	POP{R0-R4,R7,PC}
	END