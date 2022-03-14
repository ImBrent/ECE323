;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Constants.inc
; A file containing all necessary compile-time constants for the project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;LCD constants
CLEAR       EQU		0X01
HOME        EQU		0X02
DECREMENT	EQU		0x04
INCREMENT	EQU		0x06
LCD_ON      EQU		0X0C
BLINK       EQU		0X0F
CURSOR_ON   EQU		0X0E
LEFT        EQU		0X10
RIGHT       EQU		0X14
NEXT_LINE   EQU		0xC0
FOURBIT     EQU		0x28    ;0b00101000 = 0x28
LCD_OFF     EQU		0x0A

;Keypad key mappings
KEY_0				EQU		0xB
KEY_1				EQU		0xC
KEY_2				EQU		0x8
KEY_3				EQU		0x4	
KEY_4				EQU		0xD
KEY_5				EQU		0x9
KEY_6				EQU		0x5
KEY_7				EQU		0xE
KEY_8				EQU		0xA
KEY_9				EQU		0x6
KEY_A				EQU		0x0
KEY_B				EQU		0x1
KEY_C				EQU		0x2
KEY_D				EQU		0x3
KEY_ASTERISK		EQU		0xF
KEY_POUND			EQU		0x7
	
;Declarations related to local memory storing in processInputs/memory_update subroutines
memory_pointer	RN	2
memory_offset	RN	4
element_size	EQU	4
num_elements	EQU	2
memory_block	EQU	element_size * num_elements	;8 bytes per tuple
num_blocks		EQU	10
memory_size		EQU	num_blocks * memory_block 
	END