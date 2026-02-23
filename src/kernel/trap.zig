const uart = @import("hal");

export fn trap_handler() void {
    while (true) { asm volatile ("wfi"); }
}