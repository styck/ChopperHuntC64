;--------------------------------
DO_BUCKS	 LDA #$02     ;3 BUCKS
		 STA BUC_NUM
;--------------------------------
_12	 	 LDA #$0A     ; 10 TRYS
		 STA BUCTRY
;--------------------------------
_1	 	 JSR MAKE_RANDOM ;GET BUCKS HORIZONTAL
		 ROR
		 ROR
		 AND #$01
		 STA TEMP1
		 LDA BUC_NUM
		 ASL		; *2
		 CLC
		 ADC TEMP1
		 TAX
		 LDA BUC_XPOS,X
;--------------------------------
		 LDX BUC_NUM  ;SAVE HORIZONTAL POSITION
; 	 	 STA BUCHPC   ;(USED BY CHECK_POS)
		 STA BHPO,X
		 STA B2HPO,X
		 JSR MAKE_RANDOM  ;GET RANDOM MSB
		 LDA #$00
		 LDX BUC_NUM
; 	 	 STA BUCHPC_XMSB
		 STA BHPO_XMSB,X
		 STA B2HPO_XMSB,X
;--------------------------------
_16	 	 JSR MAKE_RANDOM
		 AND #$01
		 CLC
		 ADC BUC_NUM
_18	 	 TAX
;--------------------------------
		 LDA BILEVL
		 AND #$07
		 CLC
		 ADC #$02
		 STA TEMP1    ;# OF LEVELS OF DIRT
;--------------------------------
_20	 	 CPX TEMP1        ;X<TEMP1
		 BCC _19      ;YES
		 DEX
		 JMP _20
;--------------------------------
_19	 	 LDA BUC_YPOS,X
_29	 	 LDX BUC_NUM
		 STA BUCVPC    ;SAVE VERTICAL POSITION
		 STA BUC1VP,X  ;(USED BY CHECK_POS)
		 STA B2C1VP,X
;--------------------------------
		 DEC BUC_NUM   ;NEXT BUCK
		 BMI _2
		 JMP _12
;--------------------------------
_4	 	 DEC BUCTRY	 ;TRY AGAIN
		 BMI _2
		 JMP _1
;--------------------------------
_2	 	 LDA BHPO      ;LET IRQ PUT
		 STA BUC1_X    ;BUCKS ON SCREEN
		 LDA BHPO+1
		 STA BUC2_X
		 LDA BHPO+2
		 STA BUC3_X
;--------------------------------
		 LDA #$00
		 STA BUC1_XMSB
		 STA BUC2_XMSB
		 STA BUC3_XMSB
;--------------------------------
		 LDA BUC1VP  ;ENTER HERE FOR
		 STA BUC1_Y  ;PLAYER #2
		 LDA BUC2VP
		 STA BUC2_Y
		 LDA BUC3VP
		 STA BUC3_Y
;--------------------------------
		 LDA #$01   ;INDICATE THAT ALL
		 STA SHOB1  ;BOMBS ARE ON SCREEN
		 STA SHOB2
		 STA SHOB3
		 RTS
;--------------------------------
;  PICKED UP BUCKS?
;--------------------------------
BUCK_CHECK LDA FERRY           ;CARRYING $'S?
		 BNE DONE_CK
		 LDA DEAD      ;DEAD
		 BNE DONE_CK   ;YES
		 LDA LANDFG    ;LANDED
		 BNE DONE_CK   ;YES
		 LDA CHOP_EXPL ;CHOPPER EXPLODING
		 BNE DONE_CK   ;YES
		 LDA SPRITE_COLLISION
		 AND #$38      ;CHOP AND BUCK COLLISIONS ONLY
		 BEQ DONE_CK   ;NO COLLISIONS
;--------------------------------
		 LDA SPRITE_COLLISION	;CHECK IF COLLIDING WITH CHOPPER
		 AND #$01
		 BEQ DONE_CK		;CHOPPER IS NOT PART OF COLLISION
