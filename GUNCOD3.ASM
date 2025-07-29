;--------------------------------
;  SAVE GUN.CODE.3
;--------------------------------
GUN_SHOOT	LDA GUNSHT
		BEQ SHOOT_END
		LDY GUN_PHASE
		CPY #$04
		BEQ NOGDED	;FIRE SHOT
		LDA GUN_TIM
		BNE _1
		LDA #$05	;RESET ANIMATION
		STA GUN_TIM	;TIMER
		INC GUN_PHASE
		LDY GUN_PHASE
		LDA GUN_SHAPE,Y
		STA SPRITE_POINTER+2
;--------------------------------
_1		DEC GUN_TIM
SHOOT_END	RTS
;--------------------------------
NOGDED		LDA GUNSHT
		BEQ NO_SHOT
		LDA SHOTON
		BNE NO_SHOT
		LDA GUN_LAND	;NOT ON GROUND
		BEQ NO_SHOT
;--------------------------------
		LDA CHOP_Y
		SEC
		SBC #$2F		;MIDDLE OF CHOPPER
		STA TGTY
		CMP INILVL		;BELOW GROUND?
		BCS NO_SHOT		;YES
;--------------------------------
		LDA #$00
		STA PYINCL
		STA PXINCL
		STA PXHOLD
		STA PYHOLD
		STA PRSCNT
;--------------------------------
		LDA CHOP_X
		SEC
		SBC #$13
		STA TEMP1
		LDA CHOP_XMSB
		SBC #$00
		LSR
		ROR TEMP1
		LDA TEMP1
;--------------------------------
		STA TGTX
		CMP GUN_X_SC
		BCS SHOOT_RIGHT
		BCC SHOOT_LEFT
;--------------------------------
NO_SHOT		JMP CHECK_SHOT
;--------------------------------
SHOOT_LEFT	LDA #$00
		STA SHOTDR
		LDA GUN_X_SC
		SEC
		SBC TGTX
		JMP SPXINC
;--------------------------------
SHOOT_RIGHT	LDA #$01
		STA SHOTDR
		LDA TGTX
		SEC
		SBC GUN_X_SC
;--------------------------------
SPXINC		STA PXINCH
		LDA GUN_Y_SC
		SEC
		SBC TGTY
		STA PYINCH
;--------------------------------
VECTOR		LDA PXINCH
		CMP #$02
		BCS VEC2
;--------------------------------
		LDA PYINCH
		CMP #$02
		BCC VECEND
;--------------------------------
VEC2		LSR PXINCH
		ROR PXINCL
		LSR PYINCH
		ROR PYINCL
		JMP VECTOR
;--------------------------------
VECEND		LDA GUN_Y_SC
		SEC
		SBC #$04
		STA SHOTY
		LDA GUN_X_SC
		STA SHOTX
		LDA #$01	;SHOT ON!!
		STA SHOTON
		LDA #$FF
		STA SHOT_SOUND
;--------------------------------
CHECK_SHOT	LDA SHOTON
		BNE _1
;--------------------------------
		RTS
;--------------------------------
_1		JSR SHOT_ERASE
;--------------------------------
		LDA PXHOLD
		CLC
		ADC PXINCL
		STA PXHOLD
		LDA #$00
		ADC PXINCH
		STA DELTAX
;--------------------------------
		LDA PYHOLD
		CLC
		ADC PYINCL
		STA PYHOLD
		LDA #$00
		ADC PYINCH
		STA DELTAY
;--------------------------------
		LDA SHOTDR
		BNE ADJSP
;--------------------------------
		LDA SHOTX
		SEC
		SBC DELTAX
		JMP STOSX
;--------------------------------
ADJSP		LDA SHOTX
		CLC
		ADC DELTAX
STOSX		BEQ KILSHT
		CMP #160
		BCS KILSHT
;--------------------------------
		STA SHOTX
		LDA SHOTY
		SEC
		SBC DELTAY
		BMI KILSHT
		STA SHOTY
		LDX #$00
;--------------------------------
SHTPLP		STX SXHLDA
		JSR MAKE_RANDOM
		ROR
		CMP #$A0
		BCS NXTSBK
;--------------------------------
		LDA SHOTX
		CLC
		ADC WPXADD,X
		STA PLOTX
		CMP #$A0		;DONT LET IT OFF SCREEN
		BCS NXTSBK
;--------------------------------
		LDA SHOTY
		CLC
		ADC WPYADD,X
		STA PLOTY
;--------------------------------
		JSR PLOTCL
;--------------------------------
		LDA BOMB_MASK,X
		AND (LO),Y
		ORA BOMB_SHAPE,X
		STA (LO),Y
;--------------------------------
NXTSBK		LDX SXHLDA
		INX
		CPX #12
		BMI SHTPLP
;--------------------------------
		JSR CHECK_CHOP
SHOTND		RTS
;--------------------------------
; EXPLODE FALLING DIRT
;--------------------------------
SHTEXP		LDA #$01
		STA EXPGO+4
		LDA SHOTX
		STA EXPLR+4
		LDA SHOTY
		STA EXPHT+4
;--------------------------------
KILSHT		JSR SHTCLR
;--------------------------------
		LDA #$00
		STA GUN_PHASE
		STA SHOT_SOUND
		STA $D412		;VOICE 3 CONTROL
		LDA GUN_LAND
		BNE _1			;ON THE GROUND (KEEP SHOOTING)
		STA GUNSHT
_1		RTS
;--------------------------------
SHTCLR		JSR SHOT_ERASE
		LDA #$00
		STA SHOTON
		RTS
;--------------------------------
SHOT_ERASE	LDX #$00
_1		STX SXHLDA
		LDA SHOTX
		CLC
		ADC WPXADD,X
		STA PLOTX
		LDA SHOTY
		CLC
		ADC WPYADD,X
		STA PLOTY
		JSR PLOTCL
;--------------------------------
		LDA PLOTX
		AND #$03
		TAX
;--------------------------------
		LDA INILVL
		SEC
		SBC #$18
		STA TEMP1
		LDA PLOTY
		CMP TEMP1
		BCC _3
;--------------------------------
; RESTORE MOUNTAINS
;--------------------------------
		JSR SETUP_ADDR
		LDY #$00
		LDA (LO),Y
		AND BOMB_MASK,X
		ORA (JLO),Y
		STA (LO),Y
		JMP _2
;--------------------------------
; RESTORE SKY
;--------------------------------
_3		LDY #$00
		LDA BOMB_MASK,X
		AND (LO),Y
		ORA WATER_COLOR,X
		STA (LO),Y
;--------------------------------
_2		LDX SXHLDA
		INX
		CPX #12
		BMI _1
		RTS
;--------------------------------
; SOFTWARE COLLISTION FOR CHOPPER
;--------------------------------
CHECK_CHOP	LDA HIT0
		BEQ _9
;--------------------------------
		RTS
;--------------------------------
_9		LDA #$07
		STA TEMP2
		LDA CHOP_Y
		SEC
		SBC #$2C
		STA PLOTY
;--------------------------------
		LDA CHOP_X
		SEC
		SBC #$16
		STA TEMP1
		LDA CHOP_XMSB
		SBC #$00
		LSR
		ROR TEMP1
		LDA TEMP1
		STA PLOTX
;--------------------------------
_3		LDA #$04
		STA TEMP3
;--------------------------------
_2		JSR PLOTCL
;--------------------------------
		LDY #$00
		LDA BOMB_MASK,X
		EOR #$FF
		AND (LO),Y
		CMP BOMB_SHAPE,X
		BNE _1
;--------------------------------
_11		LDA #$01
		STA HIT0
		JMP KILSHT		;********
;--------------------------------
_1		INC PLOTX
		DEC TEMP3
		BNE _2
;--------------------------------
		LDA PLOTX
		SEC
		SBC #$04
		STA PLOTX
		DEC PLOTY
		DEC TEMP2
		BPL _3
		RTS
