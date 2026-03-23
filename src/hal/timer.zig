pub const Timer = struct {
    initFn: fn () void,
    delayFn: fn (u32) void,

    pub fn init(self: Timer) void {
        self.initFn();
    }

    pub fn delay(self: Timer, ms: u32) void {
        self.delayFn(ms);
    }
};
