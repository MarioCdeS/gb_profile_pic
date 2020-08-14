export mem_copy


section "memory", rom0
; mem_copy:
;   Copies the specified number of bytes to the destination address, from the
;   source address.
;
; param <bc> -> Number of bytes to copy
; param <de> -> Destination address
; param <hl> -> Source address
mem_copy:
    push af
    push bc
    push de
    push hl

    ld a, b
    or a, c
    jr z, .exit

.loop
    ld a, [hli]
    ld [de], a
    inc de

    dec bc
    ld a, b
    or a, c
    jr nz, .loop

.exit
    pop hl
    pop de
    pop bc
    pop af
    ret