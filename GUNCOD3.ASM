 1000 *--------------------------------
 1010 *  SAVE GUN.CODE.3
 1020 *--------------------------------
 1030 GUN.SHOOT  LDA GUNSHT
 1040		 BEQ SHOOT.END
 1050		 LDY GUN.PHASE
 1060		 CPY #$04
 1070		 BEQ NOGDED	FIRE SHOT
 1080		 LDA GUN.TIM
 1090		 BNE .1
 1100		 LDA #$05    RESET ANIMATION
 1110		 STA GUN.TIM TIMER
 1120		 INC GUN.PHASE
 1130		 LDY GUN.PHASE
 1140		 LDA GUN.SHAPE,Y
 1150		 STA SPRITE.POINTER+2
 1160 *--------------------------------
 1170 .1	 DEC GUN.TIM
 1180 SHOOT.END  RTS
 1190 *--------------------------------
 1200 NOGDED	 LDA GUNSHT
 1210		 BEQ NO.SHOT
 1220		 LDA SHOTON
 1230		 BNE NO.SHOT
 1240		 LDA GUN.LAND  NOT ON GROUND
 1250		 BEQ NO.SHOT
 1260 *--------------------------------
 1270		 LDA CHOP.Y
 1280		 SEC
 1290		 SBC #$2F     MIDDLE OF CHOPPER
 1300		 STA TGTY
 1310		 CMP INILVL   BELOW GROUND?
 1320		 BCS NO.SHOT  YES
 1330 *--------------------------------
 1340		 LDA #$00
 1350		 STA PYINCL
 1360		 STA PXINCL
 1370		 STA PXHOLD
 1380		 STA PYHOLD
 1390		 STA PRSCNT
 1400 *--------------------------------
 1410		 LDA CHOP.X
 1420		 SEC
 1430		 SBC #$13
 1440		 STA TEMP1
 1450		 LDA CHOP.XMSB
 1460		 SBC #$00
 1470		 LSR
 1480		 ROR TEMP1
 1490		 LDA TEMP1
 1500 *--------------------------------
 1510		 STA TGTX
 1520		 CMP GUN.X.SC
 1530		 BCS SHOOT.RIGHT
 1540		 BCC SHOOT.LEFT
 1550 *--------------------------------
 1560 NO.SHOT	 JMP CHECK.SHOT
 1570 *--------------------------------
 1580 SHOOT.LEFT LDA #$00
 1590		 STA SHOTDR
 1600		 LDA GUN.X.SC
 1610		 SEC
 1620		 SBC TGTX
 1630		 JMP SPXINC
 1640 *--------------------------------
 1650 SHOOT.RIGHT LDA #$01
 1660		  STA SHOTDR
 1670		  LDA TGTX
 1680		  SEC
 1690		  SBC GUN.X.SC
 1700 *--------------------------------
 1710 SPXINC	  STA PXINCH
 1720		  LDA GUN.Y.SC
 1730		  SEC
 1740		  SBC TGTY
 1750		  STA PYINCH
 1760 *--------------------------------
 1770 VECTOR	  LDA PXINCH
 1780		  CMP #$02
 1790		  BCS VEC2
 1800 *--------------------------------
 1810		  LDA PYINCH
 1820		  CMP #$02
 1830		  BCC VECEND
 1840 *--------------------------------
 1850 VEC2	  LSR PXINCH
 1860		  ROR PXINCL
 1870		  LSR PYINCH
 1880		  ROR PYINCL
 1890		  JMP VECTOR
 1900 *--------------------------------
 1910 VECEND	  LDA GUN.Y.SC
 1920		  SEC
 1930		  SBC #$04
 1940		  STA SHOTY
 1950		  LDA GUN.X.SC
 1960		  STA SHOTX
 1970		  LDA #$01	SHOT ON!!
 1980		  STA SHOTON
 1990		  LDA #$FF
 2000		  STA SHOT.SOUND
 2010 *--------------------------------
 2020 CHECK.SHOT  LDA SHOTON
 2030		  BNE .1
 2040 *--------------------------------
 2050		  RTS
 2060 *--------------------------------
 2070 .1	  JSR SHOT.ERASE
 2080 *--------------------------------
 2090		  LDA PXHOLD
 2100		  CLC
 2110		  ADC PXINCL
 2120		  STA PXHOLD
 2130		  LDA #$00
 2140		  ADC PXINCH
 2150		  STA DELTAX
 2160 *--------------------------------
 2170		  LDA PYHOLD
 2180		  CLC
 2190		  ADC PYINCL
 2200		  STA PYHOLD
 2210		  LDA #$00
 2220		  ADC PYINCH
 2230		  STA DELTAY
 2240 *--------------------------------
 2250		  LDA SHOTDR
 2260		  BNE ADJSP
 2270 *--------------------------------
 2280		  LDA SHOTX
 2290		  SEC
 2300		  SBC DELTAX
 2310		  JMP STOSX
 2320 *--------------------------------
 2330 ADJSP	  LDA SHOTX
 2340		  CLC
 2350		  ADC DELTAX
 2360 STOSX	  BEQ KILSHT
 2370		  CMP #160
 2380		  BCS KILSHT
 2390 *--------------------------------
 2400		  STA SHOTX
 2410		  LDA SHOTY
 2420		  SEC
 2430		  SBC DELTAY
 2440		  BMI KILSHT
 2450		  STA SHOTY
 2460		  LDX #$00
 2470 *--------------------------------
 2480 SHTPLP	  STX SXHLDA
 2490		  JSR MAKE.RANDOM
 2500		  ROR
 2510		  CMP #$A0
 2520		  BCS NXTSBK
 2530 *--------------------------------
 2540		  LDA SHOTX
 2550		  CLC
 2560		  ADC WPXADD,X
 2570		  STA PLOTX
 2580		  CMP #$A0     DONT LET IT OFF SCREEN
 2590		  BCS NXTSBK
 2600 *--------------------------------
 2610		  LDA SHOTY
 2620		  CLC
 2630		  ADC WPYADD,X
 2640		  STA PLOTY
 2650 *--------------------------------
 2660		  JSR PLOTCL
 2670 *--------------------------------
 2680		  LDA BOMB.MASK,X
 2690		  AND (LO),Y
 2700		  ORA BOMB.SHAPE,X
 2710		  STA (LO),Y
 2720 *--------------------------------
 2730 NXTSBK	  LDX SXHLDA
 2740		  INX
 2750		  CPX #12
 2760		  BMI SHTPLP
 2770 *--------------------------------
 2780		  JSR CHECK.CHOP
 2790 SHOTND	  RTS
 2800 *--------------------------------
 2810 * EXPLODE FALLING DIRT
 2820 *--------------------------------
 2830 SHTEXP	  LDA #$01
 2840		  STA EXPGO+4
 2850		  LDA SHOTX
 2860		  STA EXPLR+4
 2870		  LDA SHOTY
 2880		  STA EXPHT+4
 2890 *--------------------------------
 2900 KILSHT	  JSR SHTCLR
 2910 *--------------------------------
 2920		 LDA #$00
 2930		 STA GUN.PHASE
 2940		 STA SHOT.SOUND
 2950		 STA $D412     VOICE 3 CONTROL
 2960		 LDA GUN.LAND
 2970		 BNE .1        ON THE GROUND (KEEP SHOOTING)
 2980		 STA GUNSHT
 2990 .1	 RTS
 3000 *--------------------------------
 3010 SHTCLR	 JSR SHOT.ERASE
 3020		 LDA #$00
 3030		 STA SHOTON
 3040		 RTS
 3050 *--------------------------------
 3060 SHOT.ERASE     LDX #$00
 3070 .1	 STX SXHLDA
 3080		 LDA SHOTX
 3090		 CLC
 3100		 ADC WPXADD,X
 3110		 STA PLOTX
 3120		 LDA SHOTY
 3130		 CLC
 3140		 ADC WPYADD,X
 3150		 STA PLOTY
 3160		 JSR PLOTCL
 3170 *--------------------------------
 3180		 LDA PLOTX
 3190		 AND #$03
 3200		 TAX
 3210 *--------------------------------
 3220		 LDA INILVL
 3230		 SEC
 3240		 SBC #$18
 3250		 STA TEMP1
 3260		 LDA PLOTY
 3270		 CMP TEMP1
 3280		 BCC .3
 3290 *--------------------------------
 3300 * RESTORE MOUNTAINS
 3310 *--------------------------------
 3320		 JSR SETUP.ADDR
 3330		 LDY #$00
 3340		 LDA (LO),Y
 3350		 AND BOMB.MASK,X
 3360		 ORA (JLO),Y
 3370		 STA (LO),Y
 3380		 JMP .2
 3390 *--------------------------------
 3400 * RESTORE SKY
 3410 *--------------------------------
 3420 .3	 LDY #$00
 3430		 LDA BOMB.MASK,X
 3440		 AND (LO),Y
 3450		 ORA WATER.COLOR,X
 3460		 STA (LO),Y
 3470 *--------------------------------
 3480 .2	 LDX SXHLDA
 3490		 INX
 3500		 CPX #12
 3510		 BMI .1
 3520		 RTS
 3530 *--------------------------------
 3540 * SOFTWARE COLLISTION FOR CHOPPER
 3550 *--------------------------------
 3560 CHECK.CHOP LDA HIT0
 3570		 BEQ .9
 3580 *--------------------------------
 3590		 RTS
 3600 *--------------------------------
 3610 .9	 LDA #$07
 3620		 STA TEMP2
 3630		 LDA CHOP.Y
 3640		 SEC
 3650		 SBC #$2C
 3660		 STA PLOTY
 3670 *--------------------------------
 3680		 LDA CHOP.X
 3690		 SEC
 3700		 SBC #$16
 3710		 STA TEMP1
 3720		 LDA CHOP.XMSB
 3730		 SBC #$00
 3740		 LSR
 3750		 ROR TEMP1
 3760		 LDA TEMP1
 3770		 STA PLOTX
 3780 *--------------------------------
 3790 .3	 LDA #$04
 3800		 STA TEMP3
 3810 *--------------------------------
 3820 .2	 JSR PLOTCL
 3830 *--------------------------------
 3840		 LDY #$00
 3850		 LDA BOMB.MASK,X
 3860		 EOR #$FF
 3870		 AND (LO),Y
 3880		 CMP BOMB.SHAPE,X
 3890		 BNE .1
 3900 *--------------------------------
 3910 .11	 LDA #$01
 3920		 STA HIT0
 3930		 JMP KILSHT  ********
 3940 *--------------------------------
 3950 .1	 INC PLOTX
 3960		 DEC TEMP3
 3970		 BNE .2
 3980 *--------------------------------
 3990		 LDA PLOTX
 4000		 SEC
 4010		 SBC #$04
 4020		 STA PLOTX
 4030		 DEC PLOTY
 4040		 DEC TEMP2
 4050		 BPL .3
 4060		 RTS
