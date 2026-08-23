;;*--------------------------------
;;* SAVE CHOP EQUATES
;*--------------------------------
;		 * = $0800
;*--------------------------------
;* PROGRAM EQUATES
;*--------------------------------
;* PROGRAMMING EQUATES
;*--------------------------------
;* CHARACTER SET $5800-$6000
;* SCREEN MEMORY $4000-$4400
;* SPRITE MEMORY $4400-$5800
;* HIRES	      $6000-$8000
;* PROGRAM SPACE $0800-$3FFF
;* COLOR MEMORY  $D800-$DC00
;* VARIABLES     $0400-$0800
;*--------------------------------
;* PROGRAM EQUATES
;*--------------------------------
HIRES		  = $6000
CHARACTER_MEMORY	  = $5800
SCREEN_MEMORY	  = $4000
SPRITE_POINTER	  = SCREEN_MEMORY+$3F8
SPRITE_MEMORY	  = $4400
COLOR_MEMORY	  = $D800
;*--------------------------------
;* VIDEO HARDWARE EQUATES
;*--------------------------------
BORDER_COLOR	  = $D020
BACKGROUND_COLOR0   = $D021
BACKGROUND_COLOR1   = $D022
BACKGROUND_COLOR2   = $D023
SPRITE_XPOS	  = $D000   ;PLUS 2*SPRITE NUMBER!
SPRITE_YPOS	  = $D001   ;PLUS 2*SPRITE NUMBER!
SPRITE_XMSB	  = $D010   ;HIGH BIT OF XPOSITION
VIC_CONTROL_1	  = $D011   ;VIC CONTROL REGISTER
RASTER		  = $D012   ;RASTER REGISTER
SPRITE_ENABLE	  = $D015   ;SPRITE ENABLE REGISTER
VIC_CONTROL_2	  = $D016   ;SCROLL AND MULTI-COLOR
SPRITE_YXPAND	  = $D017   ;YXPANSION OF SPRITES
VIC_MEMORY	  = $D018   ;MEMORY BANK CONTROL
VIC_IRQ		  = $D019   ;INTERRUPT FLAGS
IRQ_ENABLE	  = $D01A   ;ENABLES INTERRUPTS
SPRITE_PRIORITY	  = $D01B   ;SPRITE TO BACKGROUND
SPRITE_MULTI_COLOR  = $D01C   ;SPRITE MULTI COLOR
SPRITE_XXPAND	  = $D01D   ;XXPANSION OF SPRITES
SPRITE_SCOLIDE	  = $D01E   ;SPRITE TO SPRITE COLLISION
SPRITE_BCOLIDE	  = $D01F   ;SPRITE TO BACKGROUND COLLISION
SPRITE_MCOLOR_0	  = $D025   ;COLOR REGISTER
SPRITE_MCOLOR_1	  = $D026   ;COLOR REGISTER
SPRITE_COLOR	  = $D027   ;MAIN SPRITE COLOR +SPRITE NUMBER
;*--------------------------------
;* CIA HARDWARE EQUATES
;*--------------------------------
PORTA1		  = $DC00
PORTB1		  = $DC01
DDRA1		  = $DC02
DDRB1		  = $DC03
PORTA2		  = $DD00
PORTB2		  = $DD01
DDRA2		  = $DD02
DDRB2		  = $DD03
CIA_1_IRQ 	  = $DC0D   ;CIA1 IRQ ENABLE
CIA_2_IRQ 	  = $DD0D   ;CIA2 IRQ ENABLE
CIA1_CTRL_A	  = $DC0E   ;CIA1 CONTROL REG A
CIA1_CTRL_B	  = $DC0F   ;CIA1 CONTROL REG B
CIA2_CTRL_A	  = $DD0E   ;CIA2 CONTROL REG A
CIA2_CTRL_B	  = $DD0F   ;CIA2 CONTROL REG B
;*--------------------------------
;* AUDIO HARDWARE EQUATES
;*--------------------------------
FREQ_1	      = $D400
FREQ_2	      = $D407
FREQ_3	      = $D40E
CONTROL_1     = $D404
CONTROL_2     = $D40B
CONTROL_3     = $D412
ATTDEC_1      = $D405
ATTDEC_2      = $D40C
ATTDEC_3      = $D413
SUSREL_1      = $D406
SUSREL_2      = $D40D
SUSREL_3      = $D414
MASTER_VOLUME = $D418
;*--------------------------------
COORD1 .byte 0,0,1,0,255,255,255,1,1,0,0,254
       .byte 2,255,2,254,1,255,254,1,2,253,1,255
       .byte 3,3,0,255,253,2,254,2,254,253,1,3,0

