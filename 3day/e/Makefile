src=bootstarp.s
obj=bootstarp.o
elf=bootstarp.elf
bootstarp=bootstarp.img
kernel_bin = kernel.out

subdir = kernel

all:img

img:subsystem
	gcc -m32 -o $(obj) -c $(src)
	ld -m elf_i386 $(obj) -e start -Ttext 0x7c00 -o $(elf)
	objcopy -S -O binary -j .text $(elf) $(bootstarp)
	cd $(subdir);mv kernel.out ../

subsystem:
	$(MAKE) -C $(subdir)

boot:
	@dd if=/dev/zero of=$(bootstarp) seek=2 count=2878

makefat12:   
	mkdir -p /tmp/floppy
	sudo mount -o loop $(bootstarp) /tmp/floppy -o fat=12
	sleep 1
	sudo cp $(kernel_bin) /tmp/floppy
	sleep 1
	sudo umount /tmp/floppy

run:
	make boot
	make makefat12
	qemu-system-i386 -drive file=$(bootstarp),index=0,media=disk,format=raw,if=floppy

clean:
	-rm -f $(obj) $(elf) $(bootstarp) $(haros) $(kernel_bin)
	cd $(subdir);make clean