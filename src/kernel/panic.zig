const uart = @import("drivers");
const std = @import("std");

pub fn panic(msg: []const u8, _: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    uart.write("\r\n--- KERNEL PANIC ---\r\n");
    uart.write(msg);
    uart.write("\r\nHalting.");
    while (true) {
        asm volatile ("wfi");
    }
}
