.section .text.init
.global _start

_start:
    la sp, _stack_top
    
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    la t0, _bss_start
    la t1, _bss_end
bss_clear:
    beq t0, t1, bss_done
    sb zero, 0(t0)
    addi t0, t0, 1
    j bss_clear

bss_done:
    tail kmain