.global load_gdtr
.global load_idtr

load_gdtr:
    mov 4(%esp), %ax
    mov %ax, 6(%esp)
    lgdt 6(%esp)
    ret

load_idtr:
    mov 4(%esp), %ax
    mov %ax, 6(%esp)
    lgdt 6(%esp)
    ret