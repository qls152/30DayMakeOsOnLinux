#include "naskfunc.h"
#include "font.h"
#include "print.h"

void init_palette(void);
void set_palette(int start, int end, unsigned char* rgb);
void boxfill8(char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
void init_screen(char *vram, int x, int y);
void putfont8(char *vram, int xsize, int x, int y, char c, char *font);
void putfont8s_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s);
void init_mouse_cursor8(char *mouse, char bc);
void putblock8_8(char *vram, int vxsize, int pxsize, int pysize,
                 int px0, int py0, char *buf, int bxsize);

void init_gdtidt(void);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);


#define COL8_000000		0
#define COL8_FF0000		1
#define COL8_00FF00		2
#define COL8_FFFF00		3
#define COL8_0000FF		4
#define COL8_FF00FF		5
#define COL8_00FFFF		6
#define COL8_FFFFFF		7
#define COL8_C6C6C6		8
#define COL8_840000		9
#define COL8_008400		10
#define COL8_848400		11
#define COL8_000084		12
#define COL8_840084		13
#define COL8_008484		14
#define COL8_848484		15

typedef struct BOOTINFO {
  char cyls, leds, vmode, reserve;
	short scrnx, scrny;
	char *vram;
} BootInfo;

struct SEGMENT_DESCRIPTOR {
  short limit_low, base_low; // 0-1字节代表limit_low, 2-3字节存放base_low
  char base_mid, access_right; // 第4字节存放base_mid, 第5字节存放访问属性
  char limit_high, base_high; // 第6字节存放limit_high, 第7字节存放base_high
};

struct GATE_DESCRIPTOR {
  short offset_low, selector;
  char dw_count, aceess_right;
  short offset_high;
};

void auxmain(BootInfo *binfo);
void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar);
void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar);

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

void boxfill8(char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1) {
  int x, y;
  for (y = y0; y <= y1; ++y) {
    for (x = x0; x <= x1; ++x) {
      vram[x + y * xsize] = c;
    }
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

void putfont8(char *vram, int xsize, int x, int y, char c, char *font) {
  char *p, d;
  for (int i = 0; i < 16; ++i) {
    p = vram + (y + i) * xsize + x;
    d = font[i];
    if ((d & 0x80) != 0) { p[0] = c; }
    if ((d & 0x40) != 0) { p[1] = c; }
    if ((d & 0x20) != 0) { p[2] = c; }
    if ((d & 0x10) != 0) { p[3] = c; }
    if ((d & 0x08) != 0) { p[4] = c; }
    if ((d & 0x04) != 0) { p[5] = c; }
    if ((d & 0x02) != 0) { p[6] = c; }
    if ((d & 0x01) != 0) { p[7] = c; }
  }
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

void putblock8_8(char *vram, int vxsize, int pxsize, int pysize,
                 int px0, int py0, char *buf, int bxsize) {
  int x, y;
  for (y = 0; y < pysize; ++y) {
    for (x = 0; x < pxsize; ++x) {
      vram[(py0 + y) * vxsize + (px0 + x)] = buf[y * bxsize + x];
    }
  }

}

void init_gdtidt(void) {
  struct SEGMENT_DESCRIPTOR  *gdt = (struct SEGMENT_DESCRIPTOR *)0x00270000;
  struct GATE_DESCRIPTOR *ldt = (struct GATE_DESCRIPTOR *)0x0026f800;

  for (int i = 0; i < 8192; ++i) {
    set_segmdesc(gdt + i, 0, 0, 0);
  }

  set_segmdesc(gdt + 1, 0xffffffff, 0x00000000, 0x4092);
  set_segmdesc(gdt + 2, 0x0007ffff, 0x00280000, 0x409a);
  load_gdtr(0xffff, 0x00270000);

  for (int i = 0; i < 256; ++i) {
    set_gatedesc(ldt + i, 0, 0, 0);
  }
  load_idtr(0x7ff, 0x0026f800);

  return;
}

void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar) {
  if (limit > 0xfffff) {
    ar |= 0x8000;
    limit >>= 12;
  }

  sd->limit_low = limit & 0xffff;
  sd->base_low = base & 0xffff;
  sd->base_mid = (base >> 16) & 0xff;
  sd->access_right = ar & 0xff;
  sd->limit_high = (limit >> 16) & 0xff | ((ar >> 8) &0xf0);
  sd->limit_high = (base >> 24) & 0xff;
  return;
}

void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar) {
  gd->offset_low = offset & 0xffff;
  gd->selector = selector;
  gd->dw_count = (ar >> 8) & 0xff;
  gd->aceess_right = ar & 0xff;
  gd->offset_high = (offset >> 16) & 0xffff;
  return;
}