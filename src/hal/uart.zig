pub const UART = struct {
    initFn: fn () void,
    witeByteFn: fn (u8) void,

    pub fn init(self: UART) void {
        self.initFn();
    }
    pub fn writeByte(self: UART, b: u8) void {
        self.writeByteFn(b);
    }

    fn writeString(self: UART, s: []const u8) void {
        for (s) |c| self.writeByte(c);
    }
};
