; ------------------------------------------------------------------
; NovaGUI - Pixel Graphics Desktop (Phase 1: 3D bevel desktop, no mouse yet)
; ------------------------------------------------------------------

	BITS 16
	%INCLUDE "mikedev.inc"
	ORG 32768

start:
	mov ax, 0013h			; VGA Mode 13h: 320x200, 256 colors
	int 10h

	mov ax, 0A000h
	mov es, ax

	; --- پس‌زمینه‌ی دسکتاپ (آبی تیره کلاسیک) ---
	mov ax, 1
	call fill_screen

	; --- تسک‌بار پایین صفحه ---
	mov ax, 0
	mov bx, 182
	mov cx, 320
	mov dx, 18
	mov si, 8			; خاکستری تیره
	call fill_rect

	mov ax, 0			; خط روشن بالای تسک‌بار (بولت سه‌بعدی)
	mov bx, 182
	mov cx, 320
	mov dx, 1
	mov si, 15
	call fill_rect

	; --- دکمه‌ی Start ---
	mov ax, 4
	mov bx, 185
	mov cx, 50
	mov dx, 12
	mov si, 7
	call fill_rect

	mov ax, 4			; هایلایت بالا
	mov bx, 185
	mov cx, 50
	mov dx, 1
	mov si, 15
	call fill_rect

	mov ax, 4			; هایلایت چپ
	mov bx, 185
	mov cx, 1
	mov dx, 12
	mov si, 15
	call fill_rect

	mov ax, 4			; سایه‌ی پایین
	mov bx, 196
	mov cx, 50
	mov dx, 1
	mov si, 0
	call fill_rect

	mov ax, 53			; سایه‌ی راست
	mov bx, 185
	mov cx, 1
	mov dx, 12
	mov si, 0
	call fill_rect

	; --- سایه‌ی پنجره (پشت پنجره، کمی جابه‌جا) ---
	mov ax, 64
	mov bx, 44
	mov cx, 200
	mov dx, 110
	mov si, 8
	call fill_rect

	; --- بدنه‌ی پنجره ---
	mov ax, 60
	mov bx, 40
	mov cx, 200
	mov dx, 110
	mov si, 7
	call fill_rect

	; --- قاب سه‌بعدی پنجره: هایلایت بالا/چپ، سایه پایین/راست ---
	mov ax, 60
	mov bx, 40
	mov cx, 200
	mov dx, 1
	mov si, 15
	call fill_rect

	mov ax, 60
	mov bx, 40
	mov cx, 1
	mov dx, 110
	mov si, 15
	call fill_rect

	mov ax, 60
	mov bx, 149
	mov cx, 200
	mov dx, 1
	mov si, 0
	call fill_rect

	mov ax, 259
	mov bx, 40
	mov cx, 1
	mov dx, 110
	mov si, 0
	call fill_rect

	; --- نوار عنوان پنجره ---
; --- نوار عنوان پنجره ---
	mov ax, 62
	mov bx, 42
	mov cx, 196
	mov dx, 14
	mov si, 1
	call fill_rect

	; --- متن "NOVAOS" روی نوار عنوان ---
	mov cx, 66
	mov dx, 45
	mov bl, 15
	mov si, title_text
	call draw_string

	; --- متن "START" روی دکمه‌ی Start ---
	mov cx, 12
	mov dx, 188
	mov bl, 15
	mov si, start_text
	call draw_string

call init_mouse

	mov word [mouse_x], 160	; نشانگر ابتدا وسط صفحه
	mov word [mouse_y], 100

main_loop:
	call draw_cursor

	mov ah, 1			; بررسی فشار کلید (بدون توقف)
	int 16h
	jz main_loop			; اگه کلیدی نزده، حلقه ادامه پیدا کنه

	mov ah, 0
	int 16h				; پاک کردن بافر کیبورد

	mov ax, 0003h			; بازگشت به حالت متنی
	int 10h
	ret

; ------------------------------------------------------------------
fill_screen:				; IN: AX = رنگ
	pusha
	mov cx, 320*200
	xor di, di
	rep stosb
	popa
	ret


