# Zig AVR HAL

A Hardware Abstraction Layer (HAL) for AVR microcontrollers, written in pure Zig. Currently supports ATmega2560 (Arduino Mega 2560).

## Features

- ✨ Pure Zig, zero dependencies
- 💡 GPIO control with type-safe pin operations
- ⏱️ Timer utilities for delays
- 📡 UART communication
- 🔧 No external linker scripts needed
- 🚀 Simple build integration

## Installation

Add to your `build.zig.zon`:

```zig
.{
    .name = "my-project",
    .version = "0.1.0",
    .dependencies = .{
        .@"zig-avr" = .{
            .url = "https://github.com/yourusername/zig-avr/archive/refs/tags/v0.1.0.tar.gz",
            .hash = "1220...",
        },
    },
}
```

## Usage

In your `build.zig`:

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const avr_dep = b.dependency("zig-avr", .{
        .target = target,
        .optimize = optimize,
    });
    const avr = avr_dep.module("zig-avr");

    const exe = b.addExecutable(.{
        .name = "firmware",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("zig-avr", avr);
    
    if (target.result.cpu_arch == .avr) {
        exe.entry = .{ .symbol_name = "main" };
        exe.bundle_compiler_rt = false;
    }

    b.installArtifact(exe);
}
```

In your `src/main.zig`:

```zig
const avr = @import("zig-avr");

pub export fn main() void {
    const led = avr.boards.mega2560.LED_BUILTIN;
    avr.gpio.pinMode(led, .output);
    
    while (true) {
        avr.gpio.digitalWrite(led, .high);
        avr.timer.delay(1000);
        avr.gpio.digitalWrite(led, .low);
        avr.timer.delay(1000);
    }
}
```

## Building and Flashing

```bash
# Build
zig build

# Generate HEX file (add this step to your build.zig)
zig build hex

# Flash (requires avrdude)
avrdude -c wiring -p m2560 -P /dev/ttyACM0 -b 115200 -D -U flash:w:zig-out/hex/firmware.hex:i
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

## Adding HEX Generation to build.zig

Add this to your `build.zig`:

```zig
// After installing the executable
const install_exe = b.addInstallArtifact(exe, .{});

// HEX file generation
const hex_step = b.step("hex", "Generate HEX file");
const hex_dir = "zig-out/hex";
const hex_file = b.fmt("{s}/firmware.hex", .{hex_dir});

const mkdir = b.addSystemCommand(&.{ "mkdir", "-p", hex_dir });
const objcopy = b.addSystemCommand(&.{
    "avr-objcopy", "-O", "ihex",
    "-R", ".eeprom",
});
objcopy.addFileArg(exe.getEmittedBin());
objcopy.addArg(hex_file);

objcopy.step.dependOn(&mkdir.step);
objcopy.step.dependOn(&install_exe.step);
hex_step.dependOn(&objcopy.step);
```

## Troubleshooting
### Linker warnings about .note-GNU-stack

These warnings are harmless and can be ignored. They don't affect functionality.

### Flash verification mismatch

Use the erase flag with avrdude:

```bash
avrdude -c wiring -p m2560 -P /dev/ttyACM0 -b 115200 -e -D -U flash:w:firmware.hex:i
```
### Programmer not responding

- Check the correct port (/dev/ttyACM0, /dev/ttyUSB0, or COM3)
- Ensure you're in the dialout group: sudo usermod -a -G dialout $USER
- Try the reset trick: press reset, then immediately run avrdude.
