src=hello.s
obj=hello.o
elf=hello.elf
bootstarp=bootstarp.img

all:img

img:
	gcc -m32 -o $(obj) -c $(src)
	ld -m elf_i386 $(obj) -e start -Ttext 0x7c00 -o $(elf)
	objcopy -S -O binary -j .text $(elf) $(bootstarp)

run:
	qemu-system-i386 -drive file=$(bootstarp),index=0,media=disk,format=raw

clean:
	-rm -f $(obj) $(elf) $(bootstarp)