;--------------------------------
		 LDA #$01
		 STA NOUPDT		;DONT ALLOW COLL. UPDATE
_11	 	 LDA SPRITE_COLLISION
		 AND #$08		;CHECK SPRITE #3
		 BEQ _1 		;NOT SPRITE #3
		 LDA #$00	        ;CARRYING BUCK 0
		 STA FERIX
		 JMP _3
;--------------------------------
_1	 	 LDA SPRITE_COLLISION
		 AND #$10		;CHECK SPRITE #4
		 BEQ _2 		;NOT SPRITE #4
		 LDA #$01	        ;CARRYING BUCK 1
		 STA FERIX
		 JMP _3
;--------------------------------
_2	 	 LDA SPRITE_COLLISION
		 AND #$20		;CHECK SPRITE #5
		 BEQ UPDATE_ON		;NOT SPRITE #5	(IF IT GOT HERE NO PRIZES INVOLVED)
		 LDA #$02	        ;CARRYING BUCK 2
		 STA FERIX
_3	 	 LDA #$01	        ;WE ARE CARRYING A BUCK
		 STA FERRY
		 LDA #$01	        ;DO PICKED UP
		 STA BUC_SOUND	        ;BUC SOUND
		 LDA FERIX	        ;DID WE GET BUC1
		 BNE _4 	        ;NO
;--------------------------------
		 JSR CLEAR_B1	        ;REMOVE FROM SCREEN
		 JMP UPDATE_ON
;--------------------------------
_4	 	 CMP #$01	     ;DID WE GET BUC2
		 BNE _5 	     ;NO
		 JSR CLEAR_B2	     ;REMOVE FROM SCREEN
		 JMP UPDATE_ON
;--------------------------------
_5	 	 CMP #$02	     ;DID WE GET BUC3
		 BNE UPDATE_ON	     ;NO
		 JSR CLEAR_B3	     ;REMOVE FROM SCREEN
UPDATE_ON  	 LDA #$00	     ;DEC NOUPDT
		 STA NOUPDT
DONE_CK	 	 RTS
;--------------------------------
; MOVE BUCKS OFF SCREEN BUT
; DONT ALLOW THEM TO COLLIDE
; WITH EACH OTHER
;--------------------------------
CLEAR_B1	 LDA #$00
		 STA BUC1_X
		 STA BUC1_XMSB
		 LDA #$10
		 STA BUC1_Y
		 LDA #$00
		 STA SHOB1
		 RTS
;--------------------------------
CLEAR_B2	 LDA #$00
		 STA BUC2_X
		 STA BUC2_XMSB
		 LDA #$40
		 STA BUC2_Y
		 LDA #$00
		 STA SHOB2
		 RTS
;--------------------------------
CLEAR_B3	 LDA #$00
		 STA BUC3_X
		 STA BUC3_XMSB
		 LDA #$70
		 STA BUC3_Y
		 LDA #$00
		 STA SHOB3
		 RTS
;--------------------------------
; DROP PRIZES IF NECESSARY
;--------------------------------
BUCFALL_CK LDA BUCHIT
		 AND #$08     ;SPRITE #3 COLLISION
		 STA BHIT1    ;(BUC1)
		 LDA BUCHIT
		 AND #$10     ;SPRITE #4 COLLISION
		 STA BHIT2    ;(BUC2)
		 LDA BUCHIT
		 AND #$20     ;SPRITE #5 COLLISION
		 STA BHIT3    ;(BUC3)
;--------------------------------
		 LDX #$02
_1	 STX BFXHLD
		 LDA FERRY    ;ARE WE CARRYIN ANY BUCS
		 BEQ _2       ;NO
		 LDA FERIX    ;ARE WE CARRYING THIS BUC
		 CMP BFXHLD
		 BEQ _3       ;YES. DONT HAVE TO CHECK IT
