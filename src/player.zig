pub const std = @import("std");
pub const rl = @import("raylib");
pub const utils = @import("utils.zig");
pub const vec2 = utils.vec2;

pub const Player = struct {
    pos: rl.Vector2,
    size: rl.Vector2,
    direction_mask: u4,
    vel: f32,

    pub fn draw(self: *Player) void {
        rl.drawRectangleV(self.pos, self.size, rl.Color.green);
    }

    pub fn direction_from_bitmask(bitmask: u4) ?rl.Vector2 {
        std.debug.assert(bitmask < 0x10); // only 4 bits must be used
        return switch (bitmask) {
            0b1000 => vec2(1, 0),
            0b1100 => vec2(1, 1).normalize(),
            0b0100 => vec2(0, 1),
            0b0110 => vec2(-1, 1).normalize(),
            0b0010 => vec2(-1, 0),
            0b0011 => vec2(-1, -1).normalize(),
            0b0001 => vec2(0, -1),
            0b1001 => vec2(1, -1).normalize(),
            0 => rl.Vector2.zero(),
            else => null,
        };
    }

    pub fn update(self: *Player, _: f32) void {
        const keys: u4 = ( //
            (utils.uVal(u4, rl.isKeyDown(.key_right)) << 3) |
            (utils.uVal(u4, rl.isKeyDown(.key_down)) << 2) |
            (utils.uVal(u4, rl.isKeyDown(.key_left)) << 1) |
            (utils.uVal(u4, rl.isKeyDown(.key_up))));

        // Zig is simple and readable..?
        const direction = if (direction_from_bitmask(keys)) |direction| blk: {
            self.direction_mask = keys;
            break :blk direction;
        } else direction_from_bitmask(self.direction_mask).?;

        if (utils.floatEqual(f32, direction.length(), 1)) {
            std.debug.assert(!utils.floatEqual(f32, self.vel, 0));

            const step = direction.scale(self.vel);
            self.pos = self.pos.add(step);
        }
    }
};
