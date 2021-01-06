#include <naskfunc.h>

void bootmain(void) {
  
  char *p = (char*) 0xa0000; // 声明变量
  for (int i = 0; i <= 0xffff; ++i) {
      p[i] = 15;
  }

  while (1) {
    io_hlt();
  }
}