obj=entry.o
elf=entry.elf
boot=entry.out
address=0xc400

CFLAGS := -I. -fno-stack-protector -fno-builtin
CFLAGS += -m32

kernelobj=main.o graphic.o print.o dsctbl.o asmint32.o int.o

all: head main
	cat main.out >> $(boot)
	mv $(boot)  kernel.out

%.o:%.c
	gcc -nostdinc $(CFLAGS) -c $< -o $@

%.o:%.S
	gcc -nostdinc $(CFLAGS) -c $< -o $@

%.o:%.asm
	nasm -f elf -o $@ $<

head:$(obj)
	ld -m elf_i386 $(obj) -e start -Ttext $(address) -o $(elf)
	objcopy -S -O binary -j .text $(elf)  $(boot)

main:$(kernelobj)
	ld -m elf_i386  -e bootmain -T kernel.ld -o main.elf $(kernelobj)
	objcopy  -S -O binary  $@.elf $@.out
clean:
	-rm -f *.elf *.out *.o