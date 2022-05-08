src = head.s
kernel = kernel.bin
mainobj = main.out
mainelf = main.elf

CFLAGS=-I.  -fno-stack-protector
kernelobj = main.o naskfunc.o

all:head main
	cat main.out >> $(kernel)
head:$(src)
	nasm -f bin -o $(kernel) $(src)
main:$(kernelobj)
	ld -m elf_i386 -e bootmain -T kernel.ld -o $(mainelf) $(kernelobj)
	objcopy -S -O binary  $(mainelf) $(mainobj)
%.o:%.c
	gcc -nostdinc $(CFLAGS) -c $< -m32 -o $@

clean:
	-rm -f $(kernel) $(obj) *.elf *.o *.out