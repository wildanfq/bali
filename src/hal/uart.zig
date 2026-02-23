const UART0 = 0x10000000;

pub fn write(msg: []const u8) void {
    const ptr: *volatile u8 = @ptrFromInt(UART0);
    for (msg) |c| {
        ptr.* = c;
    }
}

pub fn readByte() u8 {
    const data: *volatile u8 = @ptrFromInt(UART0);
    const lsr: *volatile u8 = @ptrFromInt(UART0 + 5);
    while ((lsr.* & 0x01) == 0) {}
    return data.*;
}