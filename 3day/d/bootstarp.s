;标准的FAT12格式软盘专用代码
    org 0x7c00
    jmp   entry
    db 0x90
    db "helloOSX"
    dw 512
    db 1
    dw 1
    db 2
    dw 224
    dw 2880
    db 0xf0
    dw 9
    dw 18
    dw 2
    dd 0
    dd 2880
    db 0, 0, 0x29
    dd 0xffffffff
    db "helloOSX   "
    db "fat12   "
    resb 18

entry:
  mov ax,  0
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7c00

clearscreen:  
  ;如下操作进行清屏
  mov ax, 0x0600
  mov bx, 0x0700
  mov cx, 0
  mov dx, 0x184f
  int 0x10


  mov ax, 0x0820 ; 读磁盘
  mov es, ax
  mov ch, 0 ; 柱面0
  mov dh, 0  ; 磁头0 
  mov cl, 2  ; 扇区2
 
readloop:
  mov si, 0 ;记录失败次数的寄存器

retry:
  mov ah, 0x02
  mov al, 0x1
  mov bx, 0x0
  mov dl, 0x00
  int 0x13
  jnc next
  add si, 1
  cmp si, 5
  jae error
  mov ah, 0x00
  mov dl, 0x00
  int 0x13
  jmp retry
next:
  mov ax, es 
  add ax, 0x0020
  mov es, ax
  add cl, 1
  cmp cl, 18
  jbe readloop


kernel:
  mov [0x0ff0], ch ;跳转到kernel
  jmp 0xc200

error:
    mov si, msg

putloop:
  mov al, [si]
  add si, 1
  cmp al, 0
  je fin
  mov ah, 0x0e
  mov bx, 15
  int 0x10
  jmp putloop

fin:
  hlt
  jmp fin

msg:
  db 0x0a, 0x0a
  db "hello,world"
  db 0x0a
  db 0

  times 510-($-$$) db 0 
  db 0x55, 0xaa
