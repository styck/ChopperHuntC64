;--------------------------------
;  INCREMENT TO NEXT LEVEL
;--------------------------------
NXTLVL:
		   LDA BILEVL	 ;LEVEL 99?
		   CMP #98
		   BEQ increment_lives
		   INC BILEVL
		   INC LEVEL
		   LDA LEVEL	 ;HANDLE 2-BYTE LEVEL #
		   CMP #10
		   BMI increment_lives
		   INC LEVEL+1
		   LDA #$00
		   STA LEVEL
;--------------------------------
; INCREMENT LIFES AFTER EACH LEVEL
;--------------------------------
increment_lives:
		   LDX PLAYER	 ;CHECK IF PLAYERS ARE DEAD
		   BPL SHOLVL
		   RTS
;--------------------------------
;  SHOW LEVEL ON SCREEN
;--------------------------------
SHOLVL:
		   LDA LEVEL+1
		   CLC
		   ADC #$30
		   STA SCOLIN+15
		   STA LEVEL_MSG+12
		   LDA LEVEL
		   CLC
		   ADC #$30
		   STA SCOLIN+16
		   STA LEVEL_MSG+13
;--------------------------------
;  SHOW LIVES ON SCREEN
;--------------------------------
SHOW_LIVES:
		   LDX PLAYER	  	;WAS PLAYRS *******
		   BMI show_lives_end	;PLAYERS DEAD
;--------------------------------
		   LDA LIFE2,X
		   CLC
		   ADC #$30
		   STA SCOLIN+12
		   LDA LIFE1,X
		   CLC
		   ADC #$30
		   STA SCOLIN+13
;--------------------------------
		   JSR PRINT_SCOLIN
;--------------------------------
show_lives_end:
		   RTS
;--------------------------------
; SHOW BOMBS ON SCREEN
;--------------------------------
SHOBOMBS	   LDA BOMIND
		   BEQ SHOBND
		   DEC BOMIND
		   DEC BDIG2
		   BPL SHOBOMBS
;--------------------------------
;  BCD ADDITION
;--------------------------------
		   LDA #$09    ;***
		   STA BDIG2
		   LDA BDIG1   ;IF LEFT DIGIT = 0 THEN DONT DECREMENT
		   BEQ SHOBND
		   DEC BDIG1
;--------------------------------
		   JMP SHOBOMBS
;--------------------------------
SHOBND	   LDA BDIG1
		   CLC
		   ADC #$30
		   STA SCOLIN+9
		   LDA BDIG2
		   CLC
		   ADC #$30
		   STA SCOLIN+10
		   JSR PRINT_SCOLIN
		   RTS
;--------------------------------
;   NEW PLAYER/LEVEL
;--------------------------------
PLRCHG	 JSR TURN_SCREEN_OFF
;--------------------------------
		 SEI
;--------------------------------
		 LDA #$00	 ;STOP VBLANK FROM
		 STA IRQ_ENABLE  ;SCREWING THINGS UP
;--------------------------------
		 LDA LIVES   ;ANY LIVES LEFT
		 ORA LIVES+1
		 BNE NADED   ;YES
;--------------------------------
		 LDA #$FF
		 STA PLAYER  ;PLAYER DEAD
		 LDA #$01    ;*******
		 STA DEAD    ;*******
;--------------------------------
; 	 LDA #$01
		 STA IRQ_ENABLE  ;TURN INTER. ON
		 CLI
		 JSR TURN_SCREEN_ON
		 RTS
;--------------------------------
NADED	 LDA #$00
		 STA NEWLFG
;--------------------------------
		 STA MASTER_VOLUME   ;TURN SOUND OFF
		 STA CHOP_EXPL
		 STA EXPL_SOUND
		 STA EXPL_FREQ
;--------------------------------
		 LDA SAMEPL   ;SAME PLAYER?
		 BEQ NSPLR    ;NO
;--------------------------------
		 STA NEWLFG   ;NO NEW LEVEL
