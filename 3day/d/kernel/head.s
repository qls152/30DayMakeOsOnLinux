//设定启动区
.set CYLS,  0x0ff0 
.set LEDS,  0x0ff1
//关于颜色数目的信息，颜色的位数 
.set VMODE, 0x0ff2
.set SCRNX, 0x0ff4
.set SCRNY, 0x0ff6
//图像缓冲区的开始地址
.set VRAM,  0x0ff8

.global start
.code16  
start:
  xorw %ax, %ax
  xorw %cx, %cx
  // VGA显卡，320 * 200 * 8位彩色
  mov $0x13, %al
  mov $0x00, %ah
  int $0x10
  
  //记录画面模式
  movb $8, (VMODE) 
  movw $320, (SCRNX)
  movw $200, (SCRNY)
  movl $0x000a0000, (VRAM)
  
  // 用BIOS取得键盘上各种LED指示灯的状态
  mov $0x02, %ah
  int $0x16
  mov %al, (LEDS) 

fin:
  hlt
  jmp fin
