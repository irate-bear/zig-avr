const avr_timer = @import("../mcu/atmega2560/timer.zig");
const avr_uart = @import("../mcu/atmega2560/uart.zig");
const avr_gpio = @import("../mcu/atmega2560/gpio.zig");

pub const uart = avr_uart.uart;
pub const timer = avr_timer.timer;
pub const gpio = avr_gpio;
