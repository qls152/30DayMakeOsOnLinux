# 说明
本次想要实现现实不同的字体，记录一下碰到的问题与解决方案

在该次实验中，直接参考
https://github.com/zchrissirhcz/osask-linux/blob/master/day5.6/kernel/main.c
会出现内存错误，即后续用qemu启动，操作系统工作不正常，具体原因我也不清楚，我猜测可能是内存写坏了吧

为了能利用font, 我先用gcc -E font.h.bak 进行预编译，用编译后的结果 作为字体，

这样就可以定义宏了

在main中直接引用font会导致黑屏，猜测可能是内存写坏了吧 具体我也没分析出来

但将其放在函数中便可以正确工作