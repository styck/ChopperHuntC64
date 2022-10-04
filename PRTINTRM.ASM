 1000 *--------------------------------
 1010 * SAVE PRINT.INTRM
 1020 *--------------------------------
 1030 PRINT.MSG      LDY #$13
 1040		     LDX #$26
 1050 .2	     LDA (LO),Y
 1060		     STA .1
 1070		     DEY
 1080		     TYA
 1090		     PHA
 1100		     TXA
 1110		     PHA
 1120		     LDY YPOS
 1130		     JSR PRINT
 1140 .1	     .AS "0"
 1150		     .HS FF
 1160		     PLA
 1170		     TAX
 1180		     PLA
 1190		     TAY
 1200		     DEX
 1210		     DEX
 1220		     BPL .2
 1230		     RTS
 1240 *--------------------------------
 1250 INTRM.SOUND JSR INIT.SOUND
 1260		  LDA #$00
 1270		  STA CONTROL.1  TURN BLADE SOUND OFF
 1280		  STA CONTROL.2
 1290 *--------------------------------
 1300		  LDA #$13
 1310		  STA ATTDEC.1
 1320		  STA ATTDEC.2
 1330		  LDA #$DA
 1340		  STA SUSREL.1
 1350		  STA SUSREL.2
 1360 *--------------------------------
 1370		  LDA #$C8
 1380		  STA FREQ.1
 1390		  LDA #$0F
 1400		  STA FREQ.1+1
 1410 *--------------------------------
 1420		  LDA #$F8
 1430		  STA FREQ.2
 1440		  LDA #$07
 1450		  STA FREQ.2+1
 1460 *--------------------------------
 1470		  LDA #$00	SET PULSE WIDTHS
 1480		  STA FREQ.1+2
 1490		  STA FREQ.2+2
 1500		  LDA #$08
 1510		  STA FREQ.1+3
 1520		  LDA #$04
 1530		  STA FREQ.2+3
 1540 *--------------------------------
 1550		  LDA #$03
 1560		  STA MASTER.VOLUME
 1570		  LDA #$41
 1580		  STA CONTROL.1
 1590		  STA CONTROL.2
 1600		  RTS
 1610 *--------------------------------
 1620 *  SETUP ABORT SOUND
 1630 *--------------------------------
 1640 ABORT.SOUND LDA #$00
 1650		  STA CONTROL.2
 1660		  STA CONTROL.3
 1670		  STA FREQ.2+2
 1680		  STA FREQ.3+2
 1690 *--------------------------------
 1700		  LDA #$13
 1710		  STA ATTDEC.2
 1720		  STA ATTDEC.3
 1730 *--------------------------------
 1740		  LDA #$DA
 1750		  STA SUSREL.2
 1760		  STA SUSREL.3
 1770 *--------------------------------
 1780		  LDA #$03
 1790		  STA FREQ.2+3
 1800		  LDA #$08
 1810		  STA FREQ.3+3
 1820 *--------------------------------
 1830		  STA MASTER.VOLUME
 1840		  LDA #$41
 1850		  STA CONTROL.2
 1860		  STA CONTROL.3
 1870		  RTS
