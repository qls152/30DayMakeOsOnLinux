#include "naskfunc.h"
#include "print.h"
#include "head.h"

void auxmain(void);

void bootmain(void) {
  // init_pic();
  // sti(); /* IDT/PIC的初始化已经完成，于是开放CPU的中断 */
  auxmain();

  return;
}

void auxmain(void) {
  BootInfo *binfo = (BootInfo *)0x0ff0;
  char s[10], mcursor[256];
  init_gdtidt();
  init_pic();
  sti(); /* IDT/PIC的初始化已经完成，于是开放CPU的中断 */
  
  init_palette(); //设定调色板
  init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
  /* 显示鼠标 */
  int mx = (binfo->scrnx - 16) / 2; /* 计算画面的中心坐标*/
  int my = (binfo->scrny - 28 - 16) / 2;
  init_mouse_cursor8(mcursor, COL8_008484);
  putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
  
  sprintf(s, "scrnx = %d", binfo->scrnx);
  putfonts8_asc(binfo->vram, binfo->scrnx, 8, 8, COL8_FFFFFF, "ABC 123");
  putfonts8_asc(binfo->vram, binfo->scrnx, 31, 31, COL8_FFFFFF, "Hello MyOS");
  putfonts8_asc(binfo->vram, binfo->scrnx, 16, 64, COL8_FFFFFF, s);

  outb(PIC0_IMR, 0xf9); /* 开放PIC1和键盘中断(11111001) */
  outb(PIC1_IMR, 0xef); /* 开放鼠标中断(11101111) */
  
  while (1) {
    io_hlt();
  }
}



