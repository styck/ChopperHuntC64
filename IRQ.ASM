;--------------------------------
;  SAVE IRQ.CODE
;--------------------------------
IRQ1:		LDA #BLACK
		STA BACKGROUND_COLOR0
		JSR SETUP_HIRES
		INC SEED
		LDA SPRITE_SCOLIDE
		STA SPRITE_COLLISION	;READ BELOW GROUND COLLISIONS
		LDA SPRITE_BCOLIDE
		STA BUCHIT
		ORA CHOP_BACK_COLL
		STA CHOP_BACK_COLL
		LDA #$00
		STA CHOP_DIR
		LDA #$02
		STA BOMB_SPEED
		JSR CHECK_ROT
		JSR DO_BOMBS
;--------------------------------
; RESTORE MULTI USED SPRITES
;--------------------------------
SP_UPDATE:	LDA #$24
		STA SPRITE_POINTER+3
		LDY SUNPH
		LDA SUN_TABLE,Y
		STA SPRITE_POINTER+4
		LDA #WHITE
		STA SPRITE_COLOR+3
		LDA #YELLOW
		STA SPRITE_COLOR+4
		LDA #$18
		STA SPRITE_PRIORITY
;--------------------------------
UPDATE_YPOS:	LDX #$00
update_ypos_loop:
		TXA
		ASL
		TAY
		LDA CHOP_Y,X
		STA SPRITE_YPOS,Y
		INX
		CPX #$06
		BNE update_ypos_loop
;--------------------------------
UPDATE_XPOS:	LDY #$00
update_xpos_loop:
		TYA
		ASL
		TAX
		LDA CHOP_X,X
		STA SPRITE_XPOS,X
		LDA CHOP_XMSB,X
		BEQ set_xmsb
		LDA SPRITE_XMSB
		ORA SPRITE_MASK,Y
		STA SPRITE_XMSB
		JMP continue_xpos_update
;--------------------------------
set_xmsb:	LDA SPRITE_MASK,Y
		EOR #$FF
		AND SPRITE_XMSB
		STA SPRITE_XMSB
continue_xpos_update:
		INY
		CPY #$06
		BNE update_xpos_loop
;--------------------------------
DO_TIME:	LDX #$09		;RESET ALL TIMERS
timer_loop:
		LDA TIMER1,X
		BEQ timer_no_dec
		DEC TIMER1,X
timer_no_dec:
		DEX
		BPL timer_loop
;--------------------------------
CHECK_COLL:	LDA CHOP_Y
		SEC
		SBC #$29
		STA IRQ_PLOTY
		STA CHOP_YSC
;--------------------------------
		LDA CHOP_X
		SEC
		SBC #$13
		STA IRQ_TEMP1
		LDA CHOP_XMSB
		SBC #$00
		LSR
		ROR IRQ_TEMP1
		LDA IRQ_TEMP1
		STA IRQ_PLOTX
		STA CHOP_XSC
;--------------------------------
		JSR IRQ_PLOTCL
		LDA IRQ_PLOTX
		AND #$03
		TAX
;--------------------------------
; CHECK IF HITTING PAD
;--------------------------------
		LDA CHOP_XMSB
		BNE START_COLL
		LDA IRQ_PLOTY
		SEC
		SBC #$08
		CMP INILVL
		BCS START_COLL
		LDA IRQ_PLOTY
		CMP MOUNTAIN_TOP
		BCC START_COLL
;--------------------------------
		LDA CHOP_Y
		CMP INICHT
		BEQ START_COLL
		BCC START_COLL
		LDA CHOP_X
		CMP #$35
		BCS START_COLL
;--------------------------------
		LDA #$01		;HIT PAD
		STA HIT0
;--------------------------------
START_COLL:	LDA IRQ_PLOTY
		CMP INILVL		;ABOVE GROUND?
		BCC above_ground_collision	;YES
;--------------------------------
; UNDER GROUND CHECKS
; DO SOFTWARE COLLISION
;--------------------------------
		LDY #$00
		LDA BOMB_MASK,X
		EOR #$FF
		AND (IRQ_LO),Y
		CMP WATER_COLOR,X
		BNE check_dirt_collision
