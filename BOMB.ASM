;--------------------------------
; SAVE BOMB.CODE
;--------------------------------
DO_BOMBS	LDA CHOP_Y	;IF CHOP ON PAD
			CMP INICHT	;THEN DONT LET
			BNE _1 	;HIM SHOOT
			LDA CHOP_XMSB
			BNE _1
			LDA #$36
			CMP CHOP_X
			BCC _1
			JMP GO2
;--------------------------------
_1			LDA CHOP_EXPL
			BEQ _13
			JMP GO2
_13			LDA STICK_FLAG	;READ TRIGGER
			BNE _55	;AND DEBOUNCE
			LDA STICK_TMP	;IT.
			AND #$10
			BEQ _54
			JMP GO2
;--------------------------------
_54			INC STICK_FLAG
			BNE NEW_BOMB
_55			LDA STICK_TMP
			AND #$10
			BEQ GO2
			DEC STICK_FLAG	;@@
;--------------------------------
			BEQ GO2	;BRANCH ALWAYS
;--------------------------------
NEW_BOMB	LDA BOMBLD
			BEQ GO2		;NO MORE BOMBS
;--------------------------------
			LDX #$01	;FIND AN INACTIVE  ############
BOMTRY		LDA BOMB,X	;BOMB.
			BEQ _1		;FOUND ONE.
			DEX
			BPL BOMTRY	;KEEP LOOKING
;--------------------------------
			JMP GO2		;DIDN'T FIND ONE
_1			INC BOMIND	;INCREMENT ACTIVE BOMBS
			DEC BOMBLD	;DEC NUMBER OF BOMBS
;--------------------------------
			LDA CHOP_X	;SET UP COORDINATES
			SEC		;FOR BOMB DEPENDING
			SBC #$13	;ON WHERE AND WHICH
			STA IRQ_TEMP1	;WAY THE CHOPPER
			LDA CHOP_XMSB	;IS FACING
			SBC #$00
			LSR
			ROR IRQ_TEMP1
			LDA IRQ_TEMP1
			STA BOMBLR,X
;--------------------------------
			LDY BODPH
			LDA BOMDIR,Y
			STA BOMBDR,X
;--------------------------------
			CPY #$02	;IF FACING FRONT
			BNE _11
			LDA STICK_TMP	;IF STICK PUSHED UP
			ROR		;THEN FIRE UP I.E.
			BCS _11		;YDEL=-1
			LDA #$FF
			STA BOMB_YDEL,X
			LDA CHOP_Y
			SEC
			SBC #$35
			STA BOMBHT,X
;--------------------------------
			BNE _22		;ALWAYS
;--------------------------------
_11			LDA CHOP_Y	;SET BOMBS YPOSITON
			SEC
			SBC #$29
;--------------------------------
			STA BOMBHT,X
			LDA BOMB_YINC,Y	;GET YINC DEPENDING ON BODPH
			STA BOMB_YDEL,X
_22			LDA BOMB_CNT_VAL,Y
			STA BOMB_CNT,X
			INC BOMB,X	;@@
			INC BOMACT
;--------------------------------
GO2			LDY #$01	;#######
			STY BOMB_COUNT
CHKSHO		LDA BOMB,Y	;SHOW ALL BOMBS
			BNE SHOBOM	;BOMB IS ACTIVE
CHKSH2		DEY
			BPL CHKSHO
;--------------------------------
			JMP GO4
;--------------------------------
SHOBOM		STY BOMB_COUNT	;NUMBER OF THE BOMB (0-3)
			LDA BOMB_CNT,Y
			BEQ _11
			TYA
			TAX
			DEC BOMB_CNT,X
			JMP GO3
;--------------------------------
_11			LDA BOMBHT,Y	;ADD ONE TO THE Y DIRECTION
			CLC
			ADC BOMB_YDEL,Y
			STA BOMBHT,Y
;--------------------------------
GO3			LDA BOMBLR,Y	;ADD IN BOMB DIRECTION
			CLC		;-1 OR +1
			ADC BOMBDR,Y
			STA BOMBLR,Y
			STA IRQ_PLOTX	;GET SCREEN COORDINATES
			LDA BOMBHT,Y	;FOR BOMB
			STA IRQ_PLOTY
			JSR IRQ_PLOTCL
			LDY BOMB_COUNT	;SEE IF THERE WAS AND OLD BOMB
			LDA ERASE_FLAG,Y	;BOMB #Y
			BEQ _1 		;NO
;--------------------------------
;  GET READY TO ERASE OLD BOMB
;--------------------------------
			LDA BOMB_COUNT	;# OF BOMB
			ASL		;*2
			TAY
			LDA TABLE_LO,Y	;SAVE ADDRESS OF BOMB
			STA OLD_LO
			LDA TABLE_LO+1,Y
			STA OLD_LO+1
			LDY BOMB_COUNT
			LDA INDEX_MASK,Y
			TAX
			LDA BOMB_MASK,X	;EXTRACT BITS FROM OLD
			EOR #$FF	;BYTE THAT WAS UNDER
			AND OLD_BOMB,Y	;THE BOMB
			STA IRQ_TEMP1
			CMP BOMB_SHAPE,X	;IS IT WHITE
			BNE _16		;NO
			LDA IRQ_TEMP1
			EOR BOMB_SHAPE,X
			STA IRQ_TEMP1