COORD2 .byte 0,255,0,1,0,255,1,255,1,2,254,0
       .byte 0,2,1,1,254,254,255,2,255,1,253,253
       .byte 255,1,3,3,255,2,2,254,254,0,3,0,253

;*--------------------------------
PAD_DATA .byte $55,$55,$AA,$F0,$0F,$F0,$0F,$0
         .byte $0F,$AA,$AA,$F0,$0F,$F0,$0F,$0
         .byte $0F,$AA,$AA,$FF,$FF,$FF,$FF,$FF

;*--------------------------------
PAD_COLOR .byte $07,$07		 ; YELLOW
;*--------------------------------
PADC_ADR  .byte $E1,$D9
          .byte $69,$D9
          .byte $F1,$D8

;*--------------------------------
COLOR_MEM_LO .byte $06,$DA
		   .byte $8E,$D9
		   .byte $16,$D9
		   .byte $9E,$D8
;*--------------------------------
COLOR2_MEM_LO .byte $06,$DA
		    .byte $8E,$D9
		    .byte $16,$D9
		    .byte $9E,$D8
;* 	    .byte 26D8
		    .byte $06,$DA
		    .byte $8E,$D9
		    .byte $16,$D9
		    .byte $9E,$D8
		    .byte $06,$DA
;*--------------------------------
SCR_MEM_LO       .byte $08,$42
		 .byte $90,$41
		 .byte $18,$41
		 .byte $A0,$40
;*--------------------------------
WATERC_ADR        .byte $80,$42  ;LEVEL 1
		 .byte $08,$42  ;LEVEL 2
		 .byte $90,$41  ;LEVEL 3
		 .byte $18,$41  ;LEVEL 4
		 .byte $80,$42  ;LEVEL 5
;*--------------------------------
WATER_CHECK .byte $28,$50,$78,$A0
WATER_START .byte $00,$01,$02,$03
WATER_INDEX .byte $00
WATER_TOP   .byte $00
INT_RASTER  .byte $B0,$98,$80,$68
INT_CPX	    .byte $B6,$9E,$86,$6E
INT_RASTER2 .byte $DA,$CC
; Example syntax
;         lda #<label     ; low byte of address
;        ldy #>label     ; high byte of address
INT_ADDRESS:
    .byte <IRQ2
    .byte >IRQ2
    .byte <IRQ3
    .byte >IRQ3


