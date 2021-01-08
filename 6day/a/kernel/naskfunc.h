#define io_hlt() \
     asm volatile( \
        "hlt\n\t"  \
    );

#define io_cli() \
    asm volatile( \
        "cli\n\t" \
    );

#define io_sti() \
    asm volatile(\
        "sti"    \
    );

#define io_stihlt() \
    asm volatile( \
        "sti\n\t" \
        "hlt\n\t" \
    );

#define io_in8(port) \
    asm volatile(    \
        "movl $0, %%eax \n\t" \
        "inb %%dx, %%al \n\t"  \
        :           \
        :"d"(port)  \
    );
    
#define io_in16(port) \
    asm volatile(    \
        "movl $0, %%eax \n\t" \
        "inw %%dx, %%ax \n\t"  \
        :           \
        :"d"(port)  \
    );

#define io_in32(port) \
    asm volatile(    \
        "movl $0, %%eax \n\t" \
        "inl %%dx, %%eax \n\t"  \
        :           \
        :"d"(port)  \
    );

#define io_out8(port, data) \
    asm volatile( \
        "outb %%al, %%dx \n\t" \
        :                   \
        :"a"(data), "d"(port)\
    );

#define io_out16(port, data) \
    asm volatile( \
        "outw %%ax, %%dx \n\t" \
        :                   \
        :"a"(data), "d"(port)\
    );

#define io_out32(port, data) \
    asm volatile( \
        "outb %0, %%dx \n\t" \
        :                   \
        :"a"(data), "d"(port)\
    );

static __inline int io_load_eflags(void) __attribute__((always_inline));
static __inline void io_store_eflags(int) __attribute__((always_inline));

static __inline int io_load_eflags(void) {
    int eflags;
    asm volatile(
        "pushfl \n\t"
        "popl %0"
        :"=r"(eflags)
    );

    return eflags;
}

static __inline void io_store_eflags(int eflags) {
    asm volatile(
        "pushl %0 \n\t"
        "popfl"
        :
        :"r"(eflags)
    );
}




