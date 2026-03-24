const std = @import("std");

pub fn build(b: *std.Build) void {
    // Library target (for users)
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // This is the library module that users will import
    _ = b.addModule("zig-avr", .{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    // TODO: Build examples will be added later
    // const examples = [_]struct { name: []const u8, path: []const u8 }{};
    // inline for (examples) |ex| {
    //     const exe = b.addExecutable(.{
    //         .name = ex.name,
    //         .root_source_file = b.path(ex.path),
    //         .target = target,
    //         .optimize = optimize,
    //     });
    //     b.installArtifact(exe);
    // }
}
