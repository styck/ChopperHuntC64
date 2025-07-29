;--------------------------------
;  SAVE DO.DIRT.CODE
;--------------------------------
BUSH_OFFSET .word $0000
;--------------------------------
DROP_DIRT  LDA ROCNT
 CMP ROCMAX
 BPL NODROP
 LDA DROPWT
 BEQ TRY
 LDA DROPGO
 BEQ NODROP
 LDA #$01
 STA DRPFLG
 LDA #$00
 STA DROPGO
 STA DROPWT
 BEQ NODROP
;--------------------------------
; LOOK FOR HOLE TO DROP DIRT IN
;--------------------------------
TRY  JSR MAKE_RANDOM
 CMP #155
 BCS TRY
 STA PLOTX
 LDA SOIL
 STA PLOTY
;--------------------------------
l2  JSR PLOTCL
;--------------------------------
 LDA PLOTX ; CHECK PIXEL
 AND #$03 ; TO SEE IF IT
 TAX ; IS BLACK
 LDY #$00
;--------------------------------
 LDA BOMB_MASK,X
 EOR #$FF
 AND (LO),Y
 BEQ l1
 DEC PLOTX
 BNE l2
 JMP NODROP
;--------------------------------
l1  LDA PLOTX ; FOUND HOLE
 CMP #$02 ; WHOLE ROCK ON SCREEN?
 BCS l3
 LDA #$02 ; RESET TO 2!!!
l3  STA DRPCOL
 LDA #$01
 STA DROPWT
;--------------------------------
NODROP  LDX PLOTX
 STX DROP1 ; SAVE X POSITION OF HOLE BIT
 LDY #$00
 LDA (LO),Y
 STA HOLD1
;--------------------------------
DIRT  LDA DRPFLG ; NEW DROP
 BEQ NXTDRP ; NO. GO UPDATE OTHERS
 LDA ROCNT
 CMP #$09
 BPL NXTDRP
 INC ROCNT
;--------------------------------
 LDA #$00 ; DIRT IS NOT DESTROYED
 LDX ROCNT
 STA KILL_DIRT_FLAG,X
;--------------------------------
; INIT DIRTS POSITION
;--------------------------------
 LDX ROCNT
 LDA DRPCOL
 STA RX3,X
 SEC
 SBC #$01
 STA RX2,X
 SBC #$01
 STA RX1,X
 LDA DRPCOL
 CLC
 ADC #$01
 STA RX4,X
 ADC #$01
 STA RX5,X
 ADC #$01
 STA RX6,X
 LDA #$0A ; INIT START OF GROUND
 STA RY1,X
 STA RY6,X
 LDA #$0B
 STA RY2,X
 STA RY5,X
 LDA #$0C
 STA RY3,X
 STA RY4,X
 LDA #$00
 STA DRPFLG
;--------------------------------
NXTDRP  LDA TIMER9
 BEQ NODRPD
 RTS ; RETURN
;--------------------------------
NODRPD  LDA FALSPD
 STA TIMER9
 LDA #$00
 STA DRPNUM
;--------------------------------
DROPLP  INC DRPNUM
 LDA ROCNT
 CMP DRPNUM
 BPL DRPIX
 RTS ; RETURN
;--------------------------------
DRPIX  LDA #$00
 STA MOVED ; MOVE FLAG FOR ALL COLUMNS
 LDA #$05 ; 6 COLUMNS OF FALLING DIRT
 STA DIRT_COLUMN
 LDA DRPNUM
 STA ROCOL
;--------------------------------
;  MAIN DIRT LOOP
;--------------------------------
DRPIX2  LDY DIRT_COLUMN
 LDA EOFS,Y
 STA EOFSET
 LDA EOFHT,Y
 STA HT
;--------------------------------
 LDX ROCOL
 LDA RX1,X
 STA PLOTX
 LDA RY1,X
 STA PLOTY
 INC PLOTY
;--------------------------------
 JSR PLOTCL
 JSR MOVEM ; MOVE COLUMN
 LDA MOVED2 ; DID COLUMN MOVE?
 BEQ NXTDIX ; NO IT DID NOT
;--------------------------------
 LDA PLOTY ; IT MOVED
 LDX ROCOL ; SAVE COLUMN Y
 STA RY1,X
NXTDIX  LDA ROCOL
 CLC
 ADC #11
 STA ROCOL
 DEC DIRT_COLUMN
 BPL DRPIX2
