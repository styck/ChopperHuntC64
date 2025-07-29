;--------------------------------
;  FILL HOLES UP WITH WATER
;--------------------------------
WATER_FALL LDX WPHASE
	 BEQ WTRFL1
;--------------------------------
	 CPX #$01
	 BNE _3
	 JMP HOSCAN
_3	 CPX #$02
	 BNE _11
	 JMP HOLE
_11	 CPX #$03
	 BNE _1
	 JMP BOTLP2
_1	 CPX #$04
	 BNE _2
	 JMP GOTBL
_2	 CPX #$05
	 BNE WTRFL1
	 JMP BOTL3A
;--------------------------------
WTRFL1	 INC SCAN_Y
	 LDA SCAN_Y
	 CMP #$B0
	 BCC _1
;--------------------------------
	 LDA SCAN_X
	 CLC
	 ADC #$08
	 CMP #$98     ;SINCE SCREEN IS SQUEEZED
	 BCC _2
;--------------------------------
	 LDA START
	 BEQ _11
	 LDA #$00
	 BEQ _22
_11	 LDA #$04
_22	 STA START
;--------------------------------
_2	 STA SCAN_X
	 LDA INILVL
;--------------------------------
	 STA SCAN_Y
_1	 STA WATERY
	 STA PLOTY
;--------------------------------
	 LDA SCAN_X
	 STA WATERX
	 STA PLOTX
	 LDA #$01
	 STA TEMP2
_6	 JSR PLOTCL
;--------------------------------
; SCAN BYTE FOR WATER
;--------------------------------
_7	 JSR SCAN_BYTE
	 BNE FRIGHT	 ;FOUND WATER
;--------------------------------
	 LDA TEMP2
	 BEQ _5
;--------------------------------
	 LDA DUD
	 CLC
	 ADC #$04
	 CMP #$98     ;SINCE SCREEN IS SQUEEZED
	 BCC _4
;--------------------------------
	 LDA #$00
;--------------------------------
_4	 STA DUD
	 STA WATERX
	 STA PLOTX
	 LDA INILVL
	 STA PLOTY
	 STA WATERY
	 DEC TEMP2
	 JMP _6
;--------------------------------
_5	 RTS
;--------------------------------
; SCAN RIGHT FOR A HOLE
;--------------------------------
FRIGHT	 LDA WATERY
	 STA WATER_TOP
;--------------------------------
_1	 INC WATERX  ;SCAN RIGHT UNTIL
	 JSR CHECK   ;NOT WATER
	 STA TEMP1
	 LDA TYPE2   ;EITHER DIRT OR A HOLE
	 BNE _1
	 LDA TEMP1
	 BNE HOLE    ;A=1 IF HOLE
;--------------------------------
; DIDNT FIND HOLE. NOW SCAN LEFT
;--------------------------------
;  PHASE 1
;--------------------------------
HOSCAN	 LDA #$01
	 STA WPHASE
	 LDA WATERX
	 BNE _11
	 JMP ZEROPH
;--------------------------------
; SCAN LEFT FOR HOLE
;--------------------------------
_11	 DEC WATERX
	 JSR CHECK
	 BNE HOLE    ;A=1 IF HOLE
	 LDX TYPE2
	 BNE _1      ;TYPE2=1 IF WATER
;--------------------------------
; IT WAS DIRT. GO DOWN ONE
;--------------------------------
	 JMP ZEROPH
_1	 INC WATERY
	 JSR CHECK
	 BNE HOLE    ;A=1 IF HOLE
;--------------------------------
; IT WAS STILL DIRT. BACKUP ONE
;--------------------------------
	 DEC WATERY
	 RTS	    ;***
;--------------------------------
; PHASE 2  (FOUND A HOLE)
;--------------------------------
HOLE	 LDA #$02
	 STA WPHASE
