;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;	Lab2.s
;	Using a null-terminated string, this program will:	
;	1. Create a sorted list of all alphabetic characters in the string in memory (pointed to be R5)
;	2. Add up the numeric values of all numerical digits found in the string
;	3. Divide 7320 by the total count of characters found in the string
;	Written By: Brent Clapp
;	Date: 01/20/2022
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 AREA FLASH, CODE, READONLY
 ENTRY

 EXPORT __main
 EXPORT SystemInit
	
SystemInit

sourceString		RN 7	;Reserved
sortedAlphString	RN 5	;Reserved
marker				RN 6
currChar			RN 3
size				RN 2
char1Index			RN 3
char2Index			RN 4
char1				RN 0
char2				RN 1
;Part 2
numAlpha			RN 2	;Reserved
digitSum			RN 4	;Reserved
;Part 3
characterCount		RN 0
Quotient			RN 6	;Reserved
Dividend			RN 2
n					RN 3
temp				RN 1

__main

init
;;;;;;;;; Part 1: Find and sort all alphabetical characters in source string ;;;;;;;;;;;;;;;
SortChars
	LDR		sourceString, =name 				;sourceString points to initial name
	LDR		sortedAlphString, =0x40000100		;Beginning of string where sorted alpha chars will live
	
	;;;;; First, extract alphabetical characters from source string	;;;;;;;;;;;;;;
	LDR		marker, =0			;marker is current offset in parsing and building the alphabetical string
	LDR		R0, =0				;R0 is current offset in parsing source string

findAlpha
	LDRB currChar, [sourceString,R0] ;Get next char from string
	
	cmp currChar, #0 ;Check if next char is null char before processing
	BEQ sortBegin ;If null, then jump out
	
CheckUpperCase
	cmp currChar, #0x41 		;41h is ASCII 'A'. If less than, jump to doneCheck
	BLT doneCheck
	cmp currChar, #0x5B 		;5Ah is ASCII 'Z'. Checking if less than char after
	BLT alphaFound				;If less than, uppercase alphabetical character is found
								;Otherwise, check if lower case char
CheckLowerCase
	cmp currChar, #0x7A			;7Ah is ASCII 'z'. Checking if greater than
	BGT doneCheck
	cmp currChar, #0x61			;61h is ASCII 'a'. Checking if less than
	BLT doneCheck
	
alphaFound
	STRB currChar, [sortedAlphString, marker]		;Append currChar to string of alphabetical chars
	ADDS marker, marker, #1							;Increment marker
	
doneCheck
	ADDS R0, R0, #1 ;Increment offset for parsing source string
	B findAlpha
	
sortBegin
	MOVS R1, #0	;Adding null char to end of alphabetical string
	STRB R1, [sortedAlphString, marker] 
	;Ensure that at minimum two non-null characters stored in string
	cmp marker, #2 ;marker has current size of string (+ 1 for null byte)
	blt sortDone ;If there are less than two non-null elements, skip over sorting
	MOVS size, marker ;Save size of string
	MOVS marker, #0 ;Place marker on second character in string
	
insertionSort
	ADDS marker, #1  ;Increment marker location
	CMP marker, size ;Check if end of string reached
	BEQ sortDone	 ;Exit the sorting algorithm if end is reached
	MOVS char1Index, marker 			;Set index for char1
	MOVS char2Index, marker 			;Set index for char2	
	SUBS char2Index, #1     			;Decrement index for char2	
	
sortLoop
	LDRB char1, [sortedAlphString, char1Index] ;Load first char from memory
	LDRB char2, [sortedAlphString, char2Index] ;Load second char from memory
	CMP char1, char2						   ;Compare the ASCII values of the characters
	BGE insertionSort						   ;If char1 >= char2, move marker
	
	STRB char1, [sortedAlphString, char2Index] ;Otherwise, char1 < char2. Swap.
	STRB char2, [sortedAlphString, char1Index] 
	
	SUBS char2Index, #1					;Decerement indicies of each index
	BLT insertionSort 					;If char2Index negative, then jump out
	SUBS char1Index, #1
	
	B sortLoop		;Repeat process with newly decremented indices
	
	
sortDone

;;;;;;;;;;; Part 2: Find and sum up all digital characters in source string. 
Part2
	MOVS marker, #0				;reset marker
	MOVS digitSum, #0			;initialize sum to 0
	
LookForDigits
	LDRB currChar, [sourceString,marker] ;Get next char from string
	cmp currChar, #0 ;Check if next char is null char before processing
	BEQ Part2Done ;If null, then jump out	

	cmp currChar, #0x30 		;30h is ASCII '0'. Checking if less than
	BLT notDigit				;If less than, jump to notDigit
	cmp currChar, #0x39 		;39h is ASCII '9'. Checking if greater than
	BGT notDigit				;If greater than, then not a digit. Skip addition logic	

DigitFound
	SUBS currChar, #0x30		;Convert from ASCII to decimal
	ADDS digitSum, currChar
	
notDigit
	ADDS marker, #1	;Increment marker
	B LookForDigits ;Check next digit
	
Part2Done
;;;;;;;;;;;;;; Begin Part 3 ;;;;;;;;;;;;;;;;;;
Part3
;First, find the character count
	MOVS characterCount, #0 ;Initialize character counter. Will serve as marker.
countChars
	LDRB currChar, [sourceString,characterCount] ;Get next char from string
	cmp currChar, #0 ;Check if next char is null char before processing
	BEQ doneCounting ;If null, then jump out
	ADDS characterCount, #1 ;Increment character counter
	B countChars ;Look at next character
	
doneCounting

	cmp characterCount, #0	;Checking if 0 characters; Avoid divide by 0.
	BEQ DivisionDone

	PUSH {R2}	;Save R2 on stack

DivisionStart
	MOVS Quotient, #0
	MOVS n, #31
	LDR Dividend, =7420
	
DivisionOuterLoop
	CMP Dividend, characterCount	;Done if divisor less than dividend
	BLT DivisionDone
	MOVS temp, characterCount		;Save extra copy of divisor into a register
	MOVS n, #1						;Counter initially 1
DivisionInnerLoopBegin
	CMP temp, Dividend				;If temp > Dividend, jump out of inner loop
	BGT DivisionInnerLoopDone
		LSLS temp, temp, #1			;Find largest power of 2 that temp can be multiplied by and fit into n 
		LSLS n, n, #1 				;n represents that power
	B DivisionInnerLoopBegin
DivisionInnerLoopDone
	LSRS n, n, #1			;Shift back right one position so that temp <= Dividend
	LSRS temp, temp, #1		
	ADDS Quotient, Quotient, n		;Add n to quotient
	SUBS Dividend, Dividend, temp	;Subtract temp from dividend
	B DivisionOuterLoop
	
DivisionDone
	LDR R2, =0x40000200	;Store quotient at this memory location
	STR Quotient, [R2]
	POP {R2}	;Retrieve R2
	
done
	B done
	
;;;;;;;; Memory initializations
name	DCB		"Brent Clapp : pj6749uy",0
	ALIGN
	
	
	END