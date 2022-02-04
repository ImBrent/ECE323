;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This code (lab 2) is to
;;; 1) sort an array of numbers in descending order (max to min).  
;;; An array is stored in memory pointed to by R12 (R12 is a pointer to a given array)
;;; The sorted array should be stored in memory pointed to by R11
;;; 2) find an average of the given arary and store it in R10

;;;; Written by       			 ;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Written on 	          	 ;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;; the SORTED array should be stored in memory starting at the address 0x40000000  [LDR	R11, =0x40000000] 
	;;;;;;;;;; the average value of the given array should be kepted in R10
	;;;;;;;;;;Start writing your code here ;;;;;;;;;;;;;;;
	
 AREA FLASH, CODE, READONLY
 ENTRY
 
 EXPORT __main
 EXPORT SystemInit
	 
; System Init routine
SystemInit	

sizeOfItem		EQU	1	;sizeOf(byte) = 1

srcArrayAddr	RN	7
lenAddr			RN	5

destArrayAddr	RN	6

__main

init

	LDR		lenAddr, =len2			;length of the given array
	
	LDR		srcArrayAddr, =array2	;the memory address of 
									;the first element (number) of the given array

	LDR		destArrayAddr, =0x40000100		;memory location (address) used
									;for keeping the SORTED array

	;;; More initialization here ;;;
	
copyArray
	LDRB R0, [R7]		;load R0 with 1 character from string array 
	ADDS R7, R7, #1    		;   increase the address pointed by R7 
	STRB R0, [R6]	;STORE one-byte from R0 (last 8 bits) into memory at the 
		;address pointed to by R6 
	ADDS	R6, R6, #1

	;;; Copy data in srcArrayAddr to destArrayAddr
	;;; Only need to perform this once
	
doWork

	;;; Your code goes here

done	
	B		done	;Done


	
;;;;;;;;;;;;;;; The given array (at the lab check-off, your code should work for both arrays)
len1		DCB		8
array1		DCB		-87, 69, 0, -128, -1, 100, 43, 12 

len2		DCB		8
array2		DCB		54, -119, 8, -39, 1, -93, 21, 127

name		DCB		"Brent Clapp : pj6749uy"
	END

