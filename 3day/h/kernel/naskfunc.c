void io_hlt() {
    asm(
        "hlt\n\t"
        "ret\n\t"
    );
}