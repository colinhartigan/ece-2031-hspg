ORG 0

Run:
	IN 		Switches
	SUB		State
	JZERO	Skip
	
	IN 		Switches
	STORE	State
	OUT 	LEDs
	OUT 	HSPG
	
Skip:
	JUMP 	Run
	
; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005
HSPG:      EQU &H50
State:	   DW  0