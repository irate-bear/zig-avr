# Zig AVR HAL

A pure Zig Hardware Abstraction Layer (HAL) for AVR microcontrollers, providing type-safe GPIO, timer, and UART control with zero dependencies.

## Features

- ✨ **Pure Zig** - No C code, no external dependencies
- 💡 **Type-safe GPIO** - Pin operations with compile-time checking
- ⏱️ **Timer utilities** - Accurate delays and timing
- 📡 **UART communication** - Serial output support
- 🔧 **Proven build pattern** - Uses Zig for compilation, avr-gcc for linking
- 🚀 **Simple integration** - Add to any Zig project in minutes

## Supported Boards

| Board | Chip | LED Pin | Status |
|-------|------|---------|--------|
| Arduino Mega 2560 | ATmega2560 | PB7 (pin 13) | ✅ Working |
| Arduino Uno | ATmega328P | PB5 (pin 13) | ✅ Working |
| Arduino Leonardo | ATmega32u4 | PC7 (pin 13) | ✅ Working |

## Installation

Add to your `build.zig.zon`:

```zig
.{
    .name = "my-project",
    .version = "0.1.0",
    .dependencies = .{
        .@"zig-avr" = .{
            .url = "https://github.com/irate-bear/zig-avr/archive/refs/tags/v0.1.0.tar.gz",
            .hash = "1220...",
        },
    },
}
```

## Usage

### Build Configuration

In your `build.zig`:

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    // ============================================
    // CONFIGURATION - Change these for your setup
    // ============================================
    
    const chip = struct {
        pub const name = "atmega2560";      // GCC chip name
        pub const avrdude = "m2560";         // avrdude chip name
        pub const programmer = "wiring";      // Programmer type
        pub const port = "/dev/ttyACM0";      // Serial port
        pub const baud = "115200";            // Baud rate
    };

    // ============================================
    // Build setup
    // ============================================
    
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .avr,
        .cpu_model = .{
            .explicit = &std.Target.avr.cpu.atmega2560, //Change CPU model as needed
        },
        .os_tag = .freestanding,
    });

    const optimize = b.standardOptimizeOption(.{});

    // Get the zig-avr dependency
    const avr_dep = b.dependency("zig-avr", .{
        .target = target,
        .optimize = optimize,
    });
    const avr = avr_dep.module("zig-avr");

    // Compile main to object file
    const main_obj = b.addObject(.{
        .name = "main",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    main_obj.root_module.addImport("zig-avr", avr);

    // Create output directory
    const mkdir_bin = b.addSystemCommand(&.{ "mkdir", "-p", "zig-out/bin" });

    // Link with avr-gcc to create ELF
    const link = b.addSystemCommand(&.{
        "avr-gcc",
        "-mmcu=" ++ chip.name,
        "-Os",
        "-o",
        "zig-out/bin/firmware.elf",
    });
    link.addFileArg(main_obj.getEmittedBin());
    link.step.dependOn(&main_obj.step);
    link.step.dependOn(&mkdir_bin.step);

    // Build step
    const build_step = b.step("build", "Build firmware.elf");
    build_step.dependOn(&link.step);

    // Hex step
    const hex_step = b.step("hex", "Generate firmware.hex");
    const objcopy = b.addSystemCommand(&.{
        "avr-objcopy", "-O", "ihex", "-R", ".eeprom",
        "zig-out/bin/firmware.elf", "zig-out/bin/firmware.hex",
    });
    objcopy.step.dependOn(&link.step);
    hex_step.dependOn(&objcopy.step);

    // Flash step
    const flash_step = b.step("flash", "Flash to device");
    const flash = b.addSystemCommand(&.{
        "avrdude",
        "-c", chip.programmer,
        "-p", chip.avrdude,
        "-P", chip.port,
        "-b", chip.baud,
        "-D", "-U", "flash:w:zig-out/bin/firmware.hex:i",
    });
    flash.step.dependOn(hex_step);
    flash_step.dependOn(&flash.step);

    b.default_step = build_step;
}
```

### Example Code

In your `src/main.zig`:

```zig
const avr = @import("zig-avr");

pub export fn main() void {
    // Initialize peripherals
    avr.timer.init();
    avr.uart.init();

    // use built-in LED
    const led = avr.boards.mega2560.LED_BUILTIN;
    avr.gpio.pinMode(led, .output);

    avr.uart.writeString("Hello from Zig on AVR!\n");
    
    while (true) {
        avr.gpio.digitalWrite(led, .high);
        avr.uart.writeString("LED ON\n");
        avr.timer.delay(1000);

        avr.gpio.digitalWrite(led, .low);
        avr.uart.writeString("LED OFF\n");
        avr.timer.delay(1000);
    }
}
```

## Building and Flashing

```bash
# Build ELF only
zig build

# Build ELF + generate HEX
zig build hex

# Build + flash to device
zig build flash
```

## Configuration Examples

### Arduino Uno

```zig
const chip = struct {
    pub const name = "atmega328p";
    pub const avrdude = "m328p";
    pub const programmer = "arduino";
    pub const port = "/dev/ttyUSB0";
    pub const baud = "115200";
};
```

### Arduino Leonardo

```zig
const chip = struct {
    pub const name = "atmega32u4";
    pub const avrdude = "m32u4";
    pub const programmer = "avr109";
    pub const port = "/dev/ttyACM0";
    pub const baud = "57600";
};
```

### Arduino Mega

```zig
const chip = struct {
    pub const name = "atmega2560";
    pub const avrdude = "m2560";
    pub const programmer = "wiring";
    pub const port = "/dev/ttyACM0";
    pub const baud = "115200";
};
```

## API Reference

### GPIO

```zig
// Pin modes
gpio.pinMode(pin, .output);
gpio.pinMode(pin, .input);
gpio.pinMode(pin, .input_pullup);

// Digital write
gpio.digitalWrite(pin, .high);
gpio.digitalWrite(pin, .low);

// Digital read
const state = gpio.digitalRead(pin);
```

### Timer

```zig
timer.init();        // Initialize timer for 1ms ticks
timer.delay(1000);   // Delay in milliseconds
```

### UART

```zig
uart.init();                    // Initialize at 9600 baud
uart.writeByte('A');            // Send a byte
uart.writeString("Hello");      // Send a string
```

## Board Support

Currently supported boards:
Board	MCU	LED Pin	Register Map
Arduino Mega 2560	ATmega2560	PB7 (pin 13)	Full I/O space

Pin definitions:

```zig
const board = avr.boards.mega2560;
const led = board.LED_BUILTIN;    // PB7 (pin 13)
const d2 = board.d2;               // Digital pin 2
const d13 = board.d13;             // Digital pin 13 (same as LED)
```
## Why This Build Pattern?

The Zig AVR backend is improving but the linker can be unstable. This pattern:

1. ✅ Uses Zig for compilation (excellent code generation)
2. ✅ Uses avr-gcc for linking (stable, AVR-optimized)
3. ✅ Separates concerns - each tool does what it does best
4. ✅ Works reliably across different AVR chips
5. ✅ Simple to debug - clear steps with visible output

## Troubleshooting

### Linker warnings about .note-GNU-stack

These warnings are harmless and can be ignored. They don't affect functionality.

### Programmer not responding

- Check the correct port (`/dev/ttyACM0`, `/dev/ttyUSB0`, or `COM3`)
- Ensure you're in the dialout group: `sudo usermod -a -G dialout $USER` OR ``sudo usermod -a -G uucp $USER``
- Try the reset trick: press reset, then immediately run avrdude.
