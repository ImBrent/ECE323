 AREA PROGRAM, CODE, READONLY
 INCLUDE	LPC11xx.inc
 EXPORT PIOINT0_IRQHandler
 IMPORT LCD_command
 IMPORT LCD_init 
 IMPORT Keypad_init
 IMPORT BusyWait
 IMPORT LCD_config_dir
 IMPORT Keypad_config_dir
 IMPORT get_key_num
 IMPORT wait_for_key_release
 IMPORT EnableP0Interrupt
 IMPORT DisableP0Interrupt
			
KEY_NUM		RN		7
NEW_KEY		RN		6
ROW_NUM		RN		3
ROWS		RN		0

PIOINT0_IRQHandler
	PUSH {R3,LR}
	
	BL DisableP0Interrupt
	
	;Give small window for mechanical bouncing during push to settle
	LDR R3, =0x1000
	BL BusyWait	
	
	;Get Key number from keypad
	BL get_key_num

wait
	;Wait for user to release key before leaving interrupt
	BL wait_for_key_release

	;Give a small window in case release detected during bouncing
	LDR R3, =0x1000
	BL BusyWait

	;Enable interrupt
	BL EnableP0Interrupt

	POP{R3,PC}
	BX LR
	ALIGN
	END