;--------------------------------
		LDA #$01
		STA HIT0		;WE HIT WATER
;--------------------------------
check_dirt_collision:
		CMP DIRT_COLOR,X
		BNE underground_hw_collision
;--------------------------------
		LDA #$01
		STA HIT0
;--------------------------------
; UNDERGROUND HARDWARE COLLISION
;--------------------------------
underground_hw_collision:
		LDA CHOP_BACK_COLL
		AND #$01
		BEQ NO_COLL
;--------------------------------
		LDA INILVL
		CLC
		ADC #$09
		CMP IRQ_PLOTY
		BCC hit_ground
;--------------------------------
			JMP NO_COLL
;--------------------------------
; CHECK ABOVE GROUND
; HARDWARE COLLISION
;--------------------------------
above_ground_collision:
		LDA CHOP_BACK_COLL	;CHOPPER TO BACKGROUND
		AND #$01		;COPY COLLISION
		BEQ NO_COLL
;-------------------------------
		LDA CHOP_XMSB		;MAKE SURE CHOP
		BNE smartbomb_collision 	;IS ON LEFT SIDE
		LDA CHOP_Y
		CMP INICHT
		BNE smartbomb_collision
		LDA CHOP_X
		CMP #$38		;IF CHOP_X<$3D THEN
		BCC on_landing_pad	;WE ARE OVER PAD
;--------------------------------
; SOFTWARE COLLISION FOR SMARTBOMB
;--------------------------------
smartbomb_collision:
		LDA IRQ_PLOTY
		STA IRQ_TEMP1
		LDA CHOP_Y
		SEC
		SBC #$2F
		STA IRQ_PLOTY
		JSR IRQ_PLOTCL
;--------------------------------
		LDY #$00
		LDA BOMB_MASK,X
		EOR #$FF
		AND (IRQ_LO),Y
		CMP BOMB_SHAPE,X
		BNE check_mountain_collision
;--------------------------------
		LDA INICHT
		SEC
		SBC #$02
		CMP CHOP_Y
		BEQ check_mountain_collision
		LDA CHOP_X
		CMP #$38
		BCS hit_ground
;--------------------------------
check_mountain_collision:
		LDA IRQ_TEMP1
		STA IRQ_PLOTY
		LDA MOUNTAIN_TOP
		CMP IRQ_PLOTY		;IRQ_PLOTY<=TOP
		BCC NO_COLL		;NO
;--------------------------------
hit_ground:
		LDA #$01		;WE MUST OF HIT
		STA HIT0		;GROUND
		BNE NO_COLL
;-------------------------------
on_landing_pad:
		LDA #$01		;TELL EVERYONE WE ARE
		STA LANDFG		;ON LANDING PAD
		BNE DO_SUN
;--------------------------------
NO_COLL:	LDA #$00		;WE ARE NOT
		STA LANDFG		;ON LANDING PAD
;--------------------------------
; CHECK FOR PAUSE
;--------------------------------
DO_SUN:		LDA PAUSE
		BEQ sun_no_pause
		JMP MOD3
;--------------------------------
sun_no_pause:
		LDA SUN_TIM
		BNE sun_dec_tim
		LDA #$06
		STA SUN_TIM
		LDY SUNPH
		LDA SUN_TABLE,Y
		STA SPRITE_POINTER+4
		INC SUNPH
		LDA SUNPH
		CMP #$06
		BNE sun_dec_tim
		LDA #$00
		STA SUNPH
;--------------------------------
sun_dec_tim:
		DEC SUN_TIM
		LDA CHOP_TIM		;CHECK IF TIME TO DO
		BEQ do_chopper_update 	;CHOPPER
;--------------------------------
		JMP DO_DIRT
;--------------------------------
do_chopper_update:
		LDA CHOP_SPEED		;SET CHOPPER UPDATE
		STA CHOP_TIM		;SPEED
		LDX BODPH		;POINT TO THE
		LDA CHOP_SHAPE,X	;CHOPPER SHAPE THAT
		STA SPRITE_POINTER	;WE WANT
		LDA DEMO
		BEQ MOVE_CHOP
;--------------------------------
		JMP MOD3
