BOTPAK	EQU		0x00280000		; 加载bootpack
DSKCAC	EQU		0x00100000		; 磁盘缓存的位置
DSKCAC0	EQU		0x00008000		; 磁盘缓存的位置（实模式）
 
 CYLS   equ 0x0ff0
 LEDS   equ 0x0ff1
 VMODE  equ 0x0ff2
 SCRNX  equ 0x0ff4
 SCRNY  equ 0x0ff6
 VRAM   equ 0x0ff8

 org 0x100
[bits 16]
start:
  jmp entry

entry:
  mov ax, 0
  mov ds, ax
  mov es, ax
  mov ss, ax

  ;如下操作进行清屏
  mov ax, 0x0600
  mov bx, 0x0700
  mov cx, 0
  mov dx, 0x184f
  int 0x10

  mov ah, 0x0e
  mov al, 'L'
  int 0x10

  mov al, 0x13
  mov ah, 0x00
  int 0x10
  mov byte [VMODE], 8
  mov word [SCRNX], 320
  mov word [SCRNY], 200
  mov dword [VRAM], 0x000a0000

  mov ah, 0x02
  int 0x16
  mov [LEDS], al

  mov al, 0xff
  out 0x21, al
  nop 
  out 0xa1, al 
  cli ;禁止cpu级别的中断

  call waitkbdout
  mov al, 0xd1
  out 0x64, al 
  call waitkbdout
  mov al, 0xdf
  out 0x60, al,
  call waitkbdout

  lgdt [GDTR0]
  mov eax, cr0
  and eax, 0x7fffffff
  or  eax, 0x00000001
  mov cr0, eax 
  jmp dword 2*8:pipelineflush

[bits 32]
pipelineflush:
  mov   ax, 1*8
  mov   ds, ax 
  mov   es, ax 
  mov   fs, ax 
  mov   gs, ax 
  mov   ss, ax 
  mov   esp, start

  mov   esi, bootmain
  mov   edi, BOTPAK
  mov   ecx, 512*1024/4
  call  memcpy

  mov		esi, 0x7c00		; 源
	mov		edi, DSKCAC		; 目标
	mov		ecx, 512/4
	call	memcpy

  mov		esi,   DSKCAC0+512	; 源
	mov		edi,   DSKCAC+512	; 目标
	mov		ecx,   0
	mov		cl,    BYTE [CYLS]
	imul	ecx,   512*18*2/4	; 除以4得到字节数
	sub		ecx,   512/4		; IPL偏移量
	call	memcpy 

  mov		ebx,  BOTPAK
	mov		ecx,  [ebx+16]
	add		ecx,  3			; ECX += 3;
	shr		ecx,  2			; ECX /= 4;
	jz		skip			; 传输完成
	mov		esi,  [ebx+20]	; 源
	add		esi,  ebx
	mov		edi,  [ebx+12]	; 目标
	call 	memcpy

skip:
	mov		esp,[ebx+12]	; 堆栈的初始化
	jmp		dword  2*8:0x0001b

waitkbdout:
	in		 al,0x64
	and		 al,0x02
	jnz		 waitkbdout		; AND结果不为0跳转到waitkbdout
	ret

memcpy:
	mov		eax,[esi]
	add		esi,4
	mov		[edi],eax
	add		edi,4
	sub		ecx,1
	jnz		memcpy			; 运算结果不为0跳转到memcpy
	ret               ; memcpy地址前缀大小

align	16
GDT0:
		dw 0x0000,0x0000,0x0000,0x0000 ; null
    dw 0xffff,0x0000,0x9200,0x00cf ; 写32位段寄存器
    dw 0xffff,0x0000,0x9a28,0x0047 ; 可执行文件的32bit寄存器（botpack用）
    dw 0x00

GDTR0:
		dw		23
		dd		GDT0

align	16
bootmain:
