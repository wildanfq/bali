const uart = @import("drivers");
const tui = @import("lib");

pub fn start() void {
    tui.clearScreen();
    tui.drawHeader("TEXT EDITOR");
    tui.drawFooter("Press [`] to exit");

    var cur_x: u8 = 4;
    var cur_y: u8 = 3;

    while (true) {
        tui.moveCursor(cur_y, cur_x);
        const key = uart.readByte();
        if (key == '`') break;

        switch (key) {
            10, 13 => {
                if (cur_y < 22) {
                    cur_y += 1;
                    cur_x = 4;
                }
            },
            8, 127 => {
                if (cur_x > 4) {
                    cur_x -= 1;
                    tui.moveCursor(cur_y, cur_x);
                    uart.write(" ");
                }
            },
            32...126 => {
                if (cur_x < 76) {
                    uart.write(&[1]u8{key});
                    cur_x += 1;
                }
            },
            else => {},
        }
    }
}