;--------------------------------
_2	 LDA SHOB1,X   ;IS BAG ON SCREEN
		 BEQ _3        ;NO
;--------------------------------
		 LDA BHIT1,X   ;IS BAG HITTING DIRT
		 BNE _3        ;YES,CHECK NEXT ONE
;--------------------------------
		 LDY BUC1VP,X  ;INCREMENT THE BUCKS
		 INY	       ;Y POSITION
		 STY BUC1VP,X
		 CPY #$D5      ;IS IT AT THE BOTTOM
		 BCC _4        ;NO
;--------------------------------
; CLEAR THE ONE THAT DROPED THROUGH
; THE BOTTOM OF THE SCREEN
;--------------------------------
		 LDA BFXHLD    ;BUC1
		 BNE _5        ;NO
		 JSR CLEAR_B1  ;REMOVE FROM SCREEN
		 JMP _3
;--------------------------------
_5	 	 CMP #$01          ;BUC2
		 BNE _6            ;NO
		 JSR CLEAR_B2      ;REMOVE FROM SCREEN
		 JMP _3
_6	 	 JSR CLEAR_B3      ;MUST BE BUC3. REMOVE IT
_3	 	 LDX BFXHLD        ;NEXT BUC
		 DEX
		 BPL _1
		 RTS
_4	 	 JSR SHOW_BUCK
		 JMP _3
;--------------------------------
SHOW_BUCK  	 LDA BUC1VP
		 STA BUC1_Y
		 LDA BUC2VP
		 STA BUC2_Y
		 LDA BUC3VP
		 STA BUC3_Y
		 RTS
;--------------------------------
; RANDOM NUMBER GENERATOR
;--------------------------------
MAKE_RANDOM 	  INC SEED
		  LDA RANDOM
		  ASL
		  EOR SEED
		  ASL
		  EOR RANDOM
		  ROL RANDOM
		  LDA RANDOM
		  BNE _1
		  LDA SEED
		  ORA #$63
		  STA RANDOM
_1	  	  RTS
;--------------------------------
;  CHOPPER CODE
;--------------------------------
CHOPPR	 	 LDA NPWAIT  ;WAITING FOR NEW PLAYER
		 BEQ CHOPR2  ;NO
		 RTS
CHOPR2	 	 LDA HIT0    ;CHOPPER HIT BACKGROUND?
		 BEQ CHOPR3  ;NO
		 JMP CRASH
;--------------------------------
;  SUBTRACT 1$ FOR EACH PIXEL
;  OF GROUND DESTROYED
;--------------------------------
CHOPR3	 	 LDA DEAD        ;IS HE DEAD
		 BEQ _11	 ;NO
		 JMP CHOP_END	 ;YES
;--------------------------------
_11	 	 LDA DRTHIT      ;ARE WE HITTING DIRT
		 BEQ _1          ;NO
;--------------------------------
		 DEC DRTHIT
		 LDA #$01
		 STA SCOCHG
		 LDA #$07
		 STA SCOPOS
		 JSR SUBSCO
		 LDA DEAD   ;@@@
		 BEQ _1
		 RTS
;--------------------------------
; CHECK IF ALL BUCKS ARE PICKED UP
;--------------------------------
_1	 	 LDA SHOB1   ;ALL THESE SHOULD
		 ORA SHOB2   ;ARE READY FOR
		 ORA SHOB3   ;NEXT LEVEL
		 ORA FERRY
		 BEQ _22
		 JMP CHOP_END
;--------------------------------
; PAUSE A BIT FOR REFRESHMENTS
; IF ALL BUCKS ARE PICKED UP
;--------------------------------
_22	 	 LDA #$01
		 STA INCUD
		 STA INCLR
		 STA LAND_SOUND
		 JSR DO_SOUNDS
