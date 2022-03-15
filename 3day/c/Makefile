
all:floppy.img

bin = boot
ASFLAGS = -f bin
$(bin): ipl10.s
	nasm $(ASFLAGS) -o $@ $<
 
floppy.img: $(bin)
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=$< of=$@ bs=512 conv=notrunc
 
.PHONY: clean
clean:
	rm -f $(bin) floppy.img
 
.PHONY: run
run: floppy.img
	qemu-system-i386 -fda $<
	# gcc -m32  -ffreestanding -o $(obj) -c $(src) -curses
	# ld -m elf_i386 $(obj) -o $(elf) --oformat binary