JLIVCK	 JMP LIVCHK
;--------------------------------
; GOING TO NEXT PLAYER
; SAVE PLAYER  SCORE
;--------------------------------
NSPLR	 LDX PLAYER
		 LDA SCOVAL
		 STA SCOV0,X
		 LDA SCOVAL+1
		 STA SCOV1,X
		 LDA SCOVAL+2
		 STA SCOV2,X
		 LDA SCOVAL+3
		 STA SCOV3,X
		 LDA SCOVAL+4
		 STA SCOV4,X
		 LDA SCOVAL+5
		 STA SCOV5,X
		 LDA SCOVAL+6
		 STA SCOV6,X
		 LDA SCOVAL+7
		 STA SCOV7,X
		 LDA ABORT
		 BNE LIVCHK
;--------------------------------
NCHGN2	 INC PLAYER   ;NEXT PLAYER
		 LDA PLAYER
		 CMP #$02
		 BMI LIVCHK
;--------------------------------
		 LDA #$00     ;BACK TO PLAYER 1
		 STA PLAYER
		 INC NEWLFG   ;AND NEW LEVEL
;--------------------------------
LIVCHK	 LDX PLAYER   ;HERE FIRST IF ABORTING
		 LDA LIVES,X
		 BEQ NCHGN2   ;IF DEAD, TRY OTHER PLAYER
;--------------------------------
NLCHEK	 LDA PLAYER
		 CLC
		 ADC #$31
		 STA PLAYER_MSG+13
;--------------------------------
		 LDA #$00
		 STA TRANSIT
		 STA DRTHIT   ;STOP DECREMENTING SCORE
;--------------------------------
		 LDA NEWLFG
		 BEQ do_intermediate_screen
		 JSR NXTLVL
;--------------------------------
;  DO INTERMEDIATE
;  SCREEN
;--------------------------------
do_intermediate_screen:
		 LDA BILEVL
		 CMP #38
		 BEQ set_buc_value
		 AND #$1F
		 TAX
;--------------------------------
		 LDA B1VALS,X
		 STA BUCVL1
		 LDA B2VALS,X
		 STA BUCVL2
;--------------------------------
set_buc_value:
		 LDA BUCVL1
		 CLC
		 ADC #$30
		 STA BUC_VALUE_MSG+13
;--------------------------------
		 LDA BUCVL2
		 CLC
		 ADC #$30
		 STA BUC_VALUE_MSG+15
;--------------------------------
		 JSR CLEAR_SPRITES
		 JSR SETUP_TEXT
		 JSR CLEAR_HIRES
		 JSR CLEAR_TEXT
;--------------------------------
		 LDA #WHITE
		 STA PRINT_COLOR
;--------------------------------
		 LDA #<LEVEL_MSG
		 STA LO
		 LDA #>LEVEL_MSG
		 STA LO+1
		 LDA #10
		 STA YPOS
		 JSR PRINT_MSG
;--------------------------------
		 LDA #WHITE
		 STA PRINT_COLOR
;--------------------------------
		 LDA #<PLAYER_MSG
		 STA LO
		 LDA #>PLAYER_MSG
		 STA LO+1
		 LDA #13
		 STA YPOS
		 JSR PRINT_MSG
;--------------------------------
		 LDA #<BUC_VALUE_MSG
		 STA LO
		 LDA #>BUC_VALUE_MSG
		 STA LO+1
		 LDA #16
		 STA YPOS
		 JSR PRINT_MSG
;--------------------------------
		 JSR TURN_SCREEN_ON
;--------------------------------
		 LDX PLAYER
		 LDA PLAYER_COLOR,X
		 STA SPRITE_COLOR
		 STA $D021
		 LDA #$01	      ;**
		 STA DIE_FLAG,X       ;**
;--------------------------------
		 JSR INTRM_SOUND
;--------------------------------
DO_INTRM	 LDA #$60
		 STA TEMP1
do_intrm_loop:
		 JSR DELAY
		 JSR DELAY
		 JSR DELAY
		 JSR DELAY
		 DEC TEMP1
		 BNE do_intrm_loop
;--------------------------------
		 LDA #$00
		 STA MASTER_VOLUME
		 STA $D404
		 STA $D40B
		 STA $D412
;--------------------------------
		 JSR CRTINI
		 JSR INIT_SOUND   ;RE-INIT SOUND REGISTERS
