 1000 *--------------------------------
 1010 *  SAVE EXPLOSION.CODE
 1020 *--------------------------------
 1030 *  HANDLE DIGGING EXPLOSIONS
 1040 *--------------------------------
 1050 DO.EXPLOSIONS LDY #$04
 1060 .1	    LDA EXPGO,Y
 1070		    BNE EXPNEW
 1080		    DEY
 1090		    BPL .1
 1100		    JMP MAIN2
 1110 *--------------------------------
 1120 EXPNEW	 LDA EXPCNT
 1130		 CMP #20
 1140		 BPL MAIN2
 1150 *--------------------------------
 1160		 INC EXPCNT
 1170		 LDX EXPCNT
 1180		 LDA EXPLR,Y
 1190		 STA XPOS,X
 1200		 LDA EXPHT,Y
 1210		 STA YPOS,X
 1220		 LDA #$00
 1230		 STA CNT,X
 1240		 STA EXPGO,Y
 1250		 LDA #$01
 1260		 STA EXPL.SOUND
 1270		 LDA #$FF
 1280		 STA EXPL.FREQ
 1290 *--------------------------------
 1300 MAIN2	 LDA #$00
 1310		 STA COUNTR
 1320 RUNLP	 INC COUNTR
 1330		 LDA EXPCNT
 1340		 CMP COUNTR
 1350		 BPL INDEX
 1360 *--------------------------------
 1370		 RTS
 1380 *--------------------------------
 1390 INDEX	 LDX COUNTR
 1400		 LDA #$00
 1410		 STA PLTCLR
 1420		 LDA CNT,X
 1430		 CMP #37
 1440		 BMI DOPLOT
 1450 *--------------------------------
 1460		 INC PLTCLR
 1470		 SEC
 1480		 SBC #37
 1490		 CMP #37
 1500		 BMI DOPLOT
 1510		 TXA
 1520		 TAY
 1530 *--------------------------------
 1540 REPACK	 INX	      MOVE EXPLOSIONS
 1550		 CPX EXPCNT   BACK TO TAKE PLACE
 1560		 BEQ RPK2     OF THE ONE THAT
 1570		 BPL RPKEND   JUST FINISHED
 1580 RPK2	 LDA XPOS,X
 1590		 STA XPOS,Y
 1600		 LDA YPOS,X
 1610		 STA YPOS,Y
 1620		 LDA CNT,X
 1630		 STA CNT,Y
 1640		 INY
 1650		 BNE REPACK
 1660 *--------------------------------
 1670 RPKEND	 DEC EXPCNT  ONE LESS EXPLOSION
 1680		 DEC COUNTR
 1690		 LDA #$00
 1700		 STA EXPL.SOUND
 1710		 JMP RUNLP
 1720 *--------------------------------
 1730 DOPLOT	 INC CNT,X
 1740		 TAY
 1750 *--------------------------------
 1760		 LDA XPOS,X
 1770		 CLC
 1780		 ADC COORD1,Y
 1790		 STA PLOTX
 1800		 CMP #160
 1810		 BCS RUNLP
 1820 *--------------------------------
 1830		 LDA YPOS,X
 1840		 CLC
 1850		 ADC COORD2,Y
 1860		 STA PLOTY
 1870		 CMP #$B0
 1880		 BCS RUNLP
 1890 *--------------------------------
 1900		 JSR PLOTCL
 1910 *--------------------------------
 1920		 LDA PLTCLR   ERASING?
 1930		 BNE CLEARIT  YES
 1940 *--------------------------------
 1950		 LDY #$00     PLOT EXPLOSION
 1960		 LDA PLOTX
 1970		 AND #$03
 1980		 TAX
 1990 *--------------------------------
 2000 * CHECK IF HITTING DIRT ONLY
 2010 * IF BELOW GROUND LEVEL
 2020 *--------------------------------
 2030		 LDA PLOTY
 2040		 CMP INILVL
 2050		 BCC .14      YES
 2060 *--------------------------------
 2070		 LDA BOMB.MASK,X
 2080		 EOR #$FF
 2090		 AND (LO),Y
 2100		 CMP DIRT.COLOR,X    IF EXPLODING DIRT
 2110		 BNE .11	     THEN KEEP TRACK OF
 2120		 INC DRTHIT	     EACH PIXEL HIT
 2130 *--------------------------------
 2140 * IF HITTING DIRT THEN STORE
 2150 *--------------------------------
 2160 .11	 CMP WATER.COLOR,X
 2170		 BNE .13
 2180		 JMP RUNLP
 2190 .13	 LDA (LO),Y
 2200		 AND BOMB.MASK,X
 2210		 ORA BOMB.SHAPE,X
 2220		 STA (LO),Y
 2230		 JMP RUNLP
 2240 *--------------------------------
 2250 *   EOR IT ON SCREEN
 2260 *--------------------------------
 2270 .14	 LDA PLOTY
 2280		 CMP MOUNTAIN.TOP
 2290		 BCS .2      NOT ABOVE MOUNTAINS
 2300 *--------------------------------
 2310		 LDA (LO),Y	   ABOVE MOUNTAINS
 2320		 AND BOMB.MASK,X   STORE WHITE
 2330		 ORA BOMB.SHAPE,X
 2340		 STA (LO),Y
 2350		 JMP RUNLP
 2360 *--------------------------------
 2370 .2	 LDA (LO),Y	   STORE BOMB ONTO
 2380		 AND BOMB.MASK,X   MOUNTAINS
 2390		 ORA BOMB.SHAPE,X
 2400		 STA (LO),Y
 2410		 JMP RUNLP
 2420 *--------------------------------
 2430 CLEARIT	 LDY #$00
 2440		 LDA PLOTX
 2450		 AND #$03
 2460		 TAX
 2470 *--------------------------------
 2480		 LDA PLOTY
 2490		 CMP INILVL
 2500		 BCC .1       ABOVE GROUND
 2510 *--------------------------------
 2520 *  DONT ERASE WATER
 2530 *--------------------------------
 2540		 LDA BOMB.MASK,X
 2550		 EOR #$FF
 2560		 AND (LO),Y
 2570		 CMP WATER.COLOR,X
 2580		 BNE .14
 2590 *--------------------------------
 2600		 LDA PLOTX
 2610		 STA SCAN.X
 2620		 LDA INILVL
 2630		 CLC
 2640		 ADC #$01
 2650		 STA SCAN.Y
 2660		 LDA #$00
 2670		 STA WPHASE
 2680 *--------------------------------
 2690		 JMP RUNLP
 2700 *--------------------------------
 2710 .14	 LDA (LO),Y	    ELSE ERASE WITH
 2720		 AND BOMB.MASK,X    BLACK
 2730		 STA (LO),Y
 2740 *--------------------------------
 2750		 LDA INILVL	KEEP BLACK
 2760		 SEC
 2770		 SBC #$01
 2780		 STA PLOTY	LINE AT BASE
 2790		 JSR PLOTCL	OF MOUNTAINS
 2800		 LDA (LO),Y
 2810		 AND BOMB.MASK,X
 2820		 STA (LO),Y
 2830 *--------------------------------
 2840		 JMP RUNLP
 2850 *--------------------------------
 2860 *  RESTORE ABOVE GROUND
 2870 *--------------------------------
 2880 .1	 LDA PLOTY
 2890		 CMP MOUNTAIN.TOP
 2900		 BCS .2      NOT ABOVE MOUNTAIN
 2910 *--------------------------------
 2920 *  RESTORE SKY
 2930 *--------------------------------
 2940		 LDA (LO),Y
 2950		 AND BOMB.MASK,X
 2960		 ORA WATER.COLOR,X  RESTORE SKY
 2970		 STA (LO),Y
 2980		 JMP RUNLP
 2990 *--------------------------------
 3000 *  RESTORE MOUNTAINS
 3010 *--------------------------------
 3020 .2	 JSR SETUP.ADDR    RESTORE MOUNTAIN DATA
 3030		 LDY #$00
 3040		 LDA (LO),Y
 3050		 AND BOMB.MASK,X
 3060		 ORA (JLO),Y
 3070		 STA (LO),Y
 3080 *--------------------------------
 3090		 LDA INILVL	   ERASE LINE AT
 3100		 SEC
 3110		 SBC #$01
 3120		 STA PLOTY	   BASE OF MOUNTAINS
 3130		 JSR PLOTCL
 3140		 LDA (LO),Y
 3150		 AND BOMB.MASK,X
 3160		 STA (LO),Y
 3170 *--------------------------------
 3180		 JMP RUNLP
 3190 *--------------------------------
 3200 NMI	 PHA
 3210		 TXA
 3220		 PHA
 3230		 TYA
 3240		 PHA
 3250 *--------------------------------
 3260		 INC ABORT.FLAG
 3270 *--------------------------------
 3280		 PLA
 3290		 TAY
 3300		 PLA
 3310		 TAX
 3320		 PLA
 3330		 RTI
 3340 *--------------------------------
