;--------------------------------
; SAVE GAME.OVER.CODE
;--------------------------------
GAME_OVER  LDA #$00
           STA MASTER_VOLUME
           JSR TURN_SCREEN_OFF
           LDA #$00
           STA IRQ_ENABLE
;--------------------------------
           LDA #<SCORE_ONE
           STA LO
           LDA #>SCORE_ONE
           STA LO+1
           JSR CHECK_HI_SCORE
;--------------------------------
           LDA #<SCORE_TWO
           STA LO
           LDA #>SCORE_TWO
           STA LO+1
           JSR CHECK_HI_SCORE
;--------------------------------
           JSR CLEAR_SPRITES
           JSR SETUP_TEXT
           JSR CLEAR_HIRES
           JSR CLEAR_TEXT
;--------------------------------
           LDA #WHITE
           STA PRINT_COLOR
;--------------------------------
           LDA #$31
           STA PLAYER_MSG+13
           LDA #<PLAYER_MSG
           STA LO
           LDA #>PLAYER_MSG
           STA LO+1
           LDA #03
           STA YPOS
           JSR PRINT_MSG
;--------------------------------
TEST_PLY   LDA PLAYRS
           BEQ _12      ; ONE PLAYER
           JMP _1       ; TWO PLAYERS
_12        LDA NAME_FLAG
           BEQ _22
;--------------------------------
           LDA #<NAME
           STA LO
           LDA #>NAME
           STA LO+1
           LDA #18
           STA YPOS
           JSR PRINT_MSG
           LDA #<NAME2
           STA LO
           LDA #>NAME2
           STA LO+1
           LDA #20
           STA YPOS
           JSR PRINT_MSG
           LDA #<NAME3
           STA LO
           LDA #>NAME3
           STA LO+1
           LDA #22
           STA YPOS
           JSR PRINT_MSG
           JMP _2
;--------------------------------
_22        PRINT_MACRO 0,20,WHITE,"    CHOPPER HUNT    "
           PRINT_MACRO 0,21,YELLOW,"       IMAGIC       "
           PRINT_MACRO 0,22,GREEN,"   COPYRIGHT 1984   "
;--------------------------------
           JMP _2
;--------------------------------
_1         LDA #$32
           STA PLAYER_MSG+13
           LDA #<PLAYER_MSG
           STA LO
           LDA #>PLAYER_MSG
           STA LO+1
           LDA #19
           STA YPOS
           JSR PRINT_MSG
;--------------------------------
_2         LDA #WHITE
           STA PRINT_COLOR
           LDA #<GAME_OVR_MSG
           STA LO
           LDA #>GAME_OVR_MSG
           STA LO+1
           LDA #$0B
           STA YPOS
           JSR PRINT_MSG
;--------------------------------
           LDA #<HI_SCORE_MSG
           STA LO
           LDA #>HI_SCORE_MSG
           STA LO+1
           LDA #$0D
           STA YPOS
           JSR PRINT_MSG
;--------------------------------
; PRINT PLAYER 1 SCORE
;--------------------------------
           LDA #<SCORE_ONE
           STA LO
           LDA #>SCORE_ONE
           STA LO+1
           LDA #05
           STA YPOS
           JSR PRINT_SCORES
;--------------------------------
; PRINT PLAYER 2 SCORE
;--------------------------------
           LDA PLAYRS
           BEQ PR_HI
           LDA #<SCORE_TWO
           STA LO
           LDA #>SCORE_TWO
           STA LO+1
           LDA #21
           STA YPOS
           JSR PRINT_SCORES
;--------------------------------
; PRINT HI-SCORE
;--------------------------------
PR_HI      LDA #<SCORE_HI
           STA LO
           LDA #>SCORE_HI
           STA LO+1
           LDA #$0F
           STA YPOS
;--------------------------------
           JSR PRINT_SCORES
           JSR GAME_OVR_IRQ
           JSR TURN_SCREEN_ON
