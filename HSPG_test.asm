ORG 0

ModeCheck:
	IN		Switches
	OUT		LEDs
	JZERO	Wave
	
	ADDI	-1
	JZERO	Sequential
	
	ADDI	-1
	JZERO	Jumpy
	
	JUMP	ModeCheck

Wave:
	LOADI 	&B1111
	OUT 	ServoSel
	LOADI 	60
	OUT		SpeedSel
WaveMove:
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
	
	JUMP	ModeCheck	
	
	
SeqAngle: 	DW	180
Sequential:
	LOADI 	&B1111
	OUT		ServoSel
	LOADI	360
	OUT		SpeedSel
SequentialMove:
	; sequentially move motors
	LOADI	&B0001
	OUT		ServoSel
	LOAD 	SeqAngle
	OUT		AngleSel
	
	LOADI 	5
	CALL	Wait
	
	LOADI	&B0010
	OUT		ServoSel
	LOAD 	SeqAngle
	OUT		AngleSel
	
	LOADI 	5
	CALL	Wait
	
	LOADI	&B0100
	OUT		ServoSel
	LOAD 	SeqAngle
	OUT		AngleSel
	
	LOADI 	5
	CALL	Wait
	
	LOADI	&B1000
	OUT		ServoSel
	LOAD 	SeqAngle
	OUT		AngleSel
	
	LOADI 	5
	CALL	Wait
	
	; if next angle is negative (i.e. just moved motors to zero), reset and go to mode check
	LOAD	SeqAngle
	ADDI	-180
	STORE	SeqAngle
	
	JZERO	SequentialMove
	
	LOADI	180
	STORE	SeqAngle
	JUMP	ModeCheck

JumpyAngle:	DW 	0
Jumpy:
	LOADI	&B1111
	OUT		ServoSel
	LOADI	1023
	OUT		SpeedSel
JumpyMove:
	LOADI	&B0001
	OUT		ServoSel
	LOAD	JumpyAngle
	OUT		AngleSel
	
	LOADI	1
	CALL	Wait
	
	LOADI	&B1000
	OUT		ServoSel
	LOAD	JumpyAngle
	OUT		AngleSel
	
	LOADI	1
	CALL	Wait
	
	LOADI	&B0100
	OUT		ServoSel
	LOAD	JumpyAngle
	OUT		AngleSel
	
	LOADI	1
	CALL	Wait
	
	LOADI	&B0010
	OUT		ServoSel
	LOAD	JumpyAngle
	OUT		AngleSel
	
	LOADI	1
	CALL	Wait
	
	LOAD 	JumpyAngle
	ADDI	10
	STORE	JumpyAngle
	ADDI	-179
	JNEG	JumpyMove
	
	LOADI	0
	STORE	JumpyAngle
	
	JUMP	ModeCheck
	
	
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