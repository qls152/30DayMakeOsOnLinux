 org 0x100

 BaseOfStack equ 0x800
 KERNEL_OFFSET equ 0x1000
 BaseOfKernelFilePhyAddr equ 0x90000

[bits 16]
	mov	sp, BaseOfStack

  ;如下操作进行清屏
  mov ax, 0x0600
  mov bx, 0x0700
  mov cx, 0
  mov dx, 0x184f
  int 0x10

  mov ah, 0x0e
  mov al, 'L'
  int 0x10
  
  lgdt [gdt_descriptor]

  cli

  in	al, 0x92
	or	al, 0x2
	out	0x92, al  
  
  mov eax, cr0
  and eax, 0x7fffffff  ; 设置bit31为0，禁止分页
  or eax, 0x1  
  mov cr0, eax
    
  call init_pm
  jmp $ 

[bits 32]
init_pm:  
    mov ax, DATA_SEG  
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax

    mov ebp, 0x90000  
    mov esp, ebp
    jmp $
    call	InitKernel
    jmp dword CODE_SEG:KERNEL_OFFSET  
    jmp $ 

InitKernel:	 
	xor	esi, esi
	mov	cx, word [BaseOfKernelFilePhyAddr + 2Ch]; 
	movzx	ecx, cx					 
	mov	esi, [BaseOfKernelFilePhyAddr + 1Ch] 
	add	esi, BaseOfKernelFilePhyAddr	 
.Begin:
	mov	eax, [esi + 0]
	cmp	eax, 0			 
	jz	.NoAction
	push	dword [esi + 010h]		 
	mov	eax, [esi + 04h]	 
	add	eax, BaseOfKernelFilePhyAddr 
	push	eax				 
	push	dword [esi + 08h]	 
	call	MemCpy			 
	add	esp, 12			 
.NoAction:
	add	esi, 020h		 
	dec	ecx
	jnz	.Begin

	ret

MemCpy:
	push	ebp
	mov	ebp, esp

	push	esi
	push	edi
	push	ecx

	mov	edi, [ebp + 8]	; Destination
	mov	esi, [ebp + 12]	; Source
	mov	ecx, [ebp + 16]	; Counter
.1:
	cmp	ecx, 0		; 判断计数器
	jz	.2		; 计数器为零时跳出

	mov	al, [ds:esi]		; ┓
	inc	esi			; ┃
					; ┣ 逐字节移动
	mov	byte [es:edi], al	; ┃
	inc	edi			; ┛

	dec	ecx		; 计数器减一
	jmp	.1		; 循环
.2:
	mov	eax, [ebp + 8]	; 返回值

	pop	ecx
	pop	edi
	pop	esi
	mov	esp, ebp
	pop	ebp

	ret			; 函数结束，返回  

waitkbdout:
		in		 al,0x64
		and		 al,0x02
		jnz		waitkbdout		; AND结果不为0跳转到waitkbdout
		ret

gdt_start: 
    dd 0x0  
    dd 0x0  

gdt_code: 
    dw 0xffff    
    dw 0x0       
    db 0x0       
    db 10011010b  
    db 11001111b  
    db 0x0       

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0
gdt_video:
    dw 0xffff
    dw 0x8000
    db 0x0b
    db 0x92
    db 0x60
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  
    dd gdt_start  

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
VIDEO_SEG equ gdt_video - gdt_start + 3