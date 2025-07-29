;--------------------------------
; SAVE SOUND.CODE2
;--------------------------------
DO_SOUNDS	LDA #$0A
		STA MASTER_VOLUME
		LDA EXPL_FREQ
		BEQ _11
;--------------------------------
		LDA #$02
		STA FREQ_2+1
;-------------------------------
		LDA EXPL_FREQ
		SEC
		SBC #$0F
		STA EXPL_FREQ
		STA FREQ_2
;--------------------------------
		LDA #$81
		STA $D40B
;--------------------------------
; DO SHOT SOUND
;--------------------------------
_11		LDA SHOT_SOUND
		BEQ _13
;--------------------------------
		LDA #$03
		STA FREQ_3+1
;--------------------------------
		LDA #$15
		STA ATTDEC_3
		LDA #$6A
		STA SUSREL_3
;--------------------------------
		LDA SHOT_SOUND
		SEC
		SBC #$0F
		BNE _12
		LDA #$00
		STA $D412
		STA FREQ_3+1
;--------------------------------
_12		STA SHOT_SOUND
		STA FREQ_3
		BEQ _13
		LDA #$81
		STA $D412
; 	        JMP _1
;--------------------------------
_13		LDA EXPL_FREQ
		BNE _1
		LDA #$00
		STA $D40B
;--------------------------------
;  DO LANDING SOUND
;--------------------------------
_1		LDA LAND_SOUND	  ;DO WE NEED LAND SOUND
		BEQ no_landSound  ;NO
;--------------------------------
		LDA #$00
		STA LAND_SOUND
		STA FREQ_2
		LDA #$55
		STA FREQ_2+1
		LDA #$11
		STA $D40B
		JSR DELAY
		JSR DELAY
		LDA #$10
		STA $D40B
;-------------------------------
no_landSound	LDA BUC_SOUND
		BEQ _3
;-------------------------------
		LDA #$00
		STA BUC_SOUND
		STA FREQ_2
		LDA #$33
		STA FREQ_2+1
		LDA #$11
		STA $D40B
		JSR DELAY
		JSR DELAY
		LDA #$10
		STA $D40B
;--------------------------------
;  DO SPLASH SOUND
;--------------------------------
_3		LDA SPLASH_SOUND
		BEQ _4
;--------------------------------
		LDA #$00
		STA SPLASH_SOUND
		STA FREQ_2
		LDA #$FF
		STA FREQ_2+1
		LDA #$81
		STA $D40B
		JSR DELAY
		JSR DELAY
		LDA #$80
		STA $D40B
;--------------------------------
; DO PLANE SOUND
;--------------------------------
_4		LDA PLANE_SOUND
		BEQ _99
		JMP _99
;--------------------------------
		LDA #$00
		STA FREQ_3
		LDA PLANE_X
		SEC
		SBC #$13
		STA TEMP1
		LDA PLANE_XMSB
		SBC #$00
		LSR
		ROR TEMP1
		LDA TEMP1
		STA FREQ_3+1
		LDA #$81
		STA $D412
;--------------------------------
_99		LDA #$00
;--------------------------------
SOUND_END	RTS
;--------------------------------
DO_PAD		LDY #$14
_4		LDA PAD_DATA,Y
		STA (PADLO),Y
		DEY
		BNE _4
		LDY #$01
_44		LDA PAD_COLOR,Y
		STA (PADC_LO),Y
		DEY
		BPL _44
		RTS