;--------------------------------
; INCREMENT LIVES IF PLAYER WASNT
; KILLED DURING LEVEL
;--------------------------------
		 LDX PLAYER
		 LDA LIVES,X
		 BEQ _3
		 CMP #99
		 BEQ _3
		 LDA LIVES,X
		 ADC DIE_FLAG,X
		 STA LIVES,X
		 LDA DIE_FLAG,X
		 BEQ _3
		 INC LIFE1,X
		 LDA LIFE1,X
		 CMP #10
		 BMI _3
		 INC LIFE2,X
		 LDA #$00
		 STA LIFE1,X
;--------------------------------
_3	 	 JSR SHOW_LIVES
		 LDA #$0A
		 STA MASTER_VOLUME
		 LDY #$00
_2	 	 TYA
		 PHA			      ;UP
		 JSR DELAY
		 JSR DELAY
		 JSR DO_SOUNDS
		 JSR DO_PAD
		 JSR DO_EXPLOSIONS
		 JSR DO_GUN_FALL
		 JSR GUN_SHOOT
		 JSR DROP_DIRT
		 JSR DO_EXPLOSIONS
		 PLA
		 TAY
_6	 	 LDX VIC_CONTROL_1
		 BPL _6
		 TYA
		 AND #$18
		 STA BORDER_COLOR
		 INY
		 CPY #$D0
		 BNE _2
;--------------------------------
		 STY BORDER_COLOR
		 JSR TURN_SCREEN_OFF	   ;**************
		 LDA #$01   ;ALL BUCKS ARE
		 STA NPWAIT ;PICKED UP. READY FOR NEXT LEVEL
;--------------------------------
		 LDA #$00
		 STA GUN_PHASE
		 STA SHOT_SOUND
		 STA SHOTON
		 STA GUNSHT
CHOP_END	 RTS
;--------------------------------
; DO CHOPPER ROTATION
;--------------------------------
CHECK_ROT  	 LDA TIMER4	;SET IN IRQ1
		 BNE _6 	;NOT TIME TO ROTATE
		 LDA #$05
		 STA TIMER4
;--------------------------------
		 LDA BODPH
		 BEQ _11
		 CMP #$02
		 BEQ _11
		 CMP #$04
		 BEQ _11
;--------------------------------
		 LDA ROTATE_LEFT
		 BEQ _22
		 DEC BODPH
		 LDA #$00
		 STA ROTATE_LEFT
		 JMP _11
;--------------------------------
_22	 	 LDA ROTATE_RIGHT
		 BEQ _11
		 INC BODPH
		 LDA #$00
		 STA ROTATE_RIGHT
;--------------------------------
_11	 	 LDA STICK_TMP
		 ROR		;UP
		 ROR		;DWN
		 ROR		;LFT
		 BCS _2
;-------------------------------
; MOVING LEFT
;--------------------------------
		 PHA
		 LDA BODPH
		 BEQ _4
		 DEC BODPH
		 LDA #$01
		 STA ROTATE_LEFT
_4	 	 PLA
;-------------------------------
; MOVING RIGHT
;--------------------------------
_2	 	 ROR
		 BCS _6
		 LDA BODPH
		 CMP #$04
		 BEQ _6
		 INC BODPH
		 LDA #$01
		 STA ROTATE_RIGHT
;-------------------------------
_6	 	 LDA BODPH
		 BEQ _7
		 LDA BODPH
		 CMP #$04
		 BEQ _7
;--------------------------------
		 LDA #$01     ;DONT MOVE LEFT OR RIGHT IF
		 STA INCLR    ;FACING FORWARD
		 RTS
;--------------------------------
_7	 	 LDA #$00     ;FACING RIGHT
		 STA INCLR    ;OR LEFT SO MOVE CHOP
		 RTS
;-------------------------------
;  CRASH THE CHOPPER
;--------------------------------
CRASH	 	 LDA CHOP_EXPL
		 BEQ _11
;--------------------------------
		 JMP CHK_EXPL
;--------------------------------
_11	 	 LDA DEAD
		 BEQ _12
		 RTS
