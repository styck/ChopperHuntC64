;--------------------------------
; SAVE GUN.CODE.1
;--------------------------------
DO_GUN  LDA TRANCT    ; ENOUGH TRANSITS?
        BNE GUN_END   ; NO
;--------------------------------
        LDA GUNACT    ; GUN ACTIVE?
        BNE GUN_END   ; NO
;--------------------------------
        LDA GUNSHT
        BNE GUN_END
;--------------------------------
        LDA GUNFAL    ; GUN FALLING?
        BNE GUN_END   ; YES
;--------------------------------
        LDA GUNACT    ; GUN ACTIVE
        BNE GUN_END   ; NO
;--------------------------------
        LDA #$17       ; RESTORE SMART BOMB (CLOSED POSITION)
        STA SPRITE_POINTER+2
;--------------------------------
_1      JSR MAKE_RANDOM
        CMP #$70
        BCS _1
;--------------------------------
        CLC
        ADC #$1B
        STA PLOTX
        LDA INILVL
        STA PLOTY
;--------------------------------
 JSR PLOTCL
;--------------------------------
        LDA PLOTX
        AND #$03
        TAX
        LDY #$00
        LDA BOMB_MASK,X
        EOR #$FF
        AND (LO),Y
        CMP DIRT_COLOR,X
        BNE GUN_END   ; IT WAS NOT DIRT
;--------------------------------
;  FOUND GROUND
;  SET COORDINATES
;--------------------------------
        LDA #$00
        STA TEMP1
        LDA PLOTX
        STA GUN_X_SC
        ASL
        ROL TEMP1
        CLC
        ADC #$13
        STA GUN_X
        LDA TEMP1
        ADC #$00
        STA GUN_XMSB
;--------------------------------
        LDA #00       ; MAKE SURE IT
        STA GUN_Y     ; IS OFF SCREEN
;--------------------------------
        STA GUNFGO
        STA GUNSHT
        STA GUN_TIM
;--------------------------------
        LDA #$01
        STA GUNFAL   ; READY FOR FALL
	STA GUNACT   ;IT IS ACTIVE
;*--------------------------------
GUN_END	 RTS
