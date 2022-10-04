 1000 *--------------------------------
 1010 * SAVE GUN.CHANCE.CODE
 1020 *--------------------------------
 1030 GUN.CHANCE JSR MAKE.RANDOM
 1040		 AND #$03
 1050		 CLC
 1060		 ADC GUNCHN
 1070		 STA TRANCT
 1080		 RTS