;--------------------------------
; MOVE CHOPPER
;--------------------------------
MOVE_CHOP:	LDA INCUD
		BEQ READ_ST
		JMP DO_DIRT
;--------------------------------
READ_ST:	LDA STICK_TMP
		ROR
		BCS DO_DWN
DO_UP:		PHA
		LDA CHOP_Y
		CMP #$3F
		BEQ up_no_dec
		DEC CHOP_Y
up_no_dec:
		PLA
;--------------------------------
DO_DWN:		ROR
		BCS DO_LFT
		PHA
		LDA LANDFG		;CHECK IF ON LANDING
		BNE down_no_inc		;PAD
		LDA CHOP_Y
		INC CHOP_Y
down_no_inc:
		PLA
;--------------------------------
DO_LFT:		ROR
		BCS DO_RT
		PHA
		LDA #$02
		STA CHOP_DIR
		PLA
;--------------------------------
DO_RT:		ROR
		BCS DO_CHOP
		LDA #$01
		STA CHOP_DIR
;--------------------------------
DO_CHOP:	LDA CHOP_DIR
		CMP #$01
		BEQ RIGHT
		CMP #$02
		BEQ LEFT
;--------------------------------
		JMP DO_DIRT
;--------------------------------
LEFT:		LDA BODPH
		BEQ left_can_move
;--------------------------------
		JMP DO_DIRT
;--------------------------------
left_can_move:
		LDA CHOP_XMSB
		BNE left_move
		LDA CHOP_X
		CMP #$1E
		BEQ DO_DIRT
left_move:
		LDA CHOP_X
		SEC
		SBC #$01
		STA CHOP_X
		BCS DO_DIRT
		LDA #$00
		STA CHOP_XMSB
		BEQ DO_DIRT
;--------------------------------
RIGHT:		LDA BODPH
		CMP #$04
		BEQ right_can_move
;--------------------------------
		JMP DO_DIRT
;--------------------------------
right_can_move:
		LDA CHOP_XMSB
		BEQ right_move
		LDA CHOP_X
		CMP #$2E
		BEQ DO_DIRT
;--------------------------------
right_move:
		LDA CHOP_X
		CLC
		ADC #$01
		STA CHOP_X
		BCC DO_DIRT
		LDA #$01
		STA CHOP_XMSB
;--------------------------------
;  START THE DIRT DROPPING
;--------------------------------
DO_DIRT:	DEC CHOP_TIM
		LDX PLNDIR
		LDY DROPWT		;WAITING FOR DROP?
		BEQ START_GUN		;NO
;--------------------------------
		LDA PLANE_X
		SEC
		SBC #$10
		STA IRQ_TEMP1
		LDA PLANE_XMSB
		SBC #$00
		LSR
		ROR IRQ_TEMP1
		LDA IRQ_TEMP1
		CMP DRPCOL		;SAME AS DROP COLUMN?
		BNE START_GUN		;NO
		INC DROPGO		;DROP DIRT
;--------------------------------
START_GUN:	LDA GUNFAL		;DROP GUN?
		BEQ MOD3		;NO
		LDA PLANE_X
		CMP GUN_X
		BNE MOD3
		INC GUNFGO		;START GUN FALLING
		LDA #50
		STA GUN_Y		;SHOW GUN ON SCREEN
;--------------------------------
MOD3:		LDA #$B0
		LDX <IRQ1_2
		LDY >IRQ1_2
		STA RASTER
		STX IRQLO
		STY IRQHI
		LDA #$81
		STA VIC_IRQ
		PLA
		TAY
		PLA
		TAX
		PLA
		RTI
;--------------------------------
; RESTORE BACKGROUND COLOR
; AT BASE OF MOUNTAINS
;
; 	IRQ1_2
;--------------------------------
IRQ1_2:		LDA #BLACK
one:		LDX RASTER
MOD4:		CPX #$B6
		BCC one			;WAS BNE!
		STA BACKGROUND_COLOR0
;--------------------------------
demo_check:
		LDA DEMO		;IN DEMO
		BEQ not_in_demo		;NO
;--------------------------------
		JMP DO_BLADES
