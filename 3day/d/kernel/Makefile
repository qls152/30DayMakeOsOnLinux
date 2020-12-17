src = head.s
obj = head.o
elf = head.elf
boot = kernel.out

# 这个程序被装载到的程序的地址
address = 0xc200

CFLAGS=-I.  -fno-stack-protector

all:img

img:$(src)
	gcc -nostdinc $(CFLAGS) -m32 -o $(obj) -c $(src) 
	ld -m elf_i386 $(obj) -e start -Ttext $(address) -o $(elf)
	objcopy -S -O binary -j .text $(elf) $(boot)

clean:
	-rm -f $(obj) $(elf) $(boot)