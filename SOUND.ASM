 1000 *--------------------------------
 1010 * SAVE SOUND.CODE2
 1020 *--------------------------------
 1030 DO.SOUNDS  LDA #$0A
 1040		 STA MASTER.VOLUME
 1050		 LDA EXPL.FREQ
 1060		 BEQ .11
 1070 *--------------------------------
 1080		 LDA #$02
 1090		 STA FREQ.2+1
 1100 *--------------------------------
 1110		 LDA EXPL.FREQ
 1120		 SEC
 1130		 SBC #$0F
 1140		 STA EXPL.FREQ
 1150		 STA FREQ.2
 1160 *--------------------------------
 1170		 LDA #$81
 1180		 STA $D40B
 1190 *--------------------------------
 1200 * DO SHOT SOUND
 1210 *--------------------------------
 1220 .11	 LDA SHOT.SOUND
 1230		 BEQ .13
 1240 *--------------------------------
 1250		 LDA #$03
 1260		 STA FREQ.3+1
 1270 *--------------------------------
 1280		 LDA #$15
 1290		 STA ATTDEC.3
 1300		 LDA #$6A
 1310		 STA SUSREL.3
 1320 *--------------------------------
 1330		 LDA SHOT.SOUND
 1340		 SEC
 1350		 SBC #$0F
 1360		 BNE .12
 1370		 LDA #$00
 1380		 STA $D412
 1390		 STA FREQ.3+1
 1400 *--------------------------------
 1410 .12	 STA SHOT.SOUND
 1420		 STA FREQ.3
 1430		 BEQ .13
 1440		 LDA #$81
 1450		 STA $D412
 1460 * 	 JMP .1
 1470 *--------------------------------
 1480 .13	 LDA EXPL.FREQ
 1490		 BNE .1
 1500		 LDA #$00
 1510		 STA $D40B
 1520 *--------------------------------
 1530 *  DO LANDING SOUND
 1540 *--------------------------------
 1550 .1	 LDA LAND.SOUND   DO WE NEED LAND SOUND
 1560		 BEQ .2 	  NO
 1570 *--------------------------------
 1580		 LDA #$00
 1590		 STA LAND.SOUND
 1600		 STA FREQ.2
 1610		 LDA #$55
 1620		 STA FREQ.2+1
 1630		 LDA #$11
 1640		 STA $D40B
 1650		 JSR DELAY
 1660		 JSR DELAY
 1670		 LDA #$10
 1680		 STA $D40B
 1690 *--------------------------------
 1700 .2	 LDA BUC.SOUND
 1710		 BEQ .3
 1720 *--------------------------------
 1730		 LDA #$00
 1740		 STA BUC.SOUND
 1750		 STA FREQ.2
 1760		 LDA #$33
 1770		 STA FREQ.2+1
 1780		 LDA #$11
 1790		 STA $D40B
 1800		 JSR DELAY
 1810		 JSR DELAY
 1820		 LDA #$10
 1830		 STA $D40B
 1840 *--------------------------------
 1850 *  DO SPLASH SOUND
 1860 *--------------------------------
 1870 .3	 LDA SPLASH.SOUND
 1880		 BEQ .4
 1890 *--------------------------------
 1900		 LDA #$00
 1910		 STA SPLASH.SOUND
 1920		 STA FREQ.2
 1930		 LDA #$FF
 1940		 STA FREQ.2+1
 1950		 LDA #$81
 1960		 STA $D40B
 1970		 JSR DELAY
 1980		 JSR DELAY
 1990		 LDA #$80
 2000		 STA $D40B
 2010 *--------------------------------
 2020 * DO PLANE SOUND
 2030 *--------------------------------
 2040 .4	 LDA PLANE.SOUND
 2050		 BEQ .99
 2060		 JMP .99
 2070 *--------------------------------
 2080		 LDA #$00
 2090		 STA FREQ.3
 2100		 LDA PLANE.X
 2110		 SEC
 2120		 SBC #$13
 2130		 STA TEMP1
 2140		 LDA PLANE.XMSB
 2150		 SBC #$00
 2160		 LSR
 2170		 ROR TEMP1
 2180		 LDA TEMP1
 2190		 STA FREQ.3+1
 2200		 LDA #$81
 2210		 STA $D412
 2220 *--------------------------------
 2230 .99	 LDA #$00
 2240 *--------------------------------
 2250 SOUND.END  RTS
 2260 *--------------------------------
 2270 DO.PAD	 LDY #$14
 2280 .4	 LDA PAD.DATA,Y
 2290		 STA (PADLO),Y
 2300		 DEY
 2310		 BNE .4
 2320		 LDY #$01
 2330 .44	 LDA PAD.COLOR,Y
 2340		 STA (PADC.LO),Y
 2350		 DEY
 2360		 BPL .44
 2370		 RTS
