src = head.s
obj = head.bin
all:img

img:$(src)
	nasm -f bin -o $(obj) $(src)

clean:
	-rm -f $(obj)