;--------------------------------
 LDA MOVED ; ANY COLUMNS MOVE?
 BEQ DREPAK ; NO. REPACK DIRT
 JMP DROPLP ; LOOP
;--------------------------------
;  REPACK DIRT TABLES
;--------------------------------
DREPAK  LDX DRPNUM
 LDY DRPNUM
DRPKLP  INX
 CPX ROCNT
 BEQ DRPK2
 BPL DRPKND
;--------------------------------
DRPK2  LDA RX1,X
 STA RX1,Y
 LDA RX2,X
 STA RX2,Y
 LDA RX3,X
 STA RX3,Y
 LDA RX4,X
 STA RX4,Y
 LDA RX5,X
 STA RX5,Y
 LDA RX6,X
 STA RX6,Y
;--------------------------------
 LDA RY1,X
 STA RY1,Y
 LDA RY2,X
 STA RY2,Y
 LDA RY3,X
 STA RY3,Y
 LDA RY4,X
 STA RY4,Y
 LDA RY5,X
 STA RY5,Y
 LDA RY6,X
 STA RY6,Y
;--------------------------------
 LDA KILL_DIRT_FLAG,X
 STA KILL_DIRT_FLAG,Y
;--------------------------------
 INY
 BNE DRPKLP
;--------------------------------
DRPKND  DEC ROCNT
 DEC DRPNUM
 JMP DROPLP
MOVEM  LDA #$00
 STA MOVED2
;--------------------------------
;  SEE IF DIRT WAS DESTROYED
;--------------------------------
;  LDX ROCOL
 LDX DRPNUM
 LDA KILL_DIRT_FLAG,X
 BEQ l99
 JMP MOVEM2 ; YES
;--------------------------------
l99  LDY #$00
 LDA PLOTX
 AND #$03
 TAX
;--------------------------------
 LDA PLOTY
 CMP #$B0 ; OFF SCREEN?
 BCC l11 ; NO
 JMP NOADV
;--------------------------------
l11  CMP INILVL ; ABOVE GROUND?
 BCS l5 ; NO
 JMP POF ; YES
;--------------------------------
;  BELOW GROUND CODE   !!!!
;--------------------------------
;  DONT MOVE DIRT INTO WATER
;--------------------------------
l5  LDA BOMB_MASK,X ; DONT MOVE
 EOR #$FF
 AND (LO),Y ; INTO WATER
 CMP WATER_COLOR,X
 BNE l12
l13  JMP NOADV
;--------------------------------
;  DONT MOVE DIRT INTO GROUND
;--------------------------------
l12  LDA BOMB_MASK,X
 EOR #$FF
 AND (LO),Y
 CMP DIRT_COLOR,X
 BEQ l13 ; JMP NOADV
;--------------------------------
 STA TEMP2 ; Save pixel data for collision check
 LDA PADLVL
 CLC
 ADC #$01
 STA TEMP1
 LDA PLOTY
 CMP TEMP1
 BEQ l44
;--------------------------------
 SEC
 SBC #$04
 CMP TEMP1
 BNE l4
;--------------------------------
l44  LDA PLOTX
 CMP #$38
 BCS l4
;--------------------------------
 JMP l_2 ; Plot dirt underground
;--------------------------------
l4  LDA TEMP2
  CMP BOMB_SHAPE,X ; DONT MOVE INTO EXPLOSION
  BEQ l3a ; (UNDER GROUND)
;--------------------------------
;  CHECK ABOVE DIRT FOR EXPLOSION
;--------------------------------
 LDA LO
 PHA
 LDA LO+1
 PHA
 LDA PLOTY
 PHA
 SEC
 SBC #$04
 STA PLOTY
 JSR PLOTCL
 LDA BOMB_MASK,X
 EOR #$FF
 AND (LO),Y
 TAY
;--------------------------------
 PLA
 STA PLOTY
 PLA
 STA LO+1
 PLA
 STA LO
;--------------------------------
 TYA
 LDY #$00
 CMP BOMB_SHAPE,X
 BNE l_2
;--------------------------------
;  DESTROY DIRT (UNDERGROUND)
;--------------------------------
;  LDX ROCOL
l3a  LDX DRPNUM
 LDA #$01
 STA KILL_DIRT_FLAG,X
 INC MOVED ; KEEP DIRT MOVING IF IT HIT
 JMP MOVEM2 ; AN EXPLOSION
;--------------------------------
; PLOT DIRT (UNDERGROUND)
;--------------------------------
l_2  LDY #$00 ; PLOT UNDERGROUND DIRT
 LDA BOMB_MASK,X
 AND (LO),Y
 ORA DIRT_COLOR,X
 STA (LO),Y
 JMP MOVEM2