;--------------------------------
; GO DOWN ONE
;--------------------------------
_1	 INC WATERY
	 CMP #$B0
	 BPL BOTLP2
;--------------------------------
	 LDA WLO	  ;WLO SET IN CHECK SUBROUTINE
	 CLC
	 ADC #40
	 STA WLO
	 LDA #$00
	 ADC WHI
	 STA WHI
;--------------------------------
	 LDA BOMB_MASK,X
	 EOR #$FF
	 LDY #$00
	 AND (WLO),Y
	 BEQ _1
;--------------------------------
; NOT A HOLE. GO UP ONE
;--------------------------------
HOLE2	 DEC WATERY
;--------------------------------
;  PHASE 3 (WE FOUND BOTTOM OF HOLE)
;--------------------------------
BOTLP2	 LDA #$03
	 STA WPHASE
	 LDA WATERX
	 BEQ GOTBL
;--------------------------------
; SCAN LEFT (MAKE SURE AT BOTTOM)
;--------------------------------
	 DEC WATERX
	 JSR CHECK
	 BNE BOTLP3	;A=1 IF HOLE
;--------------------------------
; WASNT A HOLE. FOUND BOTTOM LEFT
;--------------------------------
	 INC WATERX
	 JMP GOTBL
;--------------------------------
; STILL A HOLE. GO DOWN ONE
;--------------------------------
BOTLP3	 INC WATERY
	 JSR CHECK
	 BNE HOLE	;IF STILL A HOLE KEEP SCANNING DOWN
	 DEC WATERY
	 RTS
;--------------------------------
; PHASE 4  (FOUND BOTTOM LEFT)
;--------------------------------
GOTBL	 LDA #$04
	 STA WPHASE
	 LDA WATERX
	 STA WTRLFT
	 LDA WATERY
	 STA WTRLIN
;--------------------------------
; PHASE 5
;--------------------------------
BOTL3A	 LDA #$05
	 STA WPHASE
;--------------------------------
; SCAN RIGHT UNTIL NOT A HOLE
; CHECK DOWN ONE FOR HOLE
;--------------------------------
	 INC WATERX
	 JSR CHECK
	 BNE BOTLP4    ;A=1 IF HOLE
;--------------------------------
	 LDA WATERX
	 SEC
	 SBC WTRLFT
	 STA WTRLEN
	 JSR DOWATR    ;PLOT WATER
;--------------------------------
; GO UP AND LEFT AND GO TO PHASE 3
;--------------------------------
	 DEC WATERY
_2	 LDA WATERX
	 BEQ _1
	 DEC WATERX    ;!!!
	 JSR CHECK
	 STA TEMP1
	 LDA TYPE2
	 BNE ZEROPH
	 LDA TEMP1
	 BEQ _2        ;IT WAS DIRT
;--------------------------------
_1	 LDA WATERY
	 CMP WATER_TOP	;!!
	 BCC ZEROPH
	 LDA #$03
	 STA WPHASE
	 RTS
;--------------------------------
; PHASE 0
;--------------------------------
ZEROPH	 LDA #$00
	 STA WPHASE
	 RTS
;--------------------------------
BOTLP4	 INC WATERY
	 JSR CHECK
	 BEQ BOTLP5	;A=0 IF NOT HOLE
	 JMP HOLE	;MUST BE HOLE
BOTLP5	 DEC WATERY	;WASNT A HOLE
	 RTS
;--------------------------------
;   CHECK FOR HOLE
;   TYPE2=1 WHEN WATER
;   TYPE2=0 OTHERWISE
;   ACCUM=1 WHEN HOLE OR WHITE (BACKGROUND)
;   ACCUM=0 WHEN DIRT
;--------------------------------
CHECK	 LDA WATERX
	 STA PLOTX
	 LDA WATERY
	 STA PLOTY
	 JSR PLOTCL
	 LDA LO
	 STA WLO
	 LDA LO+1
	 STA WHI
	 LDA BOMB_MASK,X
	 EOR #$FF
	 LDY #$00
	 STY TYPE2
	 AND (LO),Y
	 BEQ _1
	 CMP BOMB_SHAPE,X
	 BNE CKCOLR