;--------------------------------
_12	 	 LDA #$01
		 STA INCUD	;STOP CHOPPER
;--------------------------------
		 LDA CHOP_Y
		 STA CHOP_YTEM
		 LDA #$FF	;MOVE CHOP OFF SCREEN
		 STA CHOP_Y
;--------------------------------
		 LDA #$01
		 STA CHOP_EXPL
;--------------------------------
		 LDA FERRY    ;CARRYING ANY BUCS
		 BEQ _9       ;NO
;--------------------------------
		 LDA #$00
		 STA FERRY
;--------------------------------
		 LDA FERIX    ;CARRYING BUC1
		 BNE _1       ;NO
;--------------------------------
		 LDA CHOP_X	 ;SET BUC POSITION
		 STA BUC1_X	 ;BELOW CHOPPER
		 LDA CHOP_XMSB
		 STA BUC1_XMSB
		 LDA CHOP_YTEM	 ;**
		 STA BUC1VP
		 STA BUC1_Y
;--------------------------------
		 LDA #$01     ;PRIZE #1 NOW ON
		 STA SHOB1    ;SCREEN
;--------------------------------
		 LDA #$FF
		 STA FERIX
;--------------------------------
		 JMP _9
;--------------------------------
_1	 	 CMP #$01             ;CARRYING BUC2
		 BNE _2       ;NO
;--------------------------------
		 LDA CHOP_X	 ;SET BUC2 POSITION
		 STA BUC2_X	 ;BELOW CHOPPER
		 LDA CHOP_XMSB
		 STA BUC2_XMSB
		 LDA CHOP_YTEM
		 STA BUC2VP
		 STA BUC2_Y
;--------------------------------
		 LDA #$01
		 STA SHOB2
;--------------------------------
		 LDA #$FF
		 STA FERIX
;--------------------------------
		 JMP _9
;--------------------------------
_2	 	 CMP #$02        ;CARRYING BUC3
		 BNE _9          ;NO
;--------------------------------
		 LDA CHOP_X	 ;SET BUC3 POSITION
		 STA BUC3_X	 ;BELOW CHOPPER
		 LDA CHOP_XMSB
		 STA BUC3_XMSB
		 LDA CHOP_YTEM
		 STA BUC3VP
		 STA BUC3_Y
;--------------------------------
		 LDA #$01
		 STA SHOB3
;--------------------------------
		 LDA #$FF
		 STA FERIX
;--------------------------------
;_8	  	 JSR SHOW_BUCK   ;SHOW THE BUC
;--------------------------------
_9	 	 LDA CHOP_YTEM	 ;CONVERT SPRITE COORDINATES
		 SEC		 ;O SCREEN COORDINATES
		 SBC #$2C
		 STA PLOTY
		 LDA CHOP_X
		 SEC
		 SBC #$10
		 STA TEMP1
		 LDA CHOP_XMSB
		 SBC #$00
		 LSR	     	 ;DIVIDE BY 2
		 ROR TEMP1
		 LDA TEMP1
		 STA PLOTX
;--------------------------------
;  DO EXPLOSION
;--------------------------------
		 LDA #$01
		 STA EXPGO+4
		 STA EXPGO+3
		 STA EXPGO+2
		 LDA PLOTX
		 STA EXPLR+4
		 CLC
		 ADC #$02
		 STA EXPLR+3
		 LDA PLOTX
		 SEC
		 SBC #$04
		 STA EXPLR+2
		 LDA PLOTY
		 STA EXPHT+4
		 CLC
		 SBC #$02
		 STA EXPHT+3
		 STA EXPHT+2
		 JSR DO_EXPLOSIONS
;--------------------------------
CHK_EXPL	 LDA EXPCNT  ;WAIT UNTIL EXPLOSIONS ARE DONE
		 BEQ _1
		 JMP CRASH_EXIT
