 AREA FLASH, CODE, READONLY
 EXPORT __main
 INCLUDE GlobalVariables.inc
 IMPORT LCD_init
 IMPORT Keypad_init
 IMPORT ConfigClock
 IMPORT print_string
 IMPORT channel_init
 IMPORT processInputs
 IMPORT capture_init

 EXPORT __use_two_region_memory

__use_two_region_memory EQU 0
    EXPORT SystemInit
    
	ENTRY

SystemInit 

__main
	;Allocating space for global variables. Saving beginning address of region into R7.
	;Move lower 16 bits of current stack address into bits 4-19 of R7
	MOV R0, sp
	LDR R1, =0xFFFF
	ANDS R1, R1, R0	;Mask upper 16 bits
	LSLS R1, R1, #4	;Shift into bits 4-19
	MOVS R7, #0	;Clear R7
	ORRS R7, R7, R1	;Set necessary bits.	
	SUB sp, sp, #global_memory_size ;Allocate the space on the stack
	
	;Initialize clock
	BL ConfigClock
	
	;Initialize channels. Timers, GPIO, PWM, etc
	BL channel_init
	
	;Initialize capture pin
	BL capture_init
	
	;Initialize LCD
	BL LCD_init

	;Initialize keypad
	BL Keypad_init

	BL processInputs

	ADD sp, sp, #global_memory_size
end 
	B end
	
	ALIGN
	END
