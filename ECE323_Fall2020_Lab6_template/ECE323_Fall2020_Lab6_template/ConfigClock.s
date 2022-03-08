;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ConfigClock.s
;The ConfigClock subroutine enables the clock for
;I/O config block, GPIO, and 32-bit counter/timer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	AREA PROGRAM, CODE, READONLY
	INCLUDE	LPC11xx.inc
	EXPORT ConfigClock

ConfigClock
	PUSH {R0-R7, LR}
	
	; First, load the address of SYSAHBCLKCTRL into R0
    LDR R0, =(SYSAHBCLKCTRL); SYSAHBCLKCTRL, address 0x4004 8080
    ; Load R1 with the value of SYSAHBCLKCTRL
    LDR R1, [R0];
    ; Load the bit pattern to enable clock for I/O config block(bit 16), GPIO(bit 6),
    ; and 32-bit counter/timer(bit 9) into R2
    LDR R2, =(0x10240);
    ; Apply bitwise OR between R1(value of SYSAHBCLKCTRL) and R2(new bit pattern)
    ; and save the result into R1
    ORRS R1, R2;
    ; Store the new value of R1 into SYSAHBCLKCTRL
    STR R1, [R0];
	
	POP {R0-R7, PC}
	END
	