const gpio = @import("../../hal/gpio.zig");
const Pin = gpio.Pin;
const Port = gpio.Port;
const PortRegisters = gpio.PortRegisters;

pub fn getRegisters(port: Port) PortRegisters {
    return switch (port) {
        // Base addresses from ATmega2560 datasheet
        .A => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x20)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x21)),
            .port = @as(*volatile u8, @ptrFromInt(0x22)),
        },
        .B => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x23)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x24)),
            .port = @as(*volatile u8, @ptrFromInt(0x25)),
        },
        .C => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x26)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x27)),
            .port = @as(*volatile u8, @ptrFromInt(0x28)),
        },
        .D => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x29)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x2A)),
            .port = @as(*volatile u8, @ptrFromInt(0x2B)),
        },
        .E => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x2C)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x2D)),
            .port = @as(*volatile u8, @ptrFromInt(0x2E)),
        },
        .F => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x2F)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x30)),
            .port = @as(*volatile u8, @ptrFromInt(0x31)),
        },
        .G => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x32)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x33)),
            .port = @as(*volatile u8, @ptrFromInt(0x34)),
        },
        .H => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x100)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x101)),
            .port = @as(*volatile u8, @ptrFromInt(0x102)),
        },
        .J => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x103)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x104)),
            .port = @as(*volatile u8, @ptrFromInt(0x105)),
        },
        .K => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x106)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x107)),
            .port = @as(*volatile u8, @ptrFromInt(0x108)),
        },
        .L => .{
            .pin = @as(*volatile u8, @ptrFromInt(0x109)),
            .ddr = @as(*volatile u8, @ptrFromInt(0x10A)),
            .port = @as(*volatile u8, @ptrFromInt(0x10B)),
        },
    };
}

pub const LED_BUILTIN = gpio.makePin(getRegisters(.B), 7);
pub const d0 = gpio.makePin(getRegisters(.E), 0);
pub const d1 = gpio.makePin(getRegisters(.E), 1);
pub const d2 = gpio.makePin(getRegisters(.E), 4);
pub const d3 = gpio.makePin(getRegisters(.E), 5);
pub const d4 = gpio.makePin(getRegisters(.G), 5);
pub const d5 = gpio.makePin(getRegisters(.E), 3);
pub const d6 = gpio.makePin(getRegisters(.H), 3);
pub const d7 = gpio.makePin(getRegisters(.H), 4);
pub const d8 = gpio.makePin(getRegisters(.H), 5);
pub const d9 = gpio.makePin(getRegisters(.H), 6);
pub const d10 = gpio.makePin(getRegisters(.B), 4);
pub const d11 = gpio.makePin(getRegisters(.B), 5);
pub const d12 = gpio.makePin(getRegisters(.B), 6);
pub const d13 = gpio.makePin(getRegisters(.B), 7);
