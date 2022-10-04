 1000 *--------------------------------
 1010 * SAVE CHOP.CODE.1
 1020 *--------------------------------
 1030 COLD.START    JSR TURN.SCREEN.OFF
 1040 *--------------------------------
 1050		  SEI		OFF ANY INTERRUPTS
 1060 *--------------------------------
 1070		  LDA #$00	 CLEAR PG 0
 1080		  LDX #$FA
 1090 .2	  STA $05,X
 1100		  DEX
 1110		  BPL .2
 1120 *--------------------------------
 1130		  LDA #$20
 1140		  LDX #$07
 1150 .3	  STA SCORE.ONE,X
 1160		  STA SCORE.TWO,X
 1170		  DEX
 1180		  BPL .3
 1190 *--------------------------------
 1200		  LDA SEED
 1210		  STA RANDOM
 1220		  JSR INIT.IO	 SETUP I/O HARDWARE!
 1230		  LDA #$00
 1240		  TAX
 1250 .1	  .HS 9D	OPCODE FOR STA $ZZZZ,X
 1260		  .DA TEMP1	BYTES FOR ADDRESS OF STA
 1270		  STA $D000,X	CLEAR 6566 VIDEO REGISTERS
 1280		  STA $D400,X	CLEAR 6581 SID REGISTERS
 1290		  INX
 1300		  BNE .1
 1310		  TXS		RESET STACK POINTER
 1320		  LDA #$01
 1330		  STA DEMO
 1340		  JSR INIT.GAME
 1350		  JSR INIT.HARDWARE
 1360		  JSR INIT.IRQS
 1370		  JSR INIT.SOUND
 1380		  CLI
 1390 *--------------------------------
 1400 DEMOIN	 JSR INIT.GAME
 1410		 LDA #$02
 1420		 STA BODPH
 1430 *--------------------------------
 1440		 LDA #$00
 1450		 STA PAUSE
 1460		 STA BLADE.SOUND  START BLADE SOUND
 1470		 STA SUNPH
 1480		 STA BLDPH
 1490		 STA HIT0
 1500		 STA NEWLFG
 1510		 STA STICK.TMP
 1520		 STA BLADE.SPEED
 1530		 STA CHOP.XMSB
 1540		 STA PLANE.Y
 1550		 STA CLOUD.Y
 1560 *--------------------------------
 1570		 STA STICK.NUMBER
 1580		 STA PLAYRS	  !!
 1590		 STA BLADE.SPEED  !!
 1600 *--------------------------------
 1610		 LDA #$5A
 1620		 STA CHOP.Y
 1630		 LDA #$60
 1640		 STA CHOP.X
 1650		 LDA #$01
 1660		 STA CHOP.SPEED
 1670 *--------------------------------
 1680		 JSR INIT.IRQ	  SETUP DEMO SCREEN
 1690		 JSR CLEAR.SCREEN
 1700 *--------------------------------
 1710		 LDA #$FC	  FORCE LOWER
 1720		 STA BILEVL	  LEVEL
 1730		 JSR CRTINI
 1740 *--------------------------------
 1750		 LDA #$02
 1760		 STA BODPH
 1770 *--------------------------------
 1780		 >PRINT 0,19,BROWN,"                    "
 1790		 >PRINT 0,20,WHITE,"    CHOPPER HUNT    "
 1800		 >PRINT 0,21,YELLOW,"       IMAGIC       "
 1810		 >PRINT 0,22,GREEN,"   COPYRIGHT 1984   "
 1820 *--------------------------------
 1830		 LDA #$FF
 1840		 STA TEMP1
 1850 .1	 JSR DELAY
 1860		 DEC TEMP1
 1870		 LDA TEMP1
 1880		 BNE .1
 1890 *--------------------------------
 1900 INTRO.SCR  >PRINT 0,19,BROWN,"                    "
 1910		 >PRINT 2,20,WHITE,"PRESS F7 TO START  "
 1920		 >PRINT 0,21,YELLOW,"                    "
 1930 *--------------------------------
 1940		 LDA #$01
 1950		 STA IRQ.ENABLE
 1960		 CLI	 ||
 1970 *--------------------------------
 1980		 LDA #ONE.STICK.MSG
 1990		 STA LO
 2000		 LDA /ONE.STICK.MSG
 2010		 STA LO+1
 2020		 LDA #21
 2030		 STA YPOS
 2040		 JSR PRINT.MSG
 2050 *--------------------------------
 2060		 LDA #GREEN
 2070		 STA PRINT.COLOR
 2080		 LDA #ONE.PLAYER.MSG
 2090		 STA LO
 2100		 LDA /ONE.PLAYER.MSG
 2110		 STA LO+1
 2120		 LDA #22
 2130		 STA YPOS
 2140		 JSR PRINT.MSG
 2150 *--------------------------------
 2160 * MOVE SPRITES
 2170 *--------------------------------
 2180 MOVE.SPR	 LDA #$00
 2190		 STA PLANE.X
 2200		 STA PLANE.XMSB
 2210		 STA CLOUD.X
 2220		 STA CLOUD.XMSB
 2230		 LDA #$34
 2240		 STA PLANE.Y
 2250		 LDA #$5A
 2260		 STA CHOP.Y
 2270		 LDA #$60
 2280		 STA CHOP.X
 2290		 LDA #$02
 2300		 STA BODPH
 2310 *--------------------------------
 2320 BUTTON.LUP JSR START.PLANE
 2330 *--------------------------------
 2340 * CHECK F3  (NUMBER OF PLAYERS)
 2350 *--------------------------------
 2360		 LDA #$20      CHECK F3
 2370		 LDY #$FE      (NUMBER OF PLAYERS)
 2380		 JSR KEY.SCAN
 2390		 BCC .5        NOT PUSHED
 2400		 JSR DELAY
 2410 .44	 LDA #$20      DEBOUNCE F3
 2420		 LDY #$FE
 2430		 JSR KEY.SCAN
 2440		 BCS .44       IT STILL IS PUSHED
 2450 *--------------------------------
 2460		 LDA #GREEN
 2470		 STA PRINT.COLOR
 2480		 LDA #22
 2490		 STA YPOS
 2500		 LDA PLAYRS
 2510		 EOR #$01
 2520		 STA PLAYRS
 2530		 BEQ .3
 2540		 LDA #TWO.PLAYER.MSG
 2550		 STA LO
 2560		 LDA /TWO.PLAYER.MSG
 2570		 STA LO+1
 2580		 JSR PRINT.MSG
 2590		 JMP .5
 2600 .3	 LDA #ONE.PLAYER.MSG
 2610		 STA LO
 2620		 LDA /ONE.PLAYER.MSG
 2630		 STA LO+1
 2640		 JSR PRINT.MSG
 2650		 LDA #21
 2660		 STA YPOS
 2670		 LDA #YELLOW
 2680		 STA PRINT.COLOR
 2690		 LDA #ONE.STICK.MSG
 2700		 STA LO
 2710		 LDA /ONE.STICK.MSG
 2720		 STA LO+1
 2730		 JSR PRINT.MSG
 2740 *--------------------------------
 2750 * CHECK F7  (START)
 2760 *--------------------------------
 2770 .5	 LDA #$08      CHECK F3
 2780		 LDY #$FE      (START)
 2790		 JSR KEY.SCAN
 2800		 BCC .6        NOT PUSHED
 2810		 JMP MAININ
 2820 *--------------------------------
 2830 * CHECK FIRE BUTTON
 2840 *--------------------------------
 2850 .6	 LDA PORTA1
 2860		 AND PORTB1
 2870		 AND #$10
 2880		 BNE BUTTON
 2890		 JMP MAININ
 2900 *--------------------------------
 2910 *  CHECK F1  (NUMBER OF STICKS)
 2920 *--------------------------------
 2930 BUTTON	 LDA #$10
 2940		 LDY #$FE
 2950		 JSR KEY.SCAN
 2960		 BCC .7
 2970 *--------------------------------
 2980 .77	 LDA #$10
 2990		 LDY #$FE
 3000		 JSR KEY.SCAN
 3010		 BCS .77
 3020 *--------------------------------
 3030		 LDA #YELLOW
 3040		 STA PRINT.COLOR
 3050		 LDA #21
 3060		 STA YPOS
 3070 *--------------------------------
 3080		 LDA PLAYRS   IF ONE PLAYER ONLY ONE STICK
 3090		 BEQ .73
 3100		 LDA STICK.NUMBER
 3110		 EOR #$01
 3120		 STA STICK.NUMBER
 3130		 BEQ .73
 3140		 LDA #TWO.STICK.MSG
 3150		 STA LO
 3160		 LDA /TWO.STICK.MSG
 3170		 STA LO+1
 3180		 JSR PRINT.MSG
 3190		 JMP .7
 3200 .73	 LDA #ONE.STICK.MSG
 3210		 STA LO
 3220		 LDA /ONE.STICK.MSG
 3230		 STA LO+1
 3240		 JSR PRINT.MSG
 3250 .7	 JMP BUTTON.LUP
 3260 *--------------------------------
 3270 * MAIN LOOP
 3280 *--------------------------------
 3290 MAININ	 JSR TURN.SCREEN.OFF
 3300		 LDA #$00
 3310		 STA PLANE.XMSB
 3320		 STA CHOP.XMSB
 3330		 LDA #$34
 3340		 STA PLANE.Y
 3350		 LDA #$4B
 3360		 STA CLOUD.Y
 3370		 LDA #$00
 3380		 LDX #$06
 3390 .1	 STA CHOP.X,X
 3400		 DEX
 3410		 BNE .1
 3420		 STA SPRITE.XMSB
 3430		 STA TIMER7
 3440		 STA LEVEL
 3450		 STA LEVEL+1
 3460		 STA LIFE1
 3470		 STA LIFE1+1
 3480		 STA LIFE2
 3490		 STA LIFE2+1
 3500 *--------------------------------
 3510 *  RESET VARIABLES
 3520 *--------------------------------
 3530		 STA GUN.PHASE
 3540		 STA SHOT.SOUND
 3550		 STA EXPL.FREQ
 3560		 STA SHOTON
 3570 * 	 STA STICK.TMP
 3580		 STA PLNDIR
 3590		 STA CHOP.DIR
 3600		 STA DEAD
 3610		 STA BDEAD
 3620		 STA FERRY
 3630		 STA TRANSIT
 3640 * 	 STA SNDCNT
 3650		 STA DROPWT
 3660		 STA DROPGO
 3670		 STA ROCNT
 3680		 STA BOMB
 3690		 STA BOMB+1
 3700		 STA BOMB+2
 3710		 STA BOMB+3
 3720		 STA BOMACT
 3730		 STA BOMB.COUNT
 3740		 STA ERASE.FLAG
 3750		 STA EXPGO
 3760		 STA EXPGO+1
 3770		 STA EXPGO+2
 3780		 STA EXPGO+3
 3790		 STA EXPGO+4
 3800		 STA EXPCNT
 3810 *--------------------------------
 3820 DUMMY2	 STA GUNFAL
 3830		 STA GUNFGO
 3840 *--------------------------------
 3850		 STA ABORT
 3860		 STA ABORT.FLAG
 3870		 STA INIFLG
 3880		 STA BDIG1
 3890		 STA BDIG2
 3900		 STA BOMIND
 3910		 STA INCUD
 3920		 STA INCLR
 3930 * 	 STA SPLCNT
 3940		 STA NPWAIT
 3950		 STA CHANGP
 3960		 STA OLD.LO
 3970		 STA OLD.LO+1
 3980		 STA TABLE.LO
 3990		 STA TABLE.LO+1
 4000		 STA DEMO	NO MORE DEMO
 4010		 STA HIT0
 4020		 STA HIT3
 4030		 STA BHIT1
 4040		 STA BHIT2
 4050		 STA BHIT3
 4060		 STA BUCHIT
 4070		 STA SPRITE.COLLISION
 4080		 STA CHOP.EXPL
 4090		 STA CLOUD.TIM
 4100		 STA CLOUD.DIR
 4110		 STA CLOUD.FG
 4120 * 	 STA SUNPH
 4130 * 	 STA BLDPH
 4140		 STA WATERX
 4150		 STA LAND.SOUND
 4160		 STA BUC.SOUND
 4170		 STA ROTATE.LEFT
 4180		 STA ROTATE.RIGHT
 4190		 STA CHANGP
 4200		 STA NAME.FLAG
 4210 *--------------------------------
 4220		 LDA #$FF
 4230		 STA BILEVL
 4240		 STA FERIX
 4250 *--------------------------------
 4260		 LDA #$55
 4270		 STA OLD.BOMB
 4280		 STA OLD.BOMB+1
 4290		 STA OLD.BOMB+2
 4300		 STA OLD.BOMB+3
 4310 *--------------------------------
 4320		 LDA SPRITE.BCOLIDE  CLEAR COLLISION REGISTER
 4330 *--------------------------------
 4340		 JSR INIT.IRQ
 4350 *--------------------------------
 4360		 LDA #75     START WITH 75
 4370		 STA BOMBLD  BOMBS
 4380		 LDA #$20
 4390		 LDX #18
 4400 .1	 STA SCOLIN,X
 4410		 DEX
 4420		 BPL .1
 4430		 LDA #$00
 4440		 STA PLAYER	FIRST PLAYER
 4450		 LDX PLAYRS
 4460		 LDA P1LINI,X	SET # OF LIVES
 4470		 STA LIVES
 4480		 STA LIFE1	RIGHT DIGIT OF PLAYER 1
 4490 *--------------------------------
 4500		 LDA P2LINI,X
 4510		 STA LIVES+1
 4520		 STA LIFE1+1	RIGHT DIGIT OF PLAYER 2
 4530 *--------------------------------
 4540		 LDA #$00
 4550		 LDX #15
 4560 .2	 STA SCOV0,X
 4570		 DEX
 4580		 BPL .2
 4590		 LDA #$07
 4600		 STA SCOMAX
 4610		 STA SCOMAX+1
 4620		 LDA #$02
 4630		 STA SCOV4     START WITH
 4640		 STA SCOV4+1   $2000
 4650 *--------------------------------
 4660		 LDA #$01
 4670		 STA DIE.FLAG
 4680		 STA DIE.FLAG+1
 4690		 STA SAMEPL
 4700		 JSR PLRCHG    INIT LEVEL AND SCREEN
 4710		 JSR TURN.SCREEN.ON   TEST !!!
 4720		 LDA #$00
 4730		 STA DRTHIT
 4740		 LDA #$02
 4750		 STA TIMER1
 4760 *--------------------------------
 4770 *  MAIN EXECUTION LOOP
 4780 *--------------------------------
 4790 MAIN.LOOP  LDA #$10      CHECK SPACE BAR
 4800		 LDY #$7F
 4810		 JSR KEY.SCAN
 4820		 BCC .2
 4830 *--------------------------------
 4840		 LDA PAUSE
 4850		 AND #$01
 4860		 EOR #$01
 4870		 STA PAUSE
 4880 *--------------------------------
 4890		 LDA PRIZE.1
 4900		 CMP #$29	ON THE DIAMONDS?
 4910		 BNE .22	NO
 4920		 LDA CHOP.Y
 4930		 SEC
 4940		 SBC #$2E
 4950		 CMP INILVL	BELOW GROUND
 4960		 BCC .22	NO
 4970		 LDA BODPH
 4980		 CMP #$04	FACING RIGHT?
 4990		 BNE .22	NO
 5000 *--------------------------------
 5010		 LDA #$01
 5020		 STA NAME.FLAG
 5030 *--------------------------------
 5040 .22	 LDA #$10      DEBOUNCE IT
 5050		 LDY #$7F
 5060		 JSR KEY.SCAN
 5070		 BCS .22
 5080 *--------------------------------
 5090 .2	 JSR READ.STICKS
 5100		 AND #$10
 5110		 BEQ .1
 5120		 LDA PAUSE
 5130		 BEQ .1
 5140 *--------------------------------
 5150		 LDA #$00
 5160		 STA MASTER.VOLUME
 5170		 JMP MAIN.LOOP
 5180 *--------------------------------
 5190 .1	 LDA #$00	  IF RESTARTED BY BUTTON MAKE SURE
 5200		 STA PAUSE	  PAUSE IS RESET
 5210		 LDA NPWAIT	  WAITING FOR NEXT PLAYER   (SET IN CHOP.CODE.3)
 5220		 BEQ CHECK.START  NO, CHECK ABORT
 5230 *--------------------------------
 5240		 JSR PLRCHG    CHANGE PLAYER
 5250		 LDA #$00
 5260		 STA NPWAIT    NO MORE WAIT
 5270 *-------------------------------
 5280 * CHECK BUTTONS
 5290 *--------------------------------
 5300 * CHECK F7
 5310 *--------------------------------
 5320 CHECK.START LDA #$08	 CHECK FOR F7
 5330		  LDY #$FE
 5340		  CLC
 5350		  JSR KEY.SCAN
 5360		  BCC .1
 5370 * 	  JSR NXTLVL
 5380 *--------------------------------
 5390		 LDA SEED
 5400		 STA RANDOM
 5410		 JMP MAININ	START AGAIN
 5420 *--------------------------------
 5430 * CHECK F5
 5440 *--------------------------------
 5450 .1	 LDA #$40	CHECK FOR F5
 5460		 LDY #$FE
 5470		 CLC
 5480		 JSR KEY.SCAN
 5490		 BCC .2
 5500		 JMP COLD.START
 5510 *-------------------------------
 5520 *   DRAW LANDING PAD
 5530 *--------------------------------
 5540 .2	 JSR DO.PAD
 5550 *--------------------------------
 5560		 JSR CHECK.ABORT
 5570		 JSR CHECK.LIVES
 5580 *--------------------------------
 5590		 LDA BDEAD	ARE BOTH PLAYERS DEAD
 5600		 BEQ .99	NO
 5610 *--------------------------------
 5620 *  BOTH PLAYERS ARE DEAD (PUT GAMEOVER SCREEN HERE)
 5630 *--------------------------------
 5640		 LDA #$00
 5650		 STA BDEAD
 5660		 JSR GAME.OVER
 5670		 JMP COLD.START    BOTH ARE DEAD
 5680 *--------------------------------
 5690 * IF SHOOTING GUN THEN CALL
 5700 * EXPLOSION ROUTINE EXTRA
 5710 *--------------------------------
 5720 .99	 JSR DO.EXPLOSIONS
 5730		 LDA SHOTON
 5740		 BEQ .88
 5750		 JSR DO.EXPLOSIONS
 5760		 JSR GUN.SHOOT
 5770		 JSR GUN.SHOOT
 5780		 JSR DO.EXPLOSIONS
 5790		 JSR DO.EXPLOSIONS
 5800 *--------------------------------
 5810 .88	 LDX #$08
 5820 .89	 TXA
 5830		 PHA
 5840		 JSR WATER.FALL
 5850		 JSR READ.STICKS
 5860		 STA STICK.TMP
 5870		 PLA
 5880		 TAX
 5890		 DEX
 5900		 BPL .89
 5910 *--------------------------------
 5920 *  DONT NEED SPEED
 5930 *--------------------------------
 5940		 JSR CHOPPR
 5950		 JSR DO.EXPLOSIONS
 5960		 JSR GUN.SHOOT
 5970		 JSR DO.GUN.FALL
 5980		 JSR DO.GUN
 5990		 JSR GUN.CHECK
 6000		 JSR CHOPPR
 6010		 JSR SHOBOMBS
 6020		 JSR DIRT.CHECK
 6030		 JSR MOVE.CLOUD
 6040		 JSR BUCK.CHECK
 6050		 JSR BUCFALL.CK
 6060		 JSR DO.SOUNDS
 6070		 JSR DROP.DIRT
 6080		 JSR START.PLANE
 6090		 JSR CHECK.LAND
 6100		 JSR SUB.ONE
 6110		 JSR DO.EXPLOSIONS
 6120		 JSR DO.GUN.FALL
 6130 MAIN.END	 JMP MAIN.LOOP
