
subdir = kernel

head = kernel.bin
bootstarp = bootstarp.bin
kernel = kernel.img
ASFLAGS = -f bin

all:floppy.img

$(head):
	$(MAKE) -C $(subdir)
	cd $(subdir);mv kernel.bin ../

$(bootstarp): bootstarp.s
	nasm $(ASFLAGS) -o $@ $<
 
floppy.img: $(bootstarp) $(head)
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=$(bootstarp) of=$@ bs=512 conv=notrunc
	dd if=$(head) of=$@ bs=512 seek=2 conv=notrunc
	#dd if=$(head) of=$@ bs=512 seek=6 conv=notrunc

makefat12:  
	mkdir -p /tmp/floppy
	sudo mount -o loop floppy.img /tmp/floppy -o fat=12
	sleep 1
	#sudo cp $(head) /tmp/floppy
	#sleep 1
	sudo umount /tmp/floppy

.PHONY: clean
clean:
	rm -f $(bootstarp) $(kernel) $(head) floppy.img head.bin
	cd $(subdir);make clean
 
.PHONY: run
run: floppy.img
	qemu-system-i386 -fda $<
