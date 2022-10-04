 1000 *--------------------------------
 1010 * SAVE GUN.CODE.2
 1020 *--------------------------------
 1030 DO.GUN.FALL LDA GUNFGO	    READY FOR DROP (SET IN IRQ1)
 1040		  BEQ NO.INC	    NO
 1050 *--------------------------------
 1060		  LDA GUNSHT	    ARE WE READY TO SHOOT
 1070		  BNE GUN.FALL.END	YES (NO MORE DROP)
 1080 *--------------------------------
 1090		  LDA #$00	   TELL IRQ
 1100		  STA GUNFAL	   NOT TO DROP
 1110		  INC GUN.Y
 1120		  LDA #$02
 1130		  STA GUN.TIM
 1140		  LDA GUN.Y
 1150		  SEC
 1160		  SBC #$20	 BOTTOM OF SMART
 1170		  STA PLOTY	 BOMB
 1180		  CMP INILVL
 1190		  BNE GUN.FALL.END
 1200 *--------------------------------
 1210		  INC PLOTY
 1220		  LDA GUN.X.SC
 1230		  STA PLOTX
 1240 *--------------------------------
 1250		  JSR PLOTCL
 1260		  LDY #$00
 1270		  LDA PLOTX
 1280		  AND #$03
 1290		  TAX
 1300		  LDA BOMB.MASK,X
 1310		  EOR #$FF
 1320		  AND (LO),Y	  BLACK?
 1330		  BNE .2	  NO, OK TO DROP
 1340 *--------------------------------
 1350		  LDA #$00   WASNT DIRT
 1360		  STA GUN.Y  RESET GUN
 1370		  LDA #$00
 1380		  STA GUNFGO	  NO MORE DROP
 1390		  STA GUNFAL	  READY FOR A DROP
 1400		  STA GUNACT	  GUN INACTIVE
 1410		  JSR GUN.CHANCE  RESET GUN CHANCE
 1420		  JMP GUN.FALL.END
 1430 *--------------------------------
 1440 .2	  LDA #$01
 1450		  STA GUNSHT	READY TO SHOOT
 1460		  STA GUN.LAND	WE ARE ON THE GROUND
 1470		  LDA #$00
 1480		  STA GUN.PHASE
 1490		  STA GUNFGO
 1500		  LDA #$05
 1510		  STA GUN.TIM
 1520		  LDA GUN.Y
 1530		  SEC
 1540		  SBC #$24	A LITTLE BIT
 1550		  STA GUN.Y.SC	ABOVE GUN
 1560 *--------------------------------
 1570 GUN.FALL.END DEC GUN.TIM
 1580 NO.INC	   RTS