;--------------------------------
; ABOVE GROUND CODE !!!!!
;--------------------------------
;
;--------------------------------
;  IF OVER PAD DONT CHECK FOR
;  COLLISION WITH EXPLOSION
;--------------------------------
POF  LDA PADLVL
 CLC
 ADC #$01
 STA TEMP1
 LDA PLOTY
 CMP TEMP1 ; TOP OF PAD
 BEQ l91
;--------------------------------
 SEC
 SBC #$04
 CMP TEMP1
 BEQ l91
;--------------------------------
 LDA PLOTY
 CMP PADLVL2 ; BOTTOM OF PAD
 BEQ l91
;--------------------------------
 SEC
 SBC #$04
 CMP PADLVL2
 BNE l_1
;--------------------------------
l91  LDA PLOTX
 CMP #$38
 BCS l_1
;--------------------------------
 JMP l15
;--------------------------------
l_1  LDA BOMB_MASK,X ; DONT MOVE
 EOR #$FF ; INTO EXPLOSION
 AND (LO),Y ; (IN SKY)
 CMP BOMB_SHAPE,X ; HITTING EXPLOSION?
 BEQ l90 ; NO
;--------------------------------
 LDA LO
 PHA
 LDA LO+1
 PHA
 LDA PLOTY
 PHA
 SEC
 SBC #$04
 STA PLOTY
 JSR PLOTCL
 LDA BOMB_MASK,X
 EOR #$FF
 AND (LO),Y
 TAY
;--------------------------------
 PLA
 STA PLOTY
 PLA
 STA LO+1
 PLA
 STA LO
;--------------------------------
 TYA
 LDY #$00
 CMP BOMB_SHAPE,X
 BNE l15
;--------------------------------
;  IF DESTROYED DONT PLOT
;  DESTOY DIRT (ABOVE GROUND)
;--------------------------------
;  LDX ROCOL    TRY TO DESTROY
l90  LDX DRPNUM
 LDA #$01 ; DIRT
 STA KILL_DIRT_FLAG,X
 INC MOVED
 JMP MOVEM2
;--------------------------------
;  PLOT THE DIRT (ABOVE GROUND)
;--------------------------------
l15  JSR MAKE_RANDOM
 ROR
 ROR
 AND #$03
 BEQ PEF
;--------------------------------
 LDA BOMB_MASK,X
 EOR #$FF
 STA TEMP1
 JMP PEFI
PEF  STA TEMP1
;--------------------------------
PEFI  LDY #$00 ; PLOT DIRT
 LDA BOMB_MASK,X
 AND (LO),Y
 ORA TEMP1
 STA (LO),Y
;--------------------------------
; GIVE DIRT ITS SHAPE (V-SHAPE)
;--------------------------------
MOVEM2  LDA PLOTY
 STA TEMP7
 LDA EOFSET
 CMP #40
 BNE l_22
 DEC PLOTY
 DEC PLOTY
 DEC PLOTY
 DEC PLOTY
 JMP l_4
l_22  CMP #80
 BNE l_3
 DEC PLOTY
 DEC PLOTY
 DEC PLOTY
 DEC PLOTY
 JMP l_4
l_3  CMP #120
 BNE l_4
 DEC PLOTY
 DEC PLOTY
 DEC PLOTY
 DEC PLOTY
l_4  JSR PLOTCL
;--------------------------------
; ERASE BEHIND DIRT
;--------------------------------
ERASE_DIRT LDA PLOTY ; OFF SCREEN
 CMP #$05 ; TOP (WHERE PLANE DROPS IT)
 BCC MOVFLG ; YES
 LDA PLOTY
 CLC
 ADC #$01
 CMP INILVL ; ABOVE GROUND?
 BCC l_5 ; YES
;--------------------------------
; DONT ERASE GROUND
;--------------------------------
 TXA
 TAY
;--------------------------------
 LDX DRPNUM
 LDA KILL_DIRT_FLAG,X
 BEQ l56
;--------------------------------
 TYA
 TAX
;--------------------------------
 LDY #$00
 LDA BOMB_MASK,X
 EOR #$FF
 AND (LO),Y
 CMP DIRT_COLOR,X
 BEQ NOADV
 CMP WATER_COLOR,X
 BEQ NOADV