;--------------------------------
           LDA #$D5
           STA TEMP1
DLY_LUP    JSR DELAY
           JSR DELAY
           JSR DELAY
           DEC TEMP1
           BNE DLY_LUP
;--------------------------------
           JSR TURN_SCREEN_OFF
;--------------------------------
           RTS
;--------------------------------
PRINT_SCORES    LDY #$07
           LDX #$11
_2         LDA (LO),Y
           STA _1
           DEY
;--------------------------------
           BMI _3
;--------------------------------
           TYA
           PHA
           TXA
           PHA
           LDY YPOS
;--------------------------------
           TXA
           CLC
           ADC #$07
           TAX
;--------------------------------
           JSR PRINT
_1         .text "0"
           .byte $FF
           PLA
           TAX
           PLA
           TAY
           DEX
           DEX
           BPL _2
_3         RTS
;--------------------------------
GAME_OVR_IRQ    SEI
                LDA #<GO_IRQ
                STA IRQLO
                LDA #>GO_IRQ
                STA IRQHI
                LDA #$00
                STA RASTER
                LDA #$01
                STA IRQ_ENABLE
                CLI
                RTS
;--------------------------------
GO_IRQ     LDA #LT_GREEN
_1         LDX RASTER
           CPX #$30       ; $37 IS EXACT TOP
           BNE _1
           STA $D021
           LDA #$75
           LDX #<GO_IRQ_2
           LDY #>GO_IRQ_2
           STA RASTER
           STX IRQLO
           STY IRQHI
           LDA #$81
           STA VIC_IRQ
           PLA
           TAY
           PLA
           TAX
           PLA
           RTI
;--------------------------------
GO_IRQ_2   LDA #LT_BLUE
_1         LDX RASTER
           CPX #$80
           BNE _1
;--------------------------------
           STA $D021
;--------------------------------
           LDA #$BA
           LDX #<GO_IRQ_3
           LDY #>GO_IRQ_3
           STA RASTER
           STX IRQLO
           STY IRQHI
           LDA #$81
           STA VIC_IRQ
           PLA
           TAY
           PLA
           TAX
           PLA
           RTI
;--------------------------------
GO_IRQ_3   LDA #RED
_1         LDX RASTER
           CPX #$C0
           BNE _1
           STA $D021
           LDA #$00
           LDX #<GO_IRQ
           LDY #>GO_IRQ
           STA RASTER
           STX IRQLO
           STY IRQHI
           LDA #$81
           STA VIC_IRQ
           PLA
           TAY
           PLA
           TAX
           PLA
           RTI
;--------------------------------
CHECK_HI_SCORE  LDY #$00
_1        LDA SCORE_HI,Y
          CMP #$24
          BEQ _2
          INY
          CPY #$08
          BNE _1
_2        TYA
          STA TEMP1    ; POS OF $ OF HISCORE
;--------------------------------
          LDY #$00
_3        LDA (LO),Y
;3        LDA SCORE_ONE,Y
          CMP #$24
          BEQ _4
          INY
          CPY #$08
          BNE _3
_4        TYA
          STA TEMP2
;--------------------------------
          LDA TEMP1 	; HI $ POS
          CMP TEMP2 	; SCORE $ POS
          BEQ CHECK_NUMBER
          BCC DONE_HI	; (OK)!!
;--------------------------------
;  SCORE WAS HI
;--------------------------------
GOT_HI    LDY #$07
_1        LDA (LO),Y
;1        LDA SCORE_ONE,Y
          STA SCORE_HI,Y
          DEY
          BPL _1
          RTS
;--------------------------------
CHECK_NUMBER    LDA TEMP1
                TAY
                INY
_2              LDA SCORE_HI,Y
                CMP (LO),Y
;               CMP SCORE_ONE,Y
                BEQ _1
                BCS DONE_HI
                BCC GOT_HI
;--------------------------------
_1             INY
               CPY #$08
               BNE _2
;--------------------------------
DONE_HI        RTS