;--------------------------------
NNLEVL:
		 LDA ABORT    ;ABORT?
		 BEQ no_abort       ;NO
;--------------------------------
no_abort:
    LDX PLAYER
;--------------------------------
		 LDA SCOV0,X
		 STA SCOVAL
		 LDA SCOV1,X
		 STA SCOVAL+1
		 LDA SCOV2,X
		 STA SCOVAL+2
		 LDA SCOV3,X
		 STA SCOVAL+3
		 LDA SCOV4,X
		 STA SCOVAL+4
		 LDA SCOV5,X
		 STA SCOVAL+5
		 LDA SCOV6,X
		 STA SCOVAL+6
		 LDA SCOV7,X
		 STA SCOVAL+7
;--------------------------------
NOPSLD	 JSR SHOSCO	;SHOW SCORE
		 LDX PLAYER
		 JSR SHOW_LIVES
;--------------------------------
		 LDA #$00
		 STA SAMEPL	  ;******
;--------------------------------
		 STA CHANGP
		 LDA #$01
		 STA IRQ_ENABLE ;PLAYER CHANGE FLAG
		 CLI
		 JSR DELAY
		 JSR DELAY
;--------------------------------
		 JSR TURN_SCREEN_ON
;--------------------------------
		 LDA #$0A
		 STA MASTER_VOLUME
;--------------------------------
		 LDA #$00
		 STA ABORT
		 RTS
;--------------------------------
;  SHOW SCORE ROUTINE
;--------------------------------
SHOSCO	 LDX #$00
SCOLP1	 LDA SCOVAL,X
		 BNE GOTMAX
		 INX
		 CPX #8
		 BNE SCOLP1
GOTMAX	 LDY PLAYER
		 TXA
		 STA SCOMAX,Y
;--------------------------------
		 DEX
		 LDA #$20      ;LOAD SPACE
clear_scolin_left:
		 STA SCOLIN,X
		 DEX	       ;CLEAR LEFT OF $ SIGN
		 BPL clear_scolin_left
;--------------------------------
		 LDA SCOMAX,Y  ;@@@
		 TAX	       ;@@@
SCOLP2	         LDA SCOVAL,X
		 CLC
		 ADC #$30
		 LDY SCOOFS,X
		 STA SCOLIN,Y
		 INX
		 CPX #8
		 BNE SCOLP2
;--------------------------------
		 LDY PLAYER
		 LDA SCOMAX,Y	  ;@@@
		 CMP #5
		 BCS NOCOM
		 LDY #$2C	  ;LOAD ","
		 JMP SKIP
NOCOM	         LDY #$20	  ;LOAD <SPACE>
SKIP	         STY SCOLIN+4
		 LDX #$FF	  ;FIND 1ST DIGIT STARTING
find_first_digit:
    INX		  ;FROM THE LEFT
    LDA SCOLIN,X
    CMP #$20	  ;IS IT A "0"
    BEQ find_first_digit
		 LDA #$24	  ;LOAD "$"
		 STA SCOLIN-1,X
		 DEX		  ;POINTING AT "$"
		 BEQ SCOXIT	  ;****
		 DEX		  ;POINTING AT "0"
		 LDA #$20	  ;LOAD <SPACE>
erase_leading_zeros:
		 STA SCOLIN,X	  ;ERASE LEADING ZEROS
		 DEX
		 BPL erase_leading_zeros
SCOXIT	         LDA #WHITE
		 STA PRINT_COLOR
;--------------------------------
SCORE_PR	 LDA PLAYER
		 BNE SAVE_2
;--------------------------------
SAVE_1	 LDY #$00
		 LDX #$00
save_score_one_loop:
		 LDA SCOLIN,Y
		 STA SCORE_ONE,X
		 INX
		 INY
		 CPY #$08
		 BNE save_score_one_loop
		 JMP PRINT_SCOLIN
;--------------------------------
SAVE_2	 LDY #$00
		 LDX #$00
save_score_two_loop:
		 LDA SCOLIN,Y
		 STA SCORE_TWO,X
		 INX
		 INY
		 CPY #$08
		 BNE save_score_two_loop
