const rl = @import("raylib");
const std = @import("std");

const Direction = enum {
    Right,
    Down,
    Left,
    Up,

    fn as_bitmask(self: Direction) u4 {
        return switch (self) {
            .Right => 0b1000,
            .Down => 0b0100,
            .Left => 0b0010,
            .Up => 0b0001,
        };
    }

    fn as_vec2(self: Direction) rl.Vector2 {
        return switch (self) {
            .Right => vec2(1, 0),
            .Down => vec2(0, 1),
            .Left => vec2(-1, 0),
            .Up => vec2(0, -1),
        };
    }
};

fn floatEqual(comptime T: type, value: T, target: T) bool {
    return std.math.approxEqAbs(T, value, target, std.math.floatEpsAt(T, target));
}

fn uVal(comptime T: type, x: bool) T {
    return @as(T, @intFromBool(x));
}

const Player = struct {
    pos: rl.Vector2,
    size: rl.Vector2,
    direction_mask: u4,
    vel: f32,

    fn draw(self: *Player) void {
        rl.drawRectangleV(self.pos, self.size, rl.Color.green);
    }

    fn direction_from_bitmask(self: *Player, bitmask: u4) rl.Vector2 {
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
            else => {
                // at least 3 bits set: update, but keep last direction
                const number_bits: u8 =
                    ((self.direction_mask & 0b1000) >> 3) +
                    ((self.direction_mask & 0b0100) >> 2) +
                    ((self.direction_mask & 0b0010) >> 1) +
                    (self.direction_mask & 0b0001);

                std.debug.assert(number_bits <= 2); // Maximal two bits set
                return self.direction_from_bitmask(self.direction_mask);
            },
        };
    }

    fn update(self: *Player, _: f32) void {
        const keys: u4 = ( //
            (uVal(u4, rl.isKeyDown(.key_right)) << 3) |
            (uVal(u4, rl.isKeyDown(.key_down)) << 2) |
            (uVal(u4, rl.isKeyDown(.key_left)) << 1) |
            (uVal(u4, rl.isKeyDown(.key_up))));
        const direction = self.direction_from_bitmask(keys);

        if (!floatEqual(f32, direction.length(), 0)) {
            std.debug.assert(floatEqual(f32, direction.length(), 1));
            std.debug.assert(!floatEqual(f32, self.vel, 0));
            const step = direction.scale(self.vel);
            self.pos = self.pos.add(step);
        }
    }
};

const screenWidth = 800;
const screenHeight = 800;
const gravity = vec2(0, 9.81);
const defaultPlayerVelocity = 5;

fn vec2(x: f32, y: f32) rl.Vector2 {
    return rl.Vector2{ .x = x, .y = y };
}

pub fn main() anyerror!void {
    rl.initWindow(screenWidth, screenHeight, "ReSource");
    defer rl.closeWindow();

    rl.setTargetFPS(60);

    var player = Player{ .pos = vec2(20, 20), .size = vec2(20, 20), .direction_mask = Direction.Right.as_bitmask(), .vel = defaultPlayerVelocity };

    while (!rl.windowShouldClose()) {
        const dt = rl.getFrameTime();
        // Update
        {
            player.update(dt);
        }

        // Draw
        {
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(rl.Color.black);

            player.draw();

            rl.drawFPS(5, 5);
        }
    }
}
