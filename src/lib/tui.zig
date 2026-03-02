const uart = @import("drivers");

pub const CLEAR = "\x1B[2J\x1B[H";
pub const HIDE_CURSOR = "\x1B[?25l";
pub const SHOW_CURSOR = "\x1B[?25h";

pub const CLR_PRIMARY = "\x1B[38;5;81m";
pub const CLR_ERROR = "\x1B[38;5;203m";
pub const CLR_DIM = "\x1B[38;5;242m";
pub const CLR_TEXT = "\x1B[38;5;253m";
pub const RESET = "\x1B[0m";

pub const FG_WHITE = CLR_TEXT;

pub fn setStyle(style: []const u8) void {
    uart.write(style);
}

pub fn moveCursor(row: u8, col: u8) void {
    uart.write("\x1B[");
    printUint(row);
    uart.write(";");
    printUint(col);
    uart.write("H");
}

pub fn clearScreen() void {
    uart.write(CLEAR);
}

pub fn drawCenteredText(row: u8, text: []const u8) void {
    const col = @as(u8, @intCast((80 - text.len) / 2));
    moveCursor(row, col);
    uart.write(text);
}

pub fn drawHeader(title: []const u8) void {
    moveCursor(1, 1);
    uart.write(CLR_PRIMARY);
    uart.write("── ");
    uart.write(title);
    uart.write(" ──────────────────────────────────────────────────");
    uart.write(RESET);
}

pub fn drawFooter(info: []const u8) void {
    moveCursor(24, 1);
    uart.write(CLR_DIM);
    uart.write("── ");
    uart.write(info);
    uart.write(RESET);
}

pub fn printUint(n: u32) void {
    if (n == 0) {
        uart.write("0");
        return;
    }
    var buf: [10]u8 = undefined;
    var i: usize = 0;
    var temp = n;
    while (temp > 0) : (temp /= 10) {
        buf[i] = @as(u8, @intCast(temp % 10)) + '0';
        i += 1;
    }
    while (i > 0) {
        i -= 1;
        uart.write(&[1]u8{buf[i]});
    }
}
