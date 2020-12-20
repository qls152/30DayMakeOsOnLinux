/*
关于ld的脚本编写可以参考 程序员的自我修养 一书
*/

OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(bootmain)

SECTIONS
{
	/* Link the kernel at this address: "." means the current address */
	. = 0x001b;
	.text :  {
		*(.text)
	}
	.rodata : {
		*(.rodata)
	}

	.data : {
		*(.data)
	}

	.bss : {
		*(.bss)
	}


}