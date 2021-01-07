.set CYLS,  0x0ff0 # CYLS设定启动区
.set LEDS,  0x0ff1
.set VMODE, 0x0ff2 # VMODE 关于颜色数目的信息，颜色的位数
.set SCRNX, 0x0ff4 # 分辨率X
.set SCRNY, 0x0ff6 # 分辨率Y
.set VRAM,  0x0ff8 # VRAM图像缓冲区的开始地址

.set BOTPAK, 0x00280000 #加载bootpack
.set DSKCAC, 0x00100000 #磁盘缓存的位置
.set DSKCAC0, 0x00008000 #磁盘缓存的位置（实模式）

.global start
.code16  
start:
  jmp entry

entry:
  mov $0, %ax
  mov %ax, %ds
  mov %ax, %es
  mov %ax, %ss

  mov $0x13, %al # VGA显卡，320 * 200 * 8位彩色
  mov $0x00, %ah
  int $0x10
  
  movb $10, (CYLS)
  movb $8, (VMODE) #记录画面模式
  movw $320, (SCRNX)
  movw $200, (SCRNY)
  movl $0x000a0000, (VRAM)
  
  movb $0x02, %ah # 用BIOS取得键盘上各种LED指示灯的状态
  int $0x16
  movb %al, (LEDS) 

  # 此处是30天自制操作系统由实模式转到保护模式所添加的100多行代码

  # 防止PIC接受所有中断
  # AT兼容规范，PIC初始化
  # 然后之前在CLI不做任何事就挂起
  # PIC在同意后初始化
  movb 0xff, %al
  outb %al, $0x21
  nop # 不断执行out指令
  outb %al, $0xa1
  cli # 进一步关闭中断

  # 让CPU支持1M以上的内存，设置A20GATE
  call waitbkdout
  mov $0xd1, %al
  outb %al, $0x64
  call waitbkdout
  mov $0xdf, %al # enable A20
  outb %al, $0x60
  call waitbkdout


  # 打开CR0的bit0后，便切换至32位
  # 注 此处可以参考linux0.11的实现方式，利用gas的lmsw命令进行简化，为了与30天自制OS一致，便未做修改
  lgdt gdtr0 # 利用lgdt指令设置GDTR寄存器
  movl %cr0, %eax
  andl $0x7fffffff, %eax # 设置bit31为0，禁止分页
  orl  $0x00000001, %eax # 设置cr0 bit0为1，切换到32位模式，此后的命令便处于32位模式
  movl %eax, %cr0
  ljmp $(2*8), $pipelineflush

.code32
pipelineflush:
  movw $(1*8), %ax
  movw %ax, %ds
  movw %ax, %es
  movw %ax, %fs
  movw %ax, %gs
  movw %ax, %ss
  
  // movl $start, %esp
  
  #bootpack传递
  movl $bootmain, %esi # 源
  movl $BOTPAK, %edi # 目的
  movl $(512*1024/4), %ecx
  call memcpy

  # 传输磁盘数据
  # 从引导区开始
  movl $0x7c00, %esi
  movl $DSKCAC, %edi
  movl $(512/4), %ecx
  call memcpy

  # 剩余的全部数据
  movl $(DSKCAC0 + 512), %esi
  movl $(DSKCAC + 512), %edi
  movl $0, %ecx
  movb (CYLS), %cl
  imul $(512*18*2/4), %ecx
  subl $(512/4), %ecx
  call memcpy

  # bootpack启动
  movl $BOTPAK, %ebx
  movl 16(%ebx), %ecx
  addl $3, %ecx
  shr $2, %ecx
  jz skip
  movl 20(%ebx), %esi
  addl %ebx, %esi
  movl 12(%ebx), %edi
  call memcpy

skip:
  movl 12(%ebx), %esp
  ljmp $(2*8), $0x0000
  jmp .

waitbkdout:
  inb $0x64, %al
  testb $0x02, %al 
  jnz waitbkdout
  ret

# 注 该处可以利用movsw与movsb进行简化，本次为了与30天自制OS一致便未做修改
memcpy:
  movl (%esi), %eax
  addl $4, %esi
  movl %eax, (%edi)
  addl $4, %edi
  subl $1, %ecx
  jnz memcpy # 运算结果不为0 跳转memcpy
  ret 

.align 4
gdt:
  .word 0x0000,0x0000,0x0000,0x0000 # null
  .word 0xffff,0x0000,0x9200,0x00cf # 写32位段寄存器
  .word 0xffff,0x0000,0x9a00,0x0047 # 增加代码段，用在16位--》32位转换
  .word 0xffff,0x0000,0x9a28,0x0047 # 可执行文件的32bit寄存器（botpack用）
  .word 0x00

gdtr0:
  .word 31
  .long gdt

.align 4
bootmain:
