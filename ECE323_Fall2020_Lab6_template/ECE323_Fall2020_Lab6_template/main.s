 AREA FLASH, CODE, READONLY
 EXPORT __main
 INCLUDE LPC11xx.inc
 IMPORT Part1	 
 IMPORT Level1_MAT1
 IMPORT Level2
 IMPORT Level3
 IMPORT ConfigClock
 EXPORT __use_two_region_memory

__use_two_region_memory EQU 0
    EXPORT SystemInit
    
   
    ENTRY
   
       
; System Init routine
SystemInit    

; __main routine starts here
__main

	; Enable clock for I/O config block, GPIO, and 32-bit counter/timer in SYSAHBCLKCTRL
    BL ConfigClock
	
	; Enable CT32B0 interrupt (bit 18) in Nested Vectored Interrupt Controller(NVIC)
    ; Load the address of Interrupt Set Register(ISER) of NVIC into R0
    LDR R0, =(NVIC); ISER of NVIC, address 0xE000 E100
    ; Load R1 with all zeros except bit-18 set
    MOVS R1, #0x1
	MOVS R1, R1, LSL #18
    ; Store the value of R1 into ISER of NVIC
    STR R1, [R0];
	
;	BL Part1
;	BL Level1_MAT1

;	BL Level2
	
	BL Level3
end 
	B end


	END; End of File
