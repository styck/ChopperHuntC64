 1000 *--------------------------------
 1010 *  SAVE DO.DIRT.CODE
 1020 *--------------------------------
 1030 BUSH.OFFSET .HS 0000
 1040 *--------------------------------
 1050 DROP.DIRT  LDA ROCNT
 1060		 CMP ROCMAX
 1070		 BPL NODROP
 1080		 LDA DROPWT
 1090		 BEQ TRY
 1100		 LDA DROPGO
 1110		 BEQ NODROP
 1120		 LDA #$01
 1130		 STA DRPFLG
 1140		 LDA #$00
 1150		 STA DROPGO
 1160		 STA DROPWT
 1170		 BEQ NODROP
 1180 *--------------------------------
 1190 * LOOK FOR HOLE TO DROP DIRT IN
 1200 *--------------------------------
 1210 TRY	 JSR MAKE.RANDOM
 1220		 CMP #155
 1230		 BCS TRY
 1240		 STA PLOTX
 1250		 LDA SOIL
 1260		 STA PLOTY
 1270 *--------------------------------
 1280 .2	 JSR PLOTCL
 1290 *--------------------------------
 1300		 LDA PLOTX	 CHECK PIXEL
 1310		 AND #$03	 TO SEE IF IT
 1320		 TAX		 IS BLACK
 1330		 LDY #$00
 1340 *--------------------------------
 1350		 LDA BOMB.MASK,X
 1360		 EOR #$FF
 1370		 AND (LO),Y
 1380		 BEQ .1
 1390		 DEC PLOTX
 1400		 BNE .2
 1410		 JMP NODROP
 1420 *--------------------------------
 1430 .1	 LDA PLOTX     FOUND HOLE
 1440		 CMP #$02      WHOLE ROCK ON SCREEN?
 1450		 BCS .3
 1460		 LDA #$02      RESET TO 2!!!
 1470 .3	 STA DRPCOL
 1480		 LDA #$01
 1490		 STA DROPWT
 1500 *--------------------------------
 1510 NODROP	 LDX PLOTX
 1520		 STX DROP1	  SAVE X POSITION OF HOLE BIT
 1530		 LDY #$00
 1540		 LDA (LO),Y
 1550		 STA HOLD1
 1560 *--------------------------------
 1570 DIRT	 LDA DRPFLG   NEW DROP
 1580		 BEQ NXTDRP   NO. GO UPDATE OTHERS
 1590		 LDA ROCNT
 1600		 CMP #$09
 1610		 BPL NXTDRP
 1620		 INC ROCNT
 1630 *--------------------------------
 1640		 LDA #$00	DIRT IS NOT DESTROYED
 1650		 LDX ROCNT
 1660		 STA KILL.DIRT.FLAG,X
 1670 *--------------------------------
 1680 * INIT DIRTS POSITION
 1690 *--------------------------------
 1700		 LDX ROCNT
 1710		 LDA DRPCOL
 1720		 STA RX3,X
 1730		 SEC
 1740		 SBC #$01
 1750		 STA RX2,X
 1760		 SBC #$01
 1770		 STA RX1,X
 1780		 LDA DRPCOL
 1790		 CLC
 1800		 ADC #$01
 1810		 STA RX4,X
 1820		 ADC #$01
 1830		 STA RX5,X
 1840		 ADC #$01
 1850		 STA RX6,X
 1860		 LDA #$0A      INIT START OF GROUND
 1870		 STA RY1,X
 1880		 STA RY6,X
 1890		 LDA #$0B
 1900		 STA RY2,X
 1910		 STA RY5,X
 1920		 LDA #$0C
 1930		 STA RY3,X
 1940		 STA RY4,X
 1950		 LDA #$00
 1960		 STA DRPFLG
 1970 *--------------------------------
 1980 NXTDRP	 LDA TIMER9
 1990		 BEQ NODRPD
 2000		 RTS	      RETURN
 2010 *--------------------------------
 2020 NODRPD	 LDA FALSPD
 2030		 STA TIMER9
 2040		 LDA #$00
 2050		 STA DRPNUM
 2060 *--------------------------------
 2070 DROPLP	 INC DRPNUM
 2080		 LDA ROCNT
 2090		 CMP DRPNUM
 2100		 BPL DRPIX
 2110		 RTS	      RETURN
 2120 *--------------------------------
 2130 DRPIX	 LDA #$00
 2140		 STA MOVED    MOVE FLAG FOR ALL COLUMNS
 2150		 LDA #$05     6 COLUMNS OF FALLING DIRT
 2160		 STA DIRT.COLUMN
 2170		 LDA DRPNUM
 2180		 STA ROCOL
 2190 *--------------------------------
 2200 *  MAIN DIRT LOOP
 2210 *--------------------------------
 2220 DRPIX2	 LDY DIRT.COLUMN
 2230		 LDA EOFS,Y
 2240		 STA EOFSET
 2250		 LDA EOFHT,Y
 2260		 STA HT
 2270 *--------------------------------
 2280		 LDX ROCOL
 2290		 LDA RX1,X
 2300		 STA PLOTX
 2310		 LDA RY1,X
 2320		 STA PLOTY
 2330		 INC PLOTY
 2340 *--------------------------------
 2350		 JSR PLOTCL
 2360		 JSR MOVEM    MOVE COLUMN
 2370		 LDA MOVED2   DID COLUMN MOVE?
 2380		 BEQ NXTDIX   NO IT DID NOT
 2390 *--------------------------------
 2400		 LDA PLOTY    IT MOVED
 2410		 LDX ROCOL    SAVE COLUMN Y
 2420		 STA RY1,X
 2430 NXTDIX	 LDA ROCOL
 2440		 CLC
 2450		 ADC #11
 2460		 STA ROCOL
 2470		 DEC DIRT.COLUMN
 2480		 BPL DRPIX2
 2490 *--------------------------------
 2500		 LDA MOVED    ANY COLUMNS MOVE?
 2510		 BEQ DREPAK   NO. REPACK DIRT
 2520		 JMP DROPLP   LOOP
 2530 *--------------------------------
 2540 *  REPACK DIRT TABLES
 2550 *--------------------------------
 2560 DREPAK	 LDX DRPNUM
 2570		 LDY DRPNUM
 2580 DRPKLP	 INX
 2590		 CPX ROCNT
 2600		 BEQ DRPK2
 2610		 BPL DRPKND
 2620 *--------------------------------
 2630 DRPK2	 LDA RX1,X
 2640		 STA RX1,Y
 2650		 LDA RX2,X
 2660		 STA RX2,Y
 2670		 LDA RX3,X
 2680		 STA RX3,Y
 2690		 LDA RX4,X
 2700		 STA RX4,Y
 2710		 LDA RX5,X
 2720		 STA RX5,Y
 2730		 LDA RX6,X
 2740		 STA RX6,Y
 2750 *--------------------------------
 2760		 LDA RY1,X
 2770		 STA RY1,Y
 2780		 LDA RY2,X
 2790		 STA RY2,Y
 2800		 LDA RY3,X
 2810		 STA RY3,Y
 2820		 LDA RY4,X
 2830		 STA RY4,Y
 2840		 LDA RY5,X
 2850		 STA RY5,Y
 2860		 LDA RY6,X
 2870		 STA RY6,Y
 2880 *--------------------------------
 2890		 LDA KILL.DIRT.FLAG,X
 2900		 STA KILL.DIRT.FLAG,Y
 2910 *--------------------------------
 2920		 INY
 2930		 BNE DRPKLP
 2940 *--------------------------------
 2950 DRPKND	 DEC ROCNT
 2960		 DEC DRPNUM
 2970		 JMP DROPLP
 2980 MOVEM	 LDA #$00
 2990		 STA MOVED2
 3000 *--------------------------------
 3010 *  SEE IF DIRT WAS DESTROYED
 3020 *--------------------------------
 3030 * 	 LDX ROCOL
 3040		 LDX DRPNUM
 3050		 LDA KILL.DIRT.FLAG,X
 3060		 BEQ .99
 3070		 JMP MOVEM2	YES
 3080 *--------------------------------
 3090 .99	 LDY #$00
 3100		 LDA PLOTX
 3110		 AND #$03
 3120		 TAX
 3130 *--------------------------------
 3140		 LDA PLOTY
 3150		 CMP #$B0     OFF SCREEN?
 3160		 BCC .11      NO
 3170		 JMP NOADV
 3180 *--------------------------------
 3190 .11	 CMP INILVL   ABOVE GROUND?
 3200		 BCS .5       NO
 3210		 JMP POF      YES
 3220 *--------------------------------
 3230 *  BELOW GROUND CODE   !!!!
 3240 *--------------------------------
 3250 *  DONT MOVE DIRT INTO WATER
 3260 *--------------------------------
 3270 .5	 LDA BOMB.MASK,X    DONT MOVE
 3280		 EOR #$FF
 3290		 AND (LO),Y	    INTO WATER
 3300		 CMP WATER.COLOR,X
 3310		 BNE .12
 3320 .13	 JMP NOADV
 3330 *--------------------------------
 3340 *  DONT MOVE DIRT INTO GROUND
 3350 *--------------------------------
 3360 .12	 LDA BOMB.MASK,X
 3370		 EOR #$FF
 3380		 AND (LO),Y
 3390		 CMP DIRT.COLOR,X
 3400		 BEQ .13	   JMP NOADV|||
 3410 *--------------------------------
 3420		 STA TEMP2	 ???
 3430		 LDA PADLVL
 3440		 CLC
 3450		 ADC #$01
 3460		 STA TEMP1
 3470		 LDA PLOTY
 3480		 CMP TEMP1
 3490		 BEQ .44
 3500 *--------------------------------
 3510		 SEC
 3520		 SBC #$04
 3530		 CMP TEMP1
 3540		 BNE .4
 3550 *--------------------------------
 3560 .44	 LDA PLOTX
 3570		 CMP #$38
 3580		 BCS .4
 3590 *--------------------------------
 3600		 JMP .2      ???
 3610 *--------------------------------
 3620 .4	 LDA TEMP2
 3630		 CMP BOMB.SHAPE,X  DONT MOVE INTO EXPLOSION
 3640		 BEQ .3 	   (UNDER GROUND)
 3650 *--------------------------------
 3660 *  CHECK ABOVE DIRT FOR EXPLOSION
 3670 *--------------------------------
 3680		 LDA LO
 3690		 PHA
 3700		 LDA LO+1
 3710		 PHA
 3720		 LDA PLOTY
 3730		 PHA
 3740		 SEC
 3750		 SBC #$04
 3760		 STA PLOTY
 3770		 JSR PLOTCL
 3780		 LDA BOMB.MASK,X
 3790		 EOR #$FF
 3800		 AND (LO),Y
 3810		 TAY
 3820 *--------------------------------
 3830		 PLA
 3840		 STA PLOTY
 3850		 PLA
 3860		 STA LO+1
 3870		 PLA
 3880		 STA LO
 3890 *--------------------------------
 3900		 TYA
 3910		 LDY #$00
 3920		 CMP BOMB.SHAPE,X
 3930		 BNE .2
 3940 *--------------------------------
 3950 *  DESTROY DIRT (UNDERGROUND)
 3960 *--------------------------------
 3970 * 	 LDX ROCOL
 3980 .3	 LDX DRPNUM
 3990		 LDA #$01
 4000		 STA KILL.DIRT.FLAG,X
 4010		 INC MOVED    KEEP DIRT MOVING IF IT HIT
 4020		 JMP MOVEM2   AN EXPLOSION
 4030 *--------------------------------
 4040 * PLOT DIRT (UNDERGROUND)
 4050 *--------------------------------
 4060 .2	 LDY #$00	   PLOT UNDERGROUND DIRT
 4070		 LDA BOMB.MASK,X
 4080		 AND (LO),Y
 4090		 ORA DIRT.COLOR,X
 4100		 STA (LO),Y
 4110		 JMP MOVEM2
 4120 *--------------------------------
 4130 * ABOVE GROUND CODE !!!!!
 4140 *--------------------------------
 4150 *
 4160 *--------------------------------
 4170 *  IF OVER PAD DONT CHECK FOR
 4180 *  COLLISION WITH EXPLOSION
 4190 *--------------------------------
 4200 POF	 LDA PADLVL
 4210		 CLC
 4220		 ADC #$01
 4230		 STA TEMP1
 4240		 LDA PLOTY
 4250		 CMP TEMP1   TOP OF PAD
 4260		 BEQ .91
 4270 *--------------------------------
 4280		 SEC
 4290		 SBC #$04
 4300		 CMP TEMP1
 4310		 BEQ .91
 4320 *--------------------------------
 4330		 LDA PLOTY
 4340		 CMP PADLVL2	BOTTOM OF PAD
 4350		 BEQ .91
 4360 *--------------------------------
 4370		 SEC
 4380		 SBC #$04
 4390		 CMP PADLVL2
 4400		 BNE .1
 4410 *--------------------------------
 4420 .91	 LDA PLOTX
 4430		 CMP #$38
 4440		 BCS .1
 4450 *--------------------------------
 4460		 JMP .15
 4470 *--------------------------------
 4480 .1	 LDA BOMB.MASK,X   DONT MOVE
 4490		 EOR #$FF	   INTO EXPLOSION
 4500		 AND (LO),Y	   (IN SKY)
 4510		 CMP BOMB.SHAPE,X  HITTING EXPLOSION?
 4520		 BEQ .90	   NO
 4530 *--------------------------------
 4540		 LDA LO
 4550		 PHA
 4560		 LDA LO+1
 4570		 PHA
 4580		 LDA PLOTY
 4590		 PHA
 4600		 SEC
 4610		 SBC #$04
 4620		 STA PLOTY
 4630		 JSR PLOTCL
 4640		 LDA BOMB.MASK,X
 4650		 EOR #$FF
 4660		 AND (LO),Y
 4670		 TAY
 4680 *--------------------------------
 4690		 PLA
 4700		 STA PLOTY
 4710		 PLA
 4720		 STA LO+1
 4730		 PLA
 4740		 STA LO
 4750 *--------------------------------
 4760		 TYA
 4770		 LDY #$00
 4780		 CMP BOMB.SHAPE,X
 4790		 BNE .15
 4800 *--------------------------------
 4810 *  IF DESTROYED DONT PLOT
 4820 *  DESTOY DIRT (ABOVE GROUND)
 4830 *--------------------------------
 4840 * 	 LDX ROCOL    TRY TO DESTROY
 4850 .90	 LDX DRPNUM
 4860		 LDA #$01     DIRT
 4870		 STA KILL.DIRT.FLAG,X
 4880		 INC MOVED
 4890		 JMP MOVEM2
 4900 *--------------------------------
 4910 *  PLOT THE DIRT	(ABOVE GROUND)
 4920 *--------------------------------
 4930 .15	 JSR MAKE.RANDOM
 4940		 ROR
 4950		 ROR
 4960		 AND #$03
 4970		 BEQ PEF
 4980 *--------------------------------
 4990		 LDA BOMB.MASK,X
 5000		 EOR #$FF
 5010		 STA TEMP1
 5020		 JMP PEFI
 5030 PEF	 STA TEMP1
 5040 *--------------------------------
 5050 PEFI	 LDY #$00	    PLOT DIRT
 5060		 LDA BOMB.MASK,X
 5070		 AND (LO),Y
 5080		 ORA TEMP1
 5090		 STA (LO),Y
 5100 *--------------------------------
 5110 * GIVE DIRT ITS SHAPE (V-SHAPE)
 5120 *--------------------------------
 5130 MOVEM2	 LDA PLOTY
 5140		 STA TEMP7
 5150		 LDA EOFSET
 5160		 CMP #40
 5170		 BNE .2
 5180		 DEC PLOTY
 5190		 DEC PLOTY
 5200		 DEC PLOTY
 5210		 DEC PLOTY
 5220		 JMP .4
 5230 .2	 CMP #80
 5240		 BNE .3
 5250		 DEC PLOTY
 5260		 DEC PLOTY
 5270		 DEC PLOTY
 5280		 DEC PLOTY
 5290		 JMP .4
 5300 .3	 CMP #120
 5310		 BNE .4
 5320		 DEC PLOTY
 5330		 DEC PLOTY
 5340		 DEC PLOTY
 5350		 DEC PLOTY
 5360 .4	 JSR PLOTCL
 5370 *--------------------------------
 5380 * ERASE BEHIND DIRT
 5390 *--------------------------------
 5400 ERASE.DIRT LDA PLOTY	   OFF SCREEN
 5410		 CMP #$05	   TOP (WHERE PLANE DROPS IT)
 5420		 BCC MOVFLG	   YES
 5430		 LDA PLOTY
 5440		 CLC
 5450		 ADC #$01
 5460		 CMP INILVL   ABOVE GROUND?
 5470		 BCC .5       YES
 5480 *--------------------------------
 5490 * DONT ERASE GROUND
 5500 *--------------------------------
 5510		 TXA
 5520		 TAY
 5530 *--------------------------------
 5540 * 	 LDX ROCOL	 @@@@
 5550		 LDX DRPNUM
 5560		 LDA KILL.DIRT.FLAG,X
 5570		 BEQ .56
 5580 *--------------------------------
 5590		 TYA
 5600		 TAX
 5610 *--------------------------------
 5620		 LDY #$00
 5630		 LDA BOMB.MASK,X
 5640		 EOR #$FF
 5650		 AND (LO),Y
 5660		 CMP DIRT.COLOR,X
 5670		 BEQ NOADV
 5680		 CMP WATER.COLOR,X
 5690		 BEQ NOADV
 5700 *--------------------------------
 5710 .56	 LDA PLOTX
 5720		 AND #$03
 5730		 TAX
 5740		 LDA PLOTY	   ABOVE GROUND?
 5750		 CLC
 5760		 ADC #$01
 5770		 CMP INILVL
 5780		 BCC .5 	   YES
 5790 *--------------------------------
 5800 * BELOW GROUND (ERASE WITH BLACK)
 5810 *--------------------------------
 5820		 LDY #$00
 5830		 LDA (LO),Y
 5840		 AND BOMB.MASK,X
 5850		 STA (LO),Y
 5860		 JMP MOVFLG
 5870 *--------------------------------
 5880 .5	 LDA INILVL    IF WE ARE ERASING
 5890		 SEC	       OVER MOUNTAINS THEN
 5900		 SBC #$18      STORE/RESTORE
 5910		 STA TEMP1
 5920		 LDA PLOTY
 5930		 CMP TEMP1
 5940		 BCS .55       YES. WE ARE ON MOUNTAINS
 5950 *--------------------------------
 5960 * ERASE WITH BLUE (ABOVE MOUNTAINS)
 5970 *--------------------------------
 5980		 LDY #$00	   START DIRT OFF
 5990		 LDA (LO),Y	   SO WE DONT LEAVE
 6000		 AND BOMB.MASK,X   DIRT ON THE TOP
 6010		 ORA WATER.COLOR,X
 6020		 STA (LO),Y
 6030		 JMP MOVFLG
 6040 *--------------------------------
 6050 *  RESTORE OVER MOUNTAINS
 6060 *--------------------------------
 6070 .55	 JSR SETUP.ADDR
 6080		 LDY #$00
 6090		 LDA (LO),Y
 6100		 AND BOMB.MASK,X
 6110		 ORA (JLO),Y
 6120		 STA (LO),Y
 6130 *--------------------------------
 6140 MOVFLG	 INC MOVED2
 6150		 INC MOVED
 6160 TESTIT	 LDA TEMP7
 6170		 STA PLOTY
 6180		 RTS
 6190 *--------------------------------
 6200 NOADV	 LDA PLOTY
 6210		 SEC
 6220		 SBC HT
 6230		 CMP INILVL
 6240		 BMI LEVLIT   ITS ABOVE INILVL
 6250		 RTS
 6260 *--------------------------------
 6270 * LEVEL GROUND (RESTORE MOUNTAINS)
 6280 *--------------------------------
 6290 LEVLIT	 LDA PLOTY
 6300		 STA TEMP6
 6310		 DEC PLOTY
 6320 *--------------------------------
 6330 .1	 JSR PLOTCL
 6340		 JSR SETUP.ADDR
 6350 *--------------------------------
 6360		 LDA PLOTY
 6370		 CMP INILVL
 6380		 BCS .2
 6390 *--------------------------------
 6400		 LDY #$00
 6410		 LDA (JLO),Y
 6420		 STA (LO),Y
 6430 *--------------------------------
 6440 .2	 DEC PLOTY
 6450		 DEC HT
 6460		 BMI LVLFIN
 6470		 JMP .1
 6480 LVLFIN	 LDA TEMP6
 6490		 STA PLOTY
 6500		 LDX ROCOL   *
 6510		 LDA #$B0    *	BOTTOM OF SCREEN
 6520		 STA RY1,X   *
 6530 *--------------------------------
 6540		 RTS
 6550 *--------------------------------
 6560 *  SET UP ADDRESSES FOR JLO AND LO
 6570 *  USED TO RESTORE MOUNTAINS
 6580 *--------------------------------
 6590 SETUP.ADDR LDA LO+1
 6600		 PHA
 6610		 LDA LO
 6620		 PHA
 6630		 LDA BUSH.OFFSET+1
 6640		 PHA
 6650		 LDA BUSH.OFFSET
 6660		 PHA
 6670		 JSR SUB16
 6680		 PLA
 6690		 STA JLO
 6700		 PLA
 6710		 STA JLO+1
 6720		 RTS
 6730 *--------------------------------
 6740 *   16BIT SUBTRACTION
 6750 *--------------------------------
 6760 SUB16	 PLA
 6770		 STA TEMP5
 6780		 PLA
 6790		 STA TEMP6
 6800		 PLA
 6810		 STA TEMP3
 6820		 PLA
 6830		 STA TEMP4
 6840		 PLA
 6850		 SEC
 6860		 SBC TEMP3
 6870		 TAY
 6880		 PLA
 6890		 SBC TEMP4
 6900		 PHA
 6910		 TYA
 6920		 PHA
 6930		 LDA TEMP6
 6940		 PHA
 6950		 LDA TEMP5
 6960		 PHA
 6970		 RTS
 6980 *--------------------------------
 6990 *  IRQ: SET UP ADDRESSES FOR JLO AND LO
 7000 *--------------------------------
 7010 IRQ.SETUP.ADDR LDA IRQ.LO+1
 7020		     PHA
 7030		     LDA IRQ.LO
 7040		     PHA
 7050		     LDA BUSH.OFFSET+1
 7060		     PHA
 7070		     LDA BUSH.OFFSET
 7080		     PHA
 7090		     JSR IRQ.SUB16
 7100		     PLA
 7110		     STA IRQ.JLO
 7120		     PLA
 7130		     STA IRQ.JLO+1
 7140		     RTS
 7150 *--------------------------------
 7160 *   16BIT SUBTRACTION
 7170 *--------------------------------
 7180 IRQ.SUB16      PLA
 7190		 STA IRQ.TEMP5
 7200		 PLA
 7210		 STA IRQ.TEMP6
 7220		 PLA
 7230		 STA IRQ.TEMP3
 7240		 PLA
 7250		 STA IRQ.TEMP4
 7260		 PLA
 7270		 SEC
 7280		 SBC IRQ.TEMP3
 7290		 TAY
 7300		 PLA
 7310		 SBC IRQ.TEMP4
 7320		 PHA
 7330		 TYA
 7340		 PHA
 7350		 LDA IRQ.TEMP6
 7360		 PHA
 7370		 LDA IRQ.TEMP5
 7380		 PHA
 7390		 RTS
