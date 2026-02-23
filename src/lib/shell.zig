const std = @import("std");
const uart = @import("hal");

fn print(str: []const u8) void {
    uart.write(str);
}

fn execute(cmd: []const u8) void {
    if (std.mem.eql(u8, cmd, "help")) {
        print("Tersedia: help, info, clear\n");
    } else if (std.mem.eql(u8, cmd, "info")) {
        print("NusaOS v0.0.1 | Arch: RISC-V\n");
    } else if (std.mem.eql(u8, cmd, "clear")) {
        print("\x1B[2J\x1B[H"); 
    } else if (cmd.len > 0) {
        print("Perintah tidak dikenal: ");
        print(cmd);
        print("\n");
    }
}

pub fn run() void {
    var buf: [64]u8 = undefined;
    var idx: usize = 0;

    print("\nShell >");

    while (true) {
        const char = uart.readByte();

        if (char == '\r' or char == '\n') {
            print("\n");
            execute(buf[0..idx]);
            idx = 0;
            print("Shell > ");
        } else if (char == 127) {
            if (idx > 0) {
                idx -= 1;
                print("\x08 \x08");
            }
        } else if (idx < buf.len - 1 and char >= 32 and char <= 126) {
            buf[idx] = char;
            idx += 1;
            uart.write(&[1]u8{char});
        }
    }
}