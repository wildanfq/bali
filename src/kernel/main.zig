const uart = @import("hal");
const shell = @import("lib");

comptime { _ = @import("trap.zig"); }
extern fn trap_vector() void;

export fn kmain() callconv(.c) void {
    uart.write("==============================\n");
    uart.write("Welcome to nusa os\n");
    uart.write("==============================\n");
    
    asm volatile (
        \\la t0, trap_vector
        \\csrw mtvec, t0
        : : : "t0"
    );
    shell.run();
    while (true) { asm volatile ("wfi"); }
}