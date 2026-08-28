# Converting S-C Macro Assembler (Apple II) Source to 64tass

This document records what was learned while reconstructing *Chopper Hunt*
(Imagic, 1984) and porting its source from the original **S-C Macro
Assembler** (S.C. Macro Assembler, Apple II) to **64tass v1.60.3243**
(https://sourceforge.net/projects/tass64/).

## How the original source was identified

The original listing was checked for its assembler dialect. The following
syntax is unambiguous S-C Macro Assembler:

- `/` as the high-byte operator (`.DA /IRQ2`, `BUSH.HI .DA /BUSH`)
- `>` prefix for macro invocation (`>ADD ]1,]2`, `>INC`)
- `:1`, `:2` local labels (colon-prefixed)
- periods inside labels (`COLOR.MEMORY`, `BUSH.HI`, `SCREEN.MEMORY`)
- `*` in column 1 for comments
- directives `.MA`/`.EM`, `.IN`, `.OR`, `.DUMMY`, `.DA#`, `.AS`, `.HS`,
  `.EQ`, `.BS1`, `.TI`, `.TF`, `.EN`, `.ED`
- macro parameters `]1`, `]2`, `]3`

## Reading the original listing

The `.lst` file has this layout per source line:

```
ADDR- OPCODES  LINENO  SOURCE
```

Example:

```
0809- 00 00 FE  1860 COORD1 .DA#0,#0,#1,#0,#255,#255,#255,#1
```

- `0809-` is the target address (4 hex digits + dash).
- `00 00 FE` are the emitted bytes.
- `1860` is the source line number.
- The rest is the source text.
- `*` comments and blank lines have no address or bytes.
- The whole file is prefixed by an `:ASM` command and `.TI` title directive.

This format makes byte-for-byte verification possible: each emitted byte is
already printed next to its source line.

## Directive map

| S-C Macro Assembler | 64tass | Notes |
| --- | --- | --- |
| `.OR $0800` | `* = $0800` | Set program counter / origin |
| `.EQ $D012` | `RASTER = $D012` | Equate |
| `.IN CHOP.MACROS,D2` | `.include "CHOPMAC.ASM"` | Drop the drive spec (`,D2`) |
| `.MA name` / `.EM` | `name .macro` / `.endm` | Macro definition |
| `.DUMMY` … `.ED` | `.virtual` … `.endv` | Non-emitting block (zero page) |
| `.BS1`, `.BS2`, … | `.fill n` (or `.byte 0,0,…`) | Reserve `n` bytes |
| `.DA#n` | `.byte n` | Decimal data byte(s) |
| `.DA $xx` | `.byte $xx` | Hex data byte(s) |
| `.DA /label` | `.byte >label` | High byte of label |
| `.DA <label` | `.byte <label` | Low byte of label |
| `.AS "text"` | `.text "text"` / `.null "text"` | ASCII string |
| `.HS FFA00FF0` | `.byte $FF,$A0,$0F,$F0` | Hex-digit string → bytes |
| `.TI 55,title` | (delete, use a `;` comment) | Title for page header |
| `.TF OBJECT,D1` | (delete; use 64tass `-o`) | Output file selector |
| `.EN` | (delete) | End of source / include |
| `.ED` | (delete) | End of `.DUMMY` block |

### `.DA` operand forms

`.DA` (data) uses a prefix on the operand to choose the encoding:

| Form | Meaning | 64tass |
| --- | --- | --- |
| `.DA#9` | decimal byte 9 | `.byte 9` |
| `.DA $09` | hex byte $09 | `.byte $09` |
| `.DA /LABEL` | high byte | `.byte >LABEL` |
| `.DA <LABEL` | low byte | `.byte <LABEL` |

### `.AS` vs `.HS`

- `.AS "LEVEL 00"` emits ASCII character codes. In 64tass this is
  `.text "LEVEL 00"` (raw) or `.null "..."` if a `$00` terminator is wanted.
- `.HS 5555AAF00FF00FF0` emits bytes from a hex-digit string
  (`$55,$55,$AA,$F0,$0F,$F0,$0F,$F0`). 64tass has no direct equivalent, so
  expand it manually to `.byte`.

## Operator map

| S-C | 64tass | Meaning |
| --- | --- | --- |
| `/expr` | `>expr` | High byte |
| `<expr` | `<expr` | Low byte |
| `#imm` | `#imm` | Immediate (unchanged) |
| `$hex` | `$hex` | Hexadecimal literal (unchanged) |
| `]1` | `\1` | Macro parameter (see below) |

## Number notation (do not "fix" these)

Both assemblers default to **decimal** for unprefixed numbers, and `$` marks
hex. This is a common source of false "bugs":

- `LDA #75` is decimal 75 (`$4B`) in **both** assemblers — carry it over
  verbatim, do **not** write `LDA #$75`.
- `ORA #32` is `ORA #$20` in **both**.
- `.DA#9` and `.byte 9` are the same value.

Only add `$` if the original had `$`.

## Comments

- S-C comments are `*` in column 1.
- 64tass comments are `;` (or `;` at any position).
- Convert every `*` comment line to `;`. Keep `*` only for multiplication.

## Labels

- `:1`, `:2` local labels → `_1`, `_2`. 64tass treats `_`-prefixed labels as
  local (re-usable after the next non-local label). Inside a `.macro` block
  the `:1` style can also become `.1` (a 64tass "cheap local label").
- Periods inside labels are an S-C convention; 64tass allows periods but they
  interact with 64tass's own scoped-label syntax, so the conversion uses
  underscores:

  | S-C | 64tass |
  | --- | --- |
  | `BUSH.HI` | `BUSH_HI` |
  | `COLOR.MEMORY` | `COLOR_MEMORY` |
  | `SCREEN.MEMORY` | `SCREEN_MEMORY` |

- 64tass is case-sensitive; the original labels are already uppercase, so
  preserve the exact case.

## Macros

S-C macro definition and invocation:

```
     .MA ADD            ; define macro "ADD"
     LDA ]2
     CLC
     ADC ]1             ; ]1, ]2, ]3 are parameters
     STA ]2
     BCC :1
     INC ]3
:1
     .EM
```

64tass equivalent:

```assembly
ADD .macro
     LDA \2
     CLC
     ADC \1
     STA \2
     BCC .1
     INC \3
.1
     .endm
```

Invocation drops the `>` prefix:

```
>ADD VALUE,TEMP1,TEMP2     →     ADD VALUE,TEMP1,TEMP2
```

## Include order matters

S-C assigns addresses sequentially as files are `.IN`cluded, exactly like
64tass `.include`. **The order of includes must be preserved** to reproduce
the original memory layout, because every absolute reference
(`JSR`, `JMP`, `LDA abs`, data pointers) resolves to an address that depends
on what was assembled before it.

The original `.IN` order from the listing:

```
.IN CHOP.MACROS,D2
.IN CHOP.EQUATES,D1
.IN CHOP.SHAPES,D2
.IN CHOP.CODE.1,D2
.IN CHOP.CODE.3,D2
.IN CHOP.CODE.5,D2
.IN CHOP.CODE.4,D2
.IN CHOP.CODE.2,D2
.IN DO.DIRT.CODE,D2
.IN IRQ.CODE,D2
.IN BOMB.CODE,D2
.IN EXPLOSION.CODE,D2
.IN DIRT.BOMB.CODE,D2
.IN SOUND.CODE2,D1
.IN GUN.CHANCE.CODE,D1
.IN GUN.CODE.1,D2
.IN GUN.CODE.2,D2
.IN GUN.CODE.3,D2
.IN GUN.CHECK.CODE,D1
.IN PRINT.INTRM,D2
.IN GAME.OVER.CODE
```

Two quirks to note:

- The `CHOP.CODE` files are included in the order **1, 3, 5, 4, 2**, not
  1–5.
- `IRQ.CODE` comes **after** `DO.DIRT.CODE`.

The original segment start addresses reflect this (from the listing):

| File | First code address |
| --- | --- |
| `CHOP.CODE.1` | `$12C9` |
| `CHOP.CODE.3` | `$1761` |
| `CHOP.CODE.5` | `$1CD3` |
| `CHOP.CODE.4` | `$2105` |
| `CHOP.CODE.2` | `$2515` |
| `DO.DIRT.CODE` | `$2BBC` |
| `IRQ.CODE` | `$2FD9` |
| `PRINT.INTRM` | `$3C9D` |
| `GAME.OVER.CODE` | `$3D3F` |

> **Note:** the current `CHOPHUNT.ASM` includes the code files in numeric
> order (`CHOPCOD1`–`CHOPCOD5`, then `IRQ`, then `DODIRT`), so its absolute
> addresses differ from the original even though each routine's instruction
> sequence is identical. If a byte-for-byte reproduction of the original PRG
> is ever required, restore the original `.IN` order above.

## File name map

Original S-C source names (periods, no extension) were renamed to short
64tass `.ASM` files:

| Original | New file |
| --- | --- |
| `CHOP.MACROS` | `CHOPMAC.ASM` |
| `CHOP.EQUATES` | `CHOPEQU.ASM` |
| `CHOP.SHAPES` | `SHAPES.ASM` |
| `CHOP.CODE.1` | `CHOPCOD1.ASM` |
| `CHOP.CODE.2` | `CHOPCOD2.ASM` |
| `CHOP.CODE.3` | `CHOPCOD3.ASM` |
| `CHOP.CODE.4` | `CHOPCOD4.ASM` |
| `CHOP.CODE.5` | `CHOPCOD5.ASM` |
| `DO.DIRT.CODE` | `DODIRT.ASM` |
| `IRQ.CODE` | `IRQ.ASM` |
| `BOMB.CODE` | `BOMB.ASM` |
| `EXPLOSION.CODE` | `EXPLODE.ASM` |
| `DIRT.BOMB.CODE` | `DIRTBOMB.ASM` |
| `SOUND.CODE2` | `SOUND.ASM` |
| `GUN.CHANCE.CODE` | `GUNCHANC.ASM` |
| `GUN.CODE.1` | `GUNCOD1.ASM` |
| `GUN.CODE.2` | `GUNCOD2.ASM` |
| `GUN.CODE.3` | `GUNCOD3.ASM` |
| `GUN.CHECK.CODE` | `GUNCHECK.ASM` |
| `PRINT.INTRM` | `PRTINTRM.ASM` |
| `GAME.OVER.CODE` | `GAMEOVER.ASM` |
| — (not in listing) | `SPRITES.ASM` |

## Memory layout and the zero page

The original declares its zero-page variables as a **dummy** (non-emitting)
block:

```
     .DUMMY
     .OR $05
PAUSE   .BS1
CHOP.X  .BS1
...
     .ED
```

In 64tass this becomes a `.virtual` block so the labels get addresses but no
bytes are emitted:

```assembly
.virtual $05
PAUSE   .fill 1
CHOP_X  .fill 1
...
.endv
```

Full memory map of the reconstructed game:

| Region | Range |
| --- | --- |
| Variables | `$0400-$0562` |
| Program (BASIC stub + code/data) | `$0801-$3EBF` |
| Screen RAM | `$4000-$43E7` |
| Sprite pointers | `$43F8-$43FF` |
| Sprite data | `$4400-$4B7F` |
| Character set | `$5800-$6000` |
| Hires bitmap | `$6000-$7FFF` |
| Color memory | `$D800-$DBFF` |

## BASIC auto-run stub

The `.prg` must start with a `SYS` line. 64tass generates it with the
address computed automatically:

```assembly
* = $0801
    .word (+), 10
    .null $9e, format("%4d", COLD_START)
+   .word 0
```

`format("%4d", COLD_START)` emits the decimal `SYS` address as text, so it
never needs updating when code moves.

The game's on-screen strings are screencodes, so the source sets:

```assembly
    .enc "screen"
```

which makes `.text`/`.null` encode ASCII into C64 screencodes.

## Common pitfalls that caused real bugs

1. **`.word` instead of `.byte` for `.DA#` tables.** Every byte entry became
   two little-endian bytes, doubling table size and shifting every following
   label. This is the single most common trap when porting `.DA#` tables.
   Use `.byte` (and `.byte <X` / `.byte >X` for low/high pointer pairs).

2. **16-bit pointer increments.** The original `>INC` macro increments a
   low/high pair across page boundaries. Hand-written replacement must be
   `INC lo / BNE + / INC hi` — dropping the high-byte increment makes loops
   wrap at 256-byte page boundaries and hang or corrupt memory.

3. **Sprite data load-address header.** VICE monitor `save` prepends a
   2-byte load-address header (`00 44`). Strip it before `.byte`-ing the
   data, or every 64-byte block shifts by 2 and all sprites render as
   garbage.

4. **Decimal literals.** `#32` is decimal 32 (`$20`). Do not "correct" these
   to `#$32`.

5. **Processor port value.** `INIT_IO` must write `$E7` to `$01` (the 6510
   port), not `$37`.

6. **Character ROM banking.** `CREATE_WIDEFONT` banks the character ROM in
   via `LDA $01` / `ORA #$04` (or the original's exact value) and back out
   again after copying.

7. **Self-modifying code.** The original relocates and rewrites several
   routines at runtime (`MOD`, `MOD1`–`MOD4`). Keep the code and its
   addresses intact; 64tass assembles self-modifying code fine, but any
   reordering changes what the writes target.

## Build and verification

Build command (see also `.vscode/tasks.json`):

```
64tass CHOPHUNT.ASM -o CHOPHUNT.prg \
  -L listing.txt --line-numbers --verbose-list --vice-labels -l labels.txt
```

Verification workflow used during the port:

1. Assemble and compare the emitted opcode bytes against the original
   listing's `ADDR- OPCODES` columns, routine by routine.
2. For sprite data, dump `$4400-$4B7F` from the running crack and compare
   against `SPRITES.ASM` (zeroing the runtime-written rotor bytes first).
3. Run in VICE and visually confirm the splash screen and gameplay.

Because the original listing already prints the emitted bytes per line, it
is the authoritative reference for confirming a byte-exact conversion.
