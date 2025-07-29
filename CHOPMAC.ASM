;*--------------------------------
;* SAVE CHOP.MACROS
;*--------------------------------
;* ADD AN 8BIT VALUE TO A
;* 16 BIT RESULT
;* FORMAT IS >ADD ]1,]2,]3
;* ]1=BYTE TO ADD ]2=LOW ANSER
;* ]3=HI BYTE OF ANSWER
;*--------------------------------
ADD .macro
		 LDA \2
		 CLC
		 ADC \1
		 STA \2
		 BCC .1
		 INC \3
.1
		 .endm
;*--------------------------------
;* ADD TWO 16 BIT VALUES
;* FORMAT: ]1=LOW BYTE ADDRESS OF VALUE
;* 	]2=LOW BYTE ADDRESS OF ADDRESS
;*--------------------------------
ADD16 .macro
		 CLC
		 LDA \1
		 ADC \2
		 STA \2
		 LDA \1+1
		 ADC \2+1
		 STA \2+1
		 .endm
;*--------------------------------
;* BUILD A POINTER IN ZERO PAGE
;*--------------------------------
;* FORMAT >BUILD ]1,]2
;* ]1=WHERE TO POINT TO IN MEMORY
;* ]2=ZERO PAGE ADDRESS OF POINTER
;*--------------------------------
BUILD .macro
		LDA #<\1         ; Load low byte of the address
		STA \2           ; Store in zero page
		LDA #>\1         ; Load high byte of the address
		STA \2+1         ; Store in zero page + 1
.endm
;*--------------------------------
;* INCREMENT A 16 BIT VALUE
;*--------------------------------
INC16 .macro
		 INC \1
		 BNE .1
		 INC \1+1
.1
		 .endm
;*--------------------------------
;* PRINT ROUTINE MACRO
;* ENTER WITH ]1=XCOOR, ]2=YCOOR
;* ]3=COLOR ]4=STRING TO PRINT!
;*--------------------------------
PRINT_MACRO .macro
		 LDX #\1
		 LDY #\2
		 LDA #\3
		 STA PRINT_COLOR
		 JSR PRINT
		 .text \4
		 .byte $ff
		 .endm
;*--------------------------------
;* PRINT MATRIX MACRO ROUTINE
;* ENTER WITH ]1=MATRIX NAME, ]2=MATRIX_XPOS,
;* ]3=MATRIX_YPOS, ]4=MATRIX_PRINT_COLOR
;* COLOR VALUE #$FF=NO COLOR CHANGE
;*--------------------------------
MATRIX .macro
			  BUILD \1,TEMP1
			  LDX #\2
			  LDY #\3
			  LDA #\4
			  STA PRINT_COLOR
			  JSR MATRIX_PRINT
			  .endm
;*--------------------------------
