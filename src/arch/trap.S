.section .text
.global trap_vector
.align 4

trap_vector:
    call trap_handler
    mret