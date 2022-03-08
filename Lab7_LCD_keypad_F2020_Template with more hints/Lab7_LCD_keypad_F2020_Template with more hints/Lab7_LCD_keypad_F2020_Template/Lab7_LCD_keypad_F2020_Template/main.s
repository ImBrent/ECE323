 AREA FLASH, CODE, READONLY
 EXPORT __main
 INCLUDE LPC11xx.inc
 IMPORT PIOINT0_IRQHandler
 IMPORT LCD_init
 IMPORT Print_Character
 IMPORT BusyWait
 IMPORT Keypad_init


 EXPORT __use_two_region_memory

__use_two_region_memory EQU 0
    EXPORT SystemInit
    
	ENTRY

SystemInit 
   
CHARS_PRINTED	RN	5
NEW_CHAR		RN	6
KEY_NUM			RN	7
   
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
	CMP NEW_CHAR, #1	;Check NEW_CHAR flag. Advance only when equal to 1
	BNE check
	
	;Print character and do other necessary LCD actions
	BL Print_Character
	
	BL check
end 
	B end
	END; End of File
