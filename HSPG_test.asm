ORG 0

Step:
	LOAD Angle
	ADDI 5
	STORE Angle
	ADDI -180
	JNEG Skip
	LOADI 0
	STORE Angle
	
Skip:
	LOAD Angle
	OUT HSPG
	OUT Timer
	
Wait:
	IN Timer
	ADDI -5
	JNEG Wait
    JUMP Step
	
	
; Constants
ORG 25
Angle:	   DW  0
	
; IO address constants
Switches:  EQU 000
LEDs:      EQU 001
Timer:     EQU 002
Hex0:      EQU 004
Hex1:      EQU 005

HSPG:      EQU &H50

