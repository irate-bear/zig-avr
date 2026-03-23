const Timer = @import("../../hal/timer.zig").Timer;
// Timer1 registers
const TCCR1A = @as(*volatile u8, @ptrFromInt(0x80));
const TCCR1B = @as(*volatile u8, @ptrFromInt(0x81));
const TCNT1H = @as(*volatile u8, @ptrFromInt(0x85));
const TCNT1L = @as(*volatile u8, @ptrFromInt(0x84));
const OCR1AH = @as(*volatile u8, @ptrFromInt(0x89));
const OCR1AL = @as(*volatile u8, @ptrFromInt(0x88));
const TIFR1 = @as(*volatile u8, @ptrFromInt(0x36));

pub fn init() void {
    // CTC mode
    TCCR1A.* = 0;
    TCCR1B.* = (1 << 3);

    // 1ms tick
    OCR1AH.* = 0;
    OCR1AL.* = 250;

    // Prescaler 64
    TCCR1B.* |= (1 << 1) | (1 << 0);
}

pub fn delay(ms: u32) void {
    var count: u32 = 0;
    while (count < ms) : (count += 1) {
        TCNT1H.* = 0;
        TCNT1L.* = 0;

        // Wait for compare match (OCF1A)
        while ((TIFR1.* & (1 << 1)) == 0) {}

        // Clear flag by writing 1
        TIFR1.* |= (1 << 1);
    }
}

pub const timer = Timer{
    .initFn = init,
    .delayFn = delay,
};
