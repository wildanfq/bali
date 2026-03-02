const std = @import("std");
const uart = @import("drivers");
const tui = @import("lib");
const editor = @import("editor.zig");
const viewer = @import("viewer.zig");

pub fn run() void {
    tui.clearScreen();
    uart.write(tui.CLR_PRIMARY ++ "BALI" ++ tui.RESET ++ " v0.0.1\r\n");
    uart.write(tui.CLR_DIM ++ "Type 'help' for command list\r\n" ++ tui.RESET);

    var buf: [64]u8 = undefined;
    var idx: usize = 0;

    while (true) {
        uart.write("\r\n" ++ tui.CLR_PRIMARY ++ "λ " ++ tui.RESET);
        idx = 0;
        while (true) {
            const c = uart.readByte();
            if (c == '\r' or c == '\n') {
                const cmd = std.mem.trim(u8, buf[0..idx], " ");
                if (cmd.len > 0) execute(cmd);
                break;
            } else if (c == 127 or c == 8) {
                if (idx > 0) {
                    idx -= 1;
                    uart.write("\x08 \x08");
                }
            } else if (idx < 64) {
                buf[idx] = c;
                idx += 1;
                uart.write(&[1]u8{c});
            }
        }
    }
}

fn execute(cmd: []const u8) void {
    uart.write("\r\n");

    if (std.mem.eql(u8, cmd, "help")) {
        uart.write(tui.CLR_PRIMARY ++ "NUSA OS HELP SYSTEM\r\n" ++ tui.RESET);
        uart.write(tui.CLR_DIM ++ "──────────────────────────────────────────────────\r\n" ++ tui.RESET);

        uart.write(tui.CLR_PRIMARY ++ "info     " ++ tui.RESET ++ "Informasi sistem.\r\n");
        uart.write(tui.CLR_PRIMARY ++ "edit     " ++ tui.RESET ++ "Text Editor.\r\n");
        uart.write(tui.CLR_PRIMARY ++ "view     " ++ tui.RESET ++ "Wallpaper interaktif.\r\n");
        uart.write(tui.CLR_PRIMARY ++ "clear    " ++ tui.RESET ++ "Membersihkan layar terminal.\r\n");
        uart.write(tui.CLR_PRIMARY ++ "reboot   " ++ tui.RESET ++ "Memulai ulang kernel\r\n");
        uart.write(tui.CLR_PRIMARY ++ "shutdown " ++ tui.RESET ++ "Menghentikan sistem\r\n");

        uart.write(tui.CLR_DIM ++ "──────────────────────────────────────────────────\r\n" ++ tui.RESET);
    } else if (std.mem.eql(u8, cmd, "info")) {
        uart.write(tui.CLR_TEXT ++ "Kernel: Nusa Microkernel v0.0.1\r\n" ++ tui.RESET);
        uart.write(tui.CLR_TEXT ++ "Arch  : RISC-V 32-bit (RV32IMAC)\r\n" ++ tui.RESET);
        uart.write(tui.CLR_DIM ++ "Build : Zig 0.16.0-dev (Freestanding)\r\n" ++ tui.RESET);
    } else if (std.mem.eql(u8, cmd, "edit")) {
        editor.start();
        tui.clearScreen();
        uart.write(tui.CLR_DIM ++ "Closed Editor.\r\n" ++ tui.RESET);
    } else if (std.mem.eql(u8, cmd, "view")) {
        viewer.start();
        tui.clearScreen();
        uart.write(tui.CLR_DIM ++ "Closed Wallpaper.\r\n" ++ tui.RESET);
    } else if (std.mem.eql(u8, cmd, "clear")) {
        tui.clearScreen();
    } else if (std.mem.eql(u8, cmd, "reboot")) {
        uart.write(tui.CLR_PRIMARY ++ "Rebooting...\r\n" ++ tui.RESET);
        asm volatile ("j _start");
    } else if (std.mem.eql(u8, cmd, "shutdown")) {
        uart.write(tui.CLR_ERROR ++ "Powering off. Goodbye!\r\n" ++ tui.RESET);
        uart.shutdown();
    } else {
        uart.write(tui.CLR_ERROR ++ "Error:" ++ tui.RESET ++ " unknown command '");
        uart.write(cmd);
        uart.write("'. Type 'help' for list.");
    }
}
