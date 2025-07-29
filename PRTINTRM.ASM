;--------------------------------
; SAVE PRINT.INTRM
;--------------------------------
PRINT_MSG	LDY #$13
			LDX #$26
_2			LDA (LO),Y
			STA _1
			DEY
			TYA
			PHA
			TXA
			PHA
			LDY YPOS
			JSR PRINT
_1			.byte '0', $FF
			PLA
			TAX
			PLA
			TAY
			DEX
			DEX
			BPL _2
			RTS
;--------------------------------
INTRM_SOUND	JSR INIT_SOUND
		LDA #$00
		STA CONTROL_1	;TURN BLADE SOUND OFF
		STA CONTROL_2
;--------------------------------
		LDA #$13
		STA ATTDEC_1
		STA ATTDEC_2
		LDA #$DA
		STA SUSREL_1
		STA SUSREL_2
;--------------------------------
		LDA #$C8
		STA FREQ_1
		LDA #$0F
		STA FREQ_1+1
;--------------------------------
		LDA #$F8
		STA FREQ_2
		LDA #$07
		STA FREQ_2+1
;--------------------------------
		LDA #$00	;SET PULSE WIDTHS
		STA FREQ_1+2
		STA FREQ_2+2
		LDA #$08
		STA FREQ_1+3
		LDA #$04
		STA FREQ_2+3
;--------------------------------
		LDA #$03
		STA MASTER_VOLUME
		LDA #$41
		STA CONTROL_1
		STA CONTROL_2
		RTS
;--------------------------------
;  SETUP ABORT SOUND
;--------------------------------
ABORT_SOUND	LDA #$00
		STA CONTROL_2
		STA CONTROL_3
		STA FREQ_2+2
		STA FREQ_3+2
;-------------------------------
		LDA #$13
		STA ATTDEC_2
		STA ATTDEC_3
;--------------------------------
		LDA #$DA
		STA SUSREL_2
		STA SUSREL_3
;--------------------------------
		LDA #$03
		STA FREQ_2+3
		LDA #$08
		STA FREQ_3+3
;--------------------------------
		STA MASTER_VOLUME
		LDA #$41
		STA CONTROL_2
		STA CONTROL_3
		RTS
