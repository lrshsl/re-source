pub const std = @import("std");
pub const rl = @import("raylib");

pub fn floatEqual(comptime T: type, value: T, target: T) bool {
    return std.math.approxEqAbs(T, value, target, std.math.floatEpsAt(T, target));
}

pub fn uVal(comptime T: type, x: bool) T {
    return @as(T, @intFromBool(x));
}

pub fn vec2(x: f32, y: f32) rl.Vector2 {
    return rl.Vector2{ .x = x, .y = y };
}
