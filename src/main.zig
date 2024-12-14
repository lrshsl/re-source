pub const std = @import("std");
pub const rl = @import("raylib");
pub const Direction = @import("direction.zig").Direction;
pub const Player = @import("player.zig").Player;
pub const utils = @import("utils.zig");
pub const vec2 = utils.vec2;

const screenWidth = 800;
const screenHeight = 800;
const gravity = vec2(0, 9.81);
const defaultPlayerVelocity = 5;

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
