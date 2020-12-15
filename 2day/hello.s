.global start
.code16
// 标准的FAT12格式软盘专用代码
start:
    jmp   entry
    .byte 0x90
    .ascii "helloOSX"
    .word 512
    .byte 1
    .word 1
    .byte 2
    .word 224
    .word 2880
    .byte 0xf0
    .word 9
    .word 18
    .word 2
    .long 0
    .long 2880
    .byte 0, 0, 0x29
    .long 0xffffffff
    .ascii "helloOSX   "
    .ascii "fat12   "
    .fill 18

entry:
  mov $0,  %ax
  mov %ax, %ds
  mov %ax, %es
  mov %ax, %ss
  mov $0x7c00, %sp

  mov $msg, %si

putloop:
  movb (%si), %al
  add $1, %si
  cmp $0, %al
  je fin
  movb $0x0e, %ah
  movw $15, %bx
  int $0x10
  jmp putloop

fin:
  hlt
  jmp fin

msg:
  .byte 0x0a, 0x0a
  .ascii "hello,world"
  .byte 0x0a
  .byte 0

  .org 510 # 填充为0
  .byte 0x55, 0xaa