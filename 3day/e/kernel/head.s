; haribote-os boot asm
; TAB=4
 org 0x1000

; BOOT_INFO相关
CYLS	equ	0x0ff0			; 引导扇区设置
LEDS	equ	0x0ff1
VMODE	equ	0x0ff2			; 关于颜色的信息
SCRNX	equ	0x0ff4			; 分辨率X
SCRNY	equ	0x0ff6			; 分辨率Y
VRAM	equ	0x0ff8			; 图像缓冲区的起始地址
KERNEL_OFFSET equ 0x1000
[bits 16]
  ;如下操作进行清屏
  mov ax, 0x0600
  mov bx, 0x0700
  mov cx, 0
  mov dx, 0x184f
  int 0x10
  mov bp, 0x9000
  mov sp, bp

  mov bx, KERNEL_OFFSET ; 读磁盘, 文件读入[es:bx]

  mov ax, 0x1000 
  mov es, ax
  mov ch, 0 ; 柱面0
  mov dh, 0  ; 磁头0 
  mov cl, 6  ; 扇区6

readloop:
  mov si, 0 ;记录失败次数的寄存器

retry:
  mov ah, 0x02
  mov al, 0x1
  ;mov bx, 0x0
  mov dl, 0x00
  int 0x13
  jnc next
  add si, 1
  cmp si, 5
  jae fin
  mov ah, 0x00
  mov dl, 0x00
  int 0x13
  jmp retry
next:
  mov ax, es 
  add ax, 0x0020
  mov es, ax
  add cl, 1
  cmp cl, 14
  jbe readloop

  ; VGA显卡，320x200x8bit
  mov al,0x13			
  mov ah,0x00
  int 0x10
  ; 屏幕的模式（参考C语言的引用）
  mov byte [VMODE], 8	
  mov word [SCRNX], 320
  mov word [SCRNY], 200
  mov dword [VRAM], 0x000a0000

; 通过BIOS获取指示灯状态
  mov ah,0x02
  int 0x16 			; keyboard BIOS
  mov [LEDS],al
  
; 防止PIC接受所有中断
;	AT兼容机的规范、PIC初始化
;	然后之前在CLI不做任何事就挂起
;	PIC在同意后初始化

  mov al, 0xff
  out 0x21, al
  nop	; 不断执行OUT指令
  out 0xa1, al

  cli ; 进一步中断CPU

; 让CPU支持1M以上内存、设置A20GATE

  call	waitkbdout
  mov	al, 0xd1
  out	0x64, al
  call	waitkbdout
  mov	al, 0xdf ; enable A20
  out	0x60, al
  call	waitkbdout

  call switch_to_pm
  jmp $

[bits 16]
switch_to_pm:
    cli ; 
    lgdt [gdt_descriptor] ; 
    mov eax, cr0
    or eax, 0x1 ; 
    mov cr0, eax
    jmp dword CODE_SEG:init_pm

[bits 32]
init_pm:
    mov ax, DATA_SEG 
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM 

BEGIN_PM:
    ;mov ebx, MSG_PROT_MODE
    ;call print_string_pm
    call KERNEL_OFFSET
    jmp $

gdt_start:
    dd 0x0 
    dd 0x0

gdt_code: 
    dw 0xffff    ; segment length, bits 0-15
    dw 0x0       ; segment base, bits 0-15
    db 0x0       ; segment base, bits 16-23
    db 10011010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

waitkbdout:
  in  al, 0x64
  and al, 0x02
  jnz waitkbdout		; AND结果不为0跳转到waitkbdout

fin:
  hlt 
  jmp fin

