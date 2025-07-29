* = $0801
.byte $0c, $08, $0a, $00, $9e, $20, $32, $30, $34, $38, $00, $00, $00
* = $0800  ; Your program’s original start address

;--------------------------------
; SAVE CHOPPER HUNT
; (C) 1984 IMAGIC
; BY APPLIED COMPUTER TECHNOLOGY
;--------------------------------
    
    .include "CHOPMAC.ASM"
    .include "CHOPCOD1.ASM"
    .include "CHOPCOD2.ASM"
    .include "CHOPCOD3.ASM"
    .include "CHOPCOD4.ASM"
    .include "CHOPCOD5.ASM"
    .include "IRQ.ASM"
    .include "DODIRT.ASM"
    .include "BOMB.ASM"
    .include "EXPLODE.ASM"
    .include "DIRTBOMB.ASM"
    .include "SOUND.ASM"
    .include "GUNCHANC.ASM"
    .include "GUNCOD1.ASM"
    .include "GUNCOD2.ASM"
    .include "GUNCOD3.ASM"
    .include "GUNCHECK.ASM"
    .include "PRTINTRM.ASM"
    .include "GAMEOVER.ASM"
    .include "CHOPEQU.ASM"
    .include "SHAPES.ASM"