;--------------------------------
_1	 	 STA CHOP_EXPL
WHY_ME	 	 LDX PLAYER
		 BPL _11      ;****
		 RTS
_11	 	 LDA LIVES,X  ;ANY LIVES LEFT
		 BEQ _1       ;NO
		 LDA #$00	;****
		 STA DIE_FLAG,X ;****
		 DEC LIVES,X
		 BNE _2
;--------------------------------
_1	 	 LDA #$01	 ;THIS PLAYER DEAD
		 STA DEAD	 ;GO LET NEXT PLAYER TRY
		 LDA #$00	 ;IF HE IS ALIVE
		 STA HIT0
;--------------------------------
_2	 	 DEC LIFE1,X
		 BPL _3
		 LDA #$09
		 STA LIFE1,X   ;PUT IT BACK TO NINE
		 LDA LIFE2,X
		 SEC
		 SBC #1
		 STA LIFE2,X
_3	 	 JSR SHOW_LIVES
;--------------------------------
		 LDA DEAD
		 BEQ NEW_LIFE
		 RTS
;--------------------------------
; PUT CHOPPER ON PAD  (NEWLIF)
;--------------------------------
NEW_LIFE	 LDA INICHT    ;YPOSITION OF CHOP
		 STA CHOP_Y
		 LDA #$00
		 STA CHOP_XMSB
		 LDA #$30      ;XPOSITION OF CHOP
		 STA CHOP_X
		 LDA #$04
		 STA BODPH     ;BODY PHASE OF CHOP
		 LDA #$01
		 STA LANDFG
		 LDA #$00
		 STA HIT0
CRASH_EXIT RTS
;--------------------------------
;  START PLANE MOVING
;--------------------------------
START_PLANE 	  LDA TRANSIT  ;PLANE MOVING
		  BNE _1       ;YES
;--------------------------------
		  JSR MAKE_RANDOM
		  LSR
		  AND #$01
		  STA PLNDIR
		  TAX
		  LDA PLN_SHAPE,X
		  STA SPRITE_POINTER+1
		  TXA
		  ASL
		  TAX
		  LDA PLNORG,X
		  STA PLANE_X
		  LDA PLNORG+1,X
		  STA PLANE_XMSB
		  LDA #$01
		  STA TRANSIT
		  STA PLANE_SOUND    ;START SOUND
		  LDA TRANCT
		  BEQ _1
		  DEC TRANCT  ;ONE MORE TRANSIT
_1	  	  RTS
;--------------------------------
;  TAKE CARE OF ABORTING
;--------------------------------
DO_ABORT	  LDA #$01
		  STA ABORT
		  STA INCUD
		  STA INCLR
;--------------------------------
		  LDA #$00
		  STA BOMB
		  STA BOMB+1
		  STA BOMB+2
		  STA BOMB+3
;--------------------------------
		  STA CHOP_EXPL
;--------------------------------
		  STA EXPCNT
;--------------------------------
		  STA EXPGO
		  STA EXPGO+1
		  STA EXPGO+2
		  STA EXPGO+3
		  STA EXPGO+4
		  STA EXPL_FREQ
		  STA EXPL_SOUND
		  STA BOMACT
		  STA BOMB_COUNT
		  STA ERASE_FLAG
		  STA GUNFAL
		  STA GUNFGO
		  STA ROCNT
;--------------------------------
		  LDX #20
_1	  	  STA CNT,X
		  DEX
		  BPL _1
;--------------------------------
ABDUM	  JSR ABORT_SOUND
;--------------------------------
		  LDA SHOB1
		  CLC
		  ADC SHOB2
		  ADC SHOB3
		  ADC FERRY
		  STA ABONUM
;--------------------------------
		  LDA #$00     ;NO LONGER CARRYING ONE
		  STA FERRY
		  LDA #$0A
		  STA MASTER_VOLUME
_1	  	  LDA #20
		  STA ABCNT
		  LDA #2
		  STA TIMER1
