 1000 *
 1010 * SAVE CHOP.CODE.3
 1020 *--------------------------------
 1030 DO.BUCKS	 LDA #$02     3 BUCKS
 1040		 STA BUC.NUM
 1050 *--------------------------------
 1060 .12	 LDA #$0A     10 TRYS
 1070		 STA BUCTRY
 1080 *--------------------------------
 1090 .1	 JSR MAKE.RANDOM GET BUCKS HORIZONTAL
 1100		 ROR
 1110		 ROR
 1120		 AND #$01
 1130		 STA TEMP1
 1140		 LDA BUC.NUM
 1150		 ASL		*2
 1160		 CLC
 1170		 ADC TEMP1
 1180		 TAX
 1190		 LDA BUC.XPOS,X
 1200 *--------------------------------
 1210		 LDX BUC.NUM  SAVE HORIZONTAL POSITION
 1220 * 	 STA BUCHPC   (USED BY CHECK.POS)
 1230		 STA BHPO,X
 1240		 STA B2HPO,X
 1250		 JSR MAKE.RANDOM  GET RANDOM MSB
 1260		 LDA #$00
 1270		 LDX BUC.NUM
 1280 * 	 STA BUCHPC.XMSB
 1290		 STA BHPO.XMSB,X
 1300		 STA B2HPO.XMSB,X
 1310 *--------------------------------
 1320 .16	 JSR MAKE.RANDOM
 1330		 AND #$01
 1340		 CLC
 1350		 ADC BUC.NUM
 1360 .18	 TAX
 1370 *--------------------------------
 1380		 LDA BILEVL
 1390		 AND #$07
 1400		 CLC
 1410		 ADC #$02
 1420		 STA TEMP1    # OF LEVELS OF DIRT
 1430 *--------------------------------
 1440 .20	 CPX TEMP1    X<TEMP1
 1450		 BCC .19      YES
 1460		 DEX
 1470		 JMP .20
 1480 *--------------------------------
 1490 .19	 LDA BUC.YPOS,X
 1500 .29	 LDX BUC.NUM
 1510		 STA BUCVPC    SAVE VERTICAL POSITION
 1520		 STA BUC1VP,X  (USED BY CHECK.POS)
 1530		 STA B2C1VP,X
 1540 *--------------------------------
 1550		 DEC BUC.NUM   NEXT BUCK
 1560		 BMI .2
 1570		 JMP .12
 1580 *--------------------------------
 1590 .4	 DEC BUCTRY	 TRY AGAIN
 1600		 BMI .2
 1610		 JMP .1
 1620 *--------------------------------
 1630 .2	 LDA BHPO      LET IRQ PUT
 1640		 STA BUC1.X    BUCKS ON SCREEN
 1650		 LDA BHPO+1
 1660		 STA BUC2.X
 1670		 LDA BHPO+2
 1680		 STA BUC3.X
 1690 *--------------------------------
 1700		 LDA #$00
 1710		 STA BUC1.XMSB
 1720		 STA BUC2.XMSB
 1730		 STA BUC3.XMSB
 1740 *--------------------------------
 1750		 LDA BUC1VP  ENTER HERE FOR
 1760		 STA BUC1.Y  PLAYER #2
 1770		 LDA BUC2VP
 1780		 STA BUC2.Y
 1790		 LDA BUC3VP
 1800		 STA BUC3.Y
 1810 *--------------------------------
 1820		 LDA #$01   INDICATE THAT ALL
 1830		 STA SHOB1  BOMBS ARE ON SCREEN
 1840		 STA SHOB2
 1850		 STA SHOB3
 1860		 RTS
 1870 *--------------------------------
 1880 *  PICKED UP BUCKS?
 1890 *--------------------------------
 1900 BUCK.CHECK LDA FERRY   CARRYING $'S?
 1910		 BNE DONE.CK
 1920		 LDA DEAD      DEAD
 1930		 BNE DONE.CK   YES
 1940		 LDA LANDFG    LANDED
 1950		 BNE DONE.CK   YES
 1960		 LDA CHOP.EXPL CHOPPER EXPLODING
 1970		 BNE DONE.CK   YES
 1980		 LDA SPRITE.COLLISION
 1990		 AND #$38	       CHOP AND BUCK COLLISIONS ONLY
 2000		 BEQ DONE.CK	       NO COLLISIONS
 2010 *--------------------------------
 2020		 LDA SPRITE.COLLISION	CHECK IF COLLIDING WITH CHOPPER
 2030		 AND #$01
 2040		 BEQ DONE.CK		CHOPPER IS NOT PART OF COLLISION
 2050 *--------------------------------
 2060		 LDA #$01
 2070		 STA NOUPDT		DONT ALLOW COLL. UPDATE
 2080 .11	 LDA SPRITE.COLLISION
 2090		 AND #$08		CHECK SPRITE #3
 2100		 BEQ .1 		NOT SPRITE #3
 2110		 LDA #$00	     CARRYING BUCK 0
 2120		 STA FERIX
 2130		 JMP .3
 2140 *--------------------------------
 2150 .1	 LDA SPRITE.COLLISION
 2160		 AND #$10		CHECK SPRITE #4
 2170		 BEQ .2 		NOT SPRITE #4
 2180		 LDA #$01	     CARRYING BUCK 1
 2190		 STA FERIX
 2200		 JMP .3
 2210 *--------------------------------
 2220 .2	 LDA SPRITE.COLLISION
 2230		 AND #$20		CHECK SPRITE #5
 2240		 BEQ UPDATE.ON		NOT SPRITE #5	(IF IT GOT HERE NO PRIZES INVOLVED)
 2250		 LDA #$02	     CARRYING BUCK 2
 2260		 STA FERIX
 2270 .3	 LDA #$01	     WE ARE CARRYING A BUCK
 2280		 STA FERRY
 2290		 LDA #$01	 DO PICKED UP
 2300		 STA BUC.SOUND	 BUC SOUND
 2310		 LDA FERIX	     DID WE GET BUC1
 2320		 BNE .4 	     NO
 2330 *--------------------------------
 2340		 JSR CLEAR.B1	     REMOVE FROM SCREEN
 2350		 JMP UPDATE.ON
 2360 *--------------------------------
 2370 .4	 CMP #$01	     DID WE GET BUC2
 2380		 BNE .5 	     NO
 2390		 JSR CLEAR.B2	     REMOVE FROM SCREEN
 2400		 JMP UPDATE.ON
 2410 *--------------------------------
 2420 .5	 CMP #$02	     DID WE GET BUC3
 2430		 BNE UPDATE.ON	     NO
 2440		 JSR CLEAR.B3	     REMOVE FROM SCREEN
 2450 UPDATE.ON  LDA #$00	     DEC NOUPDT
 2460		 STA NOUPDT
 2470 DONE.CK	 RTS
 2480 *--------------------------------
 2490 * MOVE BUCKS OFF SCREEN BUT
 2500 * DONT ALLOW THEM TO COLLIDE
 2510 * WITH EACH OTHER
 2520 *--------------------------------
 2530 CLEAR.B1	 LDA #$00
 2540		 STA BUC1.X
 2550		 STA BUC1.XMSB
 2560		 LDA #$10
 2570		 STA BUC1.Y
 2580		 LDA #$00
 2590		 STA SHOB1
 2600		 RTS
 2610 *--------------------------------
 2620 CLEAR.B2	 LDA #$00
 2630		 STA BUC2.X
 2640		 STA BUC2.XMSB
 2650		 LDA #$40
 2660		 STA BUC2.Y
 2670		 LDA #$00
 2680		 STA SHOB2
 2690		 RTS
 2700 *--------------------------------
 2710 CLEAR.B3	 LDA #$00
 2720		 STA BUC3.X
 2730		 STA BUC3.XMSB
 2740		 LDA #$70
 2750		 STA BUC3.Y
 2760		 LDA #$00
 2770		 STA SHOB3
 2780		 RTS
 2790 *--------------------------------
 2800 * DROP PRIZES IF NECESSARY
 2810 *--------------------------------
 2820 BUCFALL.CK LDA BUCHIT
 2830		 AND #$08     SPRITE #3 COLLISION
 2840		 STA BHIT1    (BUC1)
 2850		 LDA BUCHIT
 2860		 AND #$10     SPRITE #4 COLLISION
 2870		 STA BHIT2    (BUC2)
 2880		 LDA BUCHIT
 2890		 AND #$20     SPRITE #5 COLLISION
 2900		 STA BHIT3    (BUC3)
 2910 *--------------------------------
 2920		 LDX #$02
 2930 .1	 STX BFXHLD
 2940		 LDA FERRY    ARE WE CARRYIN ANY BUCS
 2950		 BEQ .2       NO
 2960		 LDA FERIX    ARE WE CARRYING THIS BUC
 2970		 CMP BFXHLD
 2980		 BEQ .3       YES. DONT HAVE TO CHECK IT
 2990 *--------------------------------
 3000 .2	 LDA SHOB1,X   IS BAG ON SCREEN
 3010		 BEQ .3        NO
 3020 *--------------------------------
 3030		 LDA BHIT1,X   IS BAG HITTING DIRT
 3040		 BNE .3        YES,CHECK NEXT ONE
 3050 *--------------------------------
 3060		 LDY BUC1VP,X  INCREMENT THE BUCKS
 3070		 INY	       Y POSITION
 3080		 STY BUC1VP,X
 3090		 CPY #$D5      IS IT AT THE BOTTOM
 3100		 BCC .4        NO
 3110 *--------------------------------
 3120 * CLEAR THE ONE THAT DROPED THROUGH
 3130 * THE BOTTOM OF THE SCREEN
 3140 *--------------------------------
 3150		 LDA BFXHLD  BUC1
 3160		 BNE .5      NO
 3170		 JSR CLEAR.B1  REMOVE FROM SCREEN
 3180		 JMP .3
 3190 *--------------------------------
 3200 .5	 CMP #$01    BUC2
 3210		 BNE .6      NO
 3220		 JSR CLEAR.B2  REMOVE FROM SCREEN
 3230		 JMP .3
 3240 .6	 JSR CLEAR.B3 MUST BE BUC3. REMOVE IT
 3250 .3	 LDX BFXHLD   NEXT BUC
 3260		 DEX
 3270		 BPL .1
 3280		 RTS
 3290 .4	 JSR SHOW.BUCK
 3300		 JMP .3
 3310 *--------------------------------
 3320 SHOW.BUCK  LDA BUC1VP
 3330		 STA BUC1.Y
 3340		 LDA BUC2VP
 3350		 STA BUC2.Y
 3360		 LDA BUC3VP
 3370		 STA BUC3.Y
 3380		 RTS
 3390 *--------------------------------
 3400 * RANDOM NUMBER GENERATOR
 3410 *--------------------------------
 3420 MAKE.RANDOM INC SEED
 3430		  LDA RANDOM
 3440		  ASL
 3450		  EOR SEED
 3460		  ASL
 3470		  EOR RANDOM
 3480		  ROL RANDOM
 3490		  LDA RANDOM
 3500		  BNE .1
 3510		  LDA SEED
 3520		  ORA #$63
 3530		  STA RANDOM
 3540 .1	  RTS
 3550 *--------------------------------
 3560 *  CHOPPER CODE
 3570 *--------------------------------
 3580 CHOPPR	 LDA NPWAIT  WAITING FOR NEW PLAYER
 3590		 BEQ CHOPR2  NO
 3600		 RTS
 3610 CHOPR2	 LDA HIT0    CHOPPER HIT BACKGROUND?
 3620		 BEQ CHOPR3  NO
 3630		 JMP CRASH
 3640 *--------------------------------
 3650 *  SUBTRACT 1$ FOR EACH PIXEL
 3660 *  OF GROUND DESTROYED
 3670 *--------------------------------
 3680 CHOPR3	 LDA DEAD    IS HE DEAD
 3690		 BEQ .11	 NO
 3700		 JMP CHOP.END	 YES
 3710 *--------------------------------
 3720 .11	 LDA DRTHIT  ARE WE HITTING DIRT
 3730		 BEQ .1      NO
 3740 *--------------------------------
 3750		 DEC DRTHIT
 3760		 LDA #$01
 3770		 STA SCOCHG
 3780		 LDA #$07
 3790		 STA SCOPOS
 3800		 JSR SUBSCO
 3810		 LDA DEAD   @@@
 3820		 BEQ .1
 3830		 RTS
 3840 *--------------------------------
 3850 * CHECK IF ALL BUCKS ARE PICKED UP
 3860 *--------------------------------
 3870 .1	 LDA SHOB1   ALL THESE SHOULD
 3880		 ORA SHOB2   ARE READY FOR
 3890		 ORA SHOB3   NEXT LEVEL
 3900		 ORA FERRY
 3910		 BEQ .22
 3920		 JMP CHOP.END
 3930 *--------------------------------
 3940 * PAUSE A BIT FOR REFRESHMENTS
 3950 * IF ALL BUCKS ARE PICKED UP
 3960 *--------------------------------
 3970 .22	 LDA #$01
 3980		 STA INCUD
 3990		 STA INCLR
 4000		 STA LAND.SOUND
 4010		 JSR DO.SOUNDS
 4020 *--------------------------------
 4030 * INCREMENT LIVES IF PLAYER WASNT
 4040 * KILLED DURING LEVEL
 4050 *--------------------------------
 4060		 LDX PLAYER
 4070		 LDA LIVES,X
 4080		 BEQ .3
 4090		 CMP #99
 4100		 BEQ .3
 4110		 LDA LIVES,X
 4120		 ADC DIE.FLAG,X
 4130		 STA LIVES,X
 4140		 LDA DIE.FLAG,X
 4150		 BEQ .3
 4160		 INC LIFE1,X
 4170		 LDA LIFE1,X
 4180		 CMP #10
 4190		 BMI .3
 4200		 INC LIFE2,X
 4210		 LDA #$00
 4220		 STA LIFE1,X
 4230 *--------------------------------
 4240 .3	 JSR SHOW.LIVES
 4250		 LDA #$0A
 4260		 STA MASTER.VOLUME
 4270		 LDY #$00
 4280 .2	 TYA
 4290		 PHA			      UP
 4300		 JSR DELAY
 4310		 JSR DELAY
 4320		 JSR DO.SOUNDS
 4330		 JSR DO.PAD
 4340		 JSR DO.EXPLOSIONS
 4350		 JSR DO.GUN.FALL
 4360		 JSR GUN.SHOOT
 4370		 JSR DROP.DIRT
 4380		 JSR DO.EXPLOSIONS
 4390		 PLA
 4400		 TAY
 4410 .6	 LDX VIC.CONTROL.1
 4420		 BPL .6
 4430		 TYA
 4440		 AND #$18
 4450		 STA BORDER.COLOR
 4460		 INY
 4470		 CPY #$D0
 4480		 BNE .2
 4490 *--------------------------------
 4500		 STY BORDER.COLOR
 4510		 JSR TURN.SCREEN.OFF	   **************
 4520		 LDA #$01   ALL BUCKS ARE
 4530		 STA NPWAIT PICKED UP. READY FOR NEXT LEVEL
 4540 *--------------------------------
 4550		 LDA #$00
 4560		 STA GUN.PHASE
 4570		 STA SHOT.SOUND
 4580		 STA SHOTON
 4590		 STA GUNSHT
 4600 CHOP.END	 RTS
 4610 *--------------------------------
 4620 * DO CHOPPER ROTATION
 4630 *--------------------------------
 4640 CHECK.ROT  LDA TIMER4	SET IN IRQ1
 4650		 BNE .6 	NOT TIME TO ROTATE
 4660		 LDA #$05
 4670		 STA TIMER4
 4680 *--------------------------------
 4690		 LDA BODPH
 4700		 BEQ .11
 4710		 CMP #$02
 4720		 BEQ .11
 4730		 CMP #$04
 4740		 BEQ .11
 4750 *--------------------------------
 4760		 LDA ROTATE.LEFT
 4770		 BEQ .22
 4780		 DEC BODPH
 4790		 LDA #$00
 4800		 STA ROTATE.LEFT
 4810		 JMP .11
 4820 *--------------------------------
 4830 .22	 LDA ROTATE.RIGHT
 4840		 BEQ .11
 4850		 INC BODPH
 4860		 LDA #$00
 4870		 STA ROTATE.RIGHT
 4880 *--------------------------------
 4890 .11	 LDA STICK.TMP
 4900		 ROR		UP
 4910		 ROR		DWN
 4920		 ROR		LFT
 4930		 BCS .2
 4940 *-------------------------------
 4950 * MOVING LEFT
 4960 *--------------------------------
 4970		 PHA
 4980		 LDA BODPH
 4990		 BEQ .4
 5000		 DEC BODPH
 5010		 LDA #$01
 5020		 STA ROTATE.LEFT
 5030 .4	 PLA
 5040 *-------------------------------
 5050 * MOVING RIGHT
 5060 *--------------------------------
 5070 .2	 ROR
 5080		 BCS .6
 5090		 LDA BODPH
 5100		 CMP #$04
 5110		 BEQ .6
 5120		 INC BODPH
 5130		 LDA #$01
 5140		 STA ROTATE.RIGHT
 5150 *-------------------------------
 5160 .6	 LDA BODPH
 5170		 BEQ .7
 5180		 LDA BODPH
 5190		 CMP #$04
 5200		 BEQ .7
 5210 *--------------------------------
 5220		 LDA #$01     DONT MOVE LEFT OR RIGHT IF
 5230		 STA INCLR    FACING FORWARD
 5240		 RTS
 5250 *--------------------------------
 5260 .7	 LDA #$00     FACING RIGHT
 5270		 STA INCLR    OR LEFT SO MOVE CHOP
 5280		 RTS
 5290 *-------------------------------
 5300 *  CRASH THE CHOPPER
 5310 *--------------------------------
 5320 CRASH	 LDA CHOP.EXPL
 5330		 BEQ .11
 5340 *--------------------------------
 5350		 JMP CHK.EXPL
 5360 *--------------------------------
 5370 .11	 LDA DEAD
 5380		 BEQ .12
 5390		 RTS
 5400 *--------------------------------
 5410 .12	 LDA #$01
 5420		 STA INCUD	STOP CHOPPER
 5430 *--------------------------------
 5440		 LDA CHOP.Y
 5450		 STA CHOP.YTEM
 5460		 LDA #$FF	MOVE CHOP OFF SCREEN
 5470		 STA CHOP.Y
 5480 *--------------------------------
 5490		 LDA #$01
 5500		 STA CHOP.EXPL
 5510 *--------------------------------
 5520		 LDA FERRY    CARRYING ANY BUCS
 5530		 BEQ .9       NO
 5540 *--------------------------------
 5550		 LDA #$00
 5560		 STA FERRY
 5570 *--------------------------------
 5580		 LDA FERIX    CARRYING BUC1
 5590		 BNE .1       NO
 5600 *--------------------------------
 5610		 LDA CHOP.X	 SET BUC POSITION
 5620		 STA BUC1.X	 BELOW CHOPPER
 5630		 LDA CHOP.XMSB
 5640		 STA BUC1.XMSB
 5650		 LDA CHOP.YTEM	 **
 5660		 STA BUC1VP
 5670		 STA BUC1.Y
 5680 *--------------------------------
 5690		 LDA #$01     PRIZE #1 NOW ON
 5700		 STA SHOB1    SCREEN
 5710 *--------------------------------
 5720		 LDA #$FF
 5730		 STA FERIX
 5740 *--------------------------------
 5750		 JMP .9
 5760 *--------------------------------
 5770 .1	 CMP #$01     CARRYING BUC2
 5780		 BNE .2       NO
 5790 *--------------------------------
 5800		 LDA CHOP.X	 SET BUC2 POSITION
 5810		 STA BUC2.X	 BELOW CHOPPER
 5820		 LDA CHOP.XMSB
 5830		 STA BUC2.XMSB
 5840		 LDA CHOP.YTEM
 5850		 STA BUC2VP
 5860		 STA BUC2.Y
 5870 *--------------------------------
 5880		 LDA #$01
 5890		 STA SHOB2
 5900 *--------------------------------
 5910		 LDA #$FF
 5920		 STA FERIX
 5930 *--------------------------------
 5940		 JMP .9
 5950 *--------------------------------
 5960 .2	 CMP #$02     CARRYING BUC3
 5970		 BNE .9       NO
 5980 *--------------------------------
 5990		 LDA CHOP.X	 SET BUC3 POSITION
 6000		 STA BUC3.X	 BELOW CHOPPER
 6010		 LDA CHOP.XMSB
 6020		 STA BUC3.XMSB
 6030		 LDA CHOP.YTEM
 6040		 STA BUC3VP
 6050		 STA BUC3.Y
 6060 *--------------------------------
 6070		 LDA #$01
 6080		 STA SHOB3
 6090 *--------------------------------
 6100		 LDA #$FF
 6110		 STA FERIX
 6120 *--------------------------------
 6130 *.8	  JSR SHOW.BUCK   SHOW THE BUC
 6140 *--------------------------------
 6150 .9	 LDA CHOP.YTEM	 CONVERT SPRITE COORDINATES
 6160		 SEC		 TO SCREEN COORDINATES
 6170		 SBC #$2C
 6180		 STA PLOTY
 6190		 LDA CHOP.X
 6200		 SEC
 6210		 SBC #$10
 6220		 STA TEMP1
 6230		 LDA CHOP.XMSB
 6240		 SBC #$00
 6250		 LSR	     DIVIDE BY 2
 6260		 ROR TEMP1
 6270		 LDA TEMP1
 6280		 STA PLOTX
 6290 *--------------------------------
 6300 *  DO EXPLOSION
 6310 *--------------------------------
 6320		 LDA #$01
 6330		 STA EXPGO+4
 6340		 STA EXPGO+3
 6350		 STA EXPGO+2
 6360		 LDA PLOTX
 6370		 STA EXPLR+4
 6380		 CLC
 6390		 ADC #$02
 6400		 STA EXPLR+3
 6410		 LDA PLOTX
 6420		 SEC
 6430		 SBC #$04
 6440		 STA EXPLR+2
 6450		 LDA PLOTY
 6460		 STA EXPHT+4
 6470		 CLC
 6480		 SBC #$02
 6490		 STA EXPHT+3
 6500		 STA EXPHT+2
 6510		 JSR DO.EXPLOSIONS
 6520 *--------------------------------
 6530 CHK.EXPL	 LDA EXPCNT  WAIT UNTIL EXPLOSIONS ARE DONE
 6540		 BEQ .1
 6550		 JMP CRASH.EXIT
 6560 *--------------------------------
 6570 .1	 STA CHOP.EXPL
 6580 WHY.ME	 LDX PLAYER
 6590		 BPL .11      ****
 6600		 RTS
 6610 .11	 LDA LIVES,X  ANY LIVES LEFT
 6620		 BEQ .1       NO
 6630		 LDA #$00	****
 6640		 STA DIE.FLAG,X ****
 6650		 DEC LIVES,X
 6660		 BNE .2
 6670 *--------------------------------
 6680 .1	 LDA #$01	 THIS PLAYER DEAD
 6690		 STA DEAD	 GO LET NEXT PLAYER TRY
 6700		 LDA #$00	 IF HE IS ALIVE
 6710		 STA HIT0
 6720 *--------------------------------
 6730 .2	 DEC LIFE1,X
 6740		 BPL .3
 6750		 LDA #$09
 6760		 STA LIFE1,X   PUT IT BACK TO NINE
 6770		 LDA LIFE2,X
 6780		 SEC
 6790		 SBC #1
 6800		 STA LIFE2,X
 6810 .3	 JSR SHOW.LIVES
 6820 *--------------------------------
 6830		 LDA DEAD
 6840		 BEQ NEW.LIFE
 6850		 RTS
 6860 *--------------------------------
 6870 * PUT CHOPPER ON PAD  (NEWLIF)
 6880 *--------------------------------
 6890 NEW.LIFE	 LDA INICHT    YPOSITION OF CHOP
 6900		 STA CHOP.Y
 6910		 LDA #$00
 6920		 STA CHOP.XMSB
 6930		 LDA #$30      XPOSITION OF CHOP
 6940		 STA CHOP.X
 6950		 LDA #$04
 6960		 STA BODPH     BODY PHASE OF CHOP
 6970		 LDA #$01
 6980		 STA LANDFG
 6990		 LDA #$00
 7000		 STA HIT0
 7010 CRASH.EXIT RTS
 7020 *--------------------------------
 7030 *  START PLANE MOVING
 7040 *--------------------------------
 7050 START.PLANE LDA TRANSIT  PLANE MOVING
 7060		  BNE .1       YES
 7070 *--------------------------------
 7080		  JSR MAKE.RANDOM
 7090		  LSR
 7100		  AND #$01
 7110		  STA PLNDIR
 7120		  TAX
 7130		  LDA PLN.SHAPE,X
 7140		  STA SPRITE.POINTER+1
 7150		  TXA
 7160		  ASL
 7170		  TAX
 7180		  LDA PLNORG,X
 7190		  STA PLANE.X
 7200		  LDA PLNORG+1,X
 7210		  STA PLANE.XMSB
 7220		  LDA #$01
 7230		  STA TRANSIT
 7240		  STA PLANE.SOUND    START SOUND
 7250		  LDA TRANCT
 7260		  BEQ .1
 7270		  DEC TRANCT  ONE MORE TRANSIT
 7280 .1	  RTS
 7290 *--------------------------------
 7300 *  TAKE CARE OF ABORTING
 7310 *--------------------------------
 7320 DO.ABORT	  LDA #$01
 7330		  STA ABORT
 7340		  STA INCUD
 7350		  STA INCLR
 7360 *--------------------------------
 7370		  LDA #$00
 7380		  STA BOMB
 7390		  STA BOMB+1
 7400		  STA BOMB+2
 7410		  STA BOMB+3
 7420 *--------------------------------
 7430		  STA CHOP.EXPL
 7440 *--------------------------------
 7450		  STA EXPCNT
 7460 *--------------------------------
 7470		  STA EXPGO
 7480		  STA EXPGO+1
 7490		  STA EXPGO+2
 7500		  STA EXPGO+3
 7510		  STA EXPGO+4
 7520		  STA EXPL.FREQ
 7530		  STA EXPL.SOUND
 7540		  STA BOMACT
 7550		  STA BOMB.COUNT
 7560		  STA ERASE.FLAG
 7570		  STA GUNFAL
 7580		  STA GUNFGO
 7590		  STA ROCNT
 7600 *--------------------------------
 7610		  LDX #20
 7620 .1	  STA CNT,X
 7630		  DEX
 7640		  BPL .1
 7650 *--------------------------------
 7660 ABDUM	  JSR ABORT.SOUND
 7670 *--------------------------------
 7680		  LDA SHOB1
 7690		  CLC
 7700		  ADC SHOB2
 7710		  ADC SHOB3
 7720		  ADC FERRY
 7730		  STA ABONUM
 7740 *--------------------------------
 7750		  LDA #$00     NO LONGER CARRYING ONE
 7760		  STA FERRY
 7770		  LDA #$0A
 7780		  STA MASTER.VOLUME
 7790 .1	  LDA #20
 7800		  STA ABCNT
 7810		  LDA #2
 7820		  STA TIMER1
 7830 .2	  LDA #1
 7840		  STA SCOCHG   SUBTRACT AMOUNT
 7850		  LDA #$05     DIGIT POSITION
 7860		  STA SCOPOS
 7870		  JSR SUBSCO   SUBTRACT $100
 7880 *--------------------------------
 7890		  LDA DEAD
 7900		  BEQ .21
 7910 *--------------------------------
 7920		  LDA #$00
 7930		  STA MASTER.VOLUME
 7940		  STA BORDER.COLOR
 7950		  STA INCUD
 7960		  STA INCLR
 7970		  RTS
 7980 *--------------------------------
 7990 .21	  LDA ABCNT
 8000		  ASL
 8010		  ASL	     *4
 8020		  STA FREQ.2
 8030		  STA FREQ.2+1
 8040		  ASL
 8050		  STA FREQ.3
 8060		  STA FREQ.3+1
 8070		  DEC BORDER.COLOR
 8080 *--------------------------------
 8090		  DEC ABCNT
 8100		  BNE .3
 8110 *--------------------------------
 8120		  DEC ABONUM
 8130		  BNE .1
 8140		  BEQ ABORT.END
 8150 *--------------------------------
 8160 .3	  LDX #$03
 8170 .4	  LDA TIMER1
 8180		  BNE .4
 8190		  LDA #$02
 8200		  STA TIMER1
 8210		  DEX
 8220		  BPL .4
 8230		  BMI .2
 8240 *--------------------------------
 8250 ABORT.END   LDA #$00
 8260		  STA CONTROL.1
 8270		  STA CONTROL.2
 8280		  STA CONTROL.3
 8290		  STA MASTER.VOLUME
 8300		  STA BORDER.COLOR
 8310		  STA INCUD
 8320		  STA INCLR
 8330		  RTS
 8340 *--------------------------------
 8350 *   CHECK ABORT
 8360 *--------------------------------
 8370 CHECK.ABORT LDA ABORT.FLAG  ABORTING?
 8380		  BEQ .1	  NO
 8390 *--------------------------------
 8400		  JSR DO.ABORT	  YES,DO ABORT
 8410		  LDA DEAD	  ARE WE DEAD
 8420		  BNE .11	  YES
 8430 *--------------------------------
 8440		  JSR PLRCHG	   IF NOT DEAD, DO PLAYER CHANGE
 8450 *--------------------------------
 8460 .11	  LDA #$00	  NO LONGER ABORTING
 8470		  STA ABORT.FLAG
 8480 .1	  RTS
 8490 *--------------------------------
 8500 *   CHECK LIVES
 8510 *--------------------------------
 8520 CHECK.LIVES LDA DEAD	ARE WE DEAD
 8530		  BEQ .1	NO
 8540		  LDA #$00
 8550		  STA MASTER.VOLUME
 8560		  LDA #$01
 8570		  STA INCUD
 8580 *--------------------------------
 8590		  LDA #$60
 8600		  STA TEMP1
 8610 .2	  JSR DELAY
 8620		  JSR DELAY
 8630		  JSR DELAY
 8640		  DEC TEMP1
 8650		  BNE .2
 8660 *--------------------------------
 8670		  LDA #$00
 8680		  STA DEAD
 8690		  JSR PLRCHG	   IF DEAD, DO PLAYER CHANGE
 8700		  LDA PLAYER
 8710		  BMI BOTH.DEAD
 8720 *--------------------------------
 8730		  LDA #$00
 8740		  STA DEAD
 8750 .1	  RTS
 8760 *--------------------------------
 8770 BOTH.DEAD   LDA #$01
 8780		  STA BDEAD
 8790		  LDA #$00
 8800		  STA DEAD
 8810		  RTS
 8820 *--------------------------------
 8830 DO.BUCKS.2  LDA B2HPO
 8840		  STA BUC1.X
 8850		  LDA B2HPO+1
 8860		  STA BUC2.X
 8870		  LDA B2HPO+2
 8880		  STA BUC3.X
 8890 *--------------------------------
 8900 * 	  LDA #$00
 8910 * 	  STA BUC1.XMSB
 8920 * 	  STA BUC2.XMSB
 8930 * 	  STA BUC3.XMSB
 8940 *--------------------------------
 8950		  LDA B2C1VP
 8960		  STA BUC1VP
 8970		  STA BUC1.Y
 8980		  LDA B2C1VP+1
 8990		  STA BUC1VP+1
 9000		  STA BUC2.Y
 9010		  LDA B2C1VP+2
 9020		  STA BUC1VP+2
 9030		  STA BUC3.Y
 9040 *--------------------------------
 9050		  LDA #$01
 9060		  STA SHOB1
 9070		  STA SHOB2
 9080		  STA SHOB3
 9090 *--------------------------------
 9100		  RTS
