const Uart = @import("../../hal/uart.zig").Uart;

const UBRR0H = @as(*volatile u8, @ptrFromInt(0xC5));
const UBRR0L = @as(*volatile u8, @ptrFromInt(0xC4));
const UCSR0A = @as(*volatile u8, @ptrFromInt(0xC0));
const UCSR0B = @as(*volatile u8, @ptrFromInt(0xC1));
const UCSR0C = @as(*volatile u8, @ptrFromInt(0xC2));
const UDR0 = @as(*volatile u8, @ptrFromInt(0xC6));

pub fn init() void {
    const baud: u16 = 103; // 9600 @ 16MHz

    UBRR0H.* = @as(u8, baud >> 8);
    UBRR0L.* = @as(u8, baud & 0xFF);

    UCSR0B.* = (1 << 3) | (1 << 4); // TX enable
    UCSR0C.* = (1 << 1) | (1 << 2); // 8-bit
}

pub fn writeByte(b: u8) void {
    while ((UCSR0A.* & (1 << 5)) == 0) {}
    UDR0.* = b;
}

pub const uart = Uart{
    .initFn = init,
    .writeByteFn = writeByte,
};
