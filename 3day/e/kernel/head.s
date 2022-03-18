 ;org 0x1000
  
  ;如下操作进行清屏
  mov ax, 0x0600
  mov bx, 0x0700
  mov cx, 0
  mov dx, 0x184f
  int 0x10

  mov ah, 0x0e
  mov al, 'L'
  int 0x10

fin:
  hlt 
  jmp fin