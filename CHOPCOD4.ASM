;--------------------------------
; INITIALIZE HARDWARE REGISTERS
;--------------------------------
INIT_HARDWARE	  LDA DDRA2
		  ORA #$03	  ;SELECT VIDEO BANK
		  STA DDRA2
		  JSR CREATE_WIDEFONT
		  RTS
;--------------------------------
; SETUP TEXT SCREEN
;--------------------------------
SETUP_TEXT LDA PORTA2
	 AND #$FC
	 ORA #$02	         ;SELECT BANK 1
	 STA PORTA2	         ;$4000-$8000
	 LDA VIC_CONTROL_1   ;TURN OFF HIRES
	 AND #223
	 STA VIC_CONTROL_1
	 LDA VIC_CONTROL_2
	 AND #239
	 STA VIC_CONTROL_2
	 LDA #$06	          ;SETUP POINTER TO CHARACTER SET
	 STA VIC_MEMORY       ;AND SCREEN MEMORY
	 RTS
;--------------------------------
; TITLE / DEMO TEXT DISPLAY
; Full known-good VIC text state (bank, mode, colors). Leaves sprites as-is:
; INIT_GAME already enabled them (the title shows the demo plane sprite), and
; clearing SPRITE_ENABLE here would leave them off for the whole game.
;--------------------------------
SETUP_TITLE_DISPLAY
	 JSR SETUP_TEXT
	 LDA #$1B		; DEN|RSEL|YSCROLL=3  (standard text frame)
	 STA VIC_CONTROL_1
	 LDA #$08		; 40 columns, MCM off
	 STA VIC_CONTROL_2
	 LDA #WHITE
	 STA BORDER_COLOR
	 LDA #BLUE
	 STA BACKGROUND_COLOR0
	 RTS
;--------------------------------
; SETUP MULTICOLOR SCREEN
;--------------------------------
SETUP_HIRES	  LDA PORTA2
		  AND #$FC
		  ORA #$02
		  STA PORTA2
		  LDA #$08
		  STA VIC_MEMORY
		  LDA VIC_CONTROL_1
		  ORA #32
		  STA VIC_CONTROL_1
		  LDA VIC_CONTROL_2
		  ORA #16
		  STA VIC_CONTROL_2
		  RTS
;--------------------------------
; INIT IRQ1
;--------------------------------
INIT_IRQS LDA #<IRQ1	;INITIALIZE IRQ LOCATION
	STA IRQLO	;TO POINT TO FIRST CHARACTER
	LDA #>IRQ1
	STA IRQHI
	LDA #<NMI
	STA NMI_VECTOR
	LDA #>NMI
	STA NMI_VECTOR+1
;--------------------------------
	LDA #$00
	STA RASTER
_1	LDA VIC_CONTROL_1
	BPL _1			;SYNC VBLANK!
	LDA #$01
	STA IRQ_ENABLE
	RTS
;--------------------------------
; INITIALIZE.GAME
;--------------------------------
INIT_GAME LDA #$07
	STA VIC_CONTROL_1
	LDA #$07
	STA VIC_CONTROL_2
	LDA #$00
	STA INCUD
	STA INCLR
;-------------------------------
; INITIALIZE SPRITES
;--------------------------------
	LDA #$12
	STA SPRITE_POINTER   ;POINT TO CHOPPER
	LDA #$16
	STA SPRITE_POINTER+1 ;POINT TO PLANE
	LDA #$17
	STA SPRITE_POINTER+2 ;POINT TO SMART BOMB
	LDA #$24
	STA SPRITE_POINTER+3 ;POINT TO CLOUD
	LDA #$1C
	STA SPRITE_POINTER+4 ;POINT TO SUN
	LDA #$23
	STA SPRITE_POINTER+5 ;POINT TO BUCK1
	LDA #$2D
	STA SPRITE_POINTER+6 ;POINT TO GUN BULLET
;--------------------------------
	LDA #LT_GREEN
	STA SPRITE_COLOR
	LDA #BLACK
	STA SPRITE_MCOLOR_0
	LDA #WHITE
	STA SPRITE_MCOLOR_1
	STA SPRITE_COLOR+2
	STA SPRITE_COLOR+3
	LDA #YELLOW
	STA SPRITE_COLOR+4
	STA SPRITE_COLOR+5
	LDA #$10
	STA SPRITE_PRIORITY
	LDA #$00
	STA SPRITE_XXPAND
	LDA #$67	       ;CHOP,PLANE,DUMP,BUCS
	STA SPRITE_MULTI_COLOR
	LDA #$FF
	STA SPRITE_ENABLE
	LDX #$00
	TXA		           ;ZERO OUT SPRITE
