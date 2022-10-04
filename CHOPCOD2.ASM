 1000 *
 1010 * SAVE CHOP.CODE.2
 1020 *--------------------------------
 1030 *  INCREMENT TO NEXT LEVEL
 1040 *--------------------------------
 1050 NXTLVL	   LDA BILEVL	 LEVEL 99?
 1060		   CMP #98
 1070		   BEQ .1
 1080		   INC BILEVL
 1090		   INC LEVEL
 1100		   LDA LEVEL	 HANDLE 2-BYTE LEVEL #
 1110		   CMP #10
 1120		   BMI .1
 1130		   INC LEVEL+1
 1140		   LDA #$00
 1150		   STA LEVEL
 1160 *--------------------------------
 1170 * INCREMENT LIFES AFTER EACH LEVEL
 1180 *--------------------------------
 1190 .1	   LDX PLAYER	 CHECK IF PLAYERS ARE DEAD
 1200		   BPL SHOLVL
 1210		   RTS
 1220 *--------------------------------
 1230 *  SHOW LEVEL ON SCREEN
 1240 *--------------------------------
 1250 SHOLVL	   LDA LEVEL+1
 1260		   CLC
 1270		   ADC #$30
 1280		   STA SCOLIN+15
 1290		   STA LEVEL.MSG+12
 1300		   LDA LEVEL
 1310		   CLC
 1320		   ADC #$30
 1330		   STA SCOLIN+16
 1340		   STA LEVEL.MSG+13
 1350 *--------------------------------
 1360 *  SHOW LIVES ON SCREEN
 1370 *--------------------------------
 1380 SHOW.LIVES   LDX PLAYER	  WAS PLAYRS *******
 1390		   BMI .1	  PLAYERS DEAD
 1400 *--------------------------------
 1410		   LDA LIFE2,X
 1420		   CLC
 1430		   ADC #$30
 1440		   STA SCOLIN+12
 1450		   LDA LIFE1,X
 1460		   CLC
 1470		   ADC #$30
 1480		   STA SCOLIN+13
 1490 *--------------------------------
 1500		   JSR PRINT.SCOLIN
 1510 *--------------------------------
 1520 .1	   RTS
 1530 *--------------------------------
 1540 * SHOW BOMBS ON SCREEN
 1550 *--------------------------------
 1560 SHOBOMBS	   LDA BOMIND
 1570		   BEQ SHOBND
 1580		   DEC BOMIND
 1590		   DEC BDIG2
 1600		   BPL SHOBOMBS
 1610 *--------------------------------
 1620 *  BCD ADDITION
 1630 *--------------------------------
 1640		   LDA #$09    ***
 1650		   STA BDIG2
 1660		   LDA BDIG1   IF LEFT DIGIT = 0 THEN DONT DECREMENT
 1670		   BEQ SHOBND
 1680		   DEC BDIG1
 1690 *--------------------------------
 1700		   JMP SHOBOMBS
 1710 *--------------------------------
 1720 SHOBND	   LDA BDIG1
 1730		   CLC
 1740		   ADC #$30
 1750		   STA SCOLIN+9
 1760		   LDA BDIG2
 1770		   CLC
 1780		   ADC #$30
 1790		   STA SCOLIN+10
 1800		   JSR PRINT.SCOLIN
 1810		   RTS
 1820 *--------------------------------
 1830 *   NEW PLAYER/LEVEL
 1840 *--------------------------------
 1850 PLRCHG	 JSR TURN.SCREEN.OFF
 1860 *--------------------------------
 1870		 SEI
 1880 *--------------------------------
 1890		 LDA #$00	 STOP VBLANK FROM
 1900		 STA IRQ.ENABLE  SCREWING THINGS UP
 1910 *--------------------------------
 1920		 LDA LIVES   ANY LIVES LEFT
 1930		 ORA LIVES+1
 1940		 BNE NADED   YES
 1950 *--------------------------------
 1960		 LDA #$FF
 1970		 STA PLAYER  PLAYER DEAD
 1980		 LDA #$01    *******
 1990		 STA DEAD    *******
 2000 *--------------------------------
 2010 * 	 LDA #$01
 2020		 STA IRQ.ENABLE  TURN INTER. ON
 2030		 CLI
 2040		 JSR TURN.SCREEN.ON
 2050		 RTS
 2060 *--------------------------------
 2070 NADED	 LDA #$00
 2080		 STA NEWLFG
 2090 *--------------------------------
 2100		 STA MASTER.VOLUME   TURN SOUND OFF
 2110		 STA CHOP.EXPL
 2120		 STA EXPL.SOUND
 2130		 STA EXPL.FREQ
 2140 *--------------------------------
 2150		 LDA SAMEPL   SAME PLAYER?
 2160		 BEQ NSPLR    NO
 2170 *--------------------------------
 2180		 STA NEWLFG   NO NEW LEVEL
 2190 JLIVCK	 JMP LIVCHK
 2200 *--------------------------------
 2210 * GOING TO NEXT PLAYER
 2220 * SAVE PLAYER  SCORE
 2230 *--------------------------------
 2240 NSPLR	 LDX PLAYER
 2250		 LDA SCOVAL
 2260		 STA SCOV0,X
 2270		 LDA SCOVAL+1
 2280		 STA SCOV1,X
 2290		 LDA SCOVAL+2
 2300		 STA SCOV2,X
 2310		 LDA SCOVAL+3
 2320		 STA SCOV3,X
 2330		 LDA SCOVAL+4
 2340		 STA SCOV4,X
 2350		 LDA SCOVAL+5
 2360		 STA SCOV5,X
 2370		 LDA SCOVAL+6
 2380		 STA SCOV6,X
 2390		 LDA SCOVAL+7
 2400		 STA SCOV7,X
 2410		 LDA ABORT
 2420		 BNE LIVCHK
 2430 *--------------------------------
 2440 NCHGN2	 INC PLAYER   NEXT PLAYER
 2450		 LDA PLAYER
 2460		 CMP #$02
 2470		 BMI LIVCHK
 2480 *--------------------------------
 2490		 LDA #$00     BACK TO PLAYER 1
 2500		 STA PLAYER
 2510		 INC NEWLFG   AND NEW LEVEL
 2520 *--------------------------------
 2530 LIVCHK	 LDX PLAYER   HERE FIRST IF ABORTING
 2540		 LDA LIVES,X
 2550		 BEQ NCHGN2   IF DEAD, TRY OTHER PLAYER
 2560 *--------------------------------
 2570 NLCHEK	 LDA PLAYER
 2580		 CLC
 2590		 ADC #$31
 2600		 STA PLAYER.MSG+13
 2610 *--------------------------------
 2620		 LDA #$00
 2630		 STA TRANSIT
 2640		 STA DRTHIT   STOP DECREMENTING SCORE
 2650 *--------------------------------
 2660		 LDA NEWLFG
 2670		 BEQ .1
 2680		 JSR NXTLVL
 2690 *--------------------------------
 2700 *  DO INTERMEDIATE
 2710 *  SCREEN
 2720 *--------------------------------
 2730 .1	 LDA BILEVL
 2740		 CMP #38
 2750		 BEQ .2
 2760		 AND #$1F
 2770		 TAX
 2780 *--------------------------------
 2790		 LDA B1VALS,X
 2800		 STA BUCVL1
 2810		 LDA B2VALS,X
 2820		 STA BUCVL2
 2830 *--------------------------------
 2840 .2	 LDA BUCVL1
 2850		 CLC
 2860		 ADC #$30
 2870		 STA BUC.VALUE.MSG+13
 2880 *--------------------------------
 2890		 LDA BUCVL2
 2900		 CLC
 2910		 ADC #$30
 2920		 STA BUC.VALUE.MSG+15
 2930 *--------------------------------
 2940		 JSR CLEAR.SPRITES
 2950		 JSR SETUP.TEXT
 2960		 JSR CLEAR.HIRES
 2970		 JSR CLEAR.TEXT
 2980 *--------------------------------
 2990		 LDA #WHITE
 3000		 STA PRINT.COLOR
 3010 *--------------------------------
 3020		 LDA #LEVEL.MSG
 3030		 STA LO
 3040		 LDA /LEVEL.MSG
 3050		 STA LO+1
 3060		 LDA #10
 3070		 STA YPOS
 3080		 JSR PRINT.MSG
 3090 *--------------------------------
 3100		 LDA #WHITE
 3110		 STA PRINT.COLOR
 3120 *--------------------------------
 3130		 LDA #PLAYER.MSG
 3140		 STA LO
 3150		 LDA /PLAYER.MSG
 3160		 STA LO+1
 3170		 LDA #13
 3180		 STA YPOS
 3190		 JSR PRINT.MSG
 3200 *--------------------------------
 3210		 LDA #BUC.VALUE.MSG
 3220		 STA LO
 3230		 LDA /BUC.VALUE.MSG
 3240		 STA LO+1
 3250		 LDA #16
 3260		 STA YPOS
 3270		 JSR PRINT.MSG
 3280 *--------------------------------
 3290		 JSR TURN.SCREEN.ON
 3300 *--------------------------------
 3310		 LDX PLAYER
 3320		 LDA PLAYER.COLOR,X
 3330		 STA SPRITE.COLOR
 3340		 STA $D021
 3350		 LDA #$01	      **
 3360		 STA DIE.FLAG,X       **
 3370 *--------------------------------
 3380		 JSR INTRM.SOUND
 3390 *--------------------------------
 3400 DO.INTRM	 LDA #$60
 3410		 STA TEMP1
 3420 .1	 JSR DELAY
 3430		 JSR DELAY
 3440		 JSR DELAY
 3450		 JSR DELAY
 3460		 DEC TEMP1
 3470		 BNE .1
 3480 *--------------------------------
 3490		 LDA #$00
 3500		 STA MASTER.VOLUME
 3510		 STA $D404
 3520		 STA $D40B
 3530		 STA $D412
 3540 *--------------------------------
 3550		 JSR CRTINI
 3560		 JSR INIT.SOUND   RE-INIT SOUND REGISTERS
 3570 *--------------------------------
 3580 NNLEVL	 LDA ABORT    ABORT?
 3590		 BEQ .1       NO
 3600 *--------------------------------
 3610 .1	 LDX PLAYER
 3620 *--------------------------------
 3630		 LDA SCOV0,X
 3640		 STA SCOVAL
 3650		 LDA SCOV1,X
 3660		 STA SCOVAL+1
 3670		 LDA SCOV2,X
 3680		 STA SCOVAL+2
 3690		 LDA SCOV3,X
 3700		 STA SCOVAL+3
 3710		 LDA SCOV4,X
 3720		 STA SCOVAL+4
 3730		 LDA SCOV5,X
 3740		 STA SCOVAL+5
 3750		 LDA SCOV6,X
 3760		 STA SCOVAL+6
 3770		 LDA SCOV7,X
 3780		 STA SCOVAL+7
 3790 *--------------------------------
 3800 NOPSLD	 JSR SHOSCO	SHOW SCORE
 3810		 LDX PLAYER
 3820		 JSR SHOW.LIVES
 3830 *--------------------------------
 3840		 LDA #$00
 3850		 STA SAMEPL	  ******
 3860 *--------------------------------
 3870		 STA CHANGP
 3880		 LDA #$01
 3890		 STA IRQ.ENABLE PLAYER CHANGE FLAG
 3900		 CLI
 3910		 JSR DELAY
 3920		 JSR DELAY
 3930 *--------------------------------
 3940		 JSR TURN.SCREEN.ON
 3950 *--------------------------------
 3960		 LDA #$0A
 3970		 STA MASTER.VOLUME
 3980 *--------------------------------
 3990		 LDA #$00
 4000		 STA ABORT
 4010		 RTS
 4020 *--------------------------------
 4030 *  SHOW SCORE ROUTINE
 4040 *--------------------------------
 4050 SHOSCO	 LDX #$00
 4060 SCOLP1	 LDA SCOVAL,X
 4070		 BNE GOTMAX
 4080		 INX
 4090		 CPX #8
 4100		 BNE SCOLP1
 4110 GOTMAX	 LDY PLAYER
 4120		 TXA
 4130		 STA SCOMAX,Y
 4140 *--------------------------------
 4150		 DEX
 4160		 LDA #$20      LOAD SPACE
 4170 .1	 STA SCOLIN,X
 4180		 DEX	       CLEAR LEFT OF $ SIGN
 4190		 BPL .1
 4200 *--------------------------------
 4210		 LDA SCOMAX,Y  @@@
 4220		 TAX	       @@@
 4230 SCOLP2	 LDA SCOVAL,X
 4240		 CLC
 4250		 ADC #$30
 4260		 LDY SCOOFS,X
 4270		 STA SCOLIN,Y
 4280		 INX
 4290		 CPX #8
 4300		 BNE SCOLP2
 4310 *--------------------------------
 4320		 LDY PLAYER
 4330		 LDA SCOMAX,Y	  @@@
 4340		 CMP #5
 4350		 BCS NOCOM
 4360		 LDY #$2C	  LOAD ","
 4370		 JMP SKIP
 4380 NOCOM	 LDY #$20	  LOAD <SPACE>
 4390 SKIP	 STY SCOLIN+4
 4400		 LDX #$FF	  FIND 1ST DIGIT STARTING
 4410 .1	 INX		  FROM THE LEFT
 4420		 LDA SCOLIN,X
 4430		 CMP #$20	  IS IT A "0"
 4440		 BEQ .1
 4450		 LDA #$24	  LOAD "$"
 4460		 STA SCOLIN-1,X
 4470		 DEX		  POINTING AT "$"
 4480		 BEQ SCOXIT	  ****
 4490		 DEX		  POINTING AT "0"
 4500		 LDA #$20	  LOAD <SPACE>
 4510 .2	 STA SCOLIN,X	  ERASE LEADING ZEROS
 4520		 DEX
 4530		 BPL .2
 4540 SCOXIT	 LDA #WHITE
 4550		 STA PRINT.COLOR
 4560 *--------------------------------
 4570 SCORE.PR	 LDA PLAYER
 4580		 BNE SAVE.2
 4590 *--------------------------------
 4600 SAVE.1	 LDY #$00
 4610		 LDX #$00
 4620 .1	 LDA SCOLIN,Y
 4630		 STA SCORE.ONE,X
 4640		 INX
 4650		 INY
 4660		 CPY #$08
 4670		 BNE .1
 4680		 JMP PRINT.SCOLIN
 4690 *--------------------------------
 4700 SAVE.2	 LDY #$00
 4710		 LDX #$00
 4720 .1	 LDA SCOLIN,Y
 4730		 STA SCORE.TWO,X
 4740		 INX
 4750		 INY
 4760		 CPY #$08
 4770		 BNE .1
 4780 *--------------------------------
 4790 * PRINT SCORE ON SCREEN
 4800 *--------------------------------
 4810 PRINT.SCOLIN	LDY #18
 4820			LDX #36
 4830 .2		LDA SCOLIN,Y
 4840			STA .1
 4850			LDA SCORE.COLOR,Y
 4860			STA PRINT.COLOR
 4870			DEY
 4880			TYA
 4890			PHA
 4900			TXA
 4910			PHA
 4920			LDY #23
 4930			JSR PRINT
 4940 .1		.AS "0"
 4950			.HS FF
 4960			PLA
 4970			TAX
 4980			PLA
 4990			TAY
 5000			DEX
 5010			DEX
 5020			BPL .2
 5030			RTS
 5040 *--------------------------------
 5050 * ADD TO SCORE
 5060 *--------------------------------
 5070 ADDSCO	 LDX SCOPOS
 5080		 LDA SCOCHG
 5090 CARRY	 CLC
 5100		 ADC SCOVAL,X
 5110		 CMP #10
 5120		 BPL .1
 5130		 STA SCOVAL,X
 5140 *--------------------------------
 5150		 JMP SHOSCO
 5160 *--------------------------------
 5170 .1	 SEC
 5180		 SBC #10
 5190		 STA SCOVAL,X
 5200		 LDA #1
 5210		 DEX
 5220		 JMP CARRY
 5230 *--------------------------------
 5240 * SUBTRACT FROM SCORE
 5250 *--------------------------------
 5260 SUBSCO	 LDA SCOPOS
 5270		 TAX
 5280		 LDY PLAYER
 5290		 CMP SCOMAX,Y
 5300		 BEQ UHOH
 5310		 BPL SUBOK
 5320		 BNE OUTBUX    NO MORE DOLLARS
 5330 UHOH	 LDA SCOCHG
 5340		 CMP SCOVAL,X
 5350		 BPL OUTBUX
 5360 SUBOK	 LDA SCOVAL,X
 5370		 SEC
 5380		 SBC SCOCHG
 5390		 BPL SUBDUN
 5400		 CLC
 5410		 ADC #10
 5420		 STA SCOVAL,X
 5430		 LDA #1
 5440		 STA SCOCHG
 5450		 DEX
 5460		 BPL SUBOK
 5470 *--------------------------------
 5480 OUTBUX	 LDX #7
 5490 .1	 LDA OBDATA,X
 5500		 STA SCOLIN,X
 5510		 LDA #0
 5520		 STA SCOVAL,X
 5530		 DEX
 5540		 BPL .1
 5550 *--------------------------------
 5560		 JSR SCORE.PR
 5570 *--------------------------------
 5580		 LDA #1
 5590		 STA DEAD
 5600 *--------------------------------
 5610		 LDX PLAYER
 5620		 LDA #$00
 5630		 STA LIVES,X
 5640		 RTS
 5650 *--------------------------------
 5660		 RTS
 5670 *--------------------------------
 5680 SUBDUN	 STA SCOVAL,X
 5690		 JMP SHOSCO
 5700 *--------------------------------
 5710 *  SETUP SCREEN
 5720 *--------------------------------
 5730 CRTINI	 LDA VIC.CONTROL.1   TURN SCREEN OFF
 5740		 BPL CRTINI
 5750		 JSR TURN.SCREEN.OFF
 5760 *--------------------------------
 5770		 INC INIFLG
 5780		 LDA BILEVL
 5790 NOSET3	 AND #$03
 5800		 TAX
 5810		 LDA GROUND,X  GET GROUND HEIGHT
 5820		 STA INILVL    INTO INILVL
 5830		 STA WATERY
 5840		 STA SCAN.Y
 5850 *--------------------------------
 5860		 SEC
 5870		 SBC #$18
 5880		 STA MOUNTAIN.TOP
 5890 *--------------------------------
 5900		 LDA #$00
 5910		 STA WATERX
 5920		 STA SCAN.X
 5930		 STA DROPGO  DIRT NOT READY FOR DROP
 5940 *--------------------------------
 5950		 LDA PADLOC,X  GET PAD LOCATION
 5960		 STA PADLVL    ALL DEPENDS ON LEVEL
 5970		 LDA PADLOC2,X
 5980		 STA PADLVL2
 5990 *--------------------------------
 6000		 LDA SUN.HT,X
 6010		 STA SUN.Y
 6020		 LDA SUN.LR,X
 6030		 STA SUN.X
 6040		 LDA #$01
 6050		 STA SUN.XMSB
 6060 *--------------------------------
 6070		 LDA BUCHGT,X
 6080		 STA BUCLVL
 6090		 LDA BUCADF,X
 6100		 STA BUCADD
 6110		 LDA PADLIN,X
 6120		 STA PADLIN
 6130		 LDA UWTBL,X
 6140		 STA UNDWTR
 6150		 LDA SWTBL,X
 6160		 STA SURWTR
 6170		 LDA ICTBL,X
 6180		 STA INICHT
 6190 *--------------------------------
 6200 COLOR.PAD  TXA		POINT TO COLOR
 6210		 ASL		FOR PAD
 6220		 TAX
 6230		 LDA PADC.ADR,X
 6240		 STA PADC.LO
 6250		 LDA PADC.ADR+1,X
 6260		 STA PADC.LO+1
 6270 *--------------------------------
 6280		 LDA #$00
 6290		 STA PLOTX
 6300		 LDA INILVL
 6310		 STA PLOTY
 6320		 STA SOIL
 6330		 JSR PLOTCL
 6340 *--------------------------------
 6350		 LDA BILEVL   SHIFT OFF LOW 2 BITS
 6360		 LSR	      AND USE AS INDEX
 6370		 LSR
 6380		 TAX
 6390 *--------------------------------
 6400		 LDA FALLS,X   SET FALL SPEED FOR
 6410		 STA FALSPD    DIRT
 6420		 LDA GUNPRS,X
 6430		 STA GPFLG
 6440		 LDA GCHANC,X
 6450		 STA GUNCHN
 6460		 LDA RMAX,X    SET MAX NUMBER OF
 6470		 STA ROCMAX    ROCKS BEING DROPPED
 6480 *--------------------------------
 6490		 JSR GUN.CHANCE  SET TRANCT FOR GUN ROUTINES
 6500		 LDA #$00
 6510		 STA GUN.Y	 REMOVE GUN FROM SCREEN
 6520 *--------------------------------
 6530 *  SELECT PRIZES
 6540 *--------------------------------
 6550		 LDY #$02
 6560		 LDA BILEVL
 6570		 AND #$07
 6580 .1	 TAX
 6590 .2	 LDA PRIZE.SHAPE,X  SELECT PRIZES
 6600		 STA PRIZE.1,Y	    AND THEIR COLOR
 6610		 LDA PRIZE.COLOR,X
 6620		 STA PRIZE.1C,Y
 6630		 DEY
 6640		 BPL .2
 6650 *--------------------------------
 6660		 LDA #$00
 6670		 STA EXPCNT
 6680		 STA ROCNT
 6690		 STA ERASE.FLAG
 6700		 STA ERASE.FLAG+1
 6710		 STA ERASE.FLAG+2
 6720		 STA ERASE.FLAG+3
 6730		 STA BOMB.COUNT
 6740		 STA BOMB      NO BOMBS ARE
 6750		 STA BOMB+1    ACTIVE
 6760		 STA BOMB+2
 6770		 STA BOMB+3
 6780		 STA BOMACT
 6790		 STA DROPWT
 6800		 STA WPHASE
 6810		 LDA #$04
 6820		 STA BODPH
 6830		 STA ROTGT
 6840		 LDA SHOTON
 6850		 BEQ CGUNVR
 6860		 JSR SHTCLR
 6870 CGUNVR	 LDA #$00
 6880		 STA GUNACT
 6890		 STA GUNFAL
 6900		 STA GUNFGO
 6910		 STA GUNSHT
 6920		 STA LANDFG    LANDED
 6930		 JSR CLEAR.HIRES
 6940		 JSR INIT.CM
 6950 *--------------------------------
 6960 *  DRAW BLUE SKY
 6970 *--------------------------------
 6980		 LDX #$00
 6990		 STX PLOTX
 7000 .1	 STX PLOTY
 7010		 TXA
 7020		 PHA
 7030		 JSR PLOTCL
 7040		 PLA
 7050		 TAX
 7060		 LDA #39
 7070		 STA TEMP1
 7080		 LDY #$00
 7090 .2	 LDA #$55      $55 IS BLUE
 7100		 STA (LO),Y
 7110		 LDA #$08      NEXT BYTE
 7120		 CLC
 7130		 ADC LO
 7140		 STA LO
 7150		 BCC .3
 7160		 INC LO+1
 7170 .3	 DEC TEMP1
 7180		 BPL .2
 7190		 INX
 7200		 CPX INILVL
 7210		 BCC .1
 7220 *--------------------------------
 7230 * DRAW GROUND DEPENDING ON LEVEL
 7240 *--------------------------------
 7250		 LDX #$00
 7260		 STX PLOTX
 7270		 LDX INILVL
 7280 DLOOP2	 STX PLOTY
 7290		 TXA
 7300		 PHA
 7310		 JSR PLOTCL
 7320		 PLA
 7330		 TAX
 7340		 LDA #39
 7350		 STA TEMP1
 7360 DLOOP3	 LDA PLOTY
 7370		 AND #$03
 7380		 TAY
 7390		 LDA DIRT.TEXTURE,Y
 7400		 LDY #$00
 7410		 STA (LO),Y
 7420		 LDA #$08
 7430		 CLC
 7440		 ADC LO
 7450		 STA LO
 7460		 BCC .1
 7470		 INC LO+1
 7480 .1	 DEC TEMP1
 7490		 BPL DLOOP3
 7500		 INX
 7510		 CPX #$BB
 7520		 BNE DLOOP2
 7530 *--------------------------------
 7540 * INIT SCREEN MEM BELOW GROUND
 7550 *--------------------------------
 7560 DO.SCRMEM  LDA BILEVL
 7570		 AND #$03
 7580		 ASL
 7590		 TAX
 7600		 LDA WATERC.ADR,X
 7610		 STA LO
 7620		 LDA WATERC.ADR+1,X
 7630		 STA LO+1
 7640		 LDY #$00
 7650 .1	 LDA #$31
 7660		 STA (LO),Y
 7670		 >INC LO
 7680		 LDA LO+1
 7690		 CMP #$43
 7700		 BNE .1
 7710		 LDA LO
 7720		 CMP #$70
 7730		 BNE .1
 7740 *--------------------------------
 7750 *  DRAW MOUNTAINS
 7760 *--------------------------------
 7770		 JSR DO.MOUNT
 7780		 JSR DO.COLOR
 7790 CK	 LDA DEMO
 7800		 BEQ .4
 7810		 JMP ACT2
 7820 .4	 LDA PADLVL    GET PAD HEIGHT
 7830		 STA PLOTY
 7840		 LDA #0
 7850		 STA PLOTX
 7860		 JSR PLOTCL
 7870		 LDA LO        CALCULATE POSITION
 7880		 STA PADLO     OF PAD
 7890		 LDA LO+1
 7900		 STA PADHI
 7910 REPOS	 LDA #$00
 7920		 STA HIT0
 7930		 STA TRANSIT   PLANE IS NOT MOVING
 7940 *--------------------------------
 7950		 LDA #$01
 7960		 STA LANDFG
 7970		 LDA #$01      @@@STOP CHOP
 7980		 STA INCUD
 7990		 LDA #$00
 8000		 STA CHOP.XMSB
 8010		 LDA #$30      SET CHOPPER X
 8020		 STA CHOP.X
 8030		 STA SPRITE.XPOS
 8040		 LDA INICHT    SET CHOPPER Y
 8050		 STA CHOP.Y    ONTO LANDING PAD
 8060		 STA SPRITE.YPOS
 8070 *--------------------------------
 8080 *  PUT IN SURFACE WATER
 8090 *--------------------------------
 8100		 LDA SURWTR
 8110		 BEQ ACT2
 8120		 LDA BILEVL
 8130		 AND #$30
 8140		 BNE .5
 8150		 LDA #$01
 8160		 BNE .55
 8170 .5	 LDA SURWTR
 8180 .55	 STA SURTMP
 8190 .1	 LDA #$05	WAS 3!!!!
 8200		 STA DEPTH
 8210		 TAX
 8220		 LDA INILVL
 8230		 STA WTRLIN
 8240 .11	 LDA SEED
 8250		 STA RANDOM
 8260 .2	 JSR MAKE.RANDOM
 8270		 BEQ .11
 8280		 CMP #120
 8290		 BCS .2
 8300		 STA WTRLFT
 8310		 CLC
 8320		 ADC #$01
 8330		 STA SURFACE.X
 8340 *--------------------------------
 8350 .22	 LDA SURMAX,X
 8360		 STA WTRLEN
 8370		 JSR DOWATR
 8380		 DEC DEPTH
 8390		 BEQ .4
 8400		 INC WTRLIN
 8410		 JSR MAKE.RANDOM
 8420		 AND #$07
 8430		 CLC
 8440		 ADC WTRLFT
 8450		 STA WTRLFT
 8460		 LDX DEPTH
 8470		 JMP .22	 WAS .3
 8480 .4	 DEC SURTMP
 8490		 BNE .1
 8500 *--------------------------------
 8510 * DO UNDERGROUND WATER
 8520 *--------------------------------
 8530		 JSR DO.UNDER
 8540 *--------------------------------
 8550 *  TURN ON SCREEN
 8560 *--------------------------------
 8570 ACT2	 LDA DEMO
 8580		 BNE .1
 8590		 LDA PLAYER
 8600		 BEQ .3
 8610		 JSR DO.BUCKS.2
 8620		 JMP .4
 8630 .3	 JSR DO.BUCKS
 8640 .4	 JSR CHANGE.IRQ
 8650		 JMP .2
 8660 .1	 JSR TURN.SCREEN.ON TURN ON SCREEN
 8670 .2	 LDA #$01    PUT CHOP ON PAD
 8680		 STA LANDFG
 8690		 RTS
 8700 *--------------------------------
 8710 *  CALCULATE PLOT ADDRESS
 8720 *--------------------------------
 8730 PLOTCL	 LDA PLOTY
 8740		 LSR
 8750		 LSR
 8760		 LSR
 8770		 ASL
 8780		 TAX
 8790		 LDA YTABLE,X
 8800		 STA LO
 8810		 LDA YTABLE+1,X
 8820		 STA LO+1
 8830		 LDA PLOTX
 8840		 AND #$FC
 8850		 ASL
 8860		 PHP
 8870		 CLC
 8880		 ADC LO
 8890		 STA LO
 8900		 BCC .1
 8910		 INC LO+1
 8920 .1	 LDA LO+1
 8930		 PLP
 8940		 ADC #$00
 8950		 STA LO+1
 8960		 LDA PLOTY
 8970		 AND #$07
 8980		 CLC
 8990		 ADC LO
 9000		 STA LO
 9010		 BCC .2
 9020		 INC LO+1
 9030 .2	 LDA PLOTX
 9040		 AND #$03
 9050		 TAX
 9060		 LDA PLOTBL,X
 9070		 STA PLOTBYT
 9080		 RTS
 9090 *--------------------------------
 9100 *  YTABLE USED BY PLOTCL
 9110 *--------------------------------
 9120 YTABLE	 .DA $6000
 9130		 .DA $6140
 9140		 .DA $6280
 9150		 .DA $63C0
 9160		 .DA $6500
 9170		 .DA $6640
 9180		 .DA $6780
 9190		 .DA $68C0
 9200		 .DA $6A00
 9210		 .DA $6B40
 9220		 .DA $6C80
 9230		 .DA $6DC0
 9240		 .DA $6F00
 9250		 .DA $7040
 9260		 .DA $7180
 9270		 .DA $72C0
 9280		 .DA $7400
 9290		 .DA $7540
 9300		 .DA $7680
 9310		 .DA $77C0
 9320		 .DA $7900
 9330		 .DA $7A40
 9340		 .DA $7B80
 9350		 .DA $7CC0
 9360		 .DA $7E00
 9370		 .DA $7F40
 9380 *--------------------------------
 9390 *   IRQ PLOT CALCULATOR
 9400 *--------------------------------
 9410 IRQ.PLOTCL LDA IRQ.PLOTY
 9420		 LSR
 9430		 LSR
 9440		 LSR
 9450		 ASL
 9460		 TAX
 9470		 LDA YTABLE,X
 9480		 STA IRQ.LO
 9490		 LDA YTABLE+1,X
 9500		 STA IRQ.LO+1
 9510		 LDA IRQ.PLOTX
 9520		 AND #$FC
 9530		 ASL
 9540		 PHP
 9550		 CLC
 9560		 ADC IRQ.LO
 9570		 STA IRQ.LO
 9580		 BCC .1
 9590		 INC IRQ.LO+1
 9600 .1	 LDA IRQ.LO+1
 9610		 PLP
 9620		 ADC #$00
 9630		 STA IRQ.LO+1
 9640		 LDA IRQ.PLOTY
 9650		 AND #$07
 9660		 CLC
 9670		 ADC IRQ.LO
 9680		 STA IRQ.LO
 9690		 BCC .2
 9700		 INC IRQ.LO+1
 9710 .2	 LDA IRQ.PLOTX
 9720		 AND #$03
 9730		 TAX
 9740		 LDA PLOTBL,X
 9750		 STA PLOTBYT
 9760		 RTS
 9770 *--------------------------------
 9780 *  MOVE CLOUD
 9790 *--------------------------------
 9800 MOVE.CLOUD LDA CLOUD.TIM
 9810		 BNE CLOUD.END
 9820		 LDA CLOUD.FG
 9830		 BNE .1
 9840		 LDA #$40
 9850		 STA CLOUD.TIM
 9860		 JSR MAKE.RANDOM
 9870		 AND #$01
 9880		 STA CLOUD.DIR
 9890		 ASL
 9900		 TAX
 9910		 LDA PLNORG,X
 9920		 STA CLOUD.X
 9930		 LDA PLNORG+1,X
 9940		 STA CLOUD.XMSB
 9950		 LDA #$01
 9960		 STA CLOUD.FG
 9970 *--------------------------------
 9980 .1	 DEC CLOUD.TIM
 9990		 LDA CLOUD.DIR
 10000		  BNE .11
 10010 *--------------------------------
 10020		  LDA CLOUD.XMSB
 10030		  BNE .3
 10040		  LDA CLOUD.X
 10050		  CMP #$02
 10060		  BEQ .5
 10070 .3	  LDA CLOUD.X
 10080		  SEC
 10090		  SBC #$01
 10100		  STA CLOUD.X
 10110		  BCS CLOUD.END
 10120		  LDA #$00
 10130		  STA CLOUD.XMSB
 10140		  BEQ CLOUD.END   ALWAYS
 10150 *--------------------------------
 10160 .11	  LDA CLOUD.XMSB
 10170		  BEQ .4
 10180		  LDA CLOUD.X
 10190		  CMP #$55
 10200		  BEQ .5
 10210 .4	  LDA CLOUD.X
 10220		  CLC
 10230		  ADC #$01
 10240		  STA CLOUD.X
 10250		  BCC CLOUD.END
 10260		  LDA #$01
 10270		  STA CLOUD.XMSB
 10280		  BNE CLOUD.END    ALWAYS
 10290 .5	  LDA #$00
 10300		  STA CLOUD.FG
 10310 CLOUD.END  DEC CLOUD.TIM
 10320		  RTS
 10330 *--------------------------------
 10340 CLEAR.SPRITES LDX #$00
 10350 .1	     TXA
 10360		     ASL
 10370		     TAY
 10380		     LDA #$00
 10390		     STA SPRITE.YPOS,Y
 10400		     INX
 10410		     CPX #$07
 10420		     BNE .1
 10430		     RTS
 10440 *--------------------------------
 10450 TURN.SCREEN.ON LDA #$10
 10460		      ORA VIC.CONTROL.1
 10470		      STA VIC.CONTROL.1
 10480		      RTS
