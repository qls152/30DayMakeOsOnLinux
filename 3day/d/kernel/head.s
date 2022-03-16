org 0xc200
  
  mov al, 0x13
  mov ah, 0x00
  int 0x10
  
  mov al, 'X',
  mov [0xa000], al

fin:
  hlt 
  jmp fin