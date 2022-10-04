 1000 *--------------------------------
 1010 * SAVE GAME.OVER.CODE
 1020 *--------------------------------
 1030 GAME.OVER  LDA #$00
 1040		 STA MASTER.VOLUME
 1050		 JSR TURN.SCREEN.OFF
 1060		 LDA #$00
 1070		 STA IRQ.ENABLE
 1080 *--------------------------------
 1090		 LDA #SCORE.ONE
 1100		 STA LO
 1110		 LDA /SCORE.ONE
 1120		 STA LO+1
 1130		 JSR CHECK.HI.SCORE
 1140 *--------------------------------
 1150		 LDA #SCORE.TWO
 1160		 STA LO
 1170		 LDA /SCORE.TWO
 1180		 STA LO+1
 1190		 JSR CHECK.HI.SCORE
 1200 *--------------------------------
 1210		 JSR CLEAR.SPRITES
 1220		 JSR SETUP.TEXT
 1230		 JSR CLEAR.HIRES
 1240		 JSR CLEAR.TEXT
 1250 *--------------------------------
 1260		 LDA #WHITE
 1270		 STA PRINT.COLOR
 1280 *--------------------------------
 1290		 LDA #$31
 1300		 STA PLAYER.MSG+13
 1310		 LDA #PLAYER.MSG
 1320		 STA LO
 1330		 LDA /PLAYER.MSG
 1340		 STA LO+1
 1350		 LDA #03
 1360		 STA YPOS
 1370		 JSR PRINT.MSG
 1380 *--------------------------------
 1390 TEST.PLY	 LDA PLAYRS
 1400		 BEQ .12      ONE PLAYER
 1410		 JMP .1       TWO PLAYERS
 1420 .12	 LDA NAME.FLAG
 1430		 BEQ .22
 1440 *--------------------------------
 1450		 LDA #NAME
 1460		 STA LO
 1470		 LDA /NAME
 1480		 STA LO+1
 1490		 LDA #18
 1500		 STA YPOS
 1510		 JSR PRINT.MSG
 1520		 LDA #NAME2
 1530		 STA LO
 1540		 LDA /NAME2
 1550		 STA LO+1
 1560		 LDA #20
 1570		 STA YPOS
 1580		 JSR PRINT.MSG
 1590		 LDA #NAME3
 1600		 STA LO
 1610		 LDA /NAME3
 1620		 STA LO+1
 1630		 LDA #22
 1640		 STA YPOS
 1650		 JSR PRINT.MSG
 1660		 JMP .2
 1670 *--------------------------------
 1680 .22	 >PRINT 0,20,WHITE,"    CHOPPER HUNT    "
 1690		 >PRINT 0,21,YELLOW,"       IMAGIC       "
 1700		 >PRINT 0,22,GREEN,"   COPYRIGHT 1984   "
 1710 *--------------------------------
 1720		 JMP .2
 1730 *--------------------------------
 1740 .1	 LDA #$32
 1750		 STA PLAYER.MSG+13
 1760		 LDA #PLAYER.MSG
 1770		 STA LO
 1780		 LDA /PLAYER.MSG
 1790		 STA LO+1
 1800		 LDA #19
 1810		 STA YPOS
 1820		 JSR PRINT.MSG
 1830 *--------------------------------
 1840 .2	 LDA #WHITE
 1850		 STA PRINT.COLOR
 1860		 LDA #GAME.OVR.MSG
 1870		 STA LO
 1880		 LDA /GAME.OVR.MSG
 1890		 STA LO+1
 1900		 LDA #$0B
 1910		 STA YPOS
 1920		 JSR PRINT.MSG
 1930 *--------------------------------
 1940		 LDA #HI.SCORE.MSG
 1950		 STA LO
 1960		 LDA /HI.SCORE.MSG
 1970		 STA LO+1
 1980		 LDA #$0D
 1990		 STA YPOS
 2000		 JSR PRINT.MSG
 2010 *--------------------------------
 2020 * PRINT PLAYER 1 SCORE
 2030 *--------------------------------
 2040		 LDA #SCORE.ONE
 2050		 STA LO
 2060		 LDA /SCORE.ONE
 2070		 STA LO+1
 2080		 LDA #05
 2090		 STA YPOS
 2100		 JSR PRINT.SCORES
 2110 *--------------------------------
 2120 * PRINT PLAYER 2 SCORE
 2130 *--------------------------------
 2140		 LDA PLAYRS
 2150		 BEQ PR.HI
 2160		 LDA #SCORE.TWO
 2170		 STA LO
 2180		 LDA /SCORE.TWO
 2190		 STA LO+1
 2200		 LDA #21
 2210		 STA YPOS
 2220		 JSR PRINT.SCORES
 2230 *--------------------------------
 2240 * PRINT HI-SCORE
 2250 *--------------------------------
 2260 PR.HI	 LDA #SCORE.HI
 2270		 STA LO
 2280		 LDA /SCORE.HI
 2290		 STA LO+1
 2300		 LDA #$0F
 2310		 STA YPOS
 2320 *--------------------------------
 2330		 JSR PRINT.SCORES
 2340		 JSR GAME.OVR.IRQ
 2350		 JSR TURN.SCREEN.ON
 2360 *--------------------------------
 2370		 LDA #$D5
 2380		 STA TEMP1
 2390 DLY.LUP	 JSR DELAY
 2400		 JSR DELAY
 2410		 JSR DELAY
 2420		 DEC TEMP1
 2430		 BNE DLY.LUP
 2440 *--------------------------------
 2450		 JSR TURN.SCREEN.OFF
 2460 *--------------------------------
 2470		 RTS
 2480 *--------------------------------
 2490 PRINT.SCORES    LDY #$07
 2500		      LDX #$11
 2510 .2	      LDA (LO),Y
 2520		      STA .1
 2530		      DEY
 2540 *--------------------------------
 2550		      BMI .3
 2560 *--------------------------------
 2570		      TYA
 2580		      PHA
 2590		      TXA
 2600		      PHA
 2610		      LDY YPOS
 2620 *--------------------------------
 2630		      TXA
 2640		      CLC
 2650		      ADC #$07
 2660		      TAX
 2670 *--------------------------------
 2680		      JSR PRINT
 2690 .1	      .AS "0"
 2700		      .HS FF
 2710		      PLA
 2720		      TAX
 2730		      PLA
 2740		      TAY
 2750		      DEX
 2760		      DEX
 2770		      BPL .2
 2780 .3	      RTS
 2790 *--------------------------------
 2800 GAME.OVR.IRQ    SEI
 2810		      LDA #GO.IRQ
 2820		      STA IRQLO
 2830		      LDA /GO.IRQ
 2840		      STA IRQHI
 2850		      LDA #$00
 2860		      STA RASTER
 2870		      LDA #$01
 2880		      STA IRQ.ENABLE
 2890		      CLI
 2900		      RTS
 2910 *--------------------------------
 2920 GO.IRQ	      LDA #LT.GREEN
 2930 .1	      LDX RASTER
 2940		      CPX #$30	       $37 IS EXACT TOP
 2950		      BNE .1
 2960		      STA $D021
 2970		      LDA #$75
 2980		      LDX #GO.IRQ.2
 2990		      LDY /GO.IRQ.2
 3000		      STA RASTER
 3010		      STX IRQLO
 3020		      STY IRQHI
 3030		      LDA #$81
 3040		      STA VIC.IRQ
 3050		      PLA
 3060		      TAY
 3070		      PLA
 3080		      TAX
 3090		      PLA
 3100		      RTI
 3110 *--------------------------------
 3120 GO.IRQ.2	      LDA #LT.BLUE
 3130 .1	      LDX RASTER
 3140		      CPX #$80
 3150		      BNE .1
 3160 *--------------------------------
 3170		      STA $D021
 3180 *--------------------------------
 3190		      LDA #$BA
 3200		      LDX #GO.IRQ.3
 3210		      LDY /GO.IRQ.3
 3220		      STA RASTER
 3230		      STX IRQLO
 3240		      STY IRQHI
 3250		      LDA #$81
 3260		      STA VIC.IRQ
 3270		      PLA
 3280		      TAY
 3290		      PLA
 3300		      TAX
 3310		      PLA
 3320		      RTI
 3330 *--------------------------------
 3340 GO.IRQ.3	      LDA #RED
 3350 .1	      LDX RASTER
 3360		      CPX #$C0
 3370		      BNE .1
 3380		      STA $D021
 3390		      LDA #$00
 3400		      LDX #GO.IRQ
 3410		      LDY /GO.IRQ
 3420		      STA RASTER
 3430		      STX IRQLO
 3440		      STY IRQHI
 3450		      LDA #$81
 3460		      STA VIC.IRQ
 3470		      PLA
 3480		      TAY
 3490		      PLA
 3500		      TAX
 3510		      PLA
 3520		      RTI
 3530 *--------------------------------
 3540 CHECK.HI.SCORE  LDY #$00
 3550 .1	      LDA SCORE.HI,Y
 3560		      CMP #$24
 3570		      BEQ .2
 3580		      INY
 3590		      CPY #$08
 3600		      BNE .1
 3610 .2	      TYA
 3620		      STA TEMP1    POS OF $ OF HISCORE
 3630 *--------------------------------
 3640		      LDY #$00
 3650 .3	      LDA (LO),Y
 3660 *3	      LDA SCORE.ONE,Y
 3670		      CMP #$24
 3680		      BEQ .4
 3690		      INY
 3700		      CPY #$08
 3710		      BNE .3
 3720 .4	      TYA
 3730		      STA TEMP2
 3740 *--------------------------------
 3750		      LDA TEMP1 	HI $ POS
 3760		      CMP TEMP2 	SCORE $ POS
 3770		      BEQ CHECK.NUMBER
 3780		      BCC DONE.HI	(OK)!!
 3790 *--------------------------------
 3800 *  SCORE WAS HI
 3810 *--------------------------------
 3820 GOT.HI	      LDY #$07
 3830 .1	      LDA (LO),Y
 3840 *1	      LDA SCORE.ONE,Y
 3850		      STA SCORE.HI,Y
 3860		      DEY
 3870		      BPL .1
 3880		      RTS
 3890 *--------------------------------
 3900 CHECK.NUMBER    LDA TEMP1
 3910		      TAY
 3920		      INY
 3930 .2	      LDA SCORE.HI,Y
 3940		      CMP (LO),Y
 3950 * 	      CMP SCORE.ONE,Y
 3960		      BEQ .1
 3970		      BCS DONE.HI
 3980		      BCC GOT.HI
 3990 *--------------------------------
 4000 .1	      INY
 4010		      CPY #$08
 4020		      BNE .2
 4030 *--------------------------------
 4040 DONE.HI	      RTS
