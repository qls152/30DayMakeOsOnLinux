#include "naskfunc.h"
void main(void) {
  int i;
  for (int i = 0xa0000; i<= 0xaffff; ++i) {
    write_mem8(i, 15);
  }
  while(1);
}