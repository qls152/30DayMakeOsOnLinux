extern inthandler21, inthandler27, inthandler2c
global load_gdtr, load_idtr
global asm_inthandler21, asm_inthandler27, asm_inthandler2c

load_gdtr:		; void load_gdtr(int limit, int addr);
	MOV	AX,[ESP+4]		; limit
	MOV	[ESP+6],AX
	LGDT	[ESP+6]
	RET

load_idtr:		; void load_idtr(int limit, int addr);
	MOV	AX,[ESP+4]		; limit
	MOV	[ESP+6],AX
	LIDT	[ESP+6]
	RET

asm_inthandler21:
	CALL	inthandler21
	iretd 

asm_inthandler27:
	CALL	inthandler27
	iretd

asm_inthandler2c:
	CALL	inthandler2c
	IRETD