;--------------------------------
; PRINT SCORE ON SCREEN
;--------------------------------
PRINT_SCOLIN	 LDY #18
		 LDX #36
print_scolin_loop:
		 LDA SCOLIN,Y
		 STA print_char_val
		 LDA SCORE_COLOR,Y
		 STA PRINT_COLOR
		 DEY
		 TYA
		 PHA
		 TXA
		 PHA
		 LDY #23
		 JSR PRINT
print_char_val:
		 .text "0"
		 .byte $ff
		 PLA
		 TAX
		 PLA
		 TAY
		 DEX
		 DEX
		 BPL print_scolin_loop
		 RTS
;--------------------------------
; ADD TO SCORE
;--------------------------------
ADDSCO	 	 LDX SCOPOS
		 LDA SCOCHG
CARRY	 	 CLC
		 ADC SCOVAL,X
		 CMP #10
		 BPL no_carry
		 STA SCOVAL,X
;--------------------------------
		 JMP SHOSCO
;--------------------------------
no_carry:
		 SEC
		 SBC #10
		 STA SCOVAL,X
		 LDA #1
		 DEX
		 JMP CARRY
;--------------------------------
; SUBTRACT FROM SCORE
;--------------------------------
SUBSCO	 	 LDA SCOPOS
		 TAX
		 LDY PLAYER
		 CMP SCOMAX,Y
		 BEQ UHOH
		 BPL SUBOK
		 BNE OUTBUX    ;NO MORE DOLLARS
UHOH	 	 LDA SCOCHG
		 CMP SCOVAL,X
		 BPL OUTBUX
SUBOK	 	 LDA SCOVAL,X
		 SEC
		 SBC SCOCHG
		 BPL SUBDUN
		 CLC
		 ADC #10
		 STA SCOVAL,X
		 LDA #1
		 STA SCOCHG
		 DEX
		 BPL SUBOK
;--------------------------------
OUTBUX:
		 LDX #7
outbux_loop:
		 LDA OBDATA,X
		 STA SCOLIN,X
 		 LDA #0
		 STA SCOVAL,X
		 DEX
		 BPL outbux_loop
;--------------------------------
		 JSR SCORE_PR
;--------------------------------
		 LDA #1
		 STA DEAD
;--------------------------------
		 LDX PLAYER
		 LDA #$00
		 STA LIVES,X
		 RTS
;--------------------------------
		 RTS
;--------------------------------
SUBDUN	 	 STA SCOVAL,X
		 JMP SHOSCO
;--------------------------------
;  SETUP SCREEN
;--------------------------------
CRTINI	 	 LDA VIC_CONTROL_1   ;TURN SCREEN OFF
		 BPL CRTINI
		 JSR TURN_SCREEN_OFF
;--------------------------------
		 INC INIFLG
		 LDA BILEVL
NOSET3	 	 AND #$03
		 TAX
		 LDA GROUND,X  ;GET GROUND HEIGHT
		 STA INILVL    ;INTO INILVL
		 STA WATERY
		 STA SCAN_Y
;--------------------------------
		 SEC
		 SBC #$18
		 STA MOUNTAIN_TOP
;--------------------------------
		 LDA #$00
		 STA WATERX
		 STA SCAN_X
		 STA DROPGO  ;DIRT NOT READY FOR DROP
;--------------------------------
		 LDA PADLOC,X  ;GET PAD LOCATION
		 STA PADLVL    ;ALL DEPENDS ON LEVEL
		 LDA PADLOC2,X
		 STA PADLVL2
;--------------------------------
		 LDA SUN_HT,X
		 STA SUN_Y
		 LDA SUN_LR,X
		 STA SUN_X
		 LDA #$01
		 STA SUN_XMSB
;--------------------------------
		 LDA BUCHGT,X
		 STA BUCLVL
		 LDA BUCADF,X
		 STA BUCADD
		 LDA PADLIN,X
		 STA PADLIN
		 LDA UWTBL,X
		 STA UNDWTR
		 LDA SWTBL,X
		 STA SURWTR
		 LDA ICTBL,X
		 STA INICHT
;--------------------------------
COLOR_PAD  	 TXA		;POINT TO COLOR
		 ASL		;FOR PAD
		 TAX
		 LDA PADC_ADR,X
		 STA PADC_LO
		 LDA PADC_ADR+1,X
		 STA PADC_LO+1
