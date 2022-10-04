 1000 *--------------------------------
 1010 * SAVE CHOP.CODE.5
 1020 *--------------------------------
 1030 *  FILL HOLES UP WITH WATER
 1040 *--------------------------------
 1050 WATER.FALL LDX WPHASE
 1060		 BEQ WTRFL1
 1070 *--------------------------------
 1080		 CPX #$01
 1090		 BNE .3
 1100		 JMP HOSCAN
 1110 .3	 CPX #$02
 1120		 BNE .11
 1130		 JMP HOLE
 1140 .11	 CPX #$03
 1150		 BNE .1
 1160		 JMP BOTLP2
 1170 .1	 CPX #$04
 1180		 BNE .2
 1190		 JMP GOTBL
 1200 .2	 CPX #$05
 1210		 BNE WTRFL1
 1220		 JMP BOTL3A
 1230 *--------------------------------
 1240 WTRFL1	 INC SCAN.Y
 1250		 LDA SCAN.Y
 1260		 CMP #$B0
 1270		 BCC .1
 1280 *--------------------------------
 1290		 LDA SCAN.X
 1300		 CLC
 1310		 ADC #$08
 1320		 CMP #$98     SINCE SCREEN IS SQUEEZED
 1330		 BCC .2
 1340 *--------------------------------
 1350		 LDA START
 1360		 BEQ .11
 1370		 LDA #$00
 1380		 BEQ .22
 1390 .11	 LDA #$04
 1400 .22	 STA START
 1410 *--------------------------------
 1420 .2	 STA SCAN.X
 1430		 LDA INILVL
 1440 *--------------------------------
 1450		 STA SCAN.Y
 1460 .1	 STA WATERY
 1470		 STA PLOTY
 1480 *--------------------------------
 1490		 LDA SCAN.X
 1500		 STA WATERX
 1510		 STA PLOTX
 1520		 LDA #$01
 1530		 STA TEMP2
 1540 .6	 JSR PLOTCL
 1550 *--------------------------------
 1560 * SCAN BYTE FOR WATER
 1570 *--------------------------------
 1580 .7	 JSR SCAN.BYTE
 1590		 BNE FRIGHT	 FOUND WATER
 1600 *--------------------------------
 1610		 LDA TEMP2
 1620		 BEQ .5
 1630 *--------------------------------
 1640		 LDA DUD
 1650		 CLC
 1660		 ADC #$04
 1670		 CMP #$98     SINCE SCREEN SQUEEZED
 1680		 BCC .4
 1690 *--------------------------------
 1700		 LDA #$00
 1710 *--------------------------------
 1720 .4	 STA DUD
 1730		 STA WATERX
 1740		 STA PLOTX
 1750		 LDA INILVL
 1760		 STA PLOTY
 1770		 STA WATERY
 1780		 DEC TEMP2
 1790		 JMP .6
 1800 *--------------------------------
 1810 .5	 RTS
 1820 *--------------------------------
 1830 * SCAN RIGHT FOR A HOLE
 1840 *--------------------------------
 1850 FRIGHT	 LDA WATERY
 1860		 STA WATER.TOP
 1870 *--------------------------------
 1880 .1	 INC WATERX  SCAN RIGHT UNTIL
 1890		 JSR CHECK   NOT WATER
 1900		 STA TEMP1
 1910		 LDA TYPE2   EITHER DIRT OR A HOLE
 1920		 BNE .1
 1930		 LDA TEMP1
 1940		 BNE HOLE    A=1 IF HOLE
 1950 *--------------------------------
 1960 * DIDNT FIND HOLE. NOW SCAN LEFT
 1970 *--------------------------------
 1980 *  PHASE 1
 1990 *--------------------------------
 2000 HOSCAN	 LDA #$01
 2010		 STA WPHASE
 2020		 LDA WATERX
 2030		 BNE .11
 2040		 JMP ZEROPH
 2050 *--------------------------------
 2060 * SCAN LEFT FOR HOLE
 2070 *--------------------------------
 2080 .11	 DEC WATERX
 2090		 JSR CHECK
 2100		 BNE HOLE    A=1 IF HOLE
 2110		 LDX TYPE2
 2120		 BNE .1      TYPE2=1 IF WATER
 2130 *--------------------------------
 2140 * IT WAS DIRT. GO DOWN ONE
 2150 *--------------------------------
 2160		 JMP ZEROPH
 2170 .1	 INC WATERY
 2180		 JSR CHECK
 2190		 BNE HOLE    A=1 IF HOLE
 2200 *--------------------------------
 2210 * IT WAS STILL DIRT. BACKUP ONE
 2220 *--------------------------------
 2230		 DEC WATERY
 2240		 RTS	    ***
 2250 *--------------------------------
 2260 * PHASE 2  (FOUND A HOLE)
 2270 *--------------------------------
 2280 HOLE	 LDA #$02
 2290		 STA WPHASE
 2300 *--------------------------------
 2310 * GO DOWN ONE
 2320 *--------------------------------
 2330 .1	 INC WATERY
 2340		 CMP #$B0
 2350		 BPL BOTLP2
 2360 *--------------------------------
 2370		 LDA WLO	  WLO SET IN CHECK SUBROUTINE
 2380		 CLC
 2390		 ADC #40
 2400		 STA WLO
 2410		 LDA #$00
 2420		 ADC WHI
 2430		 STA WHI
 2440 *--------------------------------
 2450		 LDA BOMB.MASK,X
 2460		 EOR #$FF
 2470		 LDY #$00
 2480		 AND (WLO),Y
 2490		 BEQ .1
 2500 *--------------------------------
 2510 * NOT A HOLE. GO UP ONE
 2520 *--------------------------------
 2530 HOLE2	 DEC WATERY
 2540 *--------------------------------
 2550 *  PHASE 3 (WE FOUND BOTTOM OF HOLE)
 2560 *--------------------------------
 2570 BOTLP2	 LDA #$03
 2580		 STA WPHASE
 2590		 LDA WATERX
 2600		 BEQ GOTBL
 2610 *--------------------------------
 2620 * SCAN LEFT (MAKE SURE AT BOTTOM)
 2630 *--------------------------------
 2640		 DEC WATERX
 2650		 JSR CHECK
 2660		 BNE BOTLP3	A=1 IF HOLE
 2670 *--------------------------------
 2680 * WASNT A HOLE. FOUND BOTTOM LEFT
 2690 *--------------------------------
 2700		 INC WATERX
 2710		 JMP GOTBL
 2720 *--------------------------------
 2730 * STILL A HOLE. GO DOWN ONE
 2740 *--------------------------------
 2750 BOTLP3	 INC WATERY
 2760		 JSR CHECK
 2770		 BNE HOLE	IF STILL A HOLE KEEP SCANNING DOWN
 2780		 DEC WATERY
 2790		 RTS	    ***
 2800 *--------------------------------
 2810 * PHASE 4  (FOUND BOTTOM LEFT)
 2820 *--------------------------------
 2830 GOTBL	 LDA #$04
 2840		 STA WPHASE
 2850		 LDA WATERX
 2860		 STA WTRLFT
 2870		 LDA WATERY
 2880		 STA WTRLIN
 2890 *--------------------------------
 2900 * PHASE 5
 2910 *--------------------------------
 2920 BOTL3A	 LDA #$05
 2930		 STA WPHASE
 2940 *--------------------------------
 2950 * SCAN RIGHT UNTIL NOT A HOLE
 2960 * CHECK DOWN ONE FOR HOLE
 2970 *--------------------------------
 2980		 INC WATERX
 2990		 JSR CHECK
 3000		 BNE BOTLP4    A=1 IF HOLE
 3010 *--------------------------------
 3020		 LDA WATERX
 3030		 SEC
 3040		 SBC WTRLFT
 3050		 STA WTRLEN
 3060		 JSR DOWATR    PLOT WATER
 3070 *--------------------------------
 3080 * GO UP AND LEFT AND GO TO PHASE 3
 3090 *--------------------------------
 3100		 DEC WATERY
 3110 .2	 LDA WATERX
 3120		 BEQ .1
 3130		 DEC WATERX    !!!
 3140		 JSR CHECK
 3150		 STA TEMP1
 3160		 LDA TYPE2
 3170		 BNE ZEROPH
 3180		 LDA TEMP1
 3190		 BEQ .2        IT WAS DIRT
 3200 *--------------------------------
 3210 .1	 LDA WATERY
 3220		 CMP WATER.TOP	!!
 3230		 BCC ZEROPH
 3240		 LDA #$03
 3250		 STA WPHASE
 3260		 RTS
 3270 *--------------------------------
 3280 * PHASE 0
 3290 *--------------------------------
 3300 ZEROPH	 LDA #$00
 3310		 STA WPHASE
 3320		 RTS
 3330 *--------------------------------
 3340 BOTLP4	 INC WATERY
 3350		 JSR CHECK
 3360		 BEQ BOTLP5	A=0 IF NOT HOLE
 3370		 JMP HOLE	MUST BE HOLE
 3380 BOTLP5	 DEC WATERY	WASNT A HOLE
 3390		 RTS
 3400 *--------------------------------
 3410 *   CHECK FOR HOLE
 3420 *   TYPE2=1 WHEN WATER
 3430 *   TYPE2=0 OTHERWISE
 3440 *   ACCUM=1 WHEN HOLE OR WHITE (BACKGROUND)
 3450 *   ACCUM=0 WHEN DIRT
 3460 *--------------------------------
 3470 CHECK	 LDA WATERX
 3480		 STA PLOTX
 3490		 LDA WATERY
 3500		 STA PLOTY
 3510		 JSR PLOTCL
 3520		 LDA LO
 3530		 STA WLO
 3540		 LDA LO+1
 3550		 STA WHI
 3560		 LDA BOMB.MASK,X
 3570		 EOR #$FF
 3580		 LDY #$00
 3590		 STY TYPE2
 3600		 AND (LO),Y
 3610		 BEQ .1
 3620		 CMP BOMB.SHAPE,X
 3630		 BNE CKCOLR
 3640 *--------------------------------
 3650 .1	 LDA #$01      A HOLE
 3660		 RTS
 3670 CKCOLR	 CMP WATER.COLOR,X
 3680		 BNE NOH
 3690		 INC TYPE2
 3700 NOH	 LDA #$00
 3710		 RTS
 3720 *--------------------------------
 3730 *   WATER PLOT ROUTINE
 3740 *--------------------------------
 3750 DOWATR	 LDA WTRLFT
 3760		 STA PLOTX
 3770		 LDA WTRLIN
 3780		 STA PLOTY
 3790 .1	 JSR PLOTCL
 3800		 LDA PLOTX
 3810		 LDY #$00
 3820		 AND #$03
 3830		 TAX
 3840		 LDA BOMB.MASK,X
 3850		 AND (LO),Y
 3860		 ORA WATER.COLOR,X
 3870		 STA (LO),Y
 3880		 INC PLOTX
 3890		 DEC WTRLEN
 3900		 BNE .1
 3910		 RTS
 3920 *--------------------------------
 3930 *  DO UNDERGROUND WATER
 3940 *--------------------------------
 3950 DO.UNDER	 LDA UNDWTR	IS THERE UNDER GROUND WATER
 3960		 BNE .30
 3970		 JMP UNDER.END	NO
 3980 .30	 LDA BILEVL
 3990		 AND #$30
 4000		 BNE .21
 4010		 LDA #$01
 4020		 BNE .22
 4030 .21	 LDA UNDWTR
 4040 .22	 STA UNDTMP	YES. #OF INTO UNDTMP
 4050 *--------------------------------
 4060 .1	 LDA #$05	SET DEPTH WAS 5!!!
 4070		 STA DEPTH
 4080		 TAX
 4090		 LDA INILVL
 4100		 CLC
 4110		 ADC #$10
 4120		 STA MINDEP
 4130 *--------------------------------
 4140 .2	 JSR MAKE.RANDOM  GET Y POS OF
 4150		 ROR
 4160		 ROR
 4170		 AND #$03	  WATER  !!!
 4180		 ADC UNDTMP
 4190		 TAY
 4200		 LDA UNDER.Y,Y
 4210		 CLC
 4220		 ADC MINDEP
 4230		 STA WTRLIN
 4240 *--------------------------------
 4250 .4	 JSR MAKE.RANDOM  GET X POS OF
 4260		 ROR
 4270		 ROR
 4280		 AND #$03
 4290		 ADC UNDTMP
 4300		 TAY
 4310		 LDA UNDER.X,Y
 4320		 STA WTRLFT
 4330 *--------------------------------
 4340 .7	 LDX DEPTH
 4350		 JSR MAKE.RANDOM
 4360		 ROR
 4370		 ROR
 4380		 AND #$0F
 4390		 CMP UNDMIN,X
 4400		 BCC .7
 4410		 CMP UNDMAX,X
 4420		 BCS .7
 4430		 STA WTRLEN
 4440		 JSR DOWATR	DRAW WATER LINE
 4450		 DEC DEPTH	NEXT DEPTH LINE
 4460		 BEQ .8
 4470		 JSR MAKE.RANDOM
 4480		 ROR		 !!
 4490		 ROR
 4500		 AND #$03
 4510		 STA UNDFAC
 4520		 INC WTRLIN
 4530		 LDX DEPTH
 4540		 CPX #$03
 4550		 BPL .9
 4560		 LDA UNDFAC	!!
 4570		 CLC
 4580		 ADC WTRLFT
 4590		 BNE .10
 4600 .9	 LDA WTRLFT
 4610		 SEC
 4620		 SBC UNDFAC
 4630 .10	 STA WTRLFT
 4640		 JMP .7
 4650 .8	 DEC UNDTMP
 4660		 BEQ UNDER.END
 4670		 JMP .1
 4680 UNDER.END  RTS
 4690 *--------------------------------
 4700 *  DRAW MOUNTAINS
 4710 *--------------------------------
 4720 DO.MOUNT	 LDA INILVL
 4730		 STA PLOTY
 4740		 LDA #$00
 4750		 STA PLOTX
 4760		 JSR PLOTCL
 4770		 LDA LO
 4780		 STA TEMP1
 4790		 LDA LO+1
 4800		 STA TEMP2
 4810 *--------------------------------
 4820		 LDA INILVL
 4830		 SEC
 4840		 SBC #$18   MOUNTAINS ARE THREE CHARACTERS HIGH
 4850		 STA PLOTY
 4860		 JSR PLOTCL
 4870 *--------------------------------
 4880		 LDA LO+1
 4890		 PHA
 4900		 LDA LO
 4910		 PHA
 4920		 LDA BUSH.LO+1
 4930		 PHA
 4940		 LDA BUSH.LO
 4950		 PHA
 4960		 JSR SUB16
 4970		 PLA
 4980		 STA BUSH.OFFSET
 4990		 PLA
 5000		 STA BUSH.OFFSET+1
 5010 *--------------------------------
 5020		 LDA BUSH.LO  STORE ADDRESS
 5030		 STA TEMP3    OF MOUNTAIN
 5040		 LDA BUSH.HI  TABLE
 5050		 STA TEMP4
 5060		 LDY #$00
 5070 .2	 LDA (TEMP3),Y
 5080		 STA (LO),Y
 5090		 >INC TEMP3
 5100		 >INC LO
 5110		 LDA LO
 5120		 CMP TEMP1
 5130		 BNE .2
 5140		 LDA LO+1
 5150		 CMP TEMP2
 5160		 BNE .2
 5170		 RTS
 5180 *--------------------------------
 5190 *  PUT COLOR IN SCREEN MEM
 5200 *--------------------------------
 5210 DO.COLOR	 LDA BILEVL
 5220		 AND #$03
 5230		 ASL
 5240		 TAX
 5250		 LDA SCR.MEM.LO,X
 5260		 STA TEMP5
 5270		 LDA SCR.MEM.LO+1,X
 5280		 STA TEMP6
 5290		 LDA #$78	   ***
 5300		 STA TEMP1
 5310		 LDA SCR.LO
 5320		 STA TEMP3
 5330		 LDA SCR.HI
 5340		 STA TEMP4
 5350 *--------------------------------
 5360		 LDY #$00
 5370 .22	 LDA (TEMP3),Y
 5380		 STA (TEMP5),Y
 5390		 >INC TEMP3
 5400		 >INC TEMP5
 5410 *--------------------------------
 5420		 DEC TEMP1
 5430		 BNE .22
 5440 *--------------------------------
 5450 * SAME FOR COLOR MEM
 5460 *--------------------------------
 5470		 LDA BILEVL
 5480		 AND #$03
 5490		 ASL
 5500		 TAX
 5510		 LDA COLOR.MEM.LO,X
 5520		 STA TEMP5
 5530		 LDA COLOR.MEM.LO+1,X
 5540		 STA TEMP6
 5550 *--------------------------------
 5560		 LDA #$79
 5570		 STA TEMP1
 5580		 LDA ATT.LO
 5590		 STA TEMP3
 5600		 LDA ATT.LO+1
 5610		 STA TEMP4
 5620 *--------------------------------
 5630		 LDY #$00
 5640 .33	 LDA (TEMP3),Y
 5650		 STA (TEMP5),Y
 5660		 >INC TEMP3
 5670		 >INC TEMP5
 5680 *--------------------------------
 5690		 DEC TEMP1
 5700		 BNE .33
 5710		 RTS
 5720 *--------------------------------
 5730 * CHECK FOR CHOPPER COLLISION
 5740 * WITH FALLING DIRT BY CHECKING
 5750 * X Y LOCATIONS
 5760 *--------------------------------
 5770 DIRT.CHECK LDX ROCNT
 5780		 BNE .11
 5790		 JMP .9
 5800 *--------------------------------
 5810 .11	 LDA CHOP.Y
 5820		 SEC
 5830		 SBC #$33	TOP LEFT CORNER OF CHOPPER
 5840		 STA PLOTY
 5850		 LDA CHOP.X
 5860		 SEC
 5870		 SBC #$15
 5880		 STA TEMP1
 5890		 LDA CHOP.XMSB
 5900		 SBC #$00
 5910		 LSR
 5920		 ROR TEMP1
 5930		 LDA TEMP1
 5940		 STA PLOTX
 5950 *--------------------------------
 5960		 LDA #$04
 5970		 STA BSY
 5980 .2	 LDA #$04
 5990		 STA BSX
 6000 *--------------------------------
 6010 *  CHECK BOTTOM ROW OF DIRT
 6020 *  BY SCANNING EACH COLUMNS
 6030 *  X-Y COORDINATES
 6040 *--------------------------------
 6050 .1	 LDX ROCNT   ***
 6060 .6	 LDA KILL.DIRT.FLAG,X	CHECK IF DIRT WAS DESTROYED
 6070		 BEQ .66		NO
 6080 *--------------------------------
 6090		 JMP .5 	  YES,CHECK NEXT ONE
 6100 *--------------------------------
 6110 .66	 LDA RX1,X
 6120		 CMP PLOTX
 6130		 BNE .3
 6140 *--------------------------------
 6150		 LDA RY1,X
 6160		 CMP PLOTY
 6170		 BEQ .33
 6180 *--------------------------------
 6190		 SEC
 6200		 SBC #$02
 6210		 CMP PLOTY
 6220		 BNE .3
 6230 *--------------------------------
 6240 .33	 JMP DIRT.COLLIDE
 6250 *--------------------------------
 6260 .3	 LDA RX2,X
 6270		 CMP PLOTX
 6280		 BNE .4
 6290 *--------------------------------
 6300		 LDA RY2,X
 6310		 CMP PLOTY
 6320		 BEQ .44
 6330 *--------------------------------
 6340		 SEC
 6350		 SBC #$04
 6360		 CMP PLOTY
 6370		 BNE .4
 6380 *--------------------------------
 6390 .44	 JMP DIRT.COLLIDE
 6400 *--------------------------------
 6410 .4	 LDA RX5,X
 6420		 CMP PLOTX
 6430		 BNE .5
 6440 *--------------------------------
 6450		 LDA RY5,X
 6460		 CMP PLOTY
 6470		 BEQ .55
 6480 *--------------------------------
 6490		 SEC
 6500		 SBC #$03
 6510		 CMP PLOTY
 6520		 BNE .5
 6530 *--------------------------------
 6540 .55	 JMP DIRT.COLLIDE
 6550 *--------------------------------
 6560 .5	 DEX
 6570		 BPL .6
 6580 *--------------------------------
 6590		 INC PLOTX
 6600		 INC PLOTX
 6610		 DEC BSX
 6620		 DEC BSX
 6630		 BPL .1
 6640 *--------------------------------
 6650		 LDA PLOTX
 6660		 SBC #$06
 6670		 STA PLOTX
 6680		 INC PLOTY
 6690		 DEC BSY
 6700		 INC PLOTY
 6710		 DEC BSY
 6720		 BPL .2
 6730 *--------------------------------
 6740 .9	 RTS
 6750 *--------------------------------
 6760 DIRT.COLLIDE  LDA #$01
 6770		    STA HIT0
 6780		    RTS
 6790 *--------------------------------
 6800 *  DID WE LAND?
 6810 *--------------------------------
 6820 CHECK.LAND LDA LANDFG
 6830		 BNE LANDED
 6840 *--------------------------------
 6850		 RTS
 6860 *--------------------------------
 6870 LANDED	 LDA #75
 6880		 STA BOMBLD
 6890		 LDA #7
 6900		 STA BDIG1
 6910		 CLC
 6920		 ADC #$30
 6930		 STA SCOLIN+09
 6940		 LDA #5
 6950		 STA BDIG2
 6960		 CLC
 6970		 ADC #$30
 6980		 STA SCOLIN+10
 6990 *--------------------------------
 7000		 LDA #$00
 7010		 STA LANDFG
 7020		 STA INCUD
 7030		 STA INCLR
 7040 *--------------------------------
 7050		 LDA FERRY
 7060		 BEQ DONE.LAND	 NO BUCKS
 7070 *--------------------------------
 7080 *  ADD IN AMOUNT FOR BUCK
 7090 *--------------------------------
 7100		 LDA #$01
 7110		 STA LAND.SOUND  DO LAND SOUND
 7120 *--------------------------------
 7130		 LDA #$00
 7140		 STA FERRY
 7150		 STA SPRITE.COLLISION  |||
 7160		 LDX FERIX
 7170		 STA SHOB1,X
 7180		 LDA BUCVL1
 7190		 STA SCOCHG
 7200		 LDA #$04
 7210		 STA SCOPOS
 7220		 JSR ADDSCO
 7230		 LDA BUCVL2
 7240		 STA SCOCHG
 7250		 LDA #$05
 7260		 STA SCOPOS
 7270		 JSR ADDSCO
 7280		 LDA #$FF
 7290		 STA FERIX
 7300 DONE.LAND  RTS
 7310 *--------------------------------
 7320 * ACCOUNT FOR CHOPPER OPERATION
 7330 *--------------------------------
 7340 SUB.ONE	 LDA TIMER6
 7350		 BNE .1
 7360 *--------------------------------
 7370		 LDA #15
 7380		 STA TIMER6
 7390		 LDA #07      SUBTRACT $1
 7400		 STA SCOPOS
 7410		 LDA #$01
 7420		 STA SCOCHG
 7430		 JSR SUBSCO
 7440 *--------------------------------
 7450 .1	 RTS
 7460 *--------------------------------
 7470 SCAN.BYTE  LDX #$00
 7480		 LDY #$00
 7490 .1	 LDA BOMB.MASK,X
 7500		 EOR #$FF
 7510		 AND (LO),Y
 7520 *--------------------------------
 7530 * 	  STA $FE
 7540 * 	 LDA (LO),Y
 7550 * 	 STA $FF
 7560 * 	 LDA #$AA
 7570 * 	 STA (LO),Y
 7580 * 	 LDA $FF
 7590 * 	 STA (LO),Y
 7600 * 	 LDA $FE
 7610 *--------------------------------
 7620		 CMP WATER.COLOR,X
 7630		 BEQ FOUND.IT
 7640		 INC WATERX
 7650		 INX
 7660		 CPX #$03
 7670		 BPL .1
 7680		 LDA #$00  NOT WATER
 7690		 RTS
 7700 FOUND.IT	 LDA #$01  FOUND WATER
 7710		 RTS
