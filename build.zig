const std = @import("std");

pub fn build(b: *std.Build) void {
    const Board = enum {
        mega2560,
        // TODO: Add more boards
    };

    const BoardConfig = struct {
        name: []const u8,
        avrdude: []const u8,
        programmer: []const u8,
        port: []const u8,
        baud: []const u8,
        cpu_model: *const std.Target.Cpu.Model,
    };

    const board_configs = std.EnumMap(Board, BoardConfig).init(.{
        .mega2560 = .{
            .name = "atmega2560",
            .avrdude = "m2560",
            .programmer = "wiring",
            .port = "/dev/ttyACM0",
            .baud = "115200",
            .cpu_model = &std.Target.avr.cpu.atmega2560,
        },
        // TODO: Add more configs
    });

    const board = b.option(Board, "board", "Target board") orelse .mega2560;
    const config = board_configs.get(board).?;

    const target = b.resolveTargetQuery(.{
        .cpu_arch = .avr,
        .cpu_model = .{ .explicit = config.cpu_model },
        .os_tag = .freestanding,
    });

    const options = b.addOptions();
    options.addOption(Board, "board", board);

    const lib = b.addObject(.{
        .name = "zig-avr",
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = .ReleaseSmall,
    });
    lib.root_module.addOptions("config", options);

    b.default_step.dependOn(&lib.step);
}