ZERO_LOOP:  STA CHOP_X,X   ;SHADOW REGISTERS
	INX
	CPX #$1A
	BNE ZERO_LOOP
	STA TRANSIT
	STA HIT0
	STA SPRITE_XMSB
	LDY #$03
_2	STA BOMB,Y
	STA OLD_BOMB,Y
	STA EXPGO,Y
	STA TABLE_LO,Y
	STA TABLE_LO+1,Y
	DEY
	BNE _2
	RTS
;--------------------------------
;  INIT I.O SYSTEM
;--------------------------------
INIT_IO	 LDA #$7F	  ;INITIALIZE CIA'S ETC.
	 STA CIA_1_IRQ
	 STA CIA_2_IRQ
	 STA PORTA1
	 LDA #$08
	 STA CIA1_CTRL_A
	 STA CIA2_CTRL_A
	 STA CIA1_CTRL_B
	 STA CIA2_CTRL_B
	 LDX #$00
	 STX DDRB1
	 STX DDRB2
	 STX $D418
	 DEX
	 STX DDRA1
	 LDA #$07
	 STA PORTA2
	 LDA #$3F
	 STA DDRA2
	 LDA #$E7
	 STA $01
	 LDA #$2F
	 STA $00
	 RTS
;--------------------------------
;  READ JOYSTICK DATA IN ACC
;--------------------------------
READ_STICKS LDA STICK_NUMBER
		  BNE _1
;--------------------------------
		  LDA PORTB1
		  AND #$1F
		  RTS
;--------------------------------
_1	  LDA PLAYER
		  BNE _2
;--------------------------------
		 LDA PORTB1
		 AND #$1F
		 RTS
;--------------------------------
_2	 LDA PORTA1
		 AND #$1F
		 RTS
;--------------------------------
; CREATE WIDEFONT
;--------------------------------
CREATE_WIDEFONT	          BUILD CHARACTER_MEMORY,TEMP1	;POINTER TO YOUR CSET
			  BUILD $D000,TEMP3	     	;POINT TO CSET (charset 1 = UPPERCASE) TO WIDEFONT FROM!
			  LDA $01		        ;BANK IN CHARACTER ROM!
			  AND #251
			  STA $01
STRETCH		  	  LDY #$07		;NUMBER OF CHARACTER LINES!
_3			  LDA (TEMP3),Y 	;GET BYTE TO WIDEN
			  PHA
			  LDX #$04		;TIMES TO SHIFT
_1		  	  ROL
			  PHP
			  ROL TEMP5
			  PLP
			  ROL TEMP5
			  DEX
			  BNE _1
			  LDA TEMP5		;SAVE WIDENED CHARACTER
			  STA (TEMP1),Y
			  PLA
			  LDX #$04
_2		  	  ROR
			  PHP
			  ROR TEMP5
			  PLP
			  ROR TEMP5
			  DEX
			  BNE _2
			  TYA
			  PHA
			  CLC
			  ADC #$08
			  TAY
			  LDA TEMP5
			  STA (TEMP1),Y   ;SAVE RIGHT HALF OF WIDE CHAR
			  PLA
			  TAY
			  DEY
			  BPL _3
;--------------------------------
INC_ADRESS	  	  LDA TEMP1
			  CLC
			  ADC #$10
			  STA TEMP1
			  BCC _1
			  INC TEMP2
_1		  	  LDA TEMP3
			  CLC
			  ADC #$08
			  STA TEMP3
			  BCC _2
			  INC TEMP4
_2		  	  LDA TEMP3
			  CMP #<$D400
			  BNE STRETCH
			  LDA TEMP4
			  CMP #>$D400
			  BNE STRETCH
			  LDA $01		       ;BANK I/O BACK IN
			  ORA #$04
			  STA $01
			  RTS
;--------------------------------
; CLEAR TEXT SCREEN
;--------------------------------
CLEAR_SCREEN	  	  LDX #$00	  ;CLEAR SCREEN RAM
_1		  	  LDA #$61
			  STA SCREEN_MEMORY,X
			  STA SCREEN_MEMORY+$100,X
			  STA SCREEN_MEMORY+$200,X
			  STA SCREEN_MEMORY+$2F7,X
			  LDA #$09
			  STA COLOR_MEMORY,X  ;ALSO COLOR MEM..
			  STA COLOR_MEMORY+$100,X
			  STA COLOR_MEMORY+$200,X
			  STA COLOR_MEMORY+$2F7,X
			  INX
			  BNE _1
			  RTS
