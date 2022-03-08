 AREA FLASH, CODE, READONLY
 EXPORT __main
 INCLUDE LPC11xx.inc
 INCLUDE Constants.inc
 IMPORT LCD_init
 IMPORT Keypad_init
 IMPORT ConfigClock
 IMPORT print_string
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT EnterTx
 IMPORT LCD_command
 IMPORT get_next_key_input
 IMPORT clear_new_key_flag
 IMPORT memorySearch

 EXPORT __use_two_region_memory

__use_two_region_memory EQU 0
    EXPORT SystemInit
    
	ENTRY

SystemInit 
   
;Declarations related to memory storing
memory_pointer	RN	2
memory_offset	RN	4
element_size	EQU	4
num_elements	EQU	2
memory_block	EQU	element_size * num_elements	;8 bytes per tuple
num_blocks		EQU	10
memory_size		EQU	num_blocks * memory_block

__main
	SUB sp, sp, #memory_size	;Set up stack pointer to accomodate locals

	;Initialize clock
	BL ConfigClock
	;Initialize LCD
	BL LCD_init
	
	;Print name
	LDR R3, =myName
	BL print_string

	;Initialize keypad
	BL Keypad_init
	
	;Initialize R7 to be clear
	MOVS R7, #0
	LDR R0, =48000000	;Initialize R0 to be maximum value
	LDR R1, =1000		;Initialize R1 to be minimum value
	MOV memory_pointer, sp ;Initialize memory pointer
	MOVS memory_offset,	#0	;Initialize offset of memory to be 0 initially

getNextInput

	;Waiting for keypad input
	BL get_next_key_input	;New key will be stored in R6
	
	;New keypad input received. Clear new key flag.
	BL clear_new_key_flag
		
	;Branch to appropriate subroutine if needed.
CheckA
	CMP R6, #KEY_A
	BNE CheckB
	MOVS R5, #0
	BL EnterTx
	B memory_update
	
CheckB
	CMP R6, #KEY_B
	BNE CheckC
	MOVS R5, #1
	BL EnterTx
	B memory_update
	
CheckC
	CMP R6, #KEY_C
	BNE CheckD
	MOVS R5, #0		;Indicate prompt for subroutine to display
	PUSH{R0,R1}
	BL memorySearch
	POP{R0,R1}
	
CheckD
	CMP R6, #KEY_D
	BNE CheckAsterisk
	MOVS R5, #1		;Indicate prompt for subroutine to display
	BL memorySearch


CheckAsterisk
	CMP R6, #KEY_ASTERISK
	BNE getNextInput		;If not any of checked keys, do nothing
	
	
	
memory_update
	;If flags for R0 and R1 update are set (bits 29 and 30 in R7), then add them to memory
	LDR R5, =0x60000000 ;Bits 29 and 30 set
	MOVS R6, R5			;Apply same value to R6
	ANDS R5, R5, R7		;Check if both are set in R7, store result in R5
	CMP R6, R5
	BNE getNextInput	;If at least one isn't set, then don't update memory
	;Otherwise, go through memory update process

	;Updating memory
	STR R0, [memory_pointer, memory_offset]		;Store R0 to memory, increment pointer
	ADDS memory_offset, memory_offset, #element_size
	STR R1, [memory_pointer, memory_offset]		;Store R1 to memory, increment pointer
	ADDS memory_offset, memory_offset, #element_size

	;Prepare for next cycle
	BICS R7, R7, R5 ;Clear the flags
	LDR R0, =48000000	;Reset R0 to be maximum value
	LDR R1, =1000		;Reset R1 to be minimum value
	
	CMP memory_offset, #memory_size	;If offset is outside of range, reset it to 0
	BNE getNextInput	;If not out of range, then skip
	
	MOVS memory_offset, #0	;Reset offset to start
	;Set flag indicating that memory is full (bit 28)
	MOVS R5, #1
	LSLS R5, R5, #28
	ORRS R7, R7, R5		;Set bit 28
	
	B getNextInput
	
	ADD sp, sp, #memory_size ;Recover space used by locals
end 
	B end
		
myName	DCB	 "Brent!",0	
	ALIGN
	END
