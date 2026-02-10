const std = @import("std");

const bf = @import("bf.zig");

pub fn main(init: std.process.Init) !void {
    var da = std.heap.DebugAllocator(.{}){};
    defer _ = da.deinit();

    const allocator = da.allocator();

    var interpreter: bf.Interpreter = .init();
    defer interpreter.deinit(allocator);

    //const src: []const u8 = ">++++++++[<+++++++++>-]<.>++++[<+++++++>-]<+.+++++++..+++.>>++++++[<+++++++>-]<++.------------.>++++++[<+++++++++>-]<+.<.+++.------.--------.>>>++++[<++++++++>-]<+."; // Hello, World
    const src: []const u8 = ",[.,]"; // Echo
    try interpreter.compile(allocator, src);

    var stdout_buf: [4096]u8 = undefined;
    var file_writer = std.Io.File.stdout().writer(init.io, &stdout_buf);
    defer _ = file_writer.flush() catch {};

    var stdin_buf: [4096]u8 = undefined;
    var file_reader = std.Io.File.stdin().reader(init.io, &stdin_buf);

    try interpreter.execute(allocator, &file_writer.interface, &file_reader.interface);
}
