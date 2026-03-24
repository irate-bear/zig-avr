const hal_timer = @import("../../hal/timer.zig");
// Timer1 registers
const TCCR1A = @as(*volatile u8, @ptrFromInt(0x80));
const TCCR1B = @as(*volatile u8, @ptrFromInt(0x81));
const TCCR1C = @as(*volatile u8, @ptrFromInt(0x82));
const TCNT1L = @as(*volatile u8, @ptrFromInt(0x84));
const TCNT1H = @as(*volatile u8, @ptrFromInt(0x85));
const OCR1AL = @as(*volatile u8, @ptrFromInt(0x88));
const OCR1AH = @as(*volatile u8, @ptrFromInt(0x89));
const OCR1BL = @as(*volatile u8, @ptrFromInt(0x8A));
const OCR1BH = @as(*volatile u8, @ptrFromInt(0x8B));
const TIFR1 = @as(*volatile u8, @ptrFromInt(0x36));

const F_CPU = 16_000_000;
const PRESCALER = 64;
const TICKS_PER_MS = F_CPU / (PRESCALER * 1000);
const OCR1A_VALUE = TICKS_PER_MS - 1;

const timer_impl = struct {
    pub fn init() void {
        TCCR1B.* = 0;

        // CTC mode
        TCCR1A.* = 0;
        TCCR1B.* = (1 << 3);

        // 1ms tick
        OCR1AH.* = @as(u8, @truncate((OCR1A_VALUE >> 8) & 0xFF));
        OCR1AL.* = @as(u8, @truncate(OCR1A_VALUE & 0xFF));

        // Prescaler 64
        TCCR1B.* |= (1 << 1) | (1 << 0);

        TIFR1.* |= (1 << 1);
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
};

pub const timer = hal_timer.Timer(timer_impl);