;--------------------------------
_16			LDY #$00
			LDA (OLD_LO),Y
			AND BOMB_MASK,X	;REMOVE OLD BOMB
			ORA IRQ_TEMP1	;PUT BACKROUND BITS
			STA IRQ_TEMP1
;--------------------------------
			LDA INILVL
			CMP IRQ_PLOTY	;ABOVE GROUND
			BCS _33		;YES
;--------------------------------
			LDA #$00	;BELOW GROUND
			STA IRQ_TEMP1	;ERASE WITH BLACK
			LDA (OLD_LO),Y
			AND BOMB_MASK,X
			ORA IRQ_TEMP1
			STA IRQ_TEMP1
			JMP _34
;--------------------------------
_33			LDA MOUNTAIN_TOP
			CMP IRQ_PLOTY	;ABOVE MOUNTAINS?
			BCC _34		;NO
;--------------------------------
;  ERASE BOMB
;--------------------------------
			LDA #$55	;ERASE WITH BLUE IF ABOVE GROUND AND MOUNTAINS
			STA IRQ_TEMP1
;--------------------------------
_34			LDA IRQ_TEMP1	;ERASE BOMB
			STA (OLD_LO),Y
;--------------------------------
			LDA IRQ_PLOTX	;CHECK IF BOMB
			BEQ _11		;WENT OFF SCREEN
			LDA IRQ_PLOTY
			BEQ _11
			LDA IRQ_PLOTX
			CMP #160
			BCS _11
			LDA IRQ_PLOTY
			CMP #$B0
			BCC _1
;--------------------------------
_11			LDA #$00
			LDY BOMB_COUNT
			STA BOMB,Y	;BOMB CAN NOW BE USED
			STA ERASE_FLAG,Y	;IT DOESN'T NEED ERASED
			JMP GO4
;--------------------------------
; PLOT THE BOMB
;--------------------------------
_1			LDA IRQ_PLOTY
			CMP INILVL	;ABOVE GROUND?
			BCS _22		;NO
;--------------------------------
			LDA MOUNTAIN_TOP
			CMP IRQ_PLOTY
			BCC _2 		;NO
;--------------------------------
; BELOW GROUND CHECK
;--------------------------------
_22			LDY #$00
			LDA IRQ_PLOTX	;CHECK TO SEE
			AND #$03	;IF WE HIT
			TAX		;DIRT
			LDA BOMB_MASK,X
			EOR #$FF	;INVERT MASK
			STA IRQ_TEMP1
			AND (IRQ_LO),Y
			CMP IRQ_TEMP1	;SHOULD BE SAME SINCE DIRT IS $FF
			BNE _2 		;DID NOT HIT DIRT
			JMP EXPL	;MUST BE DIRT
;--------------------------------
_2			LDA IRQ_PLOTY
			CMP INILVL	;ABOVE GROUND ?
			BCC _27		;YES
;--------------------------------
			LDA BOMB_MASK,X
			EOR #$FF
			STA IRQ_TEMP1
			AND (IRQ_LO),Y
			CMP WATER_COLOR,X
			BNE _27		;DID NOT HIT WATER
;--------------------------------
			INC SPLASH_SOUND	;@@
			JMP _11		;IT HIT WATER, DISABLE BOMB
;--------------------------------
_27			LDY BOMB_COUNT	;SAVE BOMBS POSITION
			LDA IRQ_PLOTX	;IN BYTE
			AND #$03
			STA INDEX_MASK,Y
			TAX
			LDY #$00
			LDA (IRQ_LO),Y
			LDY BOMB_COUNT	;!!
			STA OLD_BOMB,Y	;!!
			LDY #$00	;!!
			AND BOMB_MASK,X
			ORA BOMB_SHAPE,X
			STA (IRQ_LO),Y	;PLOT BOMB
			LDY BOMB_COUNT
			TYA
			ASL
			TAY
			LDA IRQ_LO	;KEEP TRACK OF THE
			STA TABLE_LO,Y	;ADDRESS OF THE LAST
			LDA IRQ_LO+1	;BOMB SO WE CAN ERASE
			STA TABLE_LO+1,Y	;IT ON THE NEXT PASS
			LDY BOMB_COUNT
			LDX #$01
			STX ERASE_FLAG,Y
;--------------------------------
			LDA #$00
			STA HIT3
			JSR DIRT_BOMB
			LDA HIT3
			BNE EXPL
;--------------------------------
			JMP CHKSH2
;--------------------------------
EXPL		LDY BOMB_COUNT
			LDA #$00	;WE CAN NOW USE
			STA BOMB,Y	;THIS BOMB
			STA ERASE_FLAG,Y
			DEC BOMACT	;1 LESS ACTIVE
			LDA BOMBHT,Y	;PUT BOMB COORDINATES
;--------------------------------
			SEC
			SBC #$01
;--------------------------------
			STA EXPHT,Y	;INTO EXPLOSION'S
			LDA BOMBLR,Y
			STA EXPLR,Y
			LDA #$01	;START THE EXPLOSION
			STA EXPGO,Y
;--------------------------------
GO4			DEC BOMB_SPEED
			BEQ _11
			JMP GO2
;--------------------------------
_11			RTS
