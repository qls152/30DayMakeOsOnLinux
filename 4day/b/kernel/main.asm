
main.elf：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <bootmain>:
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 ec 18             	sub    $0x18,%esp
   a:	e8 f7 00 00 00       	call   106 <__x86.get_pc_thunk.ax>
   f:	05 e1 01 00 00       	add    $0x1e1,%eax
  14:	e8 34 00 00 00       	call   4d <init_palette>
  19:	c7 45 f0 00 00 0a 00 	movl   $0xa0000,-0x10(%ebp)
  20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  27:	eb 18                	jmp    41 <bootmain+0x41>
  29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2c:	89 c1                	mov    %eax,%ecx
  2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  34:	01 d0                	add    %edx,%eax
  36:	83 e1 0f             	and    $0xf,%ecx
  39:	89 ca                	mov    %ecx,%edx
  3b:	88 10                	mov    %dl,(%eax)
  3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  41:	81 7d f4 ff ff 00 00 	cmpl   $0xffff,-0xc(%ebp)
  48:	7e df                	jle    29 <bootmain+0x29>
  4a:	f4                   	hlt    
  4b:	eb fd                	jmp    4a <bootmain+0x4a>

0000004d <init_palette>:
  4d:	f3 0f 1e fb          	endbr32 
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	83 ec 08             	sub    $0x8,%esp
  57:	e8 aa 00 00 00       	call   106 <__x86.get_pc_thunk.ax>
  5c:	05 94 01 00 00       	add    $0x194,%eax
  61:	83 ec 04             	sub    $0x4,%esp
  64:	8d 80 d0 ff ff ff    	lea    -0x30(%eax),%eax
  6a:	50                   	push   %eax
  6b:	6a 0f                	push   $0xf
  6d:	6a 00                	push   $0x0
  6f:	e8 06 00 00 00       	call   7a <set_palette>
  74:	83 c4 10             	add    $0x10,%esp
  77:	90                   	nop
  78:	c9                   	leave  
  79:	c3                   	ret    

0000007a <set_palette>:
  7a:	f3 0f 1e fb          	endbr32 
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  81:	83 ec 10             	sub    $0x10,%esp
  84:	e8 7d 00 00 00       	call   106 <__x86.get_pc_thunk.ax>
  89:	05 67 01 00 00       	add    $0x167,%eax
  8e:	9c                   	pushf  
  8f:	58                   	pop    %eax
  90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  96:	89 45 f8             	mov    %eax,-0x8(%ebp)
  99:	fa                   	cli    
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	ba c8 03 00 00       	mov    $0x3c8,%edx
  a2:	ee                   	out    %al,(%dx)
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  a9:	eb 44                	jmp    ef <set_palette+0x75>
  ab:	8b 45 10             	mov    0x10(%ebp),%eax
  ae:	0f b6 00             	movzbl (%eax),%eax
  b1:	c0 e8 02             	shr    $0x2,%al
  b4:	0f b6 c0             	movzbl %al,%eax
  b7:	ba c9 03 00 00       	mov    $0x3c9,%edx
  bc:	ee                   	out    %al,(%dx)
  bd:	8b 45 10             	mov    0x10(%ebp),%eax
  c0:	83 c0 01             	add    $0x1,%eax
  c3:	0f b6 00             	movzbl (%eax),%eax
  c6:	c0 e8 02             	shr    $0x2,%al
  c9:	0f b6 c0             	movzbl %al,%eax
  cc:	ba c9 03 00 00       	mov    $0x3c9,%edx
  d1:	ee                   	out    %al,(%dx)
  d2:	8b 45 10             	mov    0x10(%ebp),%eax
  d5:	83 c0 02             	add    $0x2,%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	c0 e8 02             	shr    $0x2,%al
  de:	0f b6 c0             	movzbl %al,%eax
  e1:	ba c9 03 00 00       	mov    $0x3c9,%edx
  e6:	ee                   	out    %al,(%dx)
  e7:	83 45 10 03          	addl   $0x3,0x10(%ebp)
  eb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  f5:	7e b4                	jle    ab <set_palette+0x31>
  f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 100:	50                   	push   %eax
 101:	9d                   	popf   
 102:	90                   	nop
 103:	90                   	nop
 104:	c9                   	leave  
 105:	c3                   	ret    

Disassembly of section .text.__x86.get_pc_thunk.ax:

00000106 <__x86.get_pc_thunk.ax>:
 106:	8b 04 24             	mov    (%esp),%eax
 109:	c3                   	ret    

Disassembly of section .eh_frame:

