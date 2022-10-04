 1000 *--------------------------------
 1010 * SAVE CHOP.MACROS
 1020 *--------------------------------
 1030 * ADD AN 8BIT VALUE TO A
 1040 * 16 BIT RESULT
 1050 * FORMAT IS >ADD ]1,]2,]3
 1060 * ]1=BYTE TO ADD ]2=LOW ANSER
 1070 * ]3=HI BYTE OF ANSWER
 1080 *--------------------------------
 1090		 .MA ADD
 1100		 LDA ]2
 1110		 CLC
 1120		 ADC ]1
 1130		 STA ]2
 1140		 BCC :1
 1150		 INC ]3
 1160 :1
 1170		 .EM
 1180 *--------------------------------
 1190 * ADD TWO 16 BIT VALUES
 1200 * FORMAT: ]1=LOW BYTE ADDRESS OF VALUE
 1210 * 	]2=LOW BYTE ADDRESS OF ADDRESS
 1220 *--------------------------------
 1230		 .MA ADD16
 1240		 CLC
 1250		 LDA ]1
 1260		 ADC ]2
 1270		 STA ]2
 1280		 LDA ]1+1
 1290		 ADC ]2+1
 1300		 STA ]2+1
 1310		 .EM
 1320 *--------------------------------
 1330 * BUILD A POINTER IN ZERO PAGE
 1340 *--------------------------------
 1350 * FORMAT >BUILD ]1,]2
 1360 * ]1=WHERE TO POINT TO IN MEMORY
 1370 * ]2=ZERO PAGE ADDRESS OF POINTER
 1380 *--------------------------------
 1390		 .MA BUILD
 1400		 LDA #]1
 1410		 STA ]2
 1420		 LDA /]1
 1430		 STA ]2+1
 1440		 .EM
 1450 *--------------------------------
 1460 * INCREMENT A 16 BIT VALUE
 1470 *--------------------------------
 1480		 .MA INC
 1490		 INC ]1
 1500		 BNE :1
 1510		 INC ]1+1
 1520 :1
 1530		 .EM
 1540 *--------------------------------
 1550 * PRINT ROUTINE MACRO
 1560 * ENTER WITH ]1=XCOOR, ]2=YCOOR
 1570 * ]3=COLOR ]4=STRING TO PRINT!
 1580 *--------------------------------
 1590		 .MA PRINT
 1600		 LDX #]1
 1610		 LDY #]2
 1620		 LDA #]3
 1630		 STA PRINT.COLOR
 1640		 JSR PRINT
 1650		 .AS -"]4"
 1660		 .HS FF
 1670		 .EM
 1680 *--------------------------------
 1690 * PRINT MATRIX MACRO ROUTINE
 1700 * ENTER WITH ]1=MATRIX NAME, ]2=MATRIX.XPOS,
 1710 * ]3=MATRIX.YPOS, ]4=MATRIX.PRINT.COLOR
 1720 * COLOR VALUE #$FF=NO COLOR CHANGE
 1730 *--------------------------------
 1740			  .MA MATRIX
 1750			  >BUILD ]1,TEMP1
 1760			  LDX #]2
 1770			  LDY #]3
 1780			  LDA #]4
 1790			  STA PRINT.COLOR
 1800			  JSR MATRIX.PRINT
 1810			  .EM
 1820 *--------------------------------
