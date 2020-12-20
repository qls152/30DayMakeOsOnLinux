src = head.s
obj = head.o
elf = head.elf
boot = head.out
kernel_out=kernel.out

# 这个程序被装载到的程序的地址
address = 0xc400

CFLAGS=-I.  -fno-stack-protector

kernelobj = main.o naskfunc.o

%.o:%.c
	gcc -nostdinc $(CFLAGS) -c $< -m32 -o $@

%.o:%.s
	gcc -nostdinc $(CFLAGS) -c $< -m32 -o $@

all:head main
	cat main.out >> $(boot)
	mv $(boot) $(kernel_out)

head:head.o
main:$(kernelobj)
head:
	ld -m elf_i386 $(obj) -e start -Ttext $(address) -o $(elf)
	objcopy -S -O binary -j .text $(elf) $(boot)
main:
	ld -m elf_i386 $(obj) -e bootmain -T kernel.ld -o main.elf $(kernelobj)
	objcopy -S -O binary  main.elf main.out

clean:
	-rm -f $(obj) $(elf) $(boot)