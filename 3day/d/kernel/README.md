在进行head.s编写的时候碰到的坑

利用.equ VMODE 0x1000

此时gas会报错，最后查看网上相关原因 主要是equ无法识别十六进制

此时应该用.set 相当于#define