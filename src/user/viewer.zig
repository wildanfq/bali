const uart = @import("drivers");
const tui = @import("lib");

const NUM_STREAMS = 25;
var rng: u32 = 0xACE1; // Seed sederhana

fn nextRand() u32 {
    rng ^= rng << 13;
    rng ^= rng >> 17;
    rng ^= rng << 5;
    return rng;
}

pub fn start() void {
    tui.clearScreen();
    uart.write(tui.HIDE_CURSOR);

    var xs: [NUM_STREAMS]u8 = undefined;
    var ys: [NUM_STREAMS]i8 = undefined;
    var spds: [NUM_STREAMS]u8 = undefined;

    for (0..NUM_STREAMS) |i| {
        xs[i] = @as(u8, @intCast(nextRand() % 78 + 1));
        ys[i] = @as(i8, @intCast(nextRand() % 30)) - 30;
        spds[i] = @as(u8, @intCast(nextRand() % 3 + 1));
    }

    while (!uart.hasInput()) {
        for (0..NUM_STREAMS) |i| {
            const tail = ys[i] - 8;
            if (tail > 0 and tail < 25) {
                tui.moveCursor(@as(u8, @intCast(tail)), xs[i]);
                uart.write(" ");
            }

            ys[i] += 1;
            if (ys[i] > 30) {
                ys[i] = 0;
                xs[i] = @as(u8, @intCast(nextRand() % 78 + 1));
            }

            if (ys[i] > 0 and ys[i] < 25) {
                tui.moveCursor(@as(u8, @intCast(ys[i])), xs[i]);

                if (spds[i] == 3) uart.write("\x1B[38;5;121m") // Terang (dekat)
                else if (spds[i] == 2) uart.write("\x1B[38;5;34m") // Sedang
                else uart.write("\x1B[38;5;22m"); // Gelap (jauh)

                const char = @as(u8, @intCast((nextRand() % 93) + 33));
                uart.write(&[1]u8{char});
            }
        }

        // Delay FPS
        var d: u32 = 0;
        while (d < 120_000) : (d += 1) {
            asm volatile ("nop");
        }
    }

    _ = uart.readByte(); // Flush input
    uart.write(tui.SHOW_CURSOR);
    uart.write(tui.RESET);
}
