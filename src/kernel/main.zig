const std = @import("std");
const uart = @import("drivers");
const tui = @import("lib");
const shell = @import("user");

pub const panic = @import("panic.zig").panic;
extern const trap_vector: anyopaque;

export fn trap_handler() callconv(.c) void {
    uart.write("\r\n\x1B[31m[ KERNEL EXCEPTION ]\x1B[0m\r\n");
}

export fn kmain() noreturn {
    uart.init();

    const vector_addr = @intFromPtr(&trap_vector);
    asm volatile ("csrw mtvec, %[vector]"
        :
        : [vector] "r" (vector_addr),
    );

    tui.clearScreen();
    uart.write(tui.HIDE_CURSOR);

    tui.setStyle(tui.CLR_PRIMARY);
    tui.drawCenteredText(10, "BALI");

    tui.setStyle(tui.CLR_DIM);
    tui.drawCenteredText(12, "microkernel booting...");

    var delay: u32 = 0;
    while (delay < 4_000_000) : (delay += 1) {
        asm volatile ("nop");
    }

    uart.write(tui.SHOW_CURSOR);
    shell.run();

    while (true) {
        asm volatile ("wfi");
    }
}
