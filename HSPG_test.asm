ORG 0

Setup:
	LOADI 	&B1111
	OUT 	ServoSel
	LOADI 	&H400
	OUT		SpeedSel

Step:
	CALL 	CheckReset
	
	LOAD 	Angle1
	ADDI 	100
	CALL 	Check
	STORE 	Angle1
	
	LOAD 	Angle2
	ADDI 	20
	CALL 	Check
	STORE 	Angle2
	
	LOAD 	Angle3
	ADDI 	30
	CALL 	Check
	STORE 	Angle3
	
	LOAD 	Angle4
	ADDI 	40
	CALL 	Check
	STORE 	Angle4
	
Send:
	LOADI 	&B0001
	OUT 	ServoSel
	LOAD 	Angle1
	OUT 	AngleSel
	
	LOADI 	&B0010
	OUT 	ServoSel
	LOAD 	Angle2
	OUT 	AngleSel
	
	LOADI 	&B0100
	OUT 	ServoSel
	LOAD 	Angle3
	OUT 	AngleSel
	
	LOADI 	&B1000
	OUT 	ServoSel
	LOAD 	Angle4
	OUT 	AngleSel
	
	CALL 	Wait
	
	JUMP 	Step
	
	
CheckReset:
	LOAD 	Angle1
	CALL 	Check
	JZERO	Reset
	RETURN
Reset:
	LOADI 	0
	STORE 	Angle1
	STORE 	Angle2
	STORE 	Angle3
	STORE 	Angle4
	RETURN
	
Check:
	STORE 	Temp
	ADDI 	-181
	JNEG	CheckGood
	LOADI 	0
	RETURN
CheckGood:
	LOAD 	Temp
	RETURN
	
Wait:
	OUT 	Timer

WaitLoop:
	IN 		Timer
	ADDI 	-10
	JNEG 	WaitLoop
	RETURN

	

Iter:		DW 	0
Angle1:	   	DW  0
Angle2:	   	DW  0
Angle3: 	DW 	0
Angle4:		DW	0
Temp:		DW 	0
	
; IO address constants
Switches:  	EQU 000
LEDs:      	EQU 001
Timer:     	EQU 002
Hex0:      	EQU 004
Hex1:      	EQU 005

ServoSel:  	EQU &H050
AngleSel:  	EQU &H051
SpeedSel:  	EQU &H052