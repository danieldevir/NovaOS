; ==========================================================
; NovaUI 0.1
; NovaOS User Interface Library
; ==========================================================

BITS 16

; ----------------------------------------------------------
; nova_draw_window
;
; AX = pointer to title string
; ----------------------------------------------------------

nova_draw_window:

    push ax

    call os_clear_screen

    pop ax

    mov cx, 00011111b
    call os_draw_background

    ret
; ----------------------------------------------------------
; nova_draw_statusbar
;
; رسم نوار وضعیت پایین صفحه
; ----------------------------------------------------------

nova_draw_statusbar:

    pusha

    mov ax, status_text
    mov cx, 01110000b      ; مشکی روی سفید
    call os_draw_background

    popa
    ret


status_text db 'Ready',0

; ----------------------------------------------------------
