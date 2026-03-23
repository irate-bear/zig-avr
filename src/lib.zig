const config = @import("config");

pub const board = switch (config.board) {
    .mega2560 => @import("boards/atmega2560/mega2560.zig"),
    //TODO: Add more boards here later
};

pub const gpio = board.gpio;
pub const timer = board.timer;
pub const uart = board.uart;
