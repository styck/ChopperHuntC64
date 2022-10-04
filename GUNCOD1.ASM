 1000 *--------------------------------
 1010 * SAVE GUN.CODE.1
 1020 *--------------------------------
 1030 DO.GUN	 LDA TRANCT    ENOUGH TRANSITS?
 1040		 BNE GUN.END   NO
 1050 *--------------------------------
 1060		 LDA GUNACT    GUN ACTIVE?
 1070		 BNE GUN.END   NO
 1080 *--------------------------------
 1090		 LDA GUNSHT
 1100		 BNE GUN.END
 1110 *--------------------------------
 1120		 LDA GUNFAL    GUN FALLING?
 1130		 BNE GUN.END   YES
 1140 *--------------------------------
 1150		 LDA GUNACT    GUN ACTIVE
 1160		 BNE GUN.END   NO
 1170 *--------------------------------
 1180		 LDA #$17	       RESTORE SMART BOMB (CLOSED POSITION)
 1190		 STA SPRITE.POINTER+2
 1200 *--------------------------------
 1210 .1	 JSR MAKE.RANDOM
 1220		 CMP #$70
 1230		 BCS .1
 1240 *--------------------------------
 1250		 CLC
 1260		 ADC #$1B
 1270		 STA PLOTX
 1280		 LDA INILVL
 1290		 STA PLOTY
 1300 *--------------------------------
 1310		 JSR PLOTCL
 1320 *--------------------------------
 1330		 LDA PLOTX
 1340		 AND #$03
 1350		 TAX
 1360		 LDY #$00
 1370		 LDA BOMB.MASK,X
 1380		 EOR #$FF
 1390		 AND (LO),Y
 1400		 CMP DIRT.COLOR,X
 1410		 BNE GUN.END	   IT WAS NOT DIRT
 1420 *--------------------------------
 1430 *  FOUND GROUND
 1440 *  SET COORDINATES
 1450 *--------------------------------
 1460		 LDA #$00
 1470		 STA TEMP1
 1480		 LDA PLOTX
 1490		 STA GUN.X.SC
 1500		 ASL
 1510		 ROL TEMP1
 1520		 CLC
 1530		 ADC #$13
 1540		 STA GUN.X
 1550		 LDA TEMP1
 1560		 ADC #$00
 1570		 STA GUN.XMSB
 1580 *--------------------------------
 1590		 LDA #00       MAKE SURE IT
 1600		 STA GUN.Y     IS OFF SCREEN
 1610 *--------------------------------
 1620		 STA GUNFGO
 1630		 STA GUNSHT
 1640		 STA GUN.TIM
 1650 *--------------------------------
 1660		 LDA #$01
 1670		 STA GUNFAL   READY FOR FALL
 1680		 STA GUNACT   IT IS ACTIVE
 1690 *--------------------------------
 1700 GUN.END	 RTS
