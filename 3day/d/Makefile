src=bootstarp.s
obj=bootstarp.o
elf=bootstarp.elf
bootstarp=bootstarp.img

subdir = kernel

all:img

img:subsystem
	gcc -m32 -o $(obj) -c $(src)
	ld -m elf_i386 $(obj) -e start -Ttext 0x7c00 -o $(elf)
	objcopy -S -O binary -j .text $(elf) $(bootstarp)
	cd $(subdir);mv kernel.out ../

subsystem:
	$(MAKE) -C $(subdir)

run:
	qemu-system-i386 -drive file=$(bootstarp),index=0,media=disk,format=raw

clean:
	-rm -f $(obj) $(elf) $(bootstarp)