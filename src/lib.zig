pub const hal = struct {
    pub const gpio = @import("hal/gpio.zig");
    pub const timer = @import("hal/timer.zig");
    pub const uart = @import("hal/uart.zig");
};

pub const boards = struct {
    pub const mega2560 = @import("boards/mega2560.zig");
    //TODO: Add more boards here later
};

pub const gpio = hal.gpio;
pub const timer = hal.timer;
pub const uart = hal.uart;
