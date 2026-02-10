const std = @import("std");

const bf = @import("bf.zig");

pub fn main() !void {
    var da = std.heap.DebugAllocator(.{}){};
    defer _ = da.deinit();

    const allocator = da.allocator();

    var interpreter: bf.Interpreter = .init();
    defer interpreter.deinit(allocator);

    const hello_world_src: []const u8 = ">++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<++.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-]<+.";

    try interpreter.compile(allocator, hello_world_src);

    try interpreter.execute(allocator);
}
