.section .text.init
.global _start

_start:
    # Atur Stack Pointer ke alamat yang ditentukan linker
    la sp, _stack_top
    
    # Langsung lompat ke kernel utama
    j kmain