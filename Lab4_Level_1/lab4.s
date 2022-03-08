 AREA FLASH, CODE, READONLY
 EXPORT __main
 INCLUDE	LPC11xx.inc
	 
 EXPORT __use_two_region_memory
 IMPORT Level1
 IMPORT Init
 IMPORT Level2
 IMPORT Level3

__use_two_region_memory EQU 0
    EXPORT SystemInit
    
   
    ENTRY
   
       
; System Init routine
SystemInit    



; __main routine starts here
__main
	;Initialize IO pins
	BL Init
	;Perform Level 1
;	BL Level1
	;Perform Level 2
 ;   BL Level2
	
	BL Level3
end 
	B end

	END; End of File