0000010c <.eh_frame>:
 10c:	14 00                	adc    $0x0,%al
 10e:	00 00                	add    %al,(%eax)
 110:	00 00                	add    %al,(%eax)
 112:	00 00                	add    %al,(%eax)
 114:	01 7a 52             	add    %edi,0x52(%edx)
 117:	00 01                	add    %al,(%ecx)
 119:	7c 08                	jl     123 <__x86.get_pc_thunk.ax+0x1d>
 11b:	01 1b                	add    %ebx,(%ebx)
 11d:	0c 04                	or     $0x4,%al
 11f:	04 88                	add    $0x88,%al
 121:	01 00                	add    %eax,(%eax)
 123:	00 18                	add    %bl,(%eax)
 125:	00 00                	add    %al,(%eax)
 127:	00 1c 00             	add    %bl,(%eax,%eax,1)
 12a:	00 00                	add    %al,(%eax)
 12c:	d4 fe                	aam    $0xfe
 12e:	ff                   	(bad)  
 12f:	ff 4d 00             	decl   0x0(%ebp)
 132:	00 00                	add    %al,(%eax)
 134:	00 45 0e             	add    %al,0xe(%ebp)
 137:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 13d:	00 00                	add    %al,(%eax)
 13f:	00 1c 00             	add    %bl,(%eax,%eax,1)
 142:	00 00                	add    %al,(%eax)
 144:	38 00                	cmp    %al,(%eax)
 146:	00 00                	add    %al,(%eax)
 148:	05 ff ff ff 2d       	add    $0x2dffffff,%eax
 14d:	00 00                	add    %al,(%eax)
 14f:	00 00                	add    %al,(%eax)
 151:	45                   	inc    %ebp
 152:	0e                   	push   %cs
 153:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 159:	65 c5 0c 04          	lds    %gs:(%esp,%eax,1),%ecx
 15d:	04 00                	add    $0x0,%al
 15f:	00 1c 00             	add    %bl,(%eax,%eax,1)
 162:	00 00                	add    %al,(%eax)
 164:	58                   	pop    %eax
 165:	00 00                	add    %al,(%eax)
 167:	00 12                	add    %dl,(%edx)
 169:	ff                   	(bad)  
 16a:	ff                   	(bad)  
 16b:	ff 8c 00 00 00 00 45 	decl   0x45000000(%eax,%eax,1)
 172:	0e                   	push   %cs
 173:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 179:	02 84 c5 0c 04 04 00 	add    0x4040c(%ebp,%eax,8),%al
 180:	10 00                	adc    %al,(%eax)
 182:	00 00                	add    %al,(%eax)
 184:	78 00                	js     186 <__x86.get_pc_thunk.ax+0x80>
 186:	00 00                	add    %al,(%eax)
 188:	7e ff                	jle    189 <__x86.get_pc_thunk.ax+0x83>
 18a:	ff                   	(bad)  
 18b:	ff 04 00             	incl   (%eax,%eax,1)
 18e:	00 00                	add    %al,(%eax)
 190:	00 00                	add    %al,(%eax)
	...

Disassembly of section .note.gnu.property:

00000194 <.note.gnu.property>:
 194:	04 00                	add    $0x0,%al
 196:	00 00                	add    %al,(%eax)
 198:	0c 00                	or     $0x0,%al
 19a:	00 00                	add    %al,(%eax)
 19c:	05 00 00 00 47       	add    $0x47000000,%eax
 1a1:	4e                   	dec    %esi
 1a2:	55                   	push   %ebp
 1a3:	00 02                	add    %al,(%edx)
 1a5:	00 00                	add    %al,(%eax)
 1a7:	c0 04 00 00          	rolb   $0x0,(%eax,%eax,1)
 1ab:	00 03                	add    %al,(%ebx)
 1ad:	00 00                	add    %al,(%eax)
	...

Disassembly of section .data:

000001c0 <table_rgb.1531>:
 1c0:	00 00                	add    %al,(%eax)
 1c2:	00 ff                	add    %bh,%bh
 1c4:	00 00                	add    %al,(%eax)
 1c6:	00 ff                	add    %bh,%bh
 1c8:	00 ff                	add    %bh,%bh
 1ca:	ff 00                	incl   (%eax)
 1cc:	00 00                	add    %al,(%eax)
 1ce:	ff                   	(bad)  
 1cf:	ff 00                	incl   (%eax)
 1d1:	ff 00                	incl   (%eax)
 1d3:	ff                   	(bad)  
 1d4:	ff                   	(bad)  
 1d5:	ff                   	(bad)  
 1d6:	ff                   	(bad)  
 1d7:	ff c6                	inc    %esi
 1d9:	c6 c6 84             	mov    $0x84,%dh
 1dc:	00 00                	add    %al,(%eax)
 1de:	00 84 00 84 84 00 00 	add    %al,0x8484(%eax,%eax,1)
 1e5:	00 84 84 00 84 00 84 	add    %al,-0x7bff7c00(%esp,%eax,4)
 1ec:	84                   	.byte 0x84
 1ed:	84                   	.byte 0x84
 1ee:	84                   	.byte 0x84
 1ef:	84                   	.byte 0x84

Disassembly of section .got.plt:

000001f0 <_GLOBAL_OFFSET_TABLE_>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 55 62             	sub    %dl,0x62(%ebp)
   8:	75 6e                	jne    78 <init_palette+0x2b>
   a:	74 75                	je     81 <set_palette+0x7>
   c:	20 39                	and    %bh,(%ecx)
   e:	2e 33 2e             	xor    %cs:(%esi),%ebp
  11:	30 2d 31 37 75 62    	xor    %ch,0x62753731
  17:	75 6e                	jne    87 <set_palette+0xd>
  19:	74 75                	je     90 <set_palette+0x16>
  1b:	31 7e 32             	xor    %edi,0x32(%esi)
  1e:	30 2e                	xor    %ch,(%esi)
  20:	30 34 29             	xor    %dh,(%ecx,%ebp,1)
  23:	20 39                	and    %bh,(%ecx)
  25:	2e 33 2e             	xor    %cs:(%esi),%ebp
  28:	30 00                	xor    %al,(%eax)
