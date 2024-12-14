const rl = @import("raylib");
pub const utils = @import("utils.zig");
pub const vec2 = utils.vec2;

pub const Direction = enum {
    Right,
    Down,
    Left,
    Up,

    pub fn as_bitmask(self: Direction) u4 {
        return switch (self) {
            .Right => 0b1000,
            .Down => 0b0100,
            .Left => 0b0010,
            .Up => 0b0001,
        };
    }

    pub fn as_vec2(self: Direction) rl.Vector2 {
        return switch (self) {
            .Right => vec2(1, 0),
            .Down => vec2(0, 1),
            .Left => vec2(-1, 0),
            .Up => vec2(0, -1),
        };
    }
};
