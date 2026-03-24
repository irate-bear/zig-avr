pub const gpio = @import("hal/gpio.zig");

pub const boards = struct {
    pub const mega2560 = @import("boards/mega2560.zig");
    //TODO: Add more boards here later
};
