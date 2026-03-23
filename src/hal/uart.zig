pub const Uart = struct {
    initFn: fn () void,
    writeByteFn: fn (u8) void,

    pub fn init(self: Uart) void {
        self.initFn();
    }

    pub fn writeByte(self: Uart, b: u8) void {
        self.writeByteFn(b);
    }

    pub fn writeString(self: Uart, s: []const u8) void {
        for (s) |c| self.writeByteFn(c);
    }
};
