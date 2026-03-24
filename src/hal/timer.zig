pub fn Timer(comptime Impl: type) type {
    return struct {
        pub fn init() void {
            Impl.init();
        }
        pub fn delay(ms: u32) void {
            Impl.delay(ms);
        }
    };
}
