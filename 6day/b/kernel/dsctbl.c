#include "head.h"

void init_gdtidt(void) {
  struct SEGMENT_DESCRIPTOR  *gdt = (struct SEGMENT_DESCRIPTOR *)ADR_GDT;
  struct GATE_DESCRIPTOR *idt = (struct GATE_DESCRIPTOR *)ADR_IDT;

  for (int i = 0; i < 8192; ++i) {
    set_segmdesc(gdt + i, 0, 0, 0);
  }
  
  set_segmdesc(gdt+1,0xffffffff   ,0x00000000,0x4092);//entry.s main.c data 4GB空间的数据都能访问
  set_segmdesc(gdt+2,0x000fffff   ,0x00000000,0x409a);//entry.S code
  set_segmdesc(gdt+3,0x000fffff   ,0x00280000,0x409a);  //main.c code　 0x7ffff=512kB
  load_gdtr(LIMIT_GDT, ADR_GDT);

  for (int i = 0; i < 256; ++i) {
    // set_gatedesc(idt + i, 0, 0, 0);
    set_gatedesc(idt + i, (int)asm_inthandler21 - 0x280000, 2 * 8, AR_INTGATE32);
  }

  load_idtr(LIMIT_IDT, ADR_IDT);
  
	set_gatedesc(idt + 0x21, (int) asm_inthandler21, 2 * 8, AR_INTGATE32);
	// set_gatedesc(idt + 0x2c, (int) asm_inthandler2c, 2 * 8, AR_INTGATE32);

  return;
}

void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar) {
  if (limit > 0xffff) {
    ar |= 0x8000;
    limit /= 0x1000;
  }

  sd->limit_low = limit & 0xffff;
  sd->base_low = base & 0xffff;
  sd->base_mid = (base >> 16) & 0xff;
  sd->access_right = ar & 0xff;
  sd->limit_high = ((limit >> 16) & 0xff) | ((ar >> 8) &0xf0);
  sd->limit_high = (base >> 24) & 0xff;
  return;
}

void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar) {
  gd->offset_low = offset & 0xffff;
  gd->selector = selector;
  gd->dw_count = (ar >> 8) & 0xff;
  gd->aceess_right = (char)(ar & 0xff);
  gd->offset_high = (offset >> 16) & 0xffff;

  return;
}