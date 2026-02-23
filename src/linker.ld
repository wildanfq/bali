ENTRY(_start)

SECTIONS {
    . = 0x80000000;
    
    .text : { 
        KEEP(*(.text.init)) 
        *(.text) 
    }
    
    .rodata : { *(.rodata) }
    .data : { *(.data) }
    .bss : { *(.bss) }
    
    . = ALIGN(16);
    . += 8192;
    _stack_top = .;
}