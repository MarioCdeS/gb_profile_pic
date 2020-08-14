include "hardware.inc"

export lcd_off_safe


VBLANK_START_Y equ 144


section "lcd", rom0
; lcd_off_safe:
;   Waits for V-blank and then turns off the LCD.
lcd_off_safe:
    push af

    ; If the LCD is already off, exit.
    ldh a, [rLCDC]
    and a, LCDCF_ON
    jr z, .exit


    ; Wait for V-blank.
.wait_for_vblank
    ldh a, [rLY]
    cp a, VBLANK_START_Y
    jr c, .wait_for_vblank

    ; Unset on bit in LCD control.
    ldh a, [rLCDC]
    xor a, LCDCF_ON
    ldh [rLCDC], a
    
.exit
    pop af
    ret