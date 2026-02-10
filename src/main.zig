const std = @import("std");

const bf = @import("bf.zig");

pub fn main() !void {
    const interpreter: bf.Interpreter = .init();

    _ = interpreter.dp + 1;

    std.debug.print("Hello, World {}\n", .{interpreter.dp});
}
