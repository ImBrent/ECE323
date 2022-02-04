;;***************************************;;
; Code for, given a value of N in R0, 
; finding value (stored in R4) of a given series and 
; finding value (stored in R5) of the summation from k = 1 to N of 3*k
; written by Brent Clapp
; written on 01/13/22  
;;***************************************;;

	AREA FLASH, CODE, READONLY
	ENTRY

	EXPORT __main
	EXPORT SystemInit
		
; System Init Routine
SystemInit

; __main routine starts here
__main
	MOVS R0, #5 ;Load N into R0
	
	;;;; Begin Part 1, R4 = N^2 + 8N - 35 ;;;;;;;;;;;
	;;;; Note: To reduce multiplications, equation is factored s.t.:
	;;;; R4 = N(N+8) - 35
	
	MOVS R2, #8    
	ADDS R4, R0, R2 ; Add 8 to N
	
	MULS R4, R0, R4 ;Multiply R4 by N
	
	MOVS R2, #35
	SUBS R4, R4, R2 ;;; N(N+8) - 35 now stored in R4.
	;;;;;;;;;; Part 1 completed ;;;;;;;;;;;;;;;
	
	;;;;;; Begin Part 2, summation of (3*k) from k = 1 to N
	;;;;;; Note: To reduce multiplications, 3 is factored out of the summation
	
	; N is already is R0
	MOVS R1, #1 ;Loading k into R1, will also use as a counter
	MOVS R2, #1 ;Used as increment quantity for counter
	
summation
	ADDS R5, R5, R1;Set R5 to R5 + k
	ADDS R1, R2;Increment k
	CMP R1, R0 ;compare k and N
	BLE summation ;If k <= N, jump to SUMMATION
		
	MOVS R3, #3
	MULS R5, R3, R5; Multiply R5 by 3
	
	;Result is now in R5.
	;;;;;;;;;;; Part 2 completed ;;;;;;;;;;;;;
		
exit
	B exit
	
	END ;End of File