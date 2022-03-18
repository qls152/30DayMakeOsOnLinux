src = head.s
obj = head.bin
kernel = kernel.bin
all:img

img:$(src)
	nasm -f bin -o $(kernel) $(src)
	#ld -s -m elf_i386 -Ttext 0x1000 -o $(kernel) $(obj) --oformat binary

clean:
	-rm -f $(kernel)