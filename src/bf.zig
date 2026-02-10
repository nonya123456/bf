const std = @import("std");

pub const Interpreter = struct {
    pc: usize,
    dp: usize,
    mem: std.ArrayList(u8),

    const max_size = 30000;

    const Self = @This();

    pub fn init() Self {
        return .{
            .pc = 0,
            .dp = 0,
            .mem = .empty,
        };
    }

    pub fn deinit(self: *Self, allocator: std.mem.Allocator) void {
        self.mem.deinit(allocator);
    }
};