;--------------------------------
_1	 LDA #$01      ;A HOLE
	 RTS
CKCOLR	 CMP WATER_COLOR,X
	 BNE NOH
	 INC TYPE2
NOH	 LDA #$00
	 RTS
;--------------------------------
;   WATER PLOT ROUTINE
;--------------------------------
DOWATR	 LDA WTRLFT
	 STA PLOTX
	 LDA WTRLIN
	 STA PLOTY
_1	 JSR PLOTCL
	 LDA PLOTX
	 LDY #$00
	 AND #$03
	 TAX
	 LDA BOMB_MASK,X
	 AND (LO),Y
	 ORA WATER_COLOR,X
	 STA (LO),Y
	 INC PLOTX
	 DEC WTRLEN
	 BNE _1
	 RTS
;--------------------------------
;  DO UNDERGROUND WATER
;--------------------------------
DO_UNDER LDA UNDWTR	;IS THERE UNDER GROUND WATER
	 BNE _30
	 JMP UNDER_END	;NO
_30	 LDA BILEVL
	 AND #$30
	 BNE _21
	 LDA #$01
	 BNE _22
_21	 LDA UNDWTR
_22	 STA UNDTMP	;YES. #OF INTO UNDTMP
;--------------------------------
_1	 LDA #$05	;SET DEPTH WAS 5!!!
	 STA DEPTH
	 TAX
	 LDA INILVL
	 CLC
	 ADC #$10
	 STA MINDEP
;--------------------------------
_2	 JSR MAKE_RANDOM  ;GET Y POS OF
	 ROR
	 ROR
	 AND #$03	  ;WATER  !!!
	 ADC UNDTMP
	 TAY
	 LDA UNDER_Y,Y
	 CLC
	 ADC MINDEP
	 STA WTRLIN
;--------------------------------
_4	 JSR MAKE_RANDOM  ;GET X POS OF
	 ROR
	 ROR
	 AND #$03
	 ADC UNDTMP
	 TAY
	 LDA UNDER_X,Y
	 STA WTRLFT
;--------------------------------
_7	 LDX DEPTH
	 JSR MAKE_RANDOM
	 ROR
	 ROR
	 AND #$0F
	 CMP UNDMIN,X
	 BCC _7
	 CMP UNDMAX,X
	 BCS _7
	 STA WTRLEN
	 JSR DOWATR	;DRAW WATER LINE
	 DEC DEPTH	;NEXT DEPTH LINE
	 BEQ _8
	 JSR MAKE_RANDOM
	 ROR		 ;!!
	 ROR
	 AND #$03
	 STA UNDFAC
	 INC WTRLIN
	 LDX DEPTH
	 CPX #$03
	 BPL _9
	 LDA UNDFAC	;!!
	 CLC
	 ADC WTRLFT
	 BNE _10
_9	 LDA WTRLFT
	 SEC
	 SBC UNDFAC
_10	 STA WTRLFT
	 JMP _7
_8	 DEC UNDTMP
	 BEQ UNDER_END
	 JMP _1
UNDER_END  RTS
;--------------------------------
;  DRAW MOUNTAINS
;--------------------------------
DO_MOUNT LDA INILVL
	 STA PLOTY
	 LDA #$00
	 STA PLOTX
	 JSR PLOTCL
	 LDA LO
	 STA TEMP1
	 LDA LO+1
	 STA TEMP2
;--------------------------------
	 LDA INILVL
	 SEC
	 SBC #$18   ;MOUNTAINS ARE THREE CHARACTERS HIGH
	 STA PLOTY
	 JSR PLOTCL
