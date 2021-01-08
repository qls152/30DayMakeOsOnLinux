obj=entry.o
elf=entry.elf
boot=entry.out
asm=entry.asm
address=0xc400

CFLAGS := -I. -fno-stack-protector
CFLAGS += -m32

kernelobj=main.o graphic.o print.o dsctbl.o asmint32.o

all: head main
	cat main.out >> entry.out
	mv entry.out  kernel.out

%.o:%.c
	gcc -nostdinc $(CFLAGS) -c $< -o $@

%.o:%.S
	gcc -nostdinc $(CFLAGS) -c $< -o $@

head:entry.o
main:$(kernelobj)
head:
	ld -m elf_i386 $(obj) -e start -Ttext $(address) -o $(elf)
	objcopy -S -O binary -j .text $(elf)  $(boot)
	objdump -S $(elf) > $(asm)


main:
	@echo "addr=0x00"
	ld -m elf_i386  -e bootmain -T kernel.ld -o main.elf $(kernelobj)
	objdump -S -D $@.elf >$@.asm
	objcopy  -S -O binary  $@.elf $@.out


clean:
	-rm -f *.elf *.out *.o *.asm