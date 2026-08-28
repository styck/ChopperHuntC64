;--------------------------------
COLD_START JSR TURN_SCREEN_OFF
;--------------------------------
    SEI		;OFF ANY INTERRUPTS
;--------------------------------
    LDA #$00	; CLEAR PG 0
    LDX #$FA
clear_pg0_loop:
    STA $05,X
    DEX
    BPL clear_pg0_loop
;--------------------------------
; CLEAR VARIABLE AREA $0400-$07FF
; (default screen RAM until VIC is remapped)
;--------------------------------
    LDA #$00
    LDX #$00
clear_var_loop:
    STA $0400,X
    STA $0500,X
    STA $0600,X
    STA $0700,X
    INX
    BNE clear_var_loop
;--------------------------------
    LDA #$20
    LDX #$07
clear_score_loop:
    STA SCORE_ONE,X
    STA SCORE_TWO,X
    DEX
    BPL clear_score_loop
;--------------------------------
    LDA SEED
    STA RANDOM
    JSR INIT_IO	; SETUP I/O HARDWARE!
    LDA #$00
    TAX
clear_hw_loop:
    .byte $9D	;OPCODE FOR STA $ZZZZ,X
    .word TEMP1	;BYTES FOR ADDRESS OF STA
    STA $D000,X	;CLEAR 6566 VIDEO REGISTERS
    STA $D400,X	;CLEAR 6581 SID REGISTERS
    INX
    BNE clear_hw_loop
    LDX #$FF
    TXS		;RESET STACK POINTER
    LDA #$01
    STA DEMO
    JSR INIT_GAME
    JSR INIT_HARDWARE
    JSR INIT_IRQS
    JSR INIT_SOUND
    ; IRQs stay masked here; DEMOIN's INIT_IRQ starts the raster IRQ chain
;--------------------------------
DEMOIN	 SEI
    JSR INIT_GAME
    LDA #$02
    STA BODPH
;--------------------------------
    LDA #$00
    STA PAUSE
    STA BLADE_SOUND  ;START BLADE SOUND
    STA SUNPH
    STA BLDPH
    STA HIT0
    STA NEWLFG
    STA STICK_TMP
    STA BLADE_SPEED
    STA CHOP_XMSB
    STA PLANE_Y
    STA CLOUD_Y
;--------------------------------
    STA STICK_NUMBER
    STA PLAYRS	  ;!!
    STA BLADE_SPEED  ;!!
;--------------------------------
    LDA #$5A
    STA CHOP_Y
    LDA #$60
    STA CHOP_X
    LDA #$01
    STA CHOP_SPEED
;--------------------------------
    JSR INIT_IRQ	  ;SETUP DEMO SCREEN (re-enables the raster IRQ chain)
    JSR CLEAR_SCREEN	  ; init the bitmap colour matrix (sky/mountains)
;--------------------------------
    LDA #$FC	  ;FORCE LOWER
    STA BILEVL	  ;LEVEL (demo table index)
    JSR CRTINI	  ; build the hires demo level (mountains behind the title)
;--------------------------------
    LDA #$02
    STA BODPH
;--------------------------------
    PRINT_MACRO 0,19,BROWN,"                    "
    PRINT_MACRO 0,20,WHITE,"    CHOPPER HUNT    "
    PRINT_MACRO 0,21,YELLOW,"       IMAGIC       "
    PRINT_MACRO 0,22,GREEN,"   COPYRIGHT 1984   "
;--------------------------------
    LDA #$FF		; title hold — keep "CHOPPER HUNT / IMAGIC / COPYRIGHT" visible ~1.6s
    STA TEMP1
delay_loop:
    JSR DELAY
    DEC TEMP1
    LDA TEMP1
    BNE delay_loop
;--------------------------------
INTRO_SCR  PRINT_MACRO 0,19,BROWN,"                    "
    PRINT_MACRO 2,20,WHITE,"PRESS F7 TO START  "
    PRINT_MACRO 0,21,YELLOW,"                    "
;--------------------------------
    LDA #<ONE_STICK_MSG
    STA LO
    LDA #>ONE_STICK_MSG
    STA LO+1
    LDA #21
    STA YPOS
    JSR PRINT_MSG
;--------------------------------
    LDA #GREEN
    STA PRINT_COLOR
    LDA #<ONE_PLAYER_MSG
    STA LO
    LDA #>ONE_PLAYER_MSG
    STA LO+1
    LDA #22
    STA YPOS
    JSR PRINT_MSG
