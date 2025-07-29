;--------------------------------
; SAVE GUN.CHECK.CODE
;--------------------------------
GUN_CHECK   LDA GUN_LAND       ; IS THE GUN ON THE GROUND?
            BEQ GUN_CHECK_END  ; NO
;--------------------------------
            LDA GUN_Y
            SEC
            SBC #$20
            STA PLOTY
;--------------------------------
            LDA GUN_X   ; CONVERT FROM SPRITE
            SEC         ; COORDINATES TO
            SBC #$13    ; SCREEN COORDINATES
            STA TEMP1
            LDA GUN_XMSB
            SBC #$00
            LSR
            ROR TEMP1
            LDA TEMP1
            STA PLOTX
;--------------------------------
            LDA PLOTY
            CMP INILVL
            BNE GUN_CHECK_END
;--------------------------------
;  WE ARE LANDED CHECK IT
;--------------------------------
            INC PLOTY
;--------------------------------
            JSR PLOTCL
;--------------------------------
            LDY #$00
            LDA PLOTX
            AND #$03
            TAX
            LDA BOMB_MASK,X
            EOR #$FF
            AND (LO),Y          ; IS IT DIRT
            CMP DIRT_COLOR,X
            BEQ GUN_CHECK_END   ; YES, LEAVE IT THERE
;--------------------------------
; THE GROUND BENEATH IS GONE
;--------------------------------
            LDA #$00        ; WASNT DIRT
            STA GUN_Y       ; RESET GUN
            LDA #$00
            STA GUNFAL      ; READY FOR A DROP
            STA GUNACT      ; GUN INACTIVE
            STA GUN_LAND    ; NO LONGER ON GROUND
            JSR GUN_CHANCE  ; RESET GUN CHANCE
;--------------------------------
GUN_CHECK_END RTS
