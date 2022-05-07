#include <naskfunc.h>

int bootmain(void) {
  int i;
  for (i = 0xa0000; i <= 0xaffff; ++i) {
    write_mem8(i, 15);
  }
  
  for (;;) {
    io_hlt();
  }
  return 0;
}