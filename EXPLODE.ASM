;--------------------------------
;  SAVE EXPLOSION.CODE
;--------------------------------
;  HANDLE DIGGING EXPLOSIONS
;--------------------------------
DO_EXPLOSIONS LDY #$04
_1	      LDA EXPGO,Y
	      BNE EXPNEW
	      DEY
	      BPL _1
	      JMP MAIN2
;--------------------------------
EXPNEW	 LDA EXPCNT
	 CMP #20
	 BPL MAIN2
;--------------------------------
	 INC EXPCNT
	 LDX EXPCNT
	 LDA EXPLR,Y
	 STA XPOS,X
	 LDA EXPHT,Y
	 STA YPOS,X
	 LDA #$00
	 STA CNT,X
	 STA EXPGO,Y
	 LDA #$01
	 STA EXPL_SOUND
	 LDA #$FF
	 STA EXPL_FREQ
;--------------------------------
MAIN2	 LDA #$00
	 STA COUNTR
RUNLP	 INC COUNTR
	 LDA EXPCNT
	 CMP COUNTR
	 BPL INDEX
;--------------------------------
	 RTS
;--------------------------------
INDEX	 LDX COUNTR
	 LDA #$00
	 STA PLTCLR
	 LDA CNT,X
	 CMP #37
	 BMI DOPLOT
;--------------------------------
	 INC PLTCLR
	 SEC
	 SBC #37
	 CMP #37
	 BMI DOPLOT
	 TXA
	 TAY
;--------------------------------
REPACK	 INX	      ;MOVE EXPLOSIONS
	 CPX EXPCNT   ;BACK TO TAKE PLACE
	 BEQ RPK2     ;OF THE ONE THAT
	 BPL RPKEND   ;JUST FINISHED
RPK2	 LDA XPOS,X
	 STA XPOS,Y
	 LDA YPOS,X
	 STA YPOS,Y
	 LDA CNT,X
	 STA CNT,Y
	 INY
	 BNE REPACK
;--------------------------------
RPKEND	 DEC EXPCNT  ;ONE LESS EXPLOSION
	 DEC COUNTR
	 LDA #$00
	 STA EXPL_SOUND
	 JMP RUNLP
;--------------------------------
DOPLOT	 INC CNT,X
	 TAY
;--------------------------------
	 LDA XPOS,X
	 CLC
	 ADC COORD1,Y
	 STA PLOTX
	 CMP #160
	 BCS RUNLP
;--------------------------------
	 LDA YPOS,X
	 CLC
	 ADC COORD2,Y
	 STA PLOTY
	 CMP #$B0
	 BCS RUNLP
;--------------------------------
	 JSR PLOTCL
;--------------------------------
	 LDA PLTCLR   ;ERASING?
	 BNE CLEARIT  ;YES
;--------------------------------
	 LDY #$00     ;PLOT EXPLOSION
	 LDA PLOTX
	 AND #$03
	 TAX
;--------------------------------
; CHECK IF HITTING DIRT ONLY
; IF BELOW GROUND LEVEL
;--------------------------------
	 LDA PLOTY
	 CMP INILVL
	 BCC _14      ;YES
;--------------------------------
	 LDA BOMB_MASK,X
	 EOR #$FF
	 AND (LO),Y
	 CMP DIRT_COLOR,X    ;IF EXPLODING DIRT
	 BNE _11	     ;THEN KEEP TRACK OF
	 INC DRTHIT	     ;EACH PIXEL HIT
;--------------------------------
; IF HITTING DIRT THEN STORE
;--------------------------------
_11	 CMP WATER_COLOR,X
	 BNE _13
	 JMP RUNLP
_13	 LDA (LO),Y
	 AND BOMB_MASK,X
	 ORA BOMB_SHAPE,X
	 STA (LO),Y
	 JMP RUNLP
;--------------------------------
;   EOR IT ON SCREEN
;--------------------------------
_14	 LDA PLOTY
	 CMP MOUNTAIN_TOP
	 BCS _2      ;NOT ABOVE MOUNTAINS
;--------------------------------
	 LDA (LO),Y	   ;ABOVE MOUNTAINS
	 AND BOMB_MASK,X   ;STORE WHITE
	 ORA BOMB_SHAPE,X
	 STA (LO),Y
	 JMP RUNLP
;--------------------------------
_2	 LDA (LO),Y	   ;STORE BOMB ONTO
	 AND BOMB_MASK,X   ;MOUNTAINS
	 ORA BOMB_SHAPE,X
	 STA (LO),Y
	 JMP RUNLP
;--------------------------------
CLEARIT	 LDY #$00
	 LDA PLOTX
	 AND #$03
	 TAX
;--------------------------------
	 LDA PLOTY
	 CMP INILVL
	 BCC _1       ;ABOVE GROUND
;--------------------------------
;  DONT ERASE WATER
;--------------------------------
	 LDA BOMB_MASK,X
	 EOR #$FF
	 AND (LO),Y
	 CMP WATER_COLOR,X
	 BNE _14
;--------------------------------
	 LDA PLOTX
	 STA SCAN_X
	 LDA INILVL
	 CLC
	 ADC #$01
	 STA SCAN_Y
	 LDA #$00
	 STA WPHASE
;--------------------------------
	 JMP RUNLP
;--------------------------------
_14	 LDA (LO),Y	    ;ELSE ERASE WITH
	 AND BOMB_MASK,X    ;BLACK
	 STA (LO),Y
;--------------------------------
	 LDA INILVL	;KEEP BLACK
	 SEC
	 SBC #$01
	 STA PLOTY	;LINE AT BASE
	 JSR PLOTCL	;OF MOUNTAINS
	 LDA (LO),Y
	 AND BOMB_MASK,X
	 STA (LO),Y
;--------------------------------
	 JMP RUNLP
;--------------------------------
;  RESTORE ABOVE GROUND
;--------------------------------
_1	 LDA PLOTY
	 CMP MOUNTAIN_TOP
	 BCS _2      ;NOT ABOVE MOUNTAIN
;--------------------------------
;  RESTORE SKY
;--------------------------------
	 LDA (LO),Y
	 AND BOMB_MASK,X
	 ORA WATER_COLOR,X  ;RESTORE SKY
	 STA (LO),Y
	 JMP RUNLP
;--------------------------------
;  RESTORE MOUNTAINS
;--------------------------------
_2	 JSR SETUP_ADDR    ;RESTORE MOUNTAIN DATA
	 LDY #$00
	 LDA (LO),Y
	 AND BOMB_MASK,X
	 ORA (JLO),Y
	 STA (LO),Y
;--------------------------------
	 LDA INILVL	   ;ERASE LINE AT
	 SEC
	 SBC #$01
	 STA PLOTY	   ;BASE OF MOUNTAINS
	 JSR PLOTCL
	 LDA (LO),Y
	 AND BOMB_MASK,X
	 STA (LO),Y
;--------------------------------
	 JMP RUNLP
;--------------------------------
NMI	 PHA
	 TXA
	 PHA
	 TYA
	 PHA
;--------------------------------
	 INC ABORT_FLAG
;--------------------------------
	 PLA
	 TAY
	 PLA
	 TAX
	 PLA
	 RTI
;--------------------------------
