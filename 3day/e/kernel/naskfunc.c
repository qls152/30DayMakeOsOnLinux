
void write_mem8(int addr, int data) {
  __asm__(
    "mov %%al, (%%ecx)" ::"c"(addr), "a"(data));
}