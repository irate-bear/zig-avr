const avr = @import("lib.zig");

pub export fn main() void {
    const led = avr.boards.mega2560.LED_BUILTIN;
    avr.gpio.pinMode(led, .output);
    avr.timer.init();

    while (true) {
        avr.gpio.digitalWrite(led, .high);
        avr.delay(500);

        avr.gpio.digitalWrite(led, .low);
        avr.timer.delay(500);
    }
}