;*--------------------------------
SPRITE_MASK .byte $01,$02,$04,$08,$10,$20,$40,$80
;*--------------------------------
ROCOL	 .byte $00
;EOFS	 .DA#40,#80,#120,#120,#80,#40
EOFS     .byte 40, 80, 120, 120, 80, 40
;EOFHT	 .DA#2,#4,#6,#6,#4,#2
EOFHT    .byte 2, 4, 6, 6, 4, 2
DIRT_COLUMN .byte 00
;*--------------------------------
BHPO	 .byte 0,0,0,0,0,0
BHPO_XMSB  .byte 0,0,0,0,0,0
;*--------------------------------
B2HPO	 .byte 0,0,0,0,0,0
B2HPO_XMSB .byte 0,0,0,0,0,0
;*--------------------------------
BOFS	 .byte 56,106,156
BNUMBER	 .byte 00
COLIX	 .byte 0,0,0,1,0,0,0,2,0,0,0,1,0,0
SCOOFS	 .byte 0,0,0,1,0,2,0,3,0,5,0,6,0,7
P1LINI	 .byte 3,3,0,3	; player 1 lives: index 0 = one player, 1 = two players
P2LINI	 .byte 0,3,0,3	; player 2 lives: index 0 = one player, 1 = two players
LIFE1	 .byte 0,0,0,0
LIFE2	 .byte 0,0,0,0
PLOTBL	 .byte $C0,$30,$0C,$03
BUCKSN	 .byte $38,$6C,$44,$F6,$C6,$DE,$44,$6C,$38,$54
BUSH_LO	 .byte <BUSH
BUSH_HI	 .byte >BUSH
SCR_LO	 .byte <SCR
SCR_HI	 .byte >SCR
ATT_LO	 .byte <ATT
ATT_HI	 .byte >ATT
;*--------------------------------
.virtual $0400
DIE_FLAG	 .fill 2
SURFACE_X  .fill 1
SCAN_X	 .fill 1
SCAN_Y	 .fill 1
DUD	 .fill 1
START	 .fill 1
.endv
;*--------------------------------
BLADE_SHAPE .byte $03,$F0,$00,$00,$0F,$C0
		  .byte $00,$F0,$00,$00,$0F,$00
		  .byte $00,$30,$00,$00,$0C,$00
		  .byte $00,$0C,$00,$00,$30,$00
		  .byte $00,$0F,$00,$00,$F0,$00
		  .byte $00,$0F,$C0,$03,$F0,$00
		  .byte $00,$0F,$00,$00,$F0,$00
		  .byte $00,$0C,$00,$00,$30,$00
		  .byte $00,$30,$00,$00,$0C,$00
		  .byte $00,$F0,$00,$00,$0F,$00
BLADE_TABLE .byte $05,$0B,$11,$17,$1D,$23,$29,$2F,$35,$3B
SUN_TABLE   .byte $1C,$1D,$1E,$1F,$20,$21
;*UPDN	  .byte 000000000001FF0000
;* 	 .byte 01FF000001FF00
BLDINC	 .byte 255
;*--------------------------------
BOMDIR	 .byte $FF,$FF,$00,$01,$01
BOMON	 .byte $03,$0C,$30,$C0
BOMOFF	 .byte $FC,$F3,$CF,$3F
;*--------------------------------
BOMB_SHAPE  .byte $80,$20,$08,$02,$80,$20,$08,$02
BOMB_MASK   .byte $3F,$CF,$F3,$FC,$3F,$CF,$F3,$FC
DIRT_COLOR  .byte $C0,$30,$0C,$03,$C0,$30,$0C,$03
ROCK_COLOR  .byte $C0,$30,$0C,$03,$C0,$30,$0C,$03
WATER_COLOR .byte $40,$10,$04,$01
DIRT_TEXTURE .byte $FF,$FF,$FF,$FF,$FF,$FF
COL0	 .byte $D4,$24,$24,$24,$26,$24,$22,$24
COL1	 .byte $88,$0F,$0F,$88,$88,$88,$88,$88
INTDC0	 .byte $72,$86,$A6,$16,$A6,$36,$C6,$78
INTDC1	 .byte $0A,$34,$24,$76,$14,$94,$08,$A6
INTDBG	 .byte $00,$80,$80,$00,$00,$00,$00,$00
SKYC1	 .byte $80
SKYC2	 .byte $80
SKYC3	 .byte $80,$00,$00,$00
WTRC1	 .byte $0F,$0F,$0F,$88,$88,$88
PC0	 .byte $00,$34,$C4,$00,$00,$00,$00,$00
P0SIZ	 .byte $00,$01,$00,$00,$00,$00,$00,$00
SCORE_COLOR .byte $06,$06,$06,$06,$06,$06,$06,$06
		  .byte $07,$07,$07,$0D,$0D,$0D
		  .byte $01,$01,$01,$01,$01,$01
