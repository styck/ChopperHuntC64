;--------------------------------
; SAVE GUN.CHANCE.CODE
;--------------------------------
GUN_CHANCE JSR MAKE_RANDOM
           AND #$03
           CLC
           ADC GUNCHN
           STA TRANCT
           RTS
