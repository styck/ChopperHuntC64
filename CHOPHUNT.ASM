;--------------------------------
; SAVE CHOPPER HUNT
; (C) 1984 IMAGIC
; BY APPLIED COMPUTER TECHNOLOGY
;--------------------------------
;
; Auto-run BASIC stub: 10 SYS <COLD_START> - the SYS address is
; computed automatically by 64tass so it never needs updating.

* = $0801
    .word (+), 10
    .null $9e, format("%4d", COLD_START)
+   .word 0

    .include "CHOPMAC.ASM"
    .include "CHOPEQU.ASM"
    .include "SHAPES.ASM"
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