;--------------------------------
CLEAR_TEXT LDX #$00
_1	   LDA #$40
	   STA SCREEN_MEMORY,X
	   STA SCREEN_MEMORY+$100,X
	   STA SCREEN_MEMORY+$200,X
	   STA SCREEN_MEMORY+$2F7,X
	   LDA #$00
	   STA COLOR_MEMORY,X
	   STA COLOR_MEMORY+$100,X
	   STA COLOR_MEMORY+$200,X
	   STA COLOR_MEMORY+$2F7,X
	   INX
	   BNE _1
	   RTS
;--------------------------------
INIT_CM	 LDA #$00
STA TEMP3  ; COLOR FLAG
;--------------------------------
	 LDA BILEVL
	 AND #$07
	 ASL
		 TAX
;--------------------------------
	 LDA COLOR2_MEM_LO,X   ;TOP LIMITS
	 STA TEMP5	           ;FOR THIS LEVEL
	 LDA COLOR2_MEM_LO+1,X
	 STA TEMP6
;--------------------------------
	 LDA #$DB	       ;BOTTOM
	 STA LO+1	       ;OF DIRT
	 LDA #$6F
		 STA LO
;--------------------------------
	 LDY #$00
;--------------------------------
_3	 LDA #$00
	 STA TEMP1  ;# OF BYTES PER LEVEL
	 STA TEMP2
;--------------------------------
	 LDA TEMP3
	 AND #$03
	 TAX
;--------------------------------
	 LDA LCOLRS,X
	 STA TEMP4
;--------------------------------
	 INC TEMP3    ;INDEX TO NEXT COLOR
;--------------------------------
_2	 LDA TEMP4
	 STA (LO),Y
;--------------------------------
	 LDA LO
	 BNE _11      ;SEE PG_82
	 DEC LO+1     ;OF SUB BOOK
_11	 DEC LO
;--------------------------------
_1	 LDA LO+1
	 CMP TEMP6
	 BNE _4
	 LDA LO
	 CMP TEMP5
	 BEQ _5
;--------------------------------
_4	 INC TEMP1
	 LDA TEMP1
	 CMP #$78
	 BNE _2
;--------------------------------
	 JMP _3
_5	 PRINT_MACRO 0,22,BLACK,"                    "
	 RTS
;--------------------------------
;  CLEAR HI-RES SCREEN
;--------------------------------
CLEAR_HIRES	  LDA #$00
		  STA TEMP1
		  LDA #>HIRES
		  STA TEMP2
		  LDX #32
_1		  LDY #$00
_2		  STA (TEMP1),Y
			  INY
			  BNE _2
			  INC TEMP2
			  DEX
			  BNE _1
			  JSR CLEAR_SCREEN
			  RTS
;--------------------------------
; PRINT ROUTINE
; ENTER WITH X=XCOOR Y=YCOOR
; PRINT_COLOR=COLOR
;--------------------------------
PRINT		  STX PRINTX
			  PLA
			  CLC
			  ADC #$01
			  STA TEMP1
			  PLA
			  ADC #$00
			  STA TEMP2
			  STY MULT1
			  LDA #$28
			  STA MULT2
			  JSR MULTIPLY	    ;MULTIPLY Y*40 COLUMN!
			  LDA PRINTX
			  CLC
			  ADC MULT1
			  STA MULT1
			  LDA #>SCREEN_MEMORY
			  ADC MULT2
			  STA MULT2
;--------------------------------
			  LDY #$00
_PRINT1		  LDA (TEMP1),Y
			  INC TEMP1
			  BNE _PRINT2
			  INC TEMP2
_PRINT2		  CMP #$FF
			  BNE _PRINT3
			  LDA TEMP1
			  SEC
			  SBC #$01
			  TAX
			  LDA TEMP2
			  SBC #$00
			  PHA
			  TXA
			  PHA
			  RTS
_PRINT3		  ASL
			  STA (MULT1),Y
			  CLC
			  ADC #$01
			  INY
			  STA (MULT1),Y
			  LDA MULT1
			  STA TEMP3
			  LDA MULT2
			  CLC
			  ADC #>(COLOR_MEMORY-SCREEN_MEMORY)
			  STA TEMP4
			  LDA PRINT_COLOR
			  STA (TEMP3),Y
			  DEY
			  STA (TEMP3),Y
			  LDA MULT1
			  CLC
			  ADC #$02
			  STA MULT1
			  BCC _PRINT1
			  INC MULT2
			  JMP _PRINT1
;--------------------------------
; MULTIPLICATION ROUTINE
; ENTER WITH MULT1 & MULT2
; RETURNS 16 BIT RESULT IN MULT 1 & 2
; DESTROYS A,X
;--------------------------------
MULTIPLY		  LDA #$00
			  LDX #$08