;--------------------------------
; MOVE SPRITES
;--------------------------------
MOVE_SPR	 LDA #$00
    STA PLANE_X
    STA PLANE_XMSB
    STA CLOUD_X
    STA CLOUD_XMSB
    LDA #$34
    STA PLANE_Y
    LDA #$5A
    STA CHOP_Y
    LDA #$60
    STA CHOP_X
    LDA #$02
    STA BODPH
;--------------------------------
    ; The title runs with the full raster-IRQ chain active (started by
    ; DEMOIN's JSR INIT_IRQ). IRQ1 re-pins the VIC bank and renders the
    ; mountains every frame, so the button loop only needs to animate the plane.
;--------------------------------
BUTTON_LUP JSR START_PLANE
;--------------------------------
; CHECK F3  (NUMBER OF PLAYERS)
;--------------------------------
    LDA #$20      ;CHECK F3
    LDY #$FE      ;(NUMBER OF PLAYERS)
    JSR KEY_SCAN
    BCC check_f7        ;NOT PUSHED
    JSR DELAY
debounce_f3:
    LDA #$20      ;DEBOUNCE F3
    LDY #$FE
    JSR KEY_SCAN
    BCS debounce_f3       ;IT STILL IS PUSHED
;--------------------------------
    LDA #GREEN
    STA PRINT_COLOR
    LDA #22
    STA YPOS
    LDA PLAYRS
    EOR #$01
    STA PLAYRS
    BEQ one_player_selected
    LDA #<TWO_PLAYER_MSG
    STA LO
    LDA #>TWO_PLAYER_MSG
    STA LO+1
    JSR PRINT_MSG
    JMP check_f7
one_player_selected:
    LDA #<ONE_PLAYER_MSG
    STA LO
    LDA #>ONE_PLAYER_MSG
    STA LO+1
    JSR PRINT_MSG
    LDA #21
    STA YPOS
    LDA #YELLOW
    STA PRINT_COLOR
    LDA #<ONE_STICK_MSG
    STA LO
    LDA #>ONE_STICK_MSG
    STA LO+1
    JSR PRINT_MSG
;--------------------------------
; CHECK F7  (START)
;--------------------------------
check_f7:
    LDA #$08      ;CHECK F7
    LDY #$FE      ;(START)
    JSR KEY_SCAN
    BCC check_fire_button        ;NOT PUSHED
    JMP MAININ
;--------------------------------
; CHECK FIRE BUTTON (require press after release so idle
; CIA reads cannot auto-start the game)
;--------------------------------
check_fire_button:
    LDA PORTA1
    AND PORTB1
    AND #$10
    BEQ fire_is_down
    LDA #$01		; fire released — arm start
    STA FIRE_ARMED
    BNE check_f1
fire_is_down:
    LDA FIRE_ARMED
    BEQ check_f1	; not armed yet
    LDA #$00
    STA FIRE_ARMED
    JMP MAININ
;--------------------------------
;  CHECK F1  (NUMBER OF STICKS)
;--------------------------------
check_f1:
    LDA #$10
    LDY #$FE
    JSR KEY_SCAN
    BCC button_loop_end
;--------------------------------
debounce_f1:
    LDA #$10
    LDY #$FE
    JSR KEY_SCAN
    BCS debounce_f1
;--------------------------------
    LDA #YELLOW
    STA PRINT_COLOR
    LDA #21
    STA YPOS
;--------------------------------
    LDA PLAYRS   ;IF ONE PLAYER ONLY ONE STICK
    BEQ one_stick_selected
    LDA STICK_NUMBER
    EOR #$01
    STA STICK_NUMBER
    BEQ one_stick_selected
    LDA #<TWO_STICK_MSG
    STA LO
    LDA #>TWO_STICK_MSG
    STA LO+1
    JSR PRINT_MSG
    JMP button_loop_end
one_stick_selected:
    LDA #<ONE_STICK_MSG
    STA LO
    LDA #>ONE_STICK_MSG
    STA LO+1
    JSR PRINT_MSG
button_loop_end:
    JMP BUTTON_LUP
;--------------------------------
; MAIN LOOP
;--------------------------------
MAININ	 JSR TURN_SCREEN_OFF
    LDA #$00
    STA PLANE_XMSB
    STA CHOP_XMSB
    LDA #$34
    STA PLANE_Y
    LDA #$4B
    STA CLOUD_Y
    LDA #$00
    LDX #$06
clear_chop_x_loop:
    STA CHOP_X,X
    DEX
    BNE clear_chop_x_loop
    STA SPRITE_XMSB
    STA TIMER7
    STA LEVEL
    STA LEVEL+1
    STA LIFE1
    STA LIFE1+1
    STA LIFE2
    STA LIFE2+1
;--------------------------------
;  RESET VARIABLES
;--------------------------------
    STA GUN_PHASE
    STA SHOT_SOUND
    STA EXPL_FREQ
    STA SHOTON
; 	 STA STICK_TMP
    STA PLNDIR
    STA CHOP_DIR
    STA DEAD
    STA BDEAD
    STA FERRY
    STA TRANSIT
; 	 STA SNDCNT
    STA DROPWT
    STA DROPGO
    STA ROCNT
    STA BOMB
    STA BOMB+1
    STA BOMB+2
    STA BOMB+3
    STA BOMACT
    STA BOMB_COUNT
    STA ERASE_FLAG
    STA EXPGO
    STA EXPGO+1
    STA EXPGO+2
    STA EXPGO+3
    STA EXPGO+4
    STA EXPCNT
;--------------------------------
DUMMY2	 STA GUNFAL
    STA GUNFGO
;--------------------------------
    STA ABORT
    STA ABORT_FLAG
    STA INIFLG
    STA BDIG1
    STA BDIG2
    STA BOMIND
    STA INCUD
    STA INCLR
; 	 STA SPLCNT
    STA NPWAIT
    STA CHANGP
    STA OLD_LO
    STA OLD_LO+1
    STA TABLE_LO
    STA TABLE_LO+1
    STA DEMO	;NO MORE DEMO
    STA HIT0
    STA HIT3
    STA BHIT1
    STA BHIT2
    STA BHIT3
    STA BUCHIT
    STA SPRITE_COLLISION
    STA CHOP_EXPL
    STA CLOUD_TIM
    STA CLOUD_DIR
    STA CLOUD_FG
; 	 STA SUNPH
; 	 STA BLDPH
    STA WATERX
    STA LAND_SOUND
    STA BUC_SOUND
    STA ROTATE_LEFT
    STA ROTATE_RIGHT
    STA CHANGP
    STA NAME_FLAG
;--------------------------------
    LDA #$FF
    STA BILEVL
    STA FERIX
;--------------------------------
    LDA #$55
    STA OLD_BOMB
    STA OLD_BOMB+1
    STA OLD_BOMB+2
    STA OLD_BOMB+3
;--------------------------------
    LDA SPRITE_BCOLIDE  ;CLEAR COLLISION REGISTER
;--------------------------------
    JSR INIT_IRQ
;--------------------------------
    LDA #75     ;START WITH 75
    STA BOMBLD  ;BOMBS
    LDA #$20
    LDX #18
clear_scolin_loop:
    STA SCOLIN,X
    DEX
    BPL clear_scolin_loop
    LDA #$00
    STA PLAYER	;FIRST PLAYER
    LDX PLAYRS
    LDA P1LINI,X	;SET # OF LIVES
    STA LIVES
    STA LIFE1	;RIGHT DIGIT OF PLAYER 1
;--------------------------------
    LDA P2LINI,X
    STA LIVES+1
    STA LIFE1+1	;RIGHT DIGIT OF PLAYER 2
;--------------------------------
    LDA #$00
    LDX #15
clear_scov0_loop:
    STA SCOV0,X
    DEX
    BPL clear_scov0_loop
    LDA #$07
    STA SCOMAX
    STA SCOMAX+1
    LDA #$02
    STA SCOV4     ;START WITH
    STA SCOV4+1   ;$2000
;--------------------------------
    LDA #$01
    STA DIE_FLAG
    STA DIE_FLAG+1
    STA SAMEPL
    JSR PLRCHG    ;INIT LEVEL AND SCREEN
    JSR TURN_SCREEN_ON   ;TEST !!!
    LDA #$00
    STA DRTHIT
    LDA #$02
    STA TIMER1
;--------------------------------
;  MAIN EXECUTION LOOP
;--------------------------------
MAIN_LOOP:
    LDA #$10      ;CHECK SPACE BAR
    LDY #$7F
    JSR KEY_SCAN
    BCC check_pause
;--------------------------------
    LDA PAUSE
    AND #$01
    EOR #$01
    STA PAUSE
;--------------------------------
    LDA BILEVL
    CMP #$00	;ON THE FIRST LEVEL?
    BNE debounce_spacebar	;NO
    LDA CHOP_Y
    SEC
    SBC #$2E
    CMP INILVL	;BELOW GROUND
    BCC debounce_spacebar	;NO
    LDA BODPH
    CMP #$04	;FACING RIGHT?
    BNE debounce_spacebar	;NO
;--------------------------------
    LDA #$01
    STA NAME_FLAG
;--------------------------------
debounce_spacebar:
    LDA #$10      ;DEBOUNCE IT
    LDY #$7F
    JSR KEY_SCAN
    BCS debounce_spacebar
;--------------------------------
check_pause:
    JSR READ_STICKS
    AND #$10
    BEQ check_restart
    LDA PAUSE
    BEQ check_restart
;--------------------------------
    LDA #$00
    STA MASTER_VOLUME
    JMP MAIN_LOOP
;--------------------------------
check_restart:
    LDA #$00	  ;IF RESTARTED BY BUTTON MAKE SURE
    STA PAUSE	  ;PAUSE IS RESET
    LDA NPWAIT	  ;WAITING FOR NEXT PLAYER   (SET IN CHOP_CODE_3)
    BEQ CHECK_START  ;NO, CHECK ABORT
;--------------------------------
    JSR PLRCHG    ;CHANGE PLAYER
    LDA #$00
    STA NPWAIT    ;NO MORE WAIT
;-------------------------------
; CHECK BUTTONS
;--------------------------------
; CHECK F7
;--------------------------------
CHECK_START:
    LDA #$08	 ;CHECK FOR F7
    LDY #$FE
    CLC
    JSR KEY_SCAN
    BCC check_f5
; 	  JSR NXTLVL
;--------------------------------
    LDA SEED
    STA RANDOM
    JMP MAININ	;START AGAIN
;--------------------------------
; CHECK F5
;--------------------------------
check_f5:
    LDA #$40	;CHECK FOR F5
    LDY #$FE
    CLC
    JSR KEY_SCAN
    BCC draw_landing_pad
    JMP COLD_START
;-------------------------------
;   DRAW LANDING PAD
;--------------------------------
draw_landing_pad:
    JSR DO_PAD
;--------------------------------
    JSR CHECK_ABORT
    JSR CHECK_LIVES
;--------------------------------
    LDA BDEAD	;ARE BOTH PLAYERS DEAD
    BEQ check_shooting	;NO
;--------------------------------
;  BOTH PLAYERS ARE DEAD (PUT GAMEOVER SCREEN HERE)
;--------------------------------
    LDA #$00
    STA BDEAD
    JSR GAME_OVER
    JMP COLD_START    ;BOTH ARE DEAD
;--------------------------------
; IF SHOOTING GUN THEN CALL
; EXPLOSION ROUTINE EXTRA
;--------------------------------
check_shooting:
    JSR DO_EXPLOSIONS
    LDA SHOTON
    BEQ main_exec_loop
    JSR DO_EXPLOSIONS
    JSR GUN_SHOOT
    JSR GUN_SHOOT
    JSR DO_EXPLOSIONS
    JSR DO_EXPLOSIONS
;--------------------------------
main_exec_loop:
    LDX #$08
main_exec_inner_loop:
    TXA
    PHA
    JSR WATER_FALL
    JSR READ_STICKS
    STA STICK_TMP
    PLA
    TAX
    DEX
    BPL main_exec_inner_loop
;--------------------------------
;  DONT NEED SPEED
;--------------------------------
    JSR CHOPPR
    JSR DO_EXPLOSIONS
    JSR GUN_SHOOT
    JSR DO_GUN_FALL
    JSR DO_GUN
    JSR GUN_CHECK
    JSR CHOPPR
    JSR SHOBOMBS
    JSR DIRT_CHECK
    JSR MOVE_CLOUD
    JSR BUCK_CHECK
    JSR BUCFALL_CK
    JSR DO_SOUNDS
    JSR DROP_DIRT
    JSR START_PLANE
    JSR CHECK_LAND
    JSR SUB_ONE
    JSR DO_EXPLOSIONS
    JSR DO_GUN_FALL
MAIN_END	 JMP MAIN_LOOP