;--------------------------------
	 LDA LO+1
	 PHA
	 LDA LO
	 PHA
	 LDA BUSH_LO+1
	 PHA
	 LDA BUSH_LO
	 PHA
	 JSR SUB16
	 PLA
	 STA BUSH_OFFSET
	 PLA
	 STA BUSH_OFFSET+1
;--------------------------------
	 LDA BUSH_LO  ;STORE ADDRESS
	 STA TEMP3    ;OF MOUNTAIN
	 LDA BUSH_HI  ;TABLE
	 STA TEMP4
	 LDY #$00
_2	 LDA (TEMP3),Y
	 STA (LO),Y
	 INC TEMP3
	 INC LO
	 LDA LO
	 CMP TEMP1
	 BNE _2
	 LDA LO+1
	 CMP TEMP2
	 BNE _2
	 RTS
;--------------------------------
;  PUT COLOR IN SCREEN MEM
;--------------------------------
DO_COLOR LDA BILEVL
	 AND #$03
	 ASL
	 TAX
	 LDA SCR_MEM_LO,X
	 STA TEMP5
	 LDA SCR_MEM_LO+1,X
	 STA TEMP6
	 LDA #$78	   ;***
	 STA TEMP1
	 LDA SCR_LO
	 STA TEMP3
	 LDA SCR_HI
	 STA TEMP4
;--------------------------------
	 LDY #$00
_22	 LDA (TEMP3),Y
	 STA (TEMP5),Y
	 INC TEMP3
	 INC TEMP5
;--------------------------------
	 DEC TEMP1
	 BNE _22
;--------------------------------
; SAME FOR COLOR MEM
;--------------------------------
	 LDA BILEVL
	 AND #$03
	 ASL
	 TAX
	 LDA COLOR_MEM_LO,X
	 STA TEMP5
	 LDA COLOR_MEM_LO+1,X
	 STA TEMP6
;--------------------------------
	 LDA #$79
	 STA TEMP1
	 LDA ATT_LO
	 STA TEMP3
	 LDA ATT_LO+1
	 STA TEMP4
;--------------------------------
	 LDY #$00
_33	 LDA (TEMP3),Y
	 STA (TEMP5),Y
	 INC TEMP3
	 INC TEMP5
;--------------------------------
	 DEC TEMP1
	 BNE _33
	 RTS
;--------------------------------
; CHECK FOR CHOPPER COLLISION
; WITH FALLING DIRT BY CHECKING
; X Y LOCATIONS
;--------------------------------
DIRT_CHECK LDX ROCNT
	 BNE _11
	 JMP _9
;--------------------------------
_11	 LDA CHOP_Y
	 SEC
	 SBC #$33	;TOP LEFT CORNER OF CHOPPER
	 STA PLOTY
	 LDA CHOP_X
	 SEC
	 SBC #$15
	 STA TEMP1
	 LDA CHOP_XMSB
	 SBC #$00
	 LSR
	 ROR TEMP1
	 LDA TEMP1
	 STA PLOTX
;--------------------------------
	 LDA #$04
	 STA BSY
_2	 LDA #$04
	 STA BSX
;--------------------------------
;  CHECK BOTTOM ROW OF DIRT
;  BY SCANNING EACH COLUMNS
;  X-Y COORDINATES
;--------------------------------
_1	 LDX ROCNT   			;***
_6	 LDA KILL_DIRT_FLAG,X	;CHECK IF DIRT WAS DESTROYED
	 BEQ _66			;NO
;--------------------------------
	 JMP _5 	  ;YES,CHECK NEXT ONE
;--------------------------------
_66	 LDA RX1,X
	 CMP PLOTX
	 BNE _3
;--------------------------------
	 LDA RY1,X
	 CMP PLOTY
	 BEQ _33
;--------------------------------
	 SEC
	 SBC #$02
	 CMP PLOTY
	 BNE _3