PLNORG	 .byte $55,$01,$00,$00
PLNLIM	 .byte $00,$00,$60,$01
;*--------------------------------
;* SPRITE POINTERS
;*--------------------------------
PLN_SHAPE  .byte $15,$16
GUN_SHAPE  .byte $17,$18,$19,$1A,$1B
CHOP_SHAPE .byte $10,$11,$12,$13,$14
PRIZE_SHAPE .byte $25,$26,$27,$28,$29,$2A,$25,$26,$27
PRIZE_COLOR .byte $0B,$05,$03,$03,$01,$07,$0B,$05,$03
;*--------------------------------
OBDATA	 .byte $20,$20,$20,$20,$20,$20,$24,$30
DRNVOL	 .byte $20,$20,$20,$21,$21,$22,$22,$23,$23,$23,$24,$24,$24
		 .byte $24,$24,$24,$24,$24,$23,$23,$23,$23,$22,$22,$21,$21,$20
;*--------------------------------
LEVEL_MSG      .text "      LEVEL 00      "
BUC_VALUE_MSG  .text " TREASURE = $2,000  "
PLAYER_MSG     .text "      PLAYER 1      "
ONE_PLAYER_MSG .text "    ONE PLAYER      "
TWO_PLAYER_MSG .text "    TWO PLAYERS     "
ONE_STICK_MSG  .text "    ONE  STICK      "
TWO_STICK_MSG  .text "    TWO  STICKS     "
GAME_OVR_MSG   .text "     GAME  OVER     "
HI_SCORE_MSG   .text "     HIGH SCORE     "
;*--------------------------------
SCORE_ONE      .text "        "
SCORE_TWO      .text "        "
SCORE_HI	     .text "        "
;*--------------------------------
NAME	     .text "  7 SEPTEMBER 1984  "
NAME2	     .text "  TO MY DAUGHTER,   "
NAME3	     .text "< NICHELLE  STYCK > "
;*--------------------------------
PLAYER_COLOR .byte $0D,$0A
PLAYC0	 .byte $8A,$CA
LCOLRS	 .byte $09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08
;*--------------------------------
;*  SPEED OF FALLING DIRT
;*--------------------------------
FALLS	 .byte 9,7,5,5,4,4,3,3,3,2,2,2,2
		 .byte 2,2,2,2,2,2,2,2,2,1,1,1
;*--------------------------------
SSPDS	 .byte 0,4,3,2,3,2,1,2,2,1,1,1,2
		 .byte 2,1,1,1,1,1,1,1,1,2,1,1
GUNPRS	 .byte 0,1,1,1,1,1,1,1,1,1,1,1,1
		 .byte 1,1,1,1,1,1,1,1,1,1,1,1
GCHANC	 .byte $3F,$06,$05,$04,$04,$04,$04,$04,$03,$03,$03,$02,$01
		 .byte $03,$03,$02,$02,$03,$03,$03,$02,$01,$01,$02,$01
;*--------------------------------
;*  MAX NUMBER OF FALLING DIRT
;*--------------------------------
RMAX	 .byte 4,5,4,5,4,5,6,4,5,6,7,8,4
		 .byte 5,6,7,7,7,8,8,8,9,7,8,9
;*--------------------------------
;* PRIZE VALUES
;*--------------------------------
B1VALS	 .byte 2,2,2,2,2,3,3,3,3,3,4,4,4
		 .byte 4,4,5,5,5,5,5,6,6,6,6,6,7
		 .byte 7,7,7,7,8,8,8,8,8,9,9,9,9
B2VALS	 .byte 0,2,4,6,8,0,2,4,6,8,0,2,4
		 .byte 6,8,0,2,4,6,8,0,2,4,6,8,0
		 .byte 2,4,6,8,0,2,4,6,8,0,2,4,6
