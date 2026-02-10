const std = @import("std");

const bf = @import("bf.zig");

pub fn main() !void {
    var da = std.heap.DebugAllocator(.{}){};
    defer _ = da.deinit();

    const allocator = da.allocator();

    var interpreter: bf.Interpreter = .init();
    defer interpreter.deinit(allocator);

    _ = interpreter.dp + 1;

    std.debug.print("Hello, World {}\n", .{interpreter.dp});
}
