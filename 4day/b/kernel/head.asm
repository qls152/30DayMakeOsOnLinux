
head.elf：     文件格式 elf32-i386


Disassembly of section .text:

0000c400 <start>:
    c400:	eb 00                	jmp    c402 <entry>

0000c402 <entry>:
    c402:	b8 00 00 8e d8       	mov    $0xd88e0000,%eax
    c407:	8e c0                	mov    %eax,%es
    c409:	8e d0                	mov    %eax,%ss
    c40b:	b0 13                	mov    $0x13,%al
    c40d:	b4 00                	mov    $0x0,%ah
    c40f:	cd 10                	int    $0x10
    c411:	c6 06 f0             	movb   $0xf0,(%esi)
    c414:	0f 0a                	(bad)  
    c416:	c6 06 f2             	movb   $0xf2,(%esi)
    c419:	0f 08                	invd   
    c41b:	c7 06 f4 0f 40 01    	movl   $0x1400ff4,(%esi)
    c421:	c7 06 f6 0f c8 00    	movl   $0xc80ff6,(%esi)
    c427:	66 c7 06 f8 0f       	movw   $0xff8,(%esi)
    c42c:	00 00                	add    %al,(%eax)
    c42e:	0a 00                	or     (%eax),%al
    c430:	b4 02                	mov    $0x2,%ah
    c432:	cd 16                	int    $0x16
    c434:	a2 f1 0f a0 ff       	mov    %al,0xffa00ff1
    c439:	00 e6                	add    %ah,%dh
    c43b:	21 90 e6 a1 fa e8    	and    %edx,-0x17055e1a(%eax)
    c441:	92                   	xchg   %eax,%edx
    c442:	00 b0 d1 e6 64 e8    	add    %dh,-0x179b192f(%eax)
    c448:	8b 00                	mov    (%eax),%eax
    c44a:	b0 df                	mov    $0xdf,%al
    c44c:	e6 60                	out    %al,$0x60
    c44e:	e8 84 00 0f 01       	call   10fc4d7 <BOTPAK+0xe7c4d7>
    c453:	16                   	push   %ss
    c454:	0e                   	push   %cs
    c455:	c5 0f                	lds    (%edi),%ecx
    c457:	20 c0                	and    %al,%al
    c459:	66 25 ff ff          	and    $0xffff,%ax
    c45d:	ff                   	(bad)  
    c45e:	7f 66                	jg     c4c6 <pipelineflush+0x5b>
    c460:	83 c8 01             	or     $0x1,%eax
    c463:	0f 22 c0             	mov    %eax,%cr0
    c466:	ea                   	.byte 0xea
    c467:	6b c4 10             	imul   $0x10,%esp,%eax
	...

0000c46b <pipelineflush>:
    c46b:	66 b8 08 00          	mov    $0x8,%ax
    c46f:	8e d8                	mov    %eax,%ds
    c471:	8e c0                	mov    %eax,%es
    c473:	8e e0                	mov    %eax,%fs
    c475:	8e e8                	mov    %eax,%gs
    c477:	8e d0                	mov    %eax,%ss
    c479:	bc 00 c4 00 00       	mov    $0xc400,%esp
    c47e:	be 14 c5 00 00       	mov    $0xc514,%esi
    c483:	bf 00 00 28 00       	mov    $0x280000,%edi
    c488:	b9 00 00 02 00       	mov    $0x20000,%ecx
    c48d:	e8 4a 00 00 00       	call   c4dc <memcpy>
    c492:	be 00 7c 00 00       	mov    $0x7c00,%esi
    c497:	bf 00 00 10 00       	mov    $0x100000,%edi
    c49c:	b9 80 00 00 00       	mov    $0x80,%ecx
    c4a1:	e8 36 00 00 00       	call   c4dc <memcpy>
    c4a6:	be 00 82 00 00       	mov    $0x8200,%esi
    c4ab:	bf 00 02 10 00       	mov    $0x100200,%edi
    c4b0:	b9 00 00 00 00       	mov    $0x0,%ecx
    c4b5:	8a 0d f0 0f 00 00    	mov    0xff0,%cl
    c4bb:	69 c9 00 12 00 00    	imul   $0x1200,%ecx,%ecx
    c4c1:	81 e9 80 00 00 00    	sub    $0x80,%ecx
    c4c7:	e8 10 00 00 00       	call   c4dc <memcpy>

0000c4cc <skip>:
    c4cc:	ea 00 00 00 00 18 00 	ljmp   $0x18,$0x0
    c4d3:	eb fe                	jmp    c4d3 <skip+0x7>

0000c4d5 <waitbkdout>:
    c4d5:	e4 64                	in     $0x64,%al
    c4d7:	a8 02                	test   $0x2,%al
    c4d9:	75 fa                	jne    c4d5 <waitbkdout>
    c4db:	c3                   	ret    

0000c4dc <memcpy>:
    c4dc:	8b 06                	mov    (%esi),%eax
    c4de:	83 c6 04             	add    $0x4,%esi
    c4e1:	89 07                	mov    %eax,(%edi)
    c4e3:	83 c7 04             	add    $0x4,%edi
    c4e6:	83 e9 01             	sub    $0x1,%ecx
    c4e9:	75 f1                	jne    c4dc <memcpy>
    c4eb:	c3                   	ret    

0000c4ec <gdt>:
	...
    c4f4:	ff                   	(bad)  
    c4f5:	ff 00                	incl   (%eax)
    c4f7:	00 00                	add    %al,(%eax)
    c4f9:	92                   	xchg   %eax,%edx
    c4fa:	cf                   	iret   
    c4fb:	00 ff                	add    %bh,%bh
    c4fd:	ff 00                	incl   (%eax)
    c4ff:	00 00                	add    %al,(%eax)
    c501:	9a 47 00 ff ff 00 00 	lcall  $0x0,$0xffff0047
    c508:	28 9a 47 00 00 00    	sub    %bl,0x47(%edx)

0000c50e <gdtr0>:
    c50e:	1f                   	pop    %ds
    c50f:	00 ec                	add    %ch,%ah
    c511:	c4 00                	les    (%eax),%eax
	...
