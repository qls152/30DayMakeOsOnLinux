#include "naskfunc.h"
#include "head.h"

void init_pic(void) {
    outb(PIC0_IMR, 0xff); //禁止所有中断
    outb(PIC1_IMR, 0xff);

    outb(PIC0_ICW1, 0x11); //边沿触发模式
    outb(PIC0_ICW2, 0x20); // IRQ0-7由INT20-27接收
    outb(PIC0_ICW3, 1 << 2); // PIC1由IRQ2连接
    outb(PIC0_ICW4, 0x01); // 无缓冲模式

    outb(PIC1_ICW1, 0x11  ); // 边缘触发模式（edge trigger mode） 
    outb(PIC1_ICW2, 0x28  ); // IRQ8-15由INT28-2f接收 
    outb(PIC1_ICW3, 2     ); // PIC1由IRQ2连接 
    outb(PIC1_ICW4, 0x01  ); // 无缓冲区模式 

    outb(PIC0_IMR,  0xfb  ); /* 11111011 PIC1以外全部禁止 */
    outb(PIC1_IMR,  0xff  ); /* 11111111 禁止所有中断 */

    return;
}

void inthandler21(int *esp) {
    BootInfo *binfo = (BootInfo *) ADR_BOOTINFO;
    boxfill8(binfo->vram, binfo->scrnx, COL8_000000, 0, 0, 32 * 8 - 1, 15);
    putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, "INT 21 (IRQ-1) : PS/2 keyboard");
    io_hlt();

}

/* 来自PS/2鼠标的中断 */
void inthandler2c(int *esp) {
    struct BOOTINFO *binfo = (struct BOOTINFO *) ADR_BOOTINFO;
    boxfill8(binfo->vram, binfo->scrnx, COL8_000000, 0, 0, 32 * 8 - 1, 15);
    putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, "INT 2C (IRQ-12) : PS/2 mouse");
    io_hlt();
}

/* PIC0中断的不完整策略 */
/* 这个中断在Athlon64X2上通过芯片组提供的便利，只需执行一次 */
/* 这个中断只是接收，不执行任何操作 */
/* 为什么不处理？
	 因为这个中断可能是电气噪声引发的、只是处理一些重要的情况。*/
void inthandler27(int *esp) {
    outb(PIC0_OCW2, 0x67); /* 通知PIC的IRQ-07（参考7-1） */
    return;
}