; ------------------------------------------------------------------
fill_rect:				; IN: AX=x BX=y CX=عرض DX=ارتفاع SI=رنگ
	pusha
	mov [.px], ax
	mov [.py], bx
	mov [.pw], cx
	mov [.ph], dx
	mov [.pc], si

.row_loop:
	cmp word [.ph], 0
	je .done

	mov ax, [.py]
	mov bx, 320
	mul bx
	add ax, [.px]
	mov di, ax

	mov cx, [.pw]
	mov al, byte [.pc]
	rep stosb

	inc word [.py]
	dec word [.ph]
	jmp .row_loop

.done:
	popa
	ret

.px	dw 0
.py	dw 0
.pw	dw 0
.ph	dw 0
.pc	dw 0


; ------------------------------------------------------------------
plot_pixel:				; IN: AX=x, BX=y, CL=color
	pusha
	push ax
	mov ax, bx
	mov bx, 320
	mul bx
	pop bx
	add ax, bx
	mov di, ax
	mov byte [es:di], cl
	popa
	ret


; ------------------------------------------------------------------
draw_char:				; IN: AL=char, CX=x, DX=y, BL=color
	pusha
	mov [.chr], al
	mov [.x], cx
	mov [.y], dx
	mov [.color], bl

	mov al, [.chr]
	cmp al, 32
	jae .ok_low
	mov al, 32
.ok_low:
	cmp al, 90
	jbe .ok_high
	mov al, 32
.ok_high:
	sub al, 32
	xor ah, ah
	mov bx, 8
	mul bx
	mov si, font_table
	add si, ax
	mov [.glyph], si

	mov word [.row], 0
.row_loop:
	mov ax, [.row]
	cmp ax, 8
	je .done

	mov si, [.glyph]
	add si, [.row]
	mov al, [si]
	mov [.rowbyte], al

	mov word [.col], 0
.col_loop:
	mov ax, [.col]
	cmp ax, 8
	je .next_row

	mov cl, 7
	sub cl, byte [.col]
	mov al, [.rowbyte]
	shr al, cl
	and al, 1
	cmp al, 0
	je .skip_pixel

	mov ax, [.x]
	add ax, [.col]
	mov bx, [.y]
	add bx, [.row]
	mov cl, [.color]
	call plot_pixel

.skip_pixel:
	inc word [.col]
	jmp .col_loop

.next_row:
	inc word [.row]
	jmp .row_loop

.done:
	popa
	ret

	.chr		db 0
	.x		dw 0
	.y		dw 0
	.color		db 0
	.glyph		dw 0
	.rowbyte	db 0
	.row		dw 0
	.col		dw 0


; ------------------------------------------------------------------
draw_string:				; IN: SI=string, CX=x, DX=y, BL=color
	pusha
	mov [.strptr], si
	mov [.curx], cx
	mov [.y], dx
	mov [.color], bl

.loop:
	mov si, [.strptr]
	mov al, [si]
	cmp al, 0
	je .done

	mov cx, [.curx]
	mov dx, [.y]
	mov bl, [.color]
	call draw_char

	inc word [.strptr]
	add word [.curx], 8
	jmp .loop

.done:
	popa
	ret

	.strptr		dw 0
	.curx		dw 0
	.y		dw 0
	.color		db 0


; ------------------------------------------------------------------
	title_text	db 'NOVAOS', 0
	start_text	db 'START', 0


; ------------------------------------------------------------------
; جدول فونت بیت‌مپ ۸x۸ (کاراکترهای 32 تا 90)
; فعلاً فقط A,N,O,R,S,T,V طراحی شده؛ بقیه خالی‌ان و بعداً اضافه می‌شن

