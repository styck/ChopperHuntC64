;--------------------------------
; SAVE GUN.CODE.2
;--------------------------------
DO_GUN_FALL LDA GUNFGO    ; READY FOR DROP (SET IN IRQ1)
            BEQ NO_INC    ; NO
;--------------------------------
            LDA GUNSHT    ; ARE WE READY TO SHOOT
            BNE GUN_FALL_END ; YES (NO MORE DROP)
;--------------------------------
            LDA #$00   ; TELL IRQ
            STA GUNFAL   ; NOT TO DROP
            INC GUN_Y
            LDA #$02
            STA GUN_TIM
            LDA GUN_Y
            SEC
            SBC #$20 ; BOTTOM OF SMART
            STA PLOTY ; BOMB
            CMP INILVL
            BNE GUN_FALL_END
;--------------------------------
            INC PLOTY
            LDA GUN_X_SC
            STA PLOTX
;--------------------------------
            JSR PLOTCL
            LDY #$00
            LDA PLOTX
            AND #$03
            TAX
            LDA BOMB_MASK,X
            EOR #$FF
            AND (LO),Y  ; BLACK?
            BNE _2  ; NO, OK TO DROP
;--------------------------------
            LDA #$00   ; WASNT DIRT
            STA GUN_Y  ; RESET GUN
            LDA #$00
            STA GUNFGO  ; NO MORE DROP
            STA GUNFAL  ; READY FOR A DROP
            STA GUNACT  ; GUN INACTIVE
            JSR GUN_CHANCE  ; RESET GUN CHANCE
            JMP GUN_FALL_END
;--------------------------------
_2          LDA #$01
            STA GUNSHT ; READY TO SHOOT
            STA GUN_LAND ; WE ARE ON THE GROUND
            LDA #$00
            STA GUN_PHASE
            STA GUNFGO
            LDA #$05
            STA GUN_TIM
            LDA GUN_Y
            SEC
            SBC #$24 ; A LITTLE BIT
            STA GUN_Y_SC ; ABOVE GUN
;--------------------------------
GUN_FALL_END DEC GUN_TIM
NO_INC       RTS
