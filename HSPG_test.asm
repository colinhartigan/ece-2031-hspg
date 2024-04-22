    ORG     0

ModeCheck:
    IN      Switches
    STORE   SWState
    JZERO   Wave

    ; sw0
    ADDI    -1
    JZERO   Sequential

    ; sw1
    ADDI    -1
    JZERO   Jumpy

    ; sw2
    ADDI    -2
    JZERO   Dance

    JUMP    ModeCheck


;	=========================================================
;	DEMO 1 --------------------------------------------------

Wave:
    LOADI   &B1111
    OUT     ServoSel
    LOADI   60
    OUT     SpeedSel
WaveMove:
    ; forwards wave
    LOADI   &B0001
    OUT     ServoSel
    LOADI   180
    OUT     AngleSel

    LOADI   10
    CALL    Wait

    LOADI   &B0010
    OUT     ServoSel
    LOADI   180
    OUT     AngleSel

    LOADI   10
    CALL    Wait

    LOADI   &B0100
    OUT     ServoSel
    LOADI   180
    OUT     AngleSel

    LOADI   10
    CALL    Wait

    LOADI   &B1000
    OUT     ServoSel
    LOADI   180
    OUT     AngleSel

    ; backwards wave

    LOADI   &B0001
    OUT     ServoSel
    LOADI   0
    OUT     AngleSel

    LOADI   10
    CALL    Wait

    LOADI   &B0010
    OUT     ServoSel
    LOADI   0
    OUT     AngleSel

    LOADI   10
    CALL    Wait

    LOADI   &B0100
    OUT     ServoSel
    LOADI   0
    OUT     AngleSel

    LOADI   10
    CALL    Wait

    LOADI   &B1000
    OUT     ServoSel
    LOADI   0
    OUT     AngleSel

    JUMP    ModeCheck


;	=========================================================
;	DEMO 2 --------------------------------------------------

SeqAngle:   DW  	180
SeqWaitTarget: DW	&B0000 
SeqSpeed:	DW 		360

SeqWait:
	STORE	SeqWaitTarget
SeqWaitLoop:
	IN		ServoStatus
	AND		SeqWaitTarget
	JZERO	SeqWaitDone
	JUMP	SeqWaitLoop
SeqWaitDone:
	RETURN

Sequential:
    LOADI   &B1111
    OUT     ServoSel
    LOADI   360
    OUT     SpeedSel
SequentialMove:
    ; sequentially move motors
    LOADI   &B0001
    OUT     ServoSel
    LOAD    SeqAngle
    OUT     AngleSel

    LOADI   &B0001
    CALL    SeqWait

    LOADI   &B0010
    OUT     ServoSel
    LOAD    SeqAngle
    OUT     AngleSel

    LOADI   &B0010
    CALL    SeqWait

    LOADI   &B0100
    OUT     ServoSel
    LOAD    SeqAngle
    OUT     AngleSel

    LOADI   &B0100
    CALL    SeqWait

    LOADI   &B1000
    OUT     ServoSel
    LOAD    SeqAngle
    OUT     AngleSel

    LOADI   &B1000
    CALL    SeqWait

    ; if next angle is negative (i.e. just moved motors to zero), reset and go to mode check
    LOAD    SeqAngle
    ADDI    -180
    STORE   SeqAngle

    JZERO   SequentialMove

    LOADI   180
    STORE   SeqAngle
    JUMP    ModeCheck


;	=========================================================
;	DEMO 3 --------------------------------------------------

JumpyAngle:    DW      0
Jumpy:
    LOADI   &B1111
    OUT     ServoSel
    LOADI   1023
    OUT     SpeedSel
JumpyMove:

    LOADI   &B0001
    OUT     ServoSel
    LOAD    JumpyAngle
    OUT     AngleSel

    LOADI   1
    CALL    Wait

    LOADI   &B1000
    OUT     ServoSel
    LOAD    JumpyAngle
    OUT     AngleSel

    LOADI   1
    CALL    Wait

    LOADI   &B0100
    OUT     ServoSel
    LOAD    JumpyAngle
    OUT     AngleSel

    LOADI   1
    CALL    Wait

    LOADI   &B0010
    OUT     ServoSel
    LOAD    JumpyAngle
    OUT     AngleSel

    LOADI   1
    CALL    Wait

    LOAD    JumpyAngle
    ADDI    10
    STORE   JumpyAngle
    ADDI    -179
    JNEG    JumpyMove

    LOADI   0
    STORE   JumpyAngle

    JUMP    ModeCheck


;	=========================================================
;	DEMO 4 --------------------------------------------------

GroupA:    DW      &B1100
GroupB:    DW      &B0011
Buf:    DW      &B0000
Dance:
    LOADI   &B1111
    OUT     ServoSel
    LOADI   1023
    OUT     SpeedSel

DanceMove:
    ; \o\;
    LOAD    GroupA
    OUT     ServoSel
    LOADI   135
    OUT     AngleSel

    LOAD    GroupB
    OUT     ServoSel
    LOADI   45
    OUT     AngleSel

    LOADI   6
    CALL    Wait

    ; /o/;
    LOAD    GroupA
    OUT     ServoSel
    LOADI   45
    OUT     AngleSel

    LOAD    GroupB
    OUT     ServoSel
    LOADI   135
    OUT     AngleSel

    LOADI   6
    CALL    Wait

    ; \o\;
    LOAD    GroupA
    OUT     ServoSel
    LOADI   135
    OUT     AngleSel

    LOAD    GroupB
    OUT     ServoSel
    LOADI   45
    OUT     AngleSel

    LOADI   3
    CALL    Wait

    ; _o_;

    LOADI   &B1010
    OUT     ServoSel
    LOADI   0
    OUT     AngleSel

    LOADI   &B0101
    OUT     ServoSel
    LOADI   180
    OUT     AngleSel

    LOADI   3
    CALL    Wait

    ; \o\;
    LOAD    GroupA
    OUT     ServoSel
    LOADI   135
    OUT     AngleSel

    LOAD    GroupB
    OUT     ServoSel
    LOADI   45
    OUT     AngleSel

    LOAD    GroupA
    STORE   Buf
    LOAD    GroupB
    STORE   GroupA
    LOAD    Buf
    STORE   GroupB

    LOADI   9
    CALL    Wait

    JUMP    ModeCheck




Wait:
    STORE   TargetTime
    OUT     Timer
WaitLoop:
    IN      Timer
    SUB     TargetTime
    JNEG    WaitLoop
    RETURN  

CheckSwitches:
    IN      Switches
    AND     SWState




SWState:    DW      0
TargetTime:    DW      0

    ; IO address constants
Switches:    EQU     000
LEDs:    EQU     001
Timer:    EQU     002
Hex0:    EQU     004
Hex1:    EQU     005

ServoSel:    EQU     &H050
AngleSel:    EQU     &H051
SpeedSel:    EQU     &H052
ServoStatus:    EQU     &H05E