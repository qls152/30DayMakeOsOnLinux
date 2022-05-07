src = head.s
head = head.bin
kernel = kernel.bin

obj = main.o


all:img

img:$(src) $(kernel)
	nasm -f bin -o $(head) $(src)

%.o : %.c 
	gcc -m32 -fno-builtin -fno-pie -o $@ -c $<

$(kernel): $(obj)
	ld -s -m elf_i386 -Ttext 0x1000 -o $(kernel) $(obj)

clean:
	-rm -f $(kernel) *.bin *.o