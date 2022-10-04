 1000 *--------------------------------
 1010 *  SAVE IRQ.CODE
 1020 *--------------------------------
 1030 IRQ1	 LDA #BLACK
 1040		 STA BACKGROUND.COLOR0
 1050		 JSR SETUP.HIRES
 1060		 INC SEED
 1070		 LDA SPRITE.SCOLIDE
 1080		 STA SPRITE.COLLISION	READ BELOW GROUND COLLISIONS
 1090		 LDA SPRITE.BCOLIDE
 1100		 STA BUCHIT
 1110		 ORA CHOP.BACK.COLL
 1120		 STA CHOP.BACK.COLL
 1130		 LDA #$00
 1140		 STA CHOP.DIR
 1150		 LDA #$02
 1160		 STA BOMB.SPEED
 1170		 JSR CHECK.ROT
 1180		 JSR DO.BOMBS
 1190 *--------------------------------
 1200 * RESTORE MULTI USED SPRITES
 1210 *--------------------------------
 1220 SP.UPDATE  LDA #$24
 1230		 STA SPRITE.POINTER+3
 1240		 LDY SUNPH
 1250		 LDA SUN.TABLE,Y
 1260		 STA SPRITE.POINTER+4
 1270		 LDA #WHITE
 1280		 STA SPRITE.COLOR+3
 1290		 LDA #YELLOW
 1300		 STA SPRITE.COLOR+4
 1310		 LDA #$18
 1320		 STA SPRITE.PRIORITY
 1330 *--------------------------------
 1340 UPDATE.YPOS LDX #$00
 1350 .1	  TXA
 1360		  ASL
 1370		  TAY
 1380		  LDA CHOP.Y,X
 1390		  STA SPRITE.YPOS,Y
 1400		  INX
 1410		  CPX #$06
 1420		  BNE .1
 1430 *--------------------------------
 1440 UPDATE.XPOS LDY #$00
 1450 .2	  TYA
 1460		  ASL
 1470		  TAX
 1480		  LDA CHOP.X,X
 1490		  STA SPRITE.XPOS,X
 1500		  LDA CHOP.XMSB,X
 1510		  BEQ .3
 1520		  LDA SPRITE.XMSB
 1530		  ORA SPRITE.MASK,Y
 1540		  STA SPRITE.XMSB
 1550		  JMP .4
 1560 *--------------------------------
 1570 .3	  LDA SPRITE.MASK,Y
 1580		  EOR #$FF
 1590		  AND SPRITE.XMSB
 1600		  STA SPRITE.XMSB
 1610 .4	  INY
 1620		  CPY #$06
 1630		  BNE .2
 1640 *--------------------------------
 1650 DO.TIME	 LDX #$09      RESET ALL TIMERS
 1660 .2	 LDA TIMER1,X
 1670		 BEQ .1
 1680		 DEC TIMER1,X
 1690 .1	 DEX
 1700		 BPL .2
 1710 *--------------------------------
 1720 CHECK.COLL LDA CHOP.Y
 1730		 SEC
 1740		 SBC #$29
 1750		 STA IRQ.PLOTY
 1760		 STA CHOP.YSC
 1770 *--------------------------------
 1780		 LDA CHOP.X
 1790		 SEC
 1800		 SBC #$13
 1810		 STA IRQ.TEMP1
 1820		 LDA CHOP.XMSB
 1830		 SBC #$00
 1840		 LSR
 1850		 ROR IRQ.TEMP1
 1860		 LDA IRQ.TEMP1
 1870		 STA IRQ.PLOTX
 1880		 STA CHOP.XSC
 1890 *--------------------------------
 1900		 JSR IRQ.PLOTCL
 1910		 LDA IRQ.PLOTX
 1920		 AND #$03
 1930		 TAX
 1940 *--------------------------------
 1950 * CHECK IF HITTING PAD
 1960 *--------------------------------
 1970		 LDA CHOP.XMSB
 1980		 BNE START.COLL
 1990		 LDA IRQ.PLOTY
 2000		 SEC
 2010		 SBC #$08
 2020		 CMP INILVL
 2030		 BCS START.COLL
 2040		 LDA IRQ.PLOTY
 2050		 CMP MOUNTAIN.TOP
 2060		 BCC START.COLL
 2070 *--------------------------------
 2080		 LDA CHOP.Y
 2090		 CMP INICHT
 2100		 BEQ START.COLL
 2110		 BCC START.COLL
 2120		 LDA CHOP.X
 2130		 CMP #$35
 2140		 BCS START.COLL
 2150 *--------------------------------
 2160		 LDA #$01     HIT PAD
 2170		 STA HIT0
 2180 *--------------------------------
 2190 START.COLL LDA IRQ.PLOTY
 2200		 CMP INILVL	ABOVE GROUND?
 2210		 BCC .33	YES
 2220 *--------------------------------
 2230 * UNDER GROUND CHECKS
 2240 * DO SOFTWARE COLLISION
 2250 *--------------------------------
 2260		 LDY #$00
 2270		 LDA BOMB.MASK,X
 2280		 EOR #$FF
 2290		 AND (IRQ.LO),Y
 2300		 CMP WATER.COLOR,X
 2310		 BNE .3
 2320 *--------------------------------
 2330		 LDA #$01
 2340		 STA HIT0	  WE HIT WATER
 2350 *--------------------------------
 2360 .3	 CMP DIRT.COLOR,X
 2370		 BNE .34
 2380 *--------------------------------
 2390		 LDA #$01
 2400		 STA HIT0
 2410 *--------------------------------
 2420 * UNDERGROUND HARDWARE COLLISION
 2430 *--------------------------------
 2440 .34	 LDA CHOP.BACK.COLL
 2450		 AND #$01
 2460		 BEQ NO.COLL
 2470 *--------------------------------
 2480		 LDA INILVL
 2490		 CLC
 2500		 ADC #$09
 2510		 CMP IRQ.PLOTY
 2520		 BCC .28
 2530 *--------------------------------
 2540		 JMP NO.COLL
 2550 *--------------------------------
 2560 * CHECK ABOVE GROUND
 2570 * HARDWARE COLLISION
 2580 *--------------------------------
 2590 .33	 LDA CHOP.BACK.COLL CHOPPER TO BACKGROUND
 2600		 AND #$01	    COPY COLLISION
 2610		 BEQ NO.COLL
 2620 *--------------------------------
 2630		 LDA CHOP.XMSB	 MAKE SURE CHOP
 2640		 BNE .2 	 IS ON LEFT SIDE
 2650		 LDA CHOP.Y
 2660		 CMP INICHT
 2670		 BNE .2
 2680		 LDA CHOP.X
 2690		 CMP #$38      IF CHOP.X<$3D THEN
 2700		 BCC .1        WE ARE OVER PAD
 2710 *--------------------------------
 2720 * SOFTWARE COLLISION FOR SMARTBOMB
 2730 *--------------------------------
 2740 .2	 LDA IRQ.PLOTY
 2750		 STA IRQ.TEMP1
 2760		 LDA CHOP.Y
 2770		 SEC
 2780		 SBC #$2F
 2790		 STA IRQ.PLOTY
 2800		 JSR IRQ.PLOTCL
 2810 *--------------------------------
 2820		 LDY #$00
 2830		 LDA BOMB.MASK,X
 2840		 EOR #$FF
 2850		 AND (IRQ.LO),Y
 2860		 CMP BOMB.SHAPE,X
 2870		 BNE .22
 2880 *--------------------------------
 2890		 LDA INICHT
 2900		 SEC
 2910		 SBC #$02
 2920		 CMP CHOP.Y
 2930		 BEQ .22
 2940		 LDA CHOP.X
 2950		 CMP #$38
 2960		 BCS .28
 2970 *--------------------------------
 2980 .22	 LDA IRQ.TEMP1
 2990		 STA IRQ.PLOTY
 3000		 LDA MOUNTAIN.TOP
 3010		 CMP IRQ.PLOTY	IRQ.PLOTY<=TOP
 3020		 BCC NO.COLL	NO
 3030 *--------------------------------
 3040 .28	 LDA #$01      WE MUST OF HIT
 3050		 STA HIT0      GROUND
 3060		 BNE NO.COLL
 3070 *--------------------------------
 3080 .1	 LDA #$01      TELL EVERYONE WE ARE
 3090		 STA LANDFG    ON LANDING PAD
 3100		 BNE DO.SUN
 3110 *--------------------------------
 3120 NO.COLL	 LDA #$00      WE ARE NOT
 3130		 STA LANDFG    ON LANDING PAD
 3140 *--------------------------------
 3150 * CHECK FOR PAUSE
 3160 *--------------------------------
 3170 DO.SUN	 LDA PAUSE
 3180		 BEQ .3
 3190		 JMP MOD3
 3200 *--------------------------------
 3210 .3	 LDA SUN.TIM
 3220		 BNE .1
 3230		 LDA #$06
 3240		 STA SUN.TIM
 3250		 LDY SUNPH
 3260		 LDA SUN.TABLE,Y
 3270		 STA SPRITE.POINTER+4
 3280		 INC SUNPH
 3290		 LDA SUNPH
 3300		 CMP #$06
 3310		 BNE .1
 3320		 LDA #$00
 3330		 STA SUNPH
 3340 *--------------------------------
 3350 .1	 DEC SUN.TIM
 3360		 LDA CHOP.TIM	  CHECK IF TIME TO DO
 3370		 BEQ .2 	CHOPPER
 3380 *--------------------------------
 3390		 JMP DO.DIRT
 3400 *--------------------------------
 3410 .2	 LDA CHOP.SPEED   SET CHOPPER UPDATE
 3420		 STA CHOP.TIM	  SPEED
 3430		 LDX BODPH	    POINT TO THE
 3440		 LDA CHOP.SHAPE,X   CHOPPER SHAPE THAT
 3450		 STA SPRITE.POINTER WE WANT
 3460		 LDA DEMO
 3470		 BEQ MOVE.CHOP
 3480 *--------------------------------
 3490		 JMP MOD3
 3500 *--------------------------------
 3510 * MOVE CHOPPER
 3520 *--------------------------------
 3530 MOVE.CHOP  LDA INCUD
 3540		 BEQ READ.ST
 3550		 JMP DO.DIRT
 3560 *--------------------------------
 3570 READ.ST	 LDA STICK.TMP
 3580		 ROR
 3590		 BCS DO.DWN
 3600 DO.UP	 PHA
 3610		 LDA CHOP.Y
 3620		 CMP #$3F
 3630		 BEQ .1
 3640		 DEC CHOP.Y
 3650 .1	 PLA
 3660 *--------------------------------
 3670 DO.DWN	 ROR
 3680		 BCS DO.LFT
 3690		 PHA
 3700		 LDA LANDFG  CHECK IF ON LANDING
 3710		 BNE .1      PAD
 3720		 LDA CHOP.Y
 3730		 INC CHOP.Y
 3740 .1	 PLA
 3750 *--------------------------------
 3760 DO.LFT	 ROR
 3770		 BCS DO.RT
 3780		 PHA
 3790		 LDA #$02
 3800		 STA CHOP.DIR
 3810		 PLA
 3820 *--------------------------------
 3830 DO.RT	 ROR
 3840		 BCS DO.CHOP
 3850		 LDA #$01
 3860		 STA CHOP.DIR
 3870 *--------------------------------
 3880 DO.CHOP	 LDA CHOP.DIR
 3890		 CMP #$01
 3900		 BEQ RIGHT
 3910		 CMP #$02
 3920		 BEQ LEFT
 3930 *--------------------------------
 3940		 JMP DO.DIRT
 3950 *--------------------------------
 3960 LEFT	 LDA BODPH
 3970		 BEQ .11
 3980 *--------------------------------
 3990		 JMP DO.DIRT
 4000 *--------------------------------
 4010 .11	 LDA CHOP.XMSB
 4020		 BNE .1
 4030		 LDA CHOP.X
 4040		 CMP #$1E
 4050		 BEQ DO.DIRT
 4060 .1	 LDA CHOP.X
 4070		 SEC
 4080		 SBC #$01
 4090		 STA CHOP.X
 4100		 BCS DO.DIRT
 4110		 LDA #$00
 4120		 STA CHOP.XMSB
 4130		 BEQ DO.DIRT
 4140 *--------------------------------
 4150 RIGHT	 LDA BODPH
 4160		 CMP #$04
 4170		 BEQ .11
 4180 *--------------------------------
 4190		 JMP DO.DIRT
 4200 *--------------------------------
 4210 .11	 LDA CHOP.XMSB
 4220		 BEQ .1
 4230		 LDA CHOP.X
 4240		 CMP #$2E
 4250		 BEQ DO.DIRT
 4260 .1	 LDA CHOP.X
 4270		 CLC
 4280		 ADC #$01
 4290		 STA CHOP.X
 4300		 BCC DO.DIRT
 4310		 LDA #$01
 4320		 STA CHOP.XMSB
 4330 *--------------------------------
 4340 *  START THE DIRT DROPPING
 4350 *--------------------------------
 4360 DO.DIRT	 DEC CHOP.TIM
 4370		 LDX PLNDIR
 4380		 LDY DROPWT    WAITING FOR DROP?
 4390		 BEQ START.GUN	 NO
 4400 *--------------------------------
 4410		 LDA PLANE.X
 4420		 SEC
 4430		 SBC #$10
 4440		 STA IRQ.TEMP1
 4450		 LDA PLANE.XMSB
 4460		 SBC #$00
 4470		 LSR
 4480		 ROR IRQ.TEMP1
 4490		 LDA IRQ.TEMP1
 4500		 CMP DRPCOL	 SAME AS DROP COLUMN?
 4510		 BNE START.GUN	   NO
 4520		 INC DROPGO	 DROP DIRT
 4530 *--------------------------------
 4540 START.GUN  LDA GUNFAL	 DROP GUN?
 4550		 BEQ MOD3  NO
 4560		 LDA PLANE.X
 4570		 CMP GUN.X
 4580		 BNE MOD3
 4590		 INC GUNFGO    START GUN FALLING
 4600		 LDA #50
 4610		 STA GUN.Y     SHOW GUN ON SCREEN
 4620 *--------------------------------
 4630 MOD3	 LDA #$B0
 4640		 LDX #IRQ1.2
 4650		 LDY /IRQ1.2
 4660		 STA RASTER
 4670		 STX IRQLO
 4680		 STY IRQHI
 4690		 LDA #$81
 4700		 STA VIC.IRQ
 4710		 PLA
 4720		 TAY
 4730		 PLA
 4740		 TAX
 4750		 PLA
 4760		 RTI
 4770 *--------------------------------
 4780 * RESTORE BACKGROUND COLOR
 4790 * AT BASE OF MOUNTAINS
 4800 *
 4810 * 	IRQ1.2
 4820 *--------------------------------
 4830 IRQ1.2	 LDA #BLACK
 4840 ONE	 LDX RASTER
 4850 MOD4	 CPX #$B6
 4860		 BCC ONE	     WAS BNE!
 4870		 STA BACKGROUND.COLOR0
 4880 *--------------------------------
 4890 .11	 LDA DEMO    IN DEMO
 4900		 BEQ .1      NO
 4910 *--------------------------------
 4920		 JMP DO.BLADES
 4930 *--------------------------------
 4940 .1	 LDA SPRITE.BCOLIDE
 4950		 STA CHOP.BACK.COLL
 4960		 LDA SPRITE.SCOLIDE    CLEAR COLLISION REGISTER
 4970 *--------------------------------
 4980		 LDA PRIZE.1		POINT TO THE BUCKS
 4990		 STA SPRITE.POINTER+3
 5000		 LDA PRIZE.2
 5010		 STA SPRITE.POINTER+4
 5020		 LDA PRIZE.3
 5030		 STA SPRITE.POINTER+5
 5040 *--------------------------------
 5050		 LDA #$07
 5060		 STA SPRITE.MULTI.COLOR
 5070		 LDA #$00
 5080		 STA SPRITE.PRIORITY
 5090 *--------------------------------
 5100		 LDA PRIZE.1C
 5110		 STA SPRITE.COLOR+3
 5120		 LDA PRIZE.2C
 5130		 STA SPRITE.COLOR+4
 5140		 LDA PRIZE.3C
 5150		 STA SPRITE.COLOR+5
 5160 *--------------------------------
 5170 * POSITION BUCKS DURING INTERUPT
 5180 *--------------------------------
 5190		 LDY #$00
 5200 .2	 TYA
 5210		 ASL
 5220		 TAX
 5230		 LDA BUC1.X,X
 5240		 STA SPRITE.XPOS+6,X
 5250		 LDA BUC1.XMSB,X
 5260		 BEQ .3
 5270		 LDA SPRITE.XMSB
 5280		 ORA SPRITE.MASK+3,Y
 5290		 STA SPRITE.XMSB
 5300		 JMP .4
 5310 .3	 LDA SPRITE.MASK+3,Y
 5320		 EOR #$FF
 5330		 AND SPRITE.XMSB
 5340		 STA SPRITE.XMSB
 5350 .4	 INY
 5360		 CPY #$04
 5370		 BNE .2
 5380 *--------------------------------
 5390		 LDA BUC1.Y
 5400		 STA SPRITE.YPOS+6
 5410		 LDA BUC2.Y
 5420		 STA SPRITE.YPOS+8
 5430		 LDA BUC3.Y
 5440		 STA SPRITE.YPOS+10
 5450 *--------------------------------
 5460 *  CHECK FOR PAUSE
 5470 *--------------------------------
 5480		 LDA PAUSE
 5490		 BEQ DO.BLADES
 5500		 JMP MOD
 5510 *--------------------------------
 5520 *  BLADE CODE
 5530 *--------------------------------
 5540 DO.BLADES  LDA BLADE.TIM
 5550		 BNE SKIP.BLADE
 5560		 LDA #$01
 5570		 STA BLADE.TIM
 5580 *--------------------------------
 5590		 LDA #$81   VOICE 1 ON
 5600		 STA $D404
 5610 *--------------------------------
 5620		 LDY BLDPH
 5630		 LDA BLADE.TABLE,Y
 5640		 TAX
 5650		 LDY #$05
 5660 .1	 LDA BLADE.SHAPE,X
 5670		 STA SPRITE.MEMORY+09,Y
 5680		 STA SPRITE.MEMORY+$40+09,Y
 5690		 STA SPRITE.MEMORY+$80+09,Y
 5700		 STA SPRITE.MEMORY+$C0+09,Y
 5710		 STA SPRITE.MEMORY+$100+09,Y
 5720		 DEX
 5730		 DEY
 5740		 BPL .1
 5750		 INC BLDPH
 5760		 LDA BLDPH
 5770		 CMP #$0A
 5780		 BNE SKIP.BLADE
 5790 *--------------------------------
 5800		 LDA $D404   VOICE 1 OFF
 5810		 AND #$FE
 5820		 STA $D404
 5830 *--------------------------------
 5840		 LDA #$00
 5850		 STA BLDPH
 5860 *--------------------------------
 5870 SKIP.BLADE DEC BLADE.TIM
 5880 *--------------------------------
 5890 DO.PLANE	 LDA TRANSIT
 5900		 BEQ MOD
 5910 *--------------------------------
 5920		 LDA #$01
 5930		 STA PLANE.TIM
 5940 *--------------------------------
 5950 PLANE.LUP  LDA PLNDIR
 5960		 BNE .1
 5970 *--------------------------------
 5980		 LDA PLANE.XMSB
 5990		 BNE .3
 6000		 LDA PLANE.X
 6010		 CMP #$02
 6020		 BEQ .5
 6030 .3	 LDA PLANE.X
 6040		 SEC
 6050		 SBC #$01
 6060		 STA PLANE.X
 6070		 BCS PLANE.EXIT
 6080		 LDA #$00
 6090		 STA PLANE.XMSB
 6100		 BEQ PLANE.EXIT  ALWAYS
 6110 *--------------------------------
 6120 .1	 LDA PLANE.XMSB
 6130		 BEQ .4
 6140		 LDA PLANE.X
 6150		 CMP #$50
 6160		 BEQ .5
 6170 *--------------------------------
 6180 .4	 LDA PLANE.X
 6190		 CLC
 6200		 ADC #$01
 6210		 STA PLANE.X
 6220		 BCC PLANE.EXIT
 6230		 LDA #$01
 6240		 STA PLANE.XMSB
 6250		 BNE PLANE.EXIT    ALWAYS
 6260 *--------------------------------
 6270 .5	 LDA #$00
 6280		 STA TRANSIT
 6290		 STA PLANE.SOUND     NO PLANE SOUND
 6300 *--------------------------------
 6310 PLANE.EXIT DEC PLANE.TIM
 6320		 BNE PLANE.LUP
 6330 *--------------------------------
 6340 MOD	 LDA #$D0
 6350 MOD1	 LDX #IRQ3
 6360 MOD2	 LDY /IRQ3
 6370		 STA RASTER
 6380		 STX IRQLO
 6390		 STY IRQHI
 6400		 LDA #$81
 6410		 STA VIC.IRQ
 6420		 PLA
 6430		 TAY
 6440		 PLA
 6450		 TAX
 6460		 PLA
 6470		 RTI
 6480 *--------------------------------
 6490 *  IRQ 2	 RESTORE BACKGROUND COLOR
 6500 *--------------------------------
 6510 IRQ2	 LDY #$06
 6520		 LDA VIC.CONTROL.2	TURN OFF HIRES
 6530		 AND #239
 6540		 STA IRQ.TEMP2
 6550		 LDA #223
 6560		 AND VIC.CONTROL.1	*****
 6570		 STA IRQ.TEMP1
 6580		 LDA #ORANGE
 6590 .1	 LDX RASTER
 6600		 CPX #$E7
 6610		 BCC .1 		WAS BNE!
 6620 *--------------------------------
 6630		 STA BACKGROUND.COLOR0
 6640		 STY VIC.MEMORY 	SET UP TEXT MODE
 6650		 LDA IRQ.TEMP1		TURN OFF HIRES
 6660		 STA VIC.CONTROL.1
 6670		 LDA IRQ.TEMP2
 6680		 STA VIC.CONTROL.2
 6690 *--------------------------------
 6700 IRQ2.END	 LDA #$00
 6710		 LDX #IRQ1
 6720		 LDY /IRQ1
 6730		 STA RASTER
 6740		 STX IRQLO
 6750		 STY IRQHI
 6760		 LDA #$81
 6770		 STA VIC.IRQ
 6780		 PLA
 6790		 TAY
 6800		 PLA
 6810		 TAX
 6820		 PLA
 6830		 RTI
 6840 *--------------------------------
 6850 *  IRQ3
 6860 *--------------------------------
 6870 IRQ3	 LDA #223
 6880		 AND VIC.CONTROL.1 ****
 6890		 STA IRQ.TEMP1
 6900		 LDA #239
 6910		 AND VIC.CONTROL.2  *****
 6920		 STA IRQ.TEMP2
 6930		 LDA #BROWN
 6940		 LDY #$06
 6950 .2	 LDX RASTER
 6960		 CPX #$CF
 6970		 BCC .2 	  WAS BNE
 6980		 STA BACKGROUND.COLOR0
 6990		 STY VIC.MEMORY
 7000		 LDA IRQ.TEMP1
 7010		 STA VIC.CONTROL.1
 7020		 LDA IRQ.TEMP2
 7030		 STA VIC.CONTROL.2
 7040		 LDA #$00
 7050		 LDX #IRQ1
 7060		 LDY /IRQ1
 7070		 STA RASTER
 7080		 STX IRQLO
 7090		 STY IRQHI
 7100		 LDA #$81
 7110		 STA VIC.IRQ
 7120		 PLA
 7130		 TAY
 7140		 PLA
 7150		 TAX
 7160		 PLA
 7170		 RTI
 7180 *--------------------------------
 7190 *  MODIFY CODE IN IRQ1
 7200 *--------------------------------
 7210 INIT.IRQ	 SEI
 7220		 LDA DEMO
 7230		 TAY
 7240		 LDA INT.RASTER2,Y
 7250		 STA MOD+1
 7260		 TYA
 7270		 ASL
 7280		 TAY
 7290		 LDA INT.ADDRESS,Y
 7300		 STA MOD1+1
 7310		 LDA INT.ADDRESS+1,Y
 7320		 STA MOD2+1
 7330		 LDA #$B0
 7340		 STA MOD3+1
 7350		 LDA #$B6
 7360		 STA MOD4+1
 7370 *--------------------------------
 7380		 CLI
 7390		 RTS
 7400 *--------------------------------
 7410 CHANGE.IRQ SEI
 7420		 LDA DEMO
 7430		 BNE INT.END
 7440 *--------------------------------
 7450		 LDA BILEVL
 7460		 AND #$03
 7470		 TAY
 7480		 LDA INT.RASTER,Y
 7490		 STA MOD3+1
 7500		 LDA INT.CPX,Y
 7510		 STA MOD4+1
 7520 *--------------------------------
 7530 INT.END	 CLI
 7540		 RTS
 7550 *--------------------------------
 7560 *  DELAY ROUTINE
 7570 *--------------------------------
 7580 DELAY	 PHA
 7590		 TYA
 7600		 PHA
 7610		 TXA
 7620		 PHA
 7630 *--------------------------------
 7640		 LDY #$05
 7650 .1	 LDX #$FF
 7660 .2	 DEX
 7670		 BNE .2
 7680		 DEY
 7690		 BNE .1
 7700 *--------------------------------
 7710		 PLA
 7720		 TAX
 7730		 PLA
 7740		 TAY
 7750		 PLA
 7760 *--------------------------------
 7770		 RTS