_MULT_LOOP	          LSR MULT1
			  BCC _MULT_SKIP
			  CLC
			  ADC MULT2
_MULT_SKIP	          ROR
			  ROR MULTIPLIER
			  DEX
			  BNE _MULT_LOOP
			  STA MULT2
			  LDA MULTIPLIER
			  STA MULT1
			  RTS
;--------------------------------
; DIVISION ROUTINE
; DIVIDES UNSIGNED BINARY DIVIDEND
; IN (DIVIDEND) BY UNSIGNED DIVISOR
; IN (DIVISOR). QUOTIENT IS RETURNED
; IN (DIVIDEND), AND REMAINDER IN
; (REMAINDER)
; DESTROYS A,X,Y
;--------------------------------
DIVIDE		  LDA #$00
		  STA REMAINDER 	   ;CLEAR REMAINDER
		  STA REMAINDER+1
;--------------------------------
		  LDX #16		   ;DIVIDEND BIT COUNT =16
NXTBIT		  ASL DIVIDEND		   ;SHIFT DIVIDEND/QUOTIENT LEFT
		  ROL DIVIDEND+1
		  ROL REMAINDER
		  ROL REMAINDER+1	   ;SHIFT PARTIAL DIVIDEND LEFT
		  LDA REMAINDER
		  SEC
		  SBC DIVISOR		   ;SUBTRACT LOW BYTES
		  TAY			   ;SAVE RESULT IN Y
		  LDA REMAINDER+1
		  SBC DIVISOR+1 	   ;SUBTRACT THE HIGH BYTES
		  BCC CNTDN		   ;DIVISOR > DIVIDEND?
		  INC DIVIDEND		   ;NO. SET BIT IN QUOTIENT
		  STA REMAINDER+1	   ;ENTER SUBTRACTION RESULT
		  TYA			   ;INTO PARTIAL DIVIDEND
		  STA REMAINDER
CNTDN		  DEX			   ;LOOP FOR 16 BITS!
		  BNE NXTBIT
		  RTS
;--------------------------------
; SCAN KEYBOARD! IGNORE JOYSTICK
; ENTER A=MASK BIT AND Y=STROBE SETUP
;--------------------------------
KEY_SCAN	  STA KEYTEMP
		  LDA #$FF
		  STA DDRA1
		  LDX #$00
		  STX DDRB1
		  STA PORTA1
		  LDA PORTB1
		  AND #$1F
		  CMP #$1F
		  BNE _1
		  LDA #$FF
		  STY PORTA1
		  LDX PORTB1
		  STA PORTA1
		  LDA PORTB1
		  AND KEYTEMP
		  BEQ _1
		  TXA
		  AND KEYTEMP
		  BNE _1
		  SEC
		  BCS _2
_1		  CLC
_2		  LDA #$00
		  STA DDRA1
_3		  RTS
;--------------------------------
;  TURN SCREEN OFF
;--------------------------------
TURN_SCREEN_OFF LDA VIC_CONTROL_1
		AND #$EF
		STA VIC_CONTROL_1
		RTS
;--------------------------------
;  INIT SOUND
;--------------------------------
INIT_SOUND       LDA #$00
		 STA FREQ_1   ;LOW BYTE
		 LDA #$05
		 STA FREQ_1+1 ;HI BYTE ($500)
		 LDA #$00
		 STA FREQ_1+2
		 STA FREQ_1+3 ;PULSE WIDTH=0
		 LDA #$11
		 STA ATTDEC_1
		 LDA #$24
		 STA SUSREL_1
;--------------------------------
		 LDA #$00
		 STA $D415    ;FILTER CUTOFF
		 LDA #$00
		 STA $D416    ;FREQ=0
		 LDA #$00
		 STA $D417    ;NO FILTER
;--------------------------------
		 LDA #$05
		 STA FREQ_2
		 STA FREQ_2+1
		 LDA #$00
		 STA FREQ_2+2
		 STA FREQ_2+3
		 LDA #$12
		 STA ATTDEC_2
		 LDA #$94
		 STA SUSREL_2
;--------------------------------
; 	 LDA #$05
; 	 STA FREQ_3
; 	 STA FREQ_3+1
; 	 LDA #$00
; 	 STA FREQ_3+2
; 	 STA FREQ_3+3
; 	 LDA #$00
; 	 STA CONTROL_3
; 	 LDA #$FA
; 	 STA ATTDEC_3
; 	 LDA #$A5
; 	 STA SUSREL_3
;--------------------------------
	 LDA #$0A
	 STA MASTER_VOLUME
;--------------------------------
	 RTS
