src = head.s
address = 0x1000
CFLAGS=-I.

kernelobj = kernel.bin 
head=head.bin

kernel = entry.o main.o naskfunc.o

all:$(kernelobj)

$(head):$(src) 
	nasm -f bin -o head.bin $(src)

entry.o:entry.s 
	nasm -f elf -o $@ $<

%.o:%.c 
	gcc -nostdinc -m32 -fno-pie -o $@ -c $<

$(kernelobj):$(kernel) $(head)
	ld -s -x -m elf_i386 -Ttext $(address) -o $(kernelobj) $(kernel)


clean:
	-rm -f $(obj) $(elf) $(boot) $(kernelobj) kernel.bin *.o