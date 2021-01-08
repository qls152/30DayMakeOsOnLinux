void init_palette(void);
void set_palette(int start, int end, unsigned char* rgb);
void boxfill8(char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
void init_screen(char *vram, int x, int y);

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

void init_gdtidt(void);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);




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

void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar);
void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar);