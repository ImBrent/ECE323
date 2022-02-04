	AREA FLASH, CODE, READONLY
	ENTRY

	EXPORT __main
	EXPORT SystemInit
		
; System Init Routine
SystemInit

; __main routine starts here
__main
	MOVS r1, #1;
	MOVS r2, #2;
	MOVS r3, #3;
	MOVS r4, #4;
	MOVS r5, #5;
	ADDS r6, r1, r2;
	ADDS r6, r6, r3;
	ADDS r6, r6, r4;
	ADDS r6, r6, r5;
exit
	B exit
	
	END ;End of File