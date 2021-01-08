#include "naskfunc.h"
#include "font.h"
#include "print.h"
#include "head.h"




void auxmain(BootInfo *binfo);

void bootmain(void) {
  BootInfo *binfo = (BootInfo *)0x0ff0;
  
  init_palette(); //设定调色板
  init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
  auxmain(binfo);

  while (1) {
    io_hlt();
  }
}

void init_palette(void) {
  static unsigned char table_rgb[16 * 3] = {
    0x00, 0x00, 0x00,	/*  0:黑 */
		0xff, 0x00, 0x00,	/*  1:梁红 */
		0x00, 0xff, 0x00,	/*  2:亮绿 */
		0xff, 0xff, 0x00,	/*  3:亮黄 */
		0x00, 0x00, 0xff,	/*  4:亮蓝 */
		0xff, 0x00, 0xff,	/*  5:亮紫 */
		0x00, 0xff, 0xff,	/*  6:浅亮蓝 */
		0xff, 0xff, 0xff,	/*  7:白 */
		0xc6, 0xc6, 0xc6,	/*  8:亮灰 */
		0x84, 0x00, 0x00,	/*  9:暗红 */
		0x00, 0x84, 0x00,	/* 10:暗绿 */
		0x84, 0x84, 0x00,	/* 11:暗黄 */
		0x00, 0x00, 0x84,	/* 12:暗青 */
		0x84, 0x00, 0x84,	/* 13:暗紫 */
		0x00, 0x84, 0x84,	/* 14:浅暗蓝 */
		0x84, 0x84, 0x84	/* 15:暗灰 */
  }; // c语言中的static char相当于汇编语言中的db
  set_palette(0, 15, table_rgb);
  return;
}

void set_palette(int start, int end, unsigned char* rgb) {
  int i, eflags;
  eflags = io_load_eflags(); //记录中断许可标志
  io_cli();
  io_out8(0x03c8, start);
  for (i = start; i <= end; ++i) {
    io_out8(0x03c9, rgb[0]/4);
    io_out8(0x03c9, rgb[1]/4);
    io_out8(0x03c9, rgb[2]/4);
    rgb += 3;
  }

  io_store_eflags(eflags); //恢复中断许可标志
  return;
}


void putfont8s_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s) {
  static MAKE_FONT
  for (; *s != 0; s++) {
    putfont8(vram, xsize, x, y, c, hankaku + *s * 16);
    x += 8;
  }
  return;
}

void init_screen(char *vram, int xsize, int ysize) {
  /* 根据 0xa0000 + x + y * 320 计算坐标 8*/
	boxfill8(vram, xsize, COL8_008484,  0,         0,          xsize -  1, ysize - 29);
	boxfill8(vram, xsize, COL8_C6C6C6,  0,         ysize - 28, xsize -  1, ysize - 28);
	boxfill8(vram, xsize, COL8_FFFFFF,  0,         ysize - 27, xsize -  1, ysize - 27);
	boxfill8(vram, xsize, COL8_C6C6C6,  0,         ysize - 26, xsize -  1, ysize -  1);

	boxfill8(vram, xsize, COL8_FFFFFF,  3,         ysize - 24, 59,         ysize - 24);
	boxfill8(vram, xsize, COL8_FFFFFF,  2,         ysize - 24,  2,         ysize -  4);
	boxfill8(vram, xsize, COL8_848484,  3,         ysize -  4, 59,         ysize -  4);
	boxfill8(vram, xsize, COL8_848484, 59,         ysize - 23, 59,         ysize -  5);
	boxfill8(vram, xsize, COL8_000000,  2,         ysize -  3, 59,         ysize -  3);
	boxfill8(vram, xsize, COL8_000000, 60,         ysize - 24, 60,         ysize -  3);

	boxfill8(vram, xsize, COL8_848484, xsize - 47, ysize - 24, xsize -  4, ysize - 24);
	boxfill8(vram, xsize, COL8_848484, xsize - 47, ysize - 23, xsize - 47, ysize -  4);
	boxfill8(vram, xsize, COL8_FFFFFF, xsize - 47, ysize -  3, xsize -  4, ysize -  3);
	boxfill8(vram, xsize, COL8_FFFFFF, xsize -  3, ysize - 24, xsize -  3, ysize -  3);
  return;
}

void init_mouse_cursor8(char *mouse, char bc) {
  static char cursor[16][16] = {
		"**************..",
		"*OOOOOOOOOOO*...",
		"*OOOOOOOOOO*....",
		"*OOOOOOOOO*.....",
		"*OOOOOOOO*......",
		"*OOOOOOO*.......",
		"*OOOOOOO*.......",
		"*OOOOOOOO*......",
		"*OOOO**OOO*.....",
		"*OOO*..*OOO*....",
		"*OO*....*OOO*...",
		"*O*......*OOO*..",
		"**........*OOO*.",
		"*..........*OOO*",
		"............*OO*",
		".............***"
	};

  for (int y = 0; y < 16; ++y) {
    for (int x = 0; x < 16; ++x) {
      if (cursor[y][x] == '*') {
        mouse[y * 16 + x] = COL8_000000;
      }
      if (cursor[y][x] == 'O') {
        mouse[y * 16 + x] = COL8_FFFFFF;
      }
      if (cursor[y][x] == '.') {
        mouse[y * 16 + x] = bc;
      }
    }
  }

  return;
}

void auxmain(BootInfo *binfo) {
  char s[10], mcursor[256];
  /* 显示鼠标 */
	int mx = (binfo->scrnx - 16) / 2; /* 计算画面的中心坐标*/
	int my = (binfo->scrny - 28 - 16) / 2;
	init_mouse_cursor8(mcursor, COL8_008484);
	putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);
  
  sprintf(s, "scrnx = %d", binfo->scrnx);
  putfont8s_asc(binfo->vram, binfo->scrnx, 8, 8, COL8_FFFFFF, "ABC 123");
  putfont8s_asc(binfo->vram, binfo->scrnx, 31, 31, COL8_FFFFFF, "Hello MyOS");
  putfont8s_asc(binfo->vram, binfo->scrnx, 16, 64, COL8_FFFFFF, s);
  return;
}