;--------------------------------
		 LDA #$00
		 STA PLOTX
		 LDA INILVL
		 STA PLOTY
		 STA SOIL
		 JSR PLOTCL
;--------------------------------
		 LDA BILEVL   ;SHIFT OFF LOW 2 BITS
		 LSR	      ;AND USE AS INDEX
		 LSR
		 TAX
;--------------------------------
		 LDA FALLS,X   ;SET FALL SPEED FOR
		 STA FALSPD    ;DIRT
		 LDA GUNPRS,X
		 STA GPFLG
		 LDA GCHANC,X
		 STA GUNCHN
		 LDA RMAX,X    ;SET MAX NUMBER OF
		 STA ROCMAX    ;ROCKS BEING DROPPED
;--------------------------------
		 JSR GUN_CHANCE  ;SET TRANCT FOR GUN ROUTINES
		 LDA #$00
		 STA GUN_Y	 ;REMOVE GUN FROM SCREEN
;--------------------------------
;  SELECT PRIZES
;--------------------------------
		 LDY #$02
		 LDA BILEVL
		 AND #$07
		 TAX
select_prizes_loop:
		 LDA PRIZE_SHAPE,X  ;SELECT PRIZES
		 STA PRIZE_1,Y	    ;AND THEIR COLOR
		 LDA PRIZE_COLOR,X
		 STA PRIZE_1C,Y
		 DEY
		 BPL select_prizes_loop
;--------------------------------
		 LDA #$00
		 STA EXPCNT
		 STA ROCNT
		 STA ERASE_FLAG
		 STA ERASE_FLAG+1
		 STA ERASE_FLAG+2
		 STA ERASE_FLAG+3
		 STA BOMB_COUNT
		 STA BOMB      ;NO BOMBS ARE
		 STA BOMB+1    ;ACTIVE
		 STA BOMB+2
		 STA BOMB+3
		 STA BOMACT
		 STA DROPWT
		 STA WPHASE
		 LDA #$04
		 STA BODPH
		 STA ROTGT
		 LDA SHOTON
		 BEQ CGUNVR
		 JSR SHTCLR
CGUNVR	 LDA #$00
		 STA GUNACT
		 STA GUNFAL
		 STA GUNFGO
		 STA GUNSHT
		 STA LANDFG    ;LANDED
		 JSR CLEAR_HIRES
		 JSR INIT_CM
;--------------------------------
;  DRAW BLUE SKY
;--------------------------------
		 LDX #$00
		 STX PLOTX
draw_sky_loop:
		 STX PLOTY
		 TXA
		 PHA
		 JSR PLOTCL
		 PLA
		 TAX
		 LDA #39
		 STA TEMP1
		 LDY #$00
draw_sky_inner_loop:
		 LDA #$55      ;$55 IS BLUE
		 STA (LO),Y
		 LDA #$08      ;NEXT BYTE
		 CLC
		 ADC LO
		 STA LO
		 BCC no_inc_lo_high
		 INC LO+1
no_inc_lo_high:
		 DEC TEMP1
		 BPL draw_sky_inner_loop
		 INX
		 CPX INILVL
		 BCC draw_sky_loop
;--------------------------------
; DRAW GROUND DEPENDING ON LEVEL
;--------------------------------
		 LDX #$00
		 STX PLOTX
		 LDX INILVL
DLOOP2	 STX PLOTY
		 TXA
		 PHA
		 JSR PLOTCL
		 PLA
		 TAX
		 LDA #39
		 STA TEMP1
DLOOP3	 LDA PLOTY
		 AND #$03
		 TAY
		 LDA DIRT_TEXTURE,Y
		 LDY #$00
		 STA (LO),Y
		 LDA #$08
		 CLC
		 ADC LO
		 STA LO
		 BCC loop_continue
		 INC LO+1
loop_continue	 DEC TEMP1
		 BPL DLOOP3
		 INX
		 CPX #$BB
		 BNE DLOOP2
