; ==========================================================
; NovaLauncher 0.1
; Main interface of NovaOS
; ==========================================================

BITS 16


nova_launcher:

    call os_clear_screen


    mov si, nova_title
    call os_print_string


    mov si, nova_menu
    call os_print_string


.wait:
    mov ah,00h
    int 16h


    cmp al,'1'
    je launch_terminal

    cmp al,'2'
    je launch_pad

    jmp .wait



launch_terminal:
    call os_command_line
    ret


launch_pad:

    mov ax, novapad_name
    mov cx, 32768             ; Standard program load address
    call os_load_file
    jc .load_fail              ; NOVAPAD.BIN not found on disk

    mov ax, 0                  ; Clear registers before handing off control
    mov bx, 0
    mov cx, 0
    mov dx, 0
    mov si, 0
    mov di, 0

    call 32768                  ; Actually run NovaPad

    ret

.load_fail:
    ret


nova_title db 13,10,'========================',13,10
           db '       NovaOS',13,10
           db '========================',13,10,13,10,0


nova_menu db '1) Terminal',13,10
          db '2) NovaPad',13,10
          db 13,10
          db 'Select: ',0


novapad_name db 'NOVAPAD.BIN',0
