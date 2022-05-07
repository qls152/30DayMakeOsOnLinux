void io_hlt() {
    asm(
        "hlt\n\t"
        "ret\n\t"
    );
}

void write_mem8(int addr, int data) {
    asm volatile(
        "mov %1, %0\n\t"
        "ret\n\t"
        :
        : "c"(addr), "a"(data)
    );
}