font_table:
	db 0,0,0,0,0,0,0,0			; 32 ' '
	times (64-33+1)*8 db 0			; 33-64 (خالی فعلاً)
	db 0x38,0x6C,0xC6,0xC6,0xFE,0xC6,0xC6,0x00	; 65 'A'
	times (77-66+1)*8 db 0			; 66-77 (خالی فعلاً)
	db 0xC6,0xE6,0xF6,0xDE,0xCE,0xC6,0xC6,0x00	; 78 'N'
	db 0x7C,0xC6,0xC6,0xC6,0xC6,0xC6,0x7C,0x00	; 79 'O'
	times (81-80+1)*8 db 0			; 80-81 (خالی فعلاً)
	db 0xFC,0xC6,0xC6,0xFC,0xD8,0xCC,0xC6,0x00	; 82 'R'
	db 0x7C,0xC0,0xC0,0x7C,0x06,0x06,0xFC,0x00	; 83 'S'
	db 0xFE,0x18,0x18,0x18,0x18,0x18,0x18,0x00	; 84 'T'
	times 8 db 0				; 85 'U' (خالی فعلاً)
	db 0xC6,0xC6,0xC6,0xC6,0x6C,0x38,0x10,0x00	; 86 'V'
times (90-87+1)*8 db 0			; 87-90 (خالی فعلاً)


; ------------------------------------------------------------------
; درایور ساده‌ی موس PS/2

init_mouse:
	pusha

call mouse_wait_write		; تنظیم موس روی حالت پیش‌فرض
					; (بدون فعال‌سازی IRQ12 یا جریان خودکار —
					;  فقط با دستور مستقیم 0xEB وضعیت رو می‌پرسیم)
	mov al, 0xD4
	out 0x64, al
	call mouse_wait_write
	mov al, 0xF6
	out 0x60, al
	call mouse_wait_read
	in al, 0x60

	popa
	ret

mouse_wait_write:
	push cx
	mov cx, 0xFFFF
.wait:
	in al, 0x64
	and al, 2
	jz .ready
	loop .wait
.ready:
	pop cx
	ret


mouse_wait_read:
	push cx
	mov cx, 0xFFFF
.wait:
	in al, 0x64
	and al, 1
	jnz .ready
	loop .wait
.ready:
	pop cx
	ret


; ------------------------------------------------------------------
; خواندن مستقیم وضعیت فعلی موس (بدون IRQ، برای سادگی و پایداری فاز اول)

read_mouse_packet:
	call mouse_wait_write
	mov al, 0xD4
	out 0x64, al
	call mouse_wait_write
	mov al, 0xEB			; دستور "درخواست وضعیت فعلی"
	out 0x60, al
	call mouse_wait_read
	in al, 0x60			; بایت ACK را دور می‌ریزیم

	call mouse_wait_read
	in al, 0x60
	mov [packet_status], al

	call mouse_wait_read
	in al, 0x60
	mov [packet_dx], al

	call mouse_wait_read
	in al, 0x60
	mov [packet_dy], al

	ret


; ------------------------------------------------------------------
draw_cursor:
	pusha

	; --- پاک کردن موقعیت قبلی نشانگر (بازرسم پس‌زمینه‌ی دسکتاپ) ---
	mov ax, [mouse_x]
	mov bx, [mouse_y]
	mov cx, 4
	mov dx, 4
	mov si, 1
	call fill_rect

	call read_mouse_packet

	mov al, [packet_dx]
	cbw
	add word [mouse_x], ax

	mov al, [packet_dy]
	cbw
	sub word [mouse_y], ax		; محور Y در موس PS/2 معکوس صفحه‌ست

	cmp word [mouse_x], 0		; محدود کردن نشانگر به کادر صفحه
	jge .x_ok
	mov word [mouse_x], 0
.x_ok:
	cmp word [mouse_x], 316
	jle .x_ok2
	mov word [mouse_x], 316
.x_ok2:
	cmp word [mouse_y], 0
	jge .y_ok
	mov word [mouse_y], 0
.y_ok:
	cmp word [mouse_y], 196
	jle .y_ok2
	mov word [mouse_y], 196
.y_ok2:

	; --- رسم نشانگر جدید (یه مربع سفید کوچیک) ---
	mov ax, [mouse_x]
	mov bx, [mouse_y]
	mov cx, 4
	mov dx, 4
	mov si, 15
	call fill_rect

	popa
	ret


	mouse_x		dw 160
	mouse_y		dw 100
	packet_status	db 0
	packet_dx	db 0
	packet_dy	db 0
