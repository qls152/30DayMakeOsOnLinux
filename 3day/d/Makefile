
subdir = kernel

head = head.bin
bootstarp = bootstarp.bin
kernel = kernel.img
ASFLAGS = -f bin

all:floppy.img

$(head):
	$(MAKE) -C $(subdir)
	cd $(subdir);mv head.bin ../$(head)

$(bootstarp): bootstarp.s
	nasm $(ASFLAGS) -o $@ $<
	#cat $(bootstarp) $(head) > $@
 
floppy.img: $(bootstarp) $(head)
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=$(bootstarp) of=$@ bs=512 conv=notrunc
	#dd if=$(head) of=$@ bs=512 seek=2 conv=notrunc

makefat12: $(head)  
	mkdir -p /tmp/floppy
	sudo mount -o loop floppy.img /tmp/floppy -o fat=12
	sleep 1
	sudo cp $(head) /tmp/floppy
	sleep 1
	sudo umount /tmp/floppy

.PHONY: clean
clean:
	rm -f $(bootstarp) $(kernel) $(head) floppy.img
 
.PHONY: run
run: floppy.img
	qemu-system-i386 -fda $<
	# gcc -m32  -ffreestanding -o $(obj) -c $(src)
	# ld -m elf_i386 $(obj) -o $(elf) --oformat binary