;--------------------------------
not_in_demo:
		LDA SPRITE_BCOLIDE
		STA CHOP_BACK_COLL
		LDA SPRITE_SCOLIDE	;CLEAR COLLISION REGISTER
;--------------------------------
		LDA PRIZE_1		;POINT TO THE BUCKS
		STA SPRITE_POINTER+3
		LDA PRIZE_2
		STA SPRITE_POINTER+4
		LDA PRIZE_3
		STA SPRITE_POINTER+5
;--------------------------------
		LDA #$07
		STA SPRITE_MULTI_COLOR
		LDA #$00
		STA SPRITE_PRIORITY
;--------------------------------
		LDA PRIZE_1C
		STA SPRITE_COLOR+3
		LDA PRIZE_2C
		STA SPRITE_COLOR+4
		LDA PRIZE_3C
		STA SPRITE_COLOR+5
;--------------------------------
; POSITION BUCKS DURING INTERUPT
;--------------------------------
		LDY #$00
position_bucks_loop:
		TYA
		ASL
		TAX
		LDA BUC1_X,X
		STA SPRITE_XPOS+6,X
		LDA BUC1_XMSB,X
		BEQ set_bucks_xmsb
		LDA SPRITE_XMSB
		ORA SPRITE_MASK+3,Y
		STA SPRITE_XMSB
		JMP continue_bucks_position
set_bucks_xmsb:
		LDA SPRITE_MASK+3,Y
		EOR #$FF
		AND SPRITE_XMSB
		STA SPRITE_XMSB
continue_bucks_position:
		INY
		CPY #$04
		BNE position_bucks_loop
;--------------------------------
		LDA BUC1_Y
		STA SPRITE_YPOS+6
		LDA BUC2_Y
		STA SPRITE_YPOS+8
		LDA BUC3_Y
		STA SPRITE_YPOS+10
;--------------------------------
;  CHECK FOR PAUSE
;--------------------------------
		LDA PAUSE
		BEQ DO_BLADES
		JMP MOD
;--------------------------------
;  BLADE CODE
;--------------------------------
DO_BLADES:	LDA BLADE_TIM
		BNE SKIP_BLADE
		LDA #$01
		STA BLADE_TIM
;--------------------------------
		LDA #$81		;VOICE 1 ON
		STA $D404
;--------------------------------
		LDY BLDPH
		LDA BLADE_TABLE,Y
		TAX
		LDY #$05
blade_shape_loop:
		LDA BLADE_SHAPE,X
		STA SPRITE_MEMORY+09,Y
		STA SPRITE_MEMORY+$40+09,Y
		STA SPRITE_MEMORY+$80+09,Y
		STA SPRITE_MEMORY+$C0+09,Y
		STA SPRITE_MEMORY+$100+09,Y
		DEX
		DEY
		BPL blade_shape_loop
		INC BLDPH
		LDA BLDPH
		CMP #$0A
		BNE SKIP_BLADE
;--------------------------------
		LDA $D404		;VOICE 1 OFF
		AND #$FE
		STA $D404
;--------------------------------
		LDA #$00
		STA BLDPH
;--------------------------------
SKIP_BLADE:	DEC BLADE_TIM
;--------------------------------
DO_PLANE:	LDA TRANSIT
		BEQ MOD
;--------------------------------
		LDA #$01
		STA PLANE_TIM
;--------------------------------
PLANE_LUP:	LDA PLNDIR
		BNE plane_right
;--------------------------------
		LDA PLANE_XMSB
		BNE plane_left_move
		LDA PLANE_X
		CMP #$02
		BEQ plane_stop
plane_left_move:
		LDA PLANE_X
		SEC
		SBC #$01
		STA PLANE_X
		BCS PLANE_EXIT
		LDA #$00
		STA PLANE_XMSB
		BEQ PLANE_EXIT		;ALWAYS
;--------------------------------
plane_right:
		LDA PLANE_XMSB
		BEQ plane_right_move
		LDA PLANE_X
		CMP #$50
		BEQ plane_stop
;--------------------------------
plane_right_move:
		LDA PLANE_X
		CLC
		ADC #$01
		STA PLANE_X
		BCC PLANE_EXIT
		LDA #$01
		STA PLANE_XMSB
		BNE PLANE_EXIT		;ALWAYS