;--------------------------------
_33	 JMP DIRT_COLLIDE
;--------------------------------
_3	 LDA RX2,X
	 CMP PLOTX
	 BNE _4
;--------------------------------
	 LDA RY2,X
	 CMP PLOTY
	 BEQ _44
;--------------------------------
	 SEC
	 SBC #$04
	 CMP PLOTY
	 BNE _4
;--------------------------------
_44	 JMP DIRT_COLLIDE
;--------------------------------
_4	 LDA RX5,X
	 CMP PLOTX
	 BNE _5
;--------------------------------
	 LDA RY5,X
	 CMP PLOTY
	 BEQ _55
;--------------------------------
	 SEC
	 SBC #$03
	 CMP PLOTY
	 BNE _5
;--------------------------------
_55	 JMP DIRT_COLLIDE
;--------------------------------
_5	 DEX
	 BPL _6
;--------------------------------
	 INC PLOTX
	 INC PLOTX
	 DEC BSX
	 DEC BSX
	 BPL _1
;--------------------------------
	 LDA PLOTX
	 SBC #$06
	 STA PLOTX
	 INC PLOTY
	 DEC BSY
	 INC PLOTY
	 DEC BSY
	 BPL _2
;--------------------------------
_9	 RTS
;--------------------------------
DIRT_COLLIDE  LDA #$01
	    STA HIT0
	    RTS
;--------------------------------
;  DID WE LAND?
;--------------------------------
CHECK_LAND LDA LANDFG
	 BNE LANDED
;--------------------------------
	 RTS
;--------------------------------
LANDED	 LDA #75
	 STA BOMBLD
	 LDA #7
	 STA BDIG1
	 CLC
	 ADC #$30
	 STA SCOLIN+09
	 LDA #5
	 STA BDIG2
	 CLC
	 ADC #$30
	 STA SCOLIN+10
;--------------------------------
	 LDA #$00
	 STA LANDFG
	 STA INCUD
	 STA INCLR
;--------------------------------
	 LDA FERRY
	 BEQ DONE_LAND	 ;NO BUCKS
;--------------------------------
;  ADD IN AMOUNT FOR BUCK
;--------------------------------
	 LDA #$01
	 STA LAND_SOUND  ;DO LAND SOUND
;--------------------------------
	 LDA #$00
	 STA FERRY
	 STA SPRITE_COLLISION
	 LDX FERIX
	 STA SHOB1,X
	 LDA BUCVL1
	 STA SCOCHG
	 LDA #$04
	 STA SCOPOS
	 JSR ADDSCO
	 LDA BUCVL2
	 STA SCOCHG
	 LDA #$05
	 STA SCOPOS
	 JSR ADDSCO
	 LDA #$FF
	 STA FERIX
DONE_LAND  RTS
;--------------------------------
; ACCOUNT FOR CHOPPER OPERATION
;--------------------------------
SUB_ONE	 LDA TIMER6
	 BNE _1
;--------------------------------
	 LDA #15
	 STA TIMER6
	 LDA #07      ;SUBTRACT $1
	 STA SCOPOS
	 LDA #$01
	 STA SCOCHG
	 JSR SUBSCO
;--------------------------------
_1	 RTS
;--------------------------------
SCAN_BYTE  LDX #$00
	 LDY #$00
_1	 LDA BOMB_MASK,X
	 EOR #$FF
	 AND (LO),Y
;--------------------------------
; 	 STA $FE
; 	 LDA (LO),Y
; 	 STA $FF
; 	 LDA #$AA
; 	 STA (LO),Y
; 	 LDA $FF
; 	 STA (LO),Y
; 	 LDA $FE
;--------------------------------
	 CMP WATER_COLOR,X
	 BEQ FOUND_IT
	 INC WATERX
	 INX
	 CPX #$03
	 BPL _1
	 LDA #$00  ;NOT WATER
	 RTS
FOUND_IT LDA #$01  ;FOUND WATER
	 RTS
