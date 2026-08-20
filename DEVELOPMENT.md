# Chopper Hunt - Development Guide

## Toolchain (installed 2026-08-20)

| Tool | Location |
|------|----------|
| 64tass (assembler) | `C:\Users\styck\tools\64tass\64tass-1.60.3243\64tass.exe` |
| VICE (emulator) | `C:\Users\styck\AppData\Local\Microsoft\WinGet\Packages\VICE-Team.VICE.GTK3_Microsoft.Winget.Source_8wekyb3d8bbwe\GTK3VICE-3.10-win64\bin\x64sc.exe` |
| RetroDebugger | `C:\Users\styck\tools\RetroDebugger\RetroDebugger-v1.0.0\RetroDebugger-notsigned.exe` |

## Build & Run

Use the VS Code tasks (Ctrl+Shift+B to build, or the Run task):

- **Build with 64tass** - assembles `CHOPHUNT.ASM` -> `CHOPHUNT.prg`,
  plus `listing.txt` and `labels.txt` (VICE labels).
- **Run in VICE** - builds, then runs `CHOPHUNT.prg` with `-autostart`.

Command line equivalents:

```
64tass CHOPHUNT.ASM -o CHOPHUNT.prg -L listing.txt --line-numbers --verbose-list --vice-labels -l labels.txt
x64sc -autostart CHOPHUNT.prg
```

## Memory Map

```
$0400-$0800   Variables (cleared at boot by COLD_START)
$05-$00FA     Zero-page variables
$0801-$080D   BASIC auto-run stub ("10 SYS <COLD_START>")
$080D-$3F28   Code + data tables + shapes (all under $4000)
$4000-$4400   Screen RAM (set up at runtime)
$4400-$5800   Sprite memory (set up at runtime)
$5800-$6000   Character set
$6000-$8000   Hi-res bitmap
```

`CHOPHUNT.ASM` includes the files in the original order (equates, shapes,
then code) and generates the BASIC stub automatically, so the `SYS` address
never needs manual updating.

## Debugging with RetroDebugger

1. Launch `RetroDebugger-notsigned.exe`.
2. Set up C64 ROMs in its Settings menu (first run only). Use the ROMs
   bundled with VICE, e.g.:
   - `C:\...\GTK3VICE-3.10-win64\C64\kernal-901227-03.bin`
   - `C:\...\GTK3VICE-3.10-win64\C64\basic-901226-01.bin`
   - `C:\...\GTK3VICE-3.10-win64\C64\chargen-901225-01.bin`
3. Load `CHOPHUNT.prg` and run it. Import `labels.txt` for symbol names.

## Notes

- The project originally used the Merlin assembler (`.OR`, `.HS`, `.BS`,
  `.DUMMY`). It was converted to 64tass; the zero-page and variable
  declarations are now `.virtual` blocks so they do not emit data.
- `CHOPHUNT.prg`, `listing.txt` and `labels.txt` are build outputs.
