ORG 0

Setup:
	LOADI 	&B1111
	OUT 	ServoSel
	LOADI 	60
	OUT		SpeedSel

Run:

	; forewards wave
	LOADI 	&B0001
	OUT 	ServoSel
	LOADI 	180
	OUT 	AngleSel
	
	LOADI	10
	CALL 	Wait
	
	LOADI 	&B0010
	OUT 	ServoSel
	LOADI 	180
	OUT 	AngleSel
	
	LOADI	10
	CALL 	Wait
	
	LOADI 	&B0100
	OUT 	ServoSel
	LOADI 	180
	OUT 	AngleSel
	
	LOADI	10
	CALL 	Wait
	
	LOADI 	&B1000
	OUT 	ServoSel
	LOADI 	180
	OUT 	AngleSel
	
	; backwards wave
	LOADI	10
	CALL 	Wait
	
	LOADI 	&B0001
	OUT 	ServoSel
	LOADI 	0
	OUT 	AngleSel
	
	LOADI	10
	CALL 	Wait
	
	LOADI 	&B0010
	OUT 	ServoSel
	LOADI 	0
	OUT 	AngleSel
	
	LOADI	10
	CALL 	Wait
	
	LOADI 	&B0100
	OUT 	ServoSel
	LOADI 	0
	OUT 	AngleSel
	
	LOADI	10
	CALL 	Wait
	
	LOADI 	&B1000
	OUT 	ServoSel
	LOADI 	0
	OUT 	AngleSel
	
	JUMP	Run	
	
Reset:
	LOADI 	&B1111
	OUT 	ServoSel
	LOADI 	&HFF
	OUT		SpeedSel
	
	LOADI 	0
	OUT		AngleSel
	
	RETURN
	
Wait:
	STORE	TargetTime
	OUT 	Timer

WaitLoop:
	IN 		Timer
	OUT 	Hex0
	SUB		TargetTime
	JNEG 	WaitLoop
	RETURN

	

TargetTime:	DW 	0
	
; IO address constants
Switches:  	EQU 000
LEDs:      	EQU 001
Timer:     	EQU 002
Hex0:      	EQU 004
Hex1:      	EQU 005

ServoSel:  	EQU &H050
AngleSel:  	EQU &H051
SpeedSel:  	EQU &H052