_2	  	  LDA #1
		  STA SCOCHG   ;SUBTRACT AMOUNT
		  LDA #$05     ;DIGIT POSITION
		  STA SCOPOS
		  JSR SUBSCO   ;SUBTRACT $100
;--------------------------------
		  LDA DEAD
		  BEQ _21
;--------------------------------
		  LDA #$00
		  STA MASTER_VOLUME
		  STA BORDER_COLOR
		  STA INCUD
		  STA INCLR
		  RTS
;--------------------------------
_21	  	  LDA ABCNT
		  ASL
		  ASL	     ;*4
		  STA FREQ_2
		  STA FREQ_2+1
		  ASL
		  STA FREQ_3
		  STA FREQ_3+1
		  DEC BORDER_COLOR
;--------------------------------
		  DEC ABCNT
		  BNE _3
;--------------------------------
		  DEC ABONUM
		  BNE _1
		  BEQ ABORT_END
;--------------------------------
_3	  	  LDX #$03
_4	  	  LDA TIMER1
		  BNE _4
		  LDA #$02
		  STA TIMER1
		  DEX
		  BPL _4
		  BMI _2
;--------------------------------
ABORT_END   	  LDA #$00
		  STA CONTROL_1
		  STA CONTROL_2
		  STA CONTROL_3
		  STA MASTER_VOLUME
		  STA BORDER_COLOR
		  STA INCUD
		  STA INCLR
		  RTS
;--------------------------------
;   CHECK ABORT
;--------------------------------
CHECK_ABORT 	  LDA ABORT_FLAG  ;ABORTING?
		  BEQ _1	  ;NO
;--------------------------------
		  JSR DO_ABORT	  ;YES,DO ABORT
		  LDA DEAD	  ;ARE WE DEAD
		  BNE _11	  ;YES
;--------------------------------
		  JSR PLRCHG	   ;IF NOT DEAD, DO PLAYER CHANGE
;--------------------------------
_11	  	  LDA #$00	  ;NO LONGER ABORTING
		  STA ABORT_FLAG
_1	  	  RTS
;--------------------------------
;   CHECK LIVES
;--------------------------------
CHECK_LIVES 	  LDA DEAD	        ;ARE WE DEAD
		  BEQ _1	;NO
		  LDA #$00
		  STA MASTER_VOLUME
		  LDA #$01
		  STA INCUD
;--------------------------------
		  LDA #$60
		  STA TEMP1
_2	  	  JSR DELAY
		  JSR DELAY
		  JSR DELAY
		  DEC TEMP1
		  BNE _2
;--------------------------------
		  LDA #$00
		  STA DEAD
		  JSR PLRCHG	   ;IF DEAD, DO PLAYER CHANGE
		  LDA PLAYER
		  BMI BOTH_DEAD
;--------------------------------
		  LDA #$00
		  STA DEAD
_1	  	  RTS
;--------------------------------
BOTH_DEAD   	  LDA #$01
		  STA BDEAD
		  LDA #$00
		  STA DEAD
		  RTS
;--------------------------------
DO_BUCKS_2  LDA B2HPO
		  STA BUC1_X
		  LDA B2HPO+1
		  STA BUC2_X
		  LDA B2HPO+2
		  STA BUC3_X
;--------------------------------
; 	  	  LDA #$00
; 	  	  STA BUC1_XMSB
; 	  	  STA BUC2_XMSB
; 	  	  STA BUC3_XMSB
;--------------------------------
		  LDA B2C1VP
		  STA BUC1VP
		  STA BUC1_Y
		  LDA B2C1VP+1
		  STA BUC1VP+1
		  STA BUC2_Y
		  LDA B2C1VP+2
		  STA BUC1VP+2
		  STA BUC3_Y
;--------------------------------
		  LDA #$01
		  STA SHOB1
		  STA SHOB2
		  STA SHOB3
;--------------------------------
		  RTS
