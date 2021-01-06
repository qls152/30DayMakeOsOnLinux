#define io_hlt() \
     asm volatile( \
        "hlt\n\t"  \
    );
