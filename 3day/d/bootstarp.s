.global start
.code16
  .equ CYLS, 10
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

// 读磁盘
  mov $0x0820, %ax
  mov %ax, %es
  // 柱面0
  movb $0, %ch
  // 磁头0 
  movb $0, %dh 
  // 扇区2
  movb $2, %cl

readloop:
  // 记录失败次数的寄存器
  mov $0, %si

retry:
  mov $0x02, %ah
  mov $1, %al
  mov $0, %bx
  mov $0x00, %dl
  int $0x13
  jnc next
  add $1, %si
  cmp $5, %si
  // 当SI >= 5时 跳转到error
  jae error
  mov $0x00, %ah
  mov $0x00, %dl
  int $0x13
  jmp retry

next:
  // 将内存地址后移0x200
  mov %es, %ax
  add $0x0020, %ax
  mov %ax, %es
  add $1, %cl
  cmp $18, %cl
  jbe readloop
  mov $1, %cl
  add $1, %dh
  cmp $2, %dh
  jb readloop
  mov $0, %dh
  add $1, %ch
  cmp $CYLS, %ch
  jb readloop

kernel:
  // 跳转到kernel
  mov %ch, (0x0ff0)
  jmp 0xc400

error:
  mov $msg, %si
#  jmp kernel

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
  .ascii "load, error"
  .byte 0x0a
  .byte 0

  .org 510 # 填充为0
  .byte 0x55, 0xaa