;--------------------------------
plane_stop:
		LDA #$00
		STA TRANSIT
		STA PLANE_SOUND		;NO PLANE SOUND
;--------------------------------
PLANE_EXIT:	DEC PLANE_TIM
		BNE PLANE_LUP
;--------------------------------
MOD:		LDA #$D0
MOD1:		LDX <IRQ3
MOD2:		LDY >IRQ3
		STA RASTER
		STX IRQLO
		STY IRQHI
		LDA #$81
		STA VIC_IRQ
		PLA
		TAY
		PLA
		TAX
		PLA
		RTI
;--------------------------------
;  IRQ 2	 RESTORE BACKGROUND COLOR
;--------------------------------
IRQ2:		LDY #$06
		LDA VIC_CONTROL_2	;TURN OFF HIRES
		AND #239
		STA IRQ_TEMP2
		LDA #223
		AND VIC_CONTROL_1	;*****
		STA IRQ_TEMP1
		LDA #ORANGE
irq2_raster_wait:
		LDX RASTER
		CPX #$E7
		BCC irq2_raster_wait    ;WAS BNE!
;--------------------------------
		STA BACKGROUND_COLOR0
		STY VIC_MEMORY 		;SET UP TEXT MODE
		LDA IRQ_TEMP1		;TURN OFF HIRES
		STA VIC_CONTROL_1
		LDA IRQ_TEMP2
		STA VIC_CONTROL_2
;--------------------------------
IRQ2_END:	LDA #$00
		LDX <IRQ1
		LDY >IRQ1
		STA RASTER
		STX IRQLO
		STY IRQHI
		LDA #$81
		STA VIC_IRQ
		PLA
		TAY
		PLA
		TAX
		PLA
		RTI
;--------------------------------
;  IRQ3
;--------------------------------
IRQ3:		LDA #223
		AND VIC_CONTROL_1
		STA IRQ_TEMP1
		LDA #239
		AND VIC_CONTROL_2
		STA IRQ_TEMP2
		LDA #BROWN
		LDY #$06
irq3_raster_wait:
		LDX RASTER
		CPX #$CF
		BCC irq3_raster_wait	;WAS BNE
		STA BACKGROUND_COLOR0
		STY VIC_MEMORY
		LDA IRQ_TEMP1
		STA VIC_CONTROL_1
		LDA IRQ_TEMP2
		STA VIC_CONTROL_2
		LDA #$00
		LDX <IRQ1
		LDY >IRQ1
		STA RASTER
		STX IRQLO
		STY IRQHI
		LDA #$81
		STA VIC_IRQ
		PLA
		TAY
		PLA
		TAX
		PLA
		RTI
;--------------------------------
;  MODIFY CODE IN IRQ1
;--------------------------------
INIT_IRQ:	SEI
		LDA DEMO
		TAY
		LDA INT_RASTER2,Y
		STA MOD+1
		TYA
		ASL
		TAY
		LDA INT_ADDRESS,Y
		STA MOD1+1
		LDA INT_ADDRESS+1,Y
		STA MOD2+1
		LDA #$B0
		STA MOD3+1
		LDA #$B6
		STA MOD4+1
;--------------------------------
		CLI
		RTS
;--------------------------------
CHANGE_IRQ:	SEI
		LDA DEMO
		BNE INT_END
;--------------------------------
		LDA BILEVL
		AND #$03
		TAY
		LDA INT_RASTER,Y
		STA MOD3+1
		LDA INT_CPX,Y
		STA MOD4+1
;--------------------------------
INT_END:	CLI
		RTS
;--------------------------------
;  DELAY ROUTINE
;--------------------------------
DELAY:		PHA
		TYA
		PHA
		TXA
		PHA
;--------------------------------
			LDY #$05
delay_outer_loop:
			LDX #$FF
delay_inner_loop:
			DEX
			BNE delay_inner_loop
			DEY
			BNE delay_outer_loop
;--------------------------------
			PLA
			TAX
			PLA
			TAY
			PLA
;--------------------------------
			RTS
