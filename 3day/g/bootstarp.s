
    [org 0x7c00]

  mov ax,  0
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7c00
  
  mov bx, 0x100 ; 读磁盘, 文件读入[es:bx]
  mov ax, 0x800 
  mov es, ax
  mov cl, 0x02
  mov al, 12
  call disk_load

  mov bx, 0
  mov ax, 0x9000
  mov es, ax
  mov cl, 14
  mov al, 0x28
  call disk_load 
  jmp 0x800:0x100 ;跳入head.s

disk_load:
  mov ch, 0 ; 柱面0
  mov dh, 0  ; 磁头0 

retry:
  mov ah, 0x02
  int 0x13
  jc retry

  mov ah, 0x00
  mov dl, 0x00
  int 0x13

  ret

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
