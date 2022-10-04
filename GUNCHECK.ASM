 1000 *--------------------------------
 1010 * SAVE GUN.CHECK.CODE
 1020 *--------------------------------
 1030 GUN.CHECK   LDA GUN.LAND	     IS THE GUN ON THE GROUND?
 1040		  BEQ GUN.CHECK.END  NO
 1050 *--------------------------------
 1060		  LDA GUN.Y
 1070		  SEC
 1080		  SBC #$20
 1090		  STA PLOTY
 1100 *--------------------------------
 1110		  LDA GUN.X   CONVERT FROM SPRITE
 1120		  SEC	      COORDINATES TO
 1130		  SBC #$13    SCREEN COORDINATES
 1140		  STA TEMP1
 1150		  LDA GUN.XMSB
 1160		  SBC #$00
 1170		  LSR
 1180		  ROR TEMP1
 1190		  LDA TEMP1
 1200		  STA PLOTX
 1210 *--------------------------------
 1220		  LDA PLOTY
 1230		  CMP INILVL
 1240		  BNE GUN.CHECK.END
 1250 *--------------------------------
 1260 *  WE ARE LANDED CHECK IT
 1270 *--------------------------------
 1280		  INC PLOTY
 1290 *--------------------------------
 1300		  JSR PLOTCL
 1310 *--------------------------------
 1320		  LDY #$00
 1330		  LDA PLOTX
 1340		  AND #$03
 1350		  TAX
 1360		  LDA BOMB.MASK,X
 1370		  EOR #$FF
 1380		  AND (LO),Y	      IS IT DIRT
 1390		  CMP DIRT.COLOR,X
 1400		  BEQ GUN.CHECK.END   YES, LEAVE IT THERE
 1410 *--------------------------------
 1420 * THE GROUND BENEATH IS GONE
 1430 *--------------------------------
 1440		  LDA #$00   WASNT DIRT
 1450		  STA GUN.Y  RESET GUN
 1460		  LDA #$00
 1470		  STA GUNFAL	  READY FOR A DROP
 1480		  STA GUNACT	  GUN INACTIVE
 1490		  STA GUN.LAND	  NO LONGER ON GROUND
 1500		  JSR GUN.CHANCE  RESET GUN CHANCE
 1510 *--------------------------------
 1520 GUN.CHECK.END RTS
