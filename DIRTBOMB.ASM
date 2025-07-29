;--------------------------------
;  SAVE DIRT.BOMB.CODE
;--------------------------------
; CHECK FOR BOMB COLLISION
; WITH FALLING DIRT BY CHECKING
; X Y LOCATIONS
;--------------------------------
DIRT_BOMB  LDX ROCNT
	   BNE _1
	   JMP _9
;--------------------------------
;  CHECK BOTTOM ROW OF DIRT
;  BY SCANNING EACH COLUMNS
;  X-Y COORDINATES
;--------------------------------
_1	   LDX ROCNT
_6	   LDA KILL_DIRT_FLAG,X
	   BEQ _66
;--------------------------------
	   JMP _99
;--------------------------------
_66	   LDA RX1,X
	   CMP IRQ_PLOTX
	   BNE _3
;--------------------------------
	   LDA RY1,X
	   CMP IRQ_PLOTY
	   BEQ _33
;--------------------------------
	   SEC
	   SBC #$01
	   CMP IRQ_PLOTY
	   BEQ _33
;--------------------------------
	   SBC #$01
	   CMP IRQ_PLOTY
	   BEQ _33
;--------------------------------
	   SBC #$01
	   CMP IRQ_PLOTY
	   BNE _3
;--------------------------------
_33	   JMP DIRT_COLLIDE2
;--------------------------------
_3	   LDA RX2,X
	   CMP IRQ_PLOTX
	   BNE _4
;--------------------------------
	   LDA RY2,X
	   CMP IRQ_PLOTY
	   BNE _4
;--------------------------------
	   JMP DIRT_COLLIDE2
;--------------------------------
_4	   LDA RX5,X
	   CMP IRQ_PLOTX
	   BNE _7
;--------------------------------
	   LDA RY5,X
	   CMP IRQ_PLOTY
	   BEQ _55
;--------------------------------
	   SEC
	   SBC #$01
	   CMP IRQ_PLOTY
	   BEQ _55
;--------------------------------
	   SBC #$01
	   CMP IRQ_PLOTY
	   BEQ _55
;-------------------------------
	   SBC #$01
	   CMP IRQ_PLOTY
	   BNE _7
;--------------------------------
_55	   JMP DIRT_COLLIDE2
;--------------------------------
;  THIS WAS ADDED AFTER FINAL
;  COPY WAS SENT
;--------------------------------
_7	   LDA RX3,X
	   CMP IRQ_PLOTX
	   BNE _8
;--------------------------------
	   LDA RY3,X
	   CMP IRQ_PLOTY
	   BEQ _88
;--------------------------------
	   SEC
	   SBC #$01
	   CMP IRQ_PLOTY
	   BEQ _88
;--------------------------------
	   SBC #$01
	   CMP IRQ_PLOTY
	   BEQ _88
;--------------------------------
	   SBC #$01
	   CMP IRQ_PLOTY
	   BNE _8
;--------------------------------
_88	   JMP DIRT_COLLIDE2
;--------------------------------
_8	   LDA RX4,X
	   CMP IRQ_PLOTX
	   BNE _99
;--------------------------------
	   LDA RY4,X
	   CMP IRQ_PLOTY
	   BEQ _88
;--------------------------------
	   SEC
	   SBC #$01
	   CMP IRQ_PLOTY
	   BEQ _88
;--------------------------------
	   SEC
	   SBC #$01
	   CMP IRQ_PLOTY
	   BEQ _88
;--------------------------------
_99	   DEX
; 	   BPL _6
	   BMI _9
	   JMP _6
;--------------------------------
_9	   RTS
;--------------------------------
DIRT_COLLIDE2 LDA #$01
	  STA HIT3
	  RTS
