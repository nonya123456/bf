const std = @import("std");
const Allocator = std.mem.Allocator;

const Operator = enum {
    inc_dp,
    dec_dp,
    inc_val,
    dec_val,
    out,
    in,
    jmp_fwd,
    jmp_bck,
};

const Instruction = struct {
    operator: Operator,
    operand: ?usize,
};

pub const Interpreter = struct {
    prog: std.ArrayList(Instruction),

    const Self = @This();

    pub fn init() Self {
        return .{
            .prog = .empty,
        };
    }

    pub fn deinit(self: *Self, allocator: Allocator) void {
        self.prog.deinit(allocator);
    }

    pub fn compile(self: *Self, allocator: Allocator, src: []const u8) !void {
        var stack: std.ArrayList(usize) = .empty;
        defer stack.deinit(allocator);

        var pc: usize = 0;
        while (pc < src.len) : (pc += 1) {
            switch (src[pc]) {
                '>' => {
                    try self.prog.append(allocator, .{
                        .operator = .inc_dp,
                        .operand = null,
                    });
                },
                '<' => {
                    try self.prog.append(allocator, .{
                        .operator = .dec_dp,
                        .operand = null,
                    });
                },
                '+' => {
                    try self.prog.append(allocator, .{
                        .operator = .inc_val,
                        .operand = null,
                    });
                },
                '-' => {
                    try self.prog.append(allocator, .{
                        .operator = .dec_val,
                        .operand = null,
                    });
                },
                '[' => {
                    try self.prog.append(allocator, .{
                        .operator = .jmp_fwd,
                        .operand = null,
                    });
                    try stack.append(allocator, pc);
                },
                ']' => {
                    const jmp_pc = stack.pop() orelse return error.UnmatchedBracket;
                    try self.prog.append(allocator, .{
                        .operator = .jmp_bck,
                        .operand = jmp_pc,
                    });

                    self.prog.items[jmp_pc].operand = pc;
                },
                ',' => {
                    try self.prog.append(allocator, .{
                        .operator = .in,
                        .operand = null,
                    });
                },
                '.' => {
                    try self.prog.append(allocator, .{
                        .operator = .out,
                        .operand = null,
                    });
                },
                else => {},
            }
        }

        if (stack.items.len != 0) {
            return error.UnmatchedBracket;
        }
    }

    pub fn execute(self: *Self, allocator: Allocator) !void {
        const data = try allocator.alloc(u8, 30000);
        defer allocator.free(data);

        @memset(data, 0);

        var dp: usize = 0;
        var pc: usize = 0;
        while (pc < self.prog.items.len) : (pc += 1) {
            const ins = self.prog.items[pc];
            switch (ins.operator) {
                .inc_dp => {
                    if (dp == data.len - 1) {
                        dp = 0;
                    } else {
                        dp += 1;
                    }
                },
                .dec_dp => {
                    if (dp == 0) {
                        dp = data.len - 1;
                    } else {
                        dp -= 1;
                    }
                },
                .inc_val => {
                    data[dp] +%= 1;
                },
                .dec_val => {
                    data[dp] -%= 1;
                },
                .out => {
                    std.debug.print("{c}", .{data[dp]});
                },
                .in => {
                    std.debug.panic("", .{});
                },
                .jmp_fwd => {
                    if (data[dp] == 0) {
                        pc = ins.operand orelse std.debug.panic("", .{});
                    }
                },
                .jmp_bck => {
                    if (data[dp] > 0) {
                        pc = ins.operand orelse std.debug.panic("", .{});
                    }
                },
            }
        }
    }
};
