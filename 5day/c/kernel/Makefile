src=head.S
obj=head.o
elf=head.elf
boot=head.out
address=0xc400

CFLAGS := -I. -fno-stack-protector
CFLAGS += -m32

kernelobj=main.o print.o

all: head main
	cat main.out >> $(boot)
	mv $(boot)  kernel.out

%.o:%.c
	gcc -nostdinc $(CFLAGS) -c $< -o $@

%.o:%.S
	gcc -nostdinc $(CFLAGS) -c $< -o $@

head:$(obj)
	ld -m elf_i386 $(obj) -e start -Ttext $(address) -o $(elf)
	objcopy -S -O binary -j .text $(elf)  $(boot)

main:$(kernelobj)
	ld -m elf_i386  -e bootmain -T kernel.ld -o main.elf $(kernelobj)
	objcopy  -S -O binary  $@.elf $@.out


clean:
	-rm -f $(obj) $(elf) $(boot) main.elf main.out *.o *.asm