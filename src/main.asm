include "hardware.inc"


HEADER_END equ $0150
SP_INIT equ $ffff


section "vblank interrupt", rom0[$0040]
    reti 


section "lcdc interrupt", rom0[$0048]
    reti 


section "timer interrupt", rom0[$0050]
    reti 


section "serial interrupt", rom0[$0058]
    reti 


section "joystick interrupt", rom0[$0060]
    reti 


section "reset entry", rom0[$0100]
    jp main


section "header", rom0[$0104]
    NINTENDO_LOGO
logo_end:

ds HEADER_END - logo_end, 0


section "tiles", rom0
tile_set:
incbin "assets/tile-set.bin"
tile_set_end:

tile_indices:
incbin "assets/indices.bin"


section "main", rom0
main:
    di
    ld sp, SP_INIT

    call lcd_off_safe

    ; Set background palette
    ld a, %00011011
    ldh [rBGP], a

    ; Copy tile-set to VRAM
    ld bc, tile_set_end - tile_set
    ld de, _VRAM
    ld hl, tile_set
    call mem_copy

    ; Set tile-set indices
    ld b, 20 ; 20 tiles per row
    ld c, 18 ; 18 rows
    ld de, _SCRN0
    ld hl, tile_indices

.idx_loop
    ld a, [hli]
    ld [de], a
    inc de

    dec b
    jr nz, .idx_loop

    ld b, 20 ; Reset row tile count

    ; Increment destination address past the last remaining tiles in the BG map
    ld a, e
    add a, 12 ; Skip last 12 tiles
    ld e, a
    ld a, d
    adc a, 0
    ld d, a

    dec c
    jr nz, .idx_loop

    ; Turn on LCD
    ldh a, [rLCDC]
    or a, LCDCF_ON
    ldh [rLCDC], a

.lock_up
    nop 
    jr .lock_up