;*--------------------------------
PADLOC	 .byte $7E,$66,$4E,$36,$36
PADLOC2	 .byte $78,$60,$48,$30,$30
;*--------------------------------
GROUND	 .byte $80,$68,$50,$38,$38
BUCADF	 .byte 165,145,121,97
BUCHGT	 .byte $C2,$9A,$32,$6A,$6A
ICTBL	 .byte $A3,$8B,$73,$5B
PADLIN	 .byte 159,135,111,87
;*--------------------------------
SUN_HT	 .byte $42,$42,$42,$42,$42
SUN_LR	 .byte $30,$30,$30,$30,$30
;*--------------------------------
BUC_YPOS	 .byte $CF,$BB,$A0,$8B,$80,$40,$40,$40
BUC_XPOS	 .byte $50,$C8,$F0,$FF,$A0,$78
;*--------------------------------
UWTBL	 .byte $00,$00,$02,$03
SWTBL	 .byte $00,$00,$01,$02
SURMIN	 .byte $00,$05,$0A,$10
SURMAX	 .byte $00,$0A,$10,$14,$16,$18
UNDER_X	 .byte $14,$1E,$28,$40,$4E,$58,$60
UNDER_Y	 .byte $08,$10,$15,$08,$10,$15,$08
UNDMIN	 .byte $04,$07,$09,$0B,$09,$07,$04
UNDMAX	 .byte $14,$16,$0E,$10,$0E,$16,$14
;*--------------------------------
GUNOFF	 .byte $C3
GUNON	 .byte $3C
WPXADD	 .byte 0,1,255,0,1,2,255,0,1,2,0,1
WPYADD	 .byte 0,0,1,1,1,1,2,2,2,2,3,3
;*--------------------------------
.virtual $0407
STICK_NUMBER  .fill 1
ABORT	 .fill 1
ABORT_FLAG .fill 1
KEYTEMP	 .fill 1
NAME_FLAG  .fill 1
FIRE_ARMED .fill 1		; title: fire must release then press
SEED	 .fill 1
CHOP_YTEM  .fill 1
LANDFG	 .fill 1
BOMACT	 .fill 1
BOMBLD	 .fill 1
BUCHIT	 .fill 1
;*--------------------------------
SCOPOS	 .fill 1
SCOCHG	 .fill 1
SCOMAX	 .fill 2
SCOVAL	 .fill 8
SCOV0	 .fill 2
SCOV1	 .fill 2
SCOV2	 .fill 2
SCOV3	 .fill 2
SCOV4	 .fill 2
SCOV5	 .fill 2
SCOV6	 .fill 2
SCOV7	 .fill 2
;*--------------------------------
PLAYRS	 .fill 1
SAMEPL	 .fill 1
LIFHLD	 .fill 1
EXPCNT	 .fill 1
PLTCLR	 .fill 1
COUNTR	 .fill 1
HIHLD	 .fill 1
LOHLD	 .fill 1
PLOTBYT	 .fill 1
COLOR	 .fill 1
DROP1	 .fill 1
DROP2	 .fill 1
HOLD1	 .fill 1
DRPCOL	 .fill 1
DRPFLG	 .fill 1
ROCNT	 .fill 1
BSX	 .fill 1
BSY	 .fill 1
IRQ_BSX	 .fill 1
IRQ_BSY	 .fill 1
SHOB1	 .fill 1
SHOB2	 .fill 1
SHOB3	 .fill 1
MOVED	 .fill 1
MOVED2	 .fill 1
HT	 .fill 1
EOFSET	 .fill 1
XPOS	 .fill 21
YPOS	 .fill 21
CNT	 .fill 21
;*--------------------------------
RX1	 .fill 11
RX2	 .fill 11
RX3	 .fill 11
RX4	 .fill 11
RX5	 .fill 11
RX6	 .fill 11
;*--------------------------------
RY1	 .fill 11
RY2	 .fill 11
RY3	 .fill 11
RY4	 .fill 11
RY5	 .fill 11
RY6	 .fill 11
;*--------------------------------
KILL_DIRT_FLAG .fill 11
.endv
;*--------------------------------
LRIND	 .byte 00
EXPHT	 .byte 0,0,0,0,0,0,0,0,0,0,0,0
EXPLR	 .byte 0,0,0,0,0,0,0,0,0,0,0,0
EXPGO	 .byte 0,0,0,0,0,0,0,0,0,0,0,0
BOMB	 .byte 0,0,0,0,0,0,0,0
BOMBHT	 .byte 0,0,0,0,0,0,0,0
BOMBLR	 .byte 0,0,0,0,0,0,0,0
BOMBDR	 .byte 0,0,0,0,0,0,0,0
;*--------------------------------
BOMB_CNT_VAL  .byte 9,5,1,5,9
;*--------------------------------
BOMB_YINC  .byte 1,2,1,2,1
.virtual $0517
BOMB_YDEL  .fill 5
HP0	 .fill 8
DRTHIT	 .fill 1
NOUPDT	 .fill 1
BOMBCT	 .fill 4
BOMTIM	 .fill 4
TRANSIT	 .fill 1
PLNDIR	 .fill 1
CHOP_DIR	 .fill 1
CLOUD_DIR  .fill 1
CLOUD_FG	 .fill 1
ABCNT	 .fill 1
ABONUM	 .fill 1
SCOLIN	 .fill 20
;*--------------------------------
DEMO	 .fill 1
DEWAIT	 .fill 1
LETTER	 .fill 1
;*--------------------------------
NPWAIT	 .fill 1
;*--------------------------------
LAND_SOUND .fill 1
LAND_FREQ  .fill 1
BUC_SOUND  .fill 1
;*--------------------------------
ABOFRQ	   .fill 1
EXPL_FREQ    .fill 1
EXPL_SOUND   .fill 1
SPLASH_SOUND .fill 1
PLANE_SOUND  .fill 1
SHOT_SOUND   .fill 1
;*--------------------------------
PRSCNT	 .fill 1
BOMIND	 .fill 1
BDIG1	 .fill 1
BDIG2	 .fill 1
NEWLFG	 .fill 1
BBRITE	 .fill 1
M2IX	 .fill 1
INEXPC	 .fill 1
SHOLTR	 .fill 1
INBRIT	 .fill 1
BFXHLD	 .fill 1
;*--------------------------------
EXPBGC	 .fill 1
TEMPCX	 .fill 1
.endv
;*--------------------------------
;* COLORS
;*--------------------------------
BLACK		  = $00
WHITE		  = $01
RED		  = $02
CYAN		  = $03
PURPLE		  = $04
GREEN		  = $05
BLUE		  = $06
YELLOW		  = $07
ORANGE		  = $08
BROWN		  = $09
LT_RED		  = $0A
DK_GREY		  = $0B
MED_GREY		  = $0C
LT_GREEN		  = $0D
LT_BLUE		  = $0E
LT_GREY		  = $0F
;*--------------------------------
IRQLO		  = $314
IRQHI		  = $315
NMI_VECTOR	  = $318
;*--------------------------------
;* ZERO PAGE VARIABLES
;*--------------------------------
.virtual $05
PAUSE	.fill 1
CHOP_X	.fill 1
CHOP_XMSB .fill 1
PLANE_X	.fill 1
PLANE_XMSB .fill 1
GUN_X	.fill 1
GUN_XMSB	.fill 1
CLOUD_X	.fill 1
CLOUD_XMSB .fill 1
SUN_X	.fill 1
SUN_XMSB	.fill 1
EXTRA_X	.fill 1
EXTRA_XMSB .fill 1
EXTRA1_X	.fill 1
EXTRA1_XMSB .fill 1
EXTRA2_X	.fill 1
EXTRA2_XMSB .fill 1
;*--------------------------------
BUC1_X	.fill 1
BUC1_XMSB .fill 1
BUC2_X	.fill 1
BUC2_XMSB .fill 1
BUC3_X	.fill 1
BUC3_XMSB .fill 1
;*--------------------------------
CHOP_Y	.fill 1
PLANE_Y	.fill 1
GUN_Y	.fill 1
CLOUD_Y	.fill 1
SUN_Y	.fill 1
EXTRA_Y	.fill 1
EXTRA1_Y	.fill 1
EXTRA2_Y	.fill 1
;*--------------------------------
BUC1_Y	.fill 1
BUC2_Y	.fill 1
BUC3_Y	.fill 1
;*--------------------------------
GUN_X_SC	.fill 1
GUN_Y_SC	.fill 1
CHOP_XSC	.fill 1
CHOP_YSC	.fill 1
;*--------------------------------
MOUNTAIN_TOP .fill 1
;*--------------------------------
CHOP_TIM	.fill 1
PLANE_TIM .fill 1
BLADE_TIM .fill 1
CLOUD_TIM .fill 1
SUN_TIM	.fill 1
GUN_TIM	.fill 1
CHOP_SPEED .fill 1	;USED TO SET CHOP_TIM
BOMB_SPEED .fill 1
BLADE_SPEED .fill 1	;CONTROLS BLADE SOUND
BLADE_SPEED2 .fill 1
BLADE_SOUND .fill 1	;=1 NO SOUND
CHOP_POS	.fill 1	;INDEX TO TABLE OF CHOPPER MOVEMENTS
CHOP_EXPL .fill 1	;FLAG IF CHOP EXPLODING
BHIT1	.fill 1
BHIT2	.fill 1
BHIT3	.fill 1
BHIT4	.fill 1
HIT0	.fill 1
HIT1	.fill 1
HIT2	.fill 1
HIT3	.fill 1
SPRITE_COLLISION .fill 1
CHOP_BACK_COLL   .fill 1
;*--------------------------------
BLDPH	.fill 1
SUNPH	.fill 1
BODPH	.fill 1
;*--------------------------------
ROTATE_LEFT .fill 1
ROTATE_RIGHT .fill 1
;*--------------------------------
CHOPT	.fill 1
STKIND	.fill 1
INCUD	.fill 1
INCLR	.fill 1
COUNT	.fill 1
ROTGT	.fill 1
ROTINC	.fill 1
DROPWT	.fill 1
DROPGO	.fill 1
FERRY	.fill 1
FERIX	.fill 1
LEVEL	.fill 2
BILEVL	.fill 1
LIVES	.fill 2
BUCHPC	.fill 1
BUCHPC_XMSB .fill 1
BUCVPC	.fill 1
TURNO	.fill 1
CKTDIR	.fill 1
BUCTRY	.fill 1
BUC_NUM	.fill 1	; BNUMBR
;*PLRSIX	 .fill 1
;*OTSIND	 .fill 1
BUCADD	.fill 1
BUCLVL	.fill 1
BUCVL1	.fill 1
BUCVL2	.fill 1
PADLVL	.fill 1
PADLVL2	.fill 1
INILVL	.fill 1
FALSPD	.fill 1
INICHT	.fill 1
PADLN	.fill 1
INIFLG	.fill 1
GPFLG	.fill 1
SHTSPD	.fill 1
GUNCHN	.fill 1
ROCMAX	.fill 1
TRANCT	.fill 1
CHANGP	.fill 1
;*--------------------------------
UNDWTR	.fill 1
SURWTR	.fill 1
SURTMP	.fill 1
DEPTH	.fill 1
WTRLIN	.fill 1
WTRLFT	.fill 1
WTRLEN	.fill 1
UNDTMP	.fill 1
MINDEP	.fill 1
UNDFAC	.fill 1
TYPE2	.fill 1
WATERX	.fill 1
WATERY	.fill 1
WPHASE	.fill 1
;*--------------------------------
GUNACT	.fill 1
GUNFAL	.fill 1
GUNFGO	.fill 1
GUNSHT	.fill 1
GUN_LAND	.fill 1
GUN_PHASE .fill 1
;*--------------------------------
TGTX	.fill 1
TGTY	.fill 1
SHOTX	.fill 1
SHOTY	.fill 1
SHOTON	.fill 1
SHOTDR	.fill 1
;*PRVDAT	 .fill 1
;*--------------------------------
PRIZE_1	.fill 1
PRIZE_2	.fill 1
PRIZE_3	.fill 1
PRIZE_1C	.fill 1
PRIZE_2C	.fill 1
PRIZE_3C	.fill 1
;*--------------------------------
PXINCH	.fill 1
PXINCL	.fill 1
PYINCH	.fill 1
PYINCL	.fill 1
PXHOLD	.fill 1
PYHOLD	.fill 1
DELTAX	.fill 1
DELTAY	.fill 1
SXHLDA	.fill 1
;*INTCNT	 .fill 1
WLO	.fill 1
WHI	.fill 1
SOIL	.fill 1
PADC_LO	.fill 1
PADC_HI	.fill 1
PADLO	.fill 1
PADHI	.fill 1
LO	.fill 2
IRQ_LO	.fill 2
JLO	.fill 2
IRQ_JLO	.fill 2
OLD_LO	.fill 8
OLD_BOMB	.fill 4
INDEX_MASK .fill 4
ERASE_FLAG .fill 4
ROTATE_FLAG .fill 1
;*--------------------------------
BUC1VP	.fill 1
BUC2VP	.fill 1
BUC3VP	.fill 1
;*--------------------------------
B2C1VP	.fill 1
B2C2VP	.fill 1
B2C3VP	.fill 1
;*--------------------------------
PLOTX	.fill 1
PLOTY	.fill 1
IRQ_PLOTX .fill 1
IRQ_PLOTY .fill 1
;*SPLCNT	 .fill 1
BDEAD	.fill 1
DEAD	.fill 1
DRPNUM	.fill 1
PLAYER	.fill 1
RANDOM	.fill 1
BOMB_COUNT .fill 1
BOMB_CNT	.fill 4
TABLE_LO	.fill 8
;*--------------------------------
TEMP1	.fill 1			;GENERAL PURPOSE VARIABLE
TEMP2	.fill 1			;GENERAL PURPOSE VARIABLE
TEMP3	.fill 1			;GENERAL PURPOSE VARIABLE
TEMP4	.fill 1			;GENERAL PURPOSE VARIABLE
TEMP5	.fill 1			;GENERAL PURPOSE VARIABLE
TEMP6	.fill 1			;GENERAL PURPOSE VARIABLE
TEMP7	.fill 1			;GENERAL PURPOSE VARIABLE
STICK_FLAG .fill 1
STICK_TMP .fill 1
WATER_TEMP .fill 1
;*--------------------------------
IRQ_TEMP1 .fill 1
IRQ_TEMP2 .fill 1
IRQ_TEMP3 .fill 1
IRQ_TEMP4 .fill 1
IRQ_TEMP5 .fill 1
IRQ_TEMP6 .fill 1
;*--------------------------------
MULT1	.fill 1			;USED BY MULTIPLICATION ROUTINE
MULT2	.fill 1
MULTIPLIER .fill 1
;*--------------------------------
DIVISOR	.fill 1			;USED BY DIVISION ROUTINE
DIVIDEND	.fill 1
REMAINDER .fill 1
;*--------------------------------
PRINTX	.fill 1			;USED BY PRINT ROUTINE
PRINTY	.fill 1
PRINT_COLOR .fill 1
;*--------------------------------
TIMER1	.fill 1
TIMER2	.fill 1
TIMER3	.fill 1
TIMER4	.fill 1
TIMER5	.fill 1
TIMER6	.fill 1
TIMER7	.fill 1
TIMER8	.fill 1
TIMER9	.fill 1
.endv
;*--------------------------------
