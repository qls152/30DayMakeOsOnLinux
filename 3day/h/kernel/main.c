#include <naskfunc.h>

int bootmain(void) {
    fin:
      io_hlt();
      goto fin;
}