;--------------------------------
; INIT SCREEN MEM BELOW GROUND
;--------------------------------
DO_SCRMEM  LDA BILEVL
		 AND #$03
		 ASL
		 TAX
		 LDA WATERC_ADR,X
		 STA LO
		 LDA WATERC_ADR+1,X
		 STA LO+1
		 LDY #$00
fill_loop	 LDA #$31
		 STA (LO),Y
		 INC LO
		 BNE fill_loop_chk
		 INC LO+1
fill_loop_chk	 LDA LO+1
		 CMP #$43
		 BNE fill_loop
		 LDA LO
		 CMP #$70
		 BNE fill_loop
;--------------------------------
;  DRAW MOUNTAINS
;--------------------------------
		 JSR DO_MOUNT
		 JSR DO_COLOR
CK	 LDA DEMO
		 BEQ pad_level
		 JMP ACT2
pad_level	 LDA PADLVL    ;GET PAD HEIGHT
		 STA PLOTY
		 LDA #0
		 STA PLOTX
		 JSR PLOTCL
		 LDA LO        ;CALCULATE POSITION
		 STA PADLO    ; OF PAD
		 LDA LO+1
		 STA PADHI
REPOS	 LDA #$00
		 STA HIT0
		 STA TRANSIT   ;PLANE IS NOT MOVING
;--------------------------------
		 LDA #$01
		 STA LANDFG
		 LDA #$01      ;@@@STOP CHOP
		 STA INCUD
		 LDA #$00
		 STA CHOP_XMSB
		 LDA #$30      ;SET CHOPPER X
		 STA CHOP_X
		 STA SPRITE_XPOS
		 LDA INICHT    ;SET CHOPPER Y
		 STA CHOP_Y    ;ONTO LANDING PAD
		 STA SPRITE_YPOS
;--------------------------------
;  PUT IN SURFACE WATER
;--------------------------------
		 LDA SURWTR
		 BEQ ACT2
		 LDA BILEVL
		 AND #$30
		 BNE _5
		 LDA #$01
		 BNE _55
_5	 	 LDA SURWTR
_55	 	 STA SURTMP
_1	 	 LDA #$05	;WAS 3!!!!
		 STA DEPTH
		 TAX
		 LDA INILVL
		 STA WTRLIN
_11	 	 LDA SEED
		 STA RANDOM
_2	 	 JSR MAKE_RANDOM
		 BEQ _11
		 CMP #120
		 BCS _2
		 STA WTRLFT
		 CLC
		 ADC #$01
		 STA SURFACE_X
;--------------------------------
_22	 	 LDA SURMAX,X
		 STA WTRLEN
		 JSR DOWATR
		 DEC DEPTH
		 BEQ _4
		 INC WTRLIN
		 JSR MAKE_RANDOM
		 AND #$07
		 CLC
		 ADC WTRLFT
		 STA WTRLFT
		 LDX DEPTH
		 JMP _22	 ;WAS .3
_4	  	 DEC SURTMP
		 BNE _1
;--------------------------------
; DO UNDERGROUND WATER
;--------------------------------
		 JSR DO_UNDER
;--------------------------------
;  TURN ON SCREEN
;--------------------------------
ACT2	 	 LDA DEMO
		 BNE _1
		 LDA PLAYER
		 BEQ _3
		 JSR DO_BUCKS_2
		 JMP _4
_3	 	 JSR DO_BUCKS
_4	 	 JSR CHANGE_IRQ
		 JMP _2
_1	 	 JSR TURN_SCREEN_ON ;TURN ON SCREEN
_2	 	 LDA #$01    ;PUT CHOP ON PAD
		 STA LANDFG
		 RTS
;--------------------------------
;  CALCULATE PLOT ADDRESS
;--------------------------------
PLOTCL	 	 LDA PLOTY
		 LSR
		 LSR
		 LSR
		 ASL
		 TAX
		 LDA YTABLE,X
		 STA LO
		 LDA YTABLE+1,X
		 STA LO+1
		 LDA PLOTX
		 AND #$FC
		 ASL
		 PHP
		 CLC
		 ADC LO
		 STA LO
		 BCC _1
		 INC LO+1
_1	 	 LDA LO+1
		 PLP
		 ADC #$00
		 STA LO+1
		 LDA PLOTY
		 AND #$07
		 CLC
		 ADC LO
		 STA LO
		 BCC _2
		 INC LO+1
_2	 	 LDA PLOTX
		 AND #$03
		 TAX
		 LDA PLOTBL,X
		 STA PLOTBYT
		 RTS
;--------------------------------
;  YTABLE USED BY PLOTCL
;--------------------------------
YTABLE	 	 .word $6000
		 .word $6140
		 .word $6280
		 .word $63C0
		 .word $6500
		 .word $6640
		 .word $6780
		 .word $68C0
		 .word $6A00
		 .word $6B40
		 .word $6C80
		 .word $6DC0
		 .word $6F00
		 .word $7040
		 .word $7180
		 .word $72C0
		 .word $7400
		 .word $7540
		 .word $7680
		 .word $77C0
		 .word $7900
		 .word $7A40
		 .word $7B80
		 .word $7CC0
		 .word $7E00
		 .word $7F40
;--------------------------------
;   IRQ PLOT CALCULATOR
;--------------------------------
IRQ_PLOTCL LDA IRQ_PLOTY
		 LSR
		 LSR
		 LSR
		 ASL
		 TAX
		 LDA YTABLE,X
		 STA IRQ_LO
		 LDA YTABLE+1,X
		 STA IRQ_LO+1
		 LDA IRQ_PLOTX
		 AND #$FC
		 ASL
		 PHP
		 CLC
		 ADC IRQ_LO
		 STA IRQ_LO
		 BCC _1
		 INC IRQ_LO+1
_1	 	 LDA IRQ_LO+1
		 PLP
		 ADC #$00
		 STA IRQ_LO+1
		 LDA IRQ_PLOTY
		 AND #$07
		 CLC
		 ADC IRQ_LO
		 STA IRQ_LO
		 BCC _2
		 INC IRQ_LO+1
_2	 	 LDA IRQ_PLOTX
		 AND #$03
		 TAX
		 LDA PLOTBL,X
		 STA PLOTBYT
		 RTS
;--------------------------------
;  MOVE CLOUD
;--------------------------------
MOVE_CLOUD LDA CLOUD_TIM
		 BNE CLOUD_END
		 LDA CLOUD_FG
		 BNE _1
		 LDA #$40
		 STA CLOUD_TIM
		 JSR MAKE_RANDOM
		 AND #$01
		 STA CLOUD_DIR
		 ASL
		 TAX
		 LDA PLNORG,X
		 STA CLOUD_X
		 LDA PLNORG+1,X
		 STA CLOUD_XMSB
		 LDA #$01
		 STA CLOUD_FG
;--------------------------------
_1	 	 DEC CLOUD_TIM
		 LDA CLOUD_DIR
		 BNE _11
;--------------------------------
		  LDA CLOUD_XMSB
		  BNE _3
		  LDA CLOUD_X
		  CMP #$02
		  BEQ _5
_3	  	 LDA CLOUD_X
		  SEC
		  SBC #$01
		  STA CLOUD_X
		  BCS CLOUD_END
		  LDA #$00
		  STA CLOUD_XMSB
		  BEQ CLOUD_END   ;ALWAYS
;--------------------------------
_11	  	  LDA CLOUD_XMSB
		  BEQ _4
		  LDA CLOUD_X
		  CMP #$55
		  BEQ _5
_4	  	  LDA CLOUD_X
		  CLC
		  ADC #$01
		  STA CLOUD_X
		  BCC CLOUD_END
		  LDA #$01
		  STA CLOUD_XMSB
		  BNE CLOUD_END    ;ALWAYS
_5	  LDA #$00
		  STA CLOUD_FG
CLOUD_END  DEC CLOUD_TIM
		  RTS
;--------------------------------
CLEAR_SPRITES 	  LDX #$00
_1	     	  TXA
		  ASL
		  TAY
		  LDA #$00
		  STA SPRITE_YPOS,Y
		  INX
		  CPX #$07
		  BNE _1
		  RTS
;--------------------------------
TURN_SCREEN_ON    LDA #$10
		  ORA VIC_CONTROL_1
		  STA VIC_CONTROL_1
		  RTS