;--------------------------------
l56  LDA PLOTX
 AND #$03
 TAX
 LDA PLOTY ; ABOVE GROUND?
 CLC
 ADC #$01
 CMP INILVL
 BCC l_5 ; YES
;--------------------------------
; BELOW GROUND (ERASE WITH BLACK)
;--------------------------------
 LDY #$00
 LDA (LO),Y
 AND BOMB_MASK,X
 STA (LO),Y
 JMP MOVFLG
;--------------------------------
l_5  LDA INILVL ; IF WE ARE ERASING
 SEC ; OVER MOUNTAINS THEN
 SBC #$18 ; STORE/RESTORE
 STA TEMP1
 LDA PLOTY
 CMP TEMP1
 BCS l55 ; YES. WE ARE ON MOUNTAINS
;--------------------------------
; ERASE WITH BLUE (ABOVE MOUNTAINS)
;--------------------------------
 LDY #$00 ; START DIRT OFF
 LDA (LO),Y ; SO WE DONT LEAVE
 AND BOMB_MASK,X ; DIRT ON THE TOP
 ORA WATER_COLOR,X
 STA (LO),Y
 JMP MOVFLG
;--------------------------------
;  RESTORE OVER MOUNTAINS
;--------------------------------
l55  JSR SETUP_ADDR
 LDY #$00
 LDA (LO),Y
 AND BOMB_MASK,X
 ORA (JLO),Y
 STA (LO),Y
;--------------------------------
MOVFLG  INC MOVED2
 INC MOVED
TESTIT  LDA TEMP7
 STA PLOTY
 RTS
;--------------------------------
NOADV  LDA PLOTY
 SEC
 SBC HT
 CMP INILVL
 BMI LEVLIT ; ITS ABOVE INILVL
 RTS
;--------------------------------
; LEVEL GROUND (RESTORE MOUNTAINS)
;--------------------------------
LEVLIT  LDA PLOTY
 STA TEMP6
 DEC PLOTY
;--------------------------------
l_lev1  JSR PLOTCL
 JSR SETUP_ADDR
;--------------------------------
 LDA PLOTY
 CMP INILVL
 BCS l_lev2
;--------------------------------
 LDY #$00
 LDA (JLO),Y
 STA (LO),Y
;--------------------------------
l_lev2  DEC PLOTY
 DEC HT
 BMI LVLFIN
 JMP l_lev1
LVLFIN  LDA TEMP6
 STA PLOTY
 LDX ROCOL ; *
 LDA #$B0 ; * BOTTOM OF SCREEN
 STA RY1,X ; *
;--------------------------------
 RTS
;--------------------------------
;  SET UP ADDRESSES FOR JLO AND LO
;  USED TO RESTORE MOUNTAINS
;--------------------------------
SETUP_ADDR LDA LO+1
 PHA
 LDA LO
 PHA
 LDA BUSH_OFFSET+1
 PHA
 LDA BUSH_OFFSET
 PHA
 JSR SUB16
 PLA
 STA JLO
 PLA
 STA JLO+1
 RTS
;--------------------------------
;   16BIT SUBTRACTION
;--------------------------------
SUB16  PLA
 STA TEMP5
 PLA
 STA TEMP6
 PLA
 STA TEMP3
 PLA
 STA TEMP4
 PLA
 SEC
 SBC TEMP3
 TAY
 PLA
 SBC TEMP4
 PHA
 TYA
 PHA
 LDA TEMP6
 PHA
 LDA TEMP5
 PHA
 RTS
;--------------------------------
;  IRQ: SET UP ADDRESSES FOR JLO AND LO
;--------------------------------
IRQ_SETUP_ADDR LDA IRQ_LO+1
 PHA
 LDA IRQ_LO
 PHA
 LDA BUSH_OFFSET+1
 PHA
 LDA BUSH_OFFSET
 PHA
 JSR IRQ_SUB16
 PLA
 STA IRQ_JLO
 PLA
 STA IRQ_JLO+1
 RTS
;--------------------------------
;   16BIT SUBTRACTION
;--------------------------------
IRQ_SUB16  PLA
 STA IRQ_TEMP5
 PLA
 STA IRQ_TEMP6
 PLA
 STA IRQ_TEMP3
 PLA
 STA IRQ_TEMP4
 PLA
 SEC
 SBC IRQ_TEMP3
 TAY
 PLA
 SBC IRQ_TEMP4
 PHA
 TYA
 PHA
 LDA IRQ_TEMP6
 PHA
 LDA IRQ_TEMP5
 PHA
 RTS
