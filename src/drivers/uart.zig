const std = @import("std");

pub const UART0 = 0x10000000;
pub const TEST_FINISHER = 0x100000;

pub fn init() void {
    const lcr: *volatile u8 = @ptrFromInt(UART0 + 3);
    lcr.* = 0x03;
}

pub fn write(msg: []const u8) void {
    const thr: *volatile u8 = @ptrFromInt(UART0);
    const lsr: *volatile u8 = @ptrFromInt(UART0 + 5);
    for (msg) |c| {
        while ((lsr.* & 0x20) == 0) {}
        thr.* = c;
    }
}

pub fn readByte() u8 {
    const rbr: *volatile u8 = @ptrFromInt(UART0);
    const lsr: *volatile u8 = @ptrFromInt(UART0 + 5);
    while ((lsr.* & 0x01) == 0) {}
    return rbr.*;
}

pub fn shutdown() noreturn {
    const ptr: *volatile u32 = @ptrFromInt(TEST_FINISHER);
    ptr.* = 0x5555;
    while (true) {
        asm volatile ("wfi");
    }
}

pub fn hasInput() bool {
    const lsr: *volatile u8 = @ptrFromInt(UART0 + 5);
    return (lsr.* & 0x01) != 0;
}
