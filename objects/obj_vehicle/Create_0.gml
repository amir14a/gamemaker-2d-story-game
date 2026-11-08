// obj_vehicle — the courier hauler (Episode 2) / bike (Episode 4). Drives the
// player forward along the ring-road or industrial artery, tilts into hills, and
// is drawn with a clean neon silhouette.

spd = 5;
tilt = 0;
wheel_rot = 0;
is_bike = false;

function vehicle_step() {
    wheel_rot += spd * 0.3;
    x += spd;
    if (x > global.WORLD_W * 3) x = 0;

    // tilt into climbs based on a fake track sine
    var track = sin(x * 0.01);
    tilt = track * 12;

    // the player jumps on board
    if (instance_exists(obj_player)) {
        var p = obj_player;
        if (point_distance(x, y, p.x, p.y) < 40 && btn_pressed(BTN_ACTION)) {
            p.x = x; p.y = y - 18;
            riding = true;
        }
        if (riding) {
            p.x = x; p.y = y - 18 + tilt * 0.3;
            p.facing = 1;
        }
    }
}

function render() {
    var sx = x - global.cam_x;
    var sy = y - global.cam_y + tilt * 0.5;
    draw_glow(sx, sy - 4, 20, is_bike ? COL_ORANGE : COL_CYAN, 0.3);
    if (is_bike) {
        draw_set_colour(make_colour_rgb(28,24,40));
        draw_line_width(sx - 14, sy, sx + 14, sy, 6);
        draw_line_width(sx - 4, sy, sx - 2, sy - 12, 4);
        draw_roundrect_ext(sx - 8, sy - 16, sx + 6, sy - 8, 4, 4, false);
        draw_set_colour(COL_ORANGE);
        draw_circle(sx - 12, sy, 5, true);
        draw_circle(sx + 12, sy, 5, true);
        draw_set_colour(COL_CYAN);
        draw_circle(sx + 12, sy, 2, false);
    } else {
        draw_set_colour(make_colour_rgb(22,26,44));
        draw_roundrect_ext(sx - 26, sy - 18, sx + 26, sy - 2, 8, 8, false);
        draw_set_colour(make_colour_rgb(40,46,72));
        draw_roundrect_ext(sx - 20, sy - 26, sx + 12, sy - 18, 5, 5, false);
        draw_set_colour(COL_CYAN);
        draw_glow(sx - 16, sy, 6, COL_CYAN, 0.5);
        draw_circle(sx - 16, sy, 5, false);
        draw_circle(sx + 16, sy, 5, false);
        draw_set_alpha(0.3);
        draw_set_colour(COL_CYAN);
        draw_triangle(sx + 26, sy - 10, sx + 70, sy - 22, sx + 70, sy - 4, false);
        draw_set_alpha(1);
    }
}