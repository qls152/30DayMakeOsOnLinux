.global load_gdtr
.global load_idtr

load_gdtr:
    movw 4(%esp), %ax
    movw %ax, 6(%esp)
    lgdt 6(%esp)
    ret

load_idtr:
    movw 4(%esp), %ax
    movw %ax, 6(%esp)
    lgdt 6(%esp)
    ret