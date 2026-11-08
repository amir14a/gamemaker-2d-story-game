// obj_trigger — an invisible zone that fires a story beat when the player crosses
// it. Placed by the scene builder to pace the narrative by movement.

trigger_id = -1;   // index into the scene beat list to fire (or -1 = next chrono)
fired = false;
w = 60;
h = 60;

function trigger_step() {
    if (fired) exit;
    if (!instance_exists(obj_player)) exit;
    var p = obj_player;
    if (point_in_rectangle(p.x, p.y, x, y, x + w, y + h)) {
        fired = true;
        with (obj_controller) {
            if (other.trigger_id >= 0 && other.trigger_id < array_length(global.story.beats)) {
                fire_beat(global.story.beats[other.trigger_id]);
            } else {
                player_reached_goal();
            }
        }
    }
}

function render() {
    var sx = x - global.cam_x;
    var sy = y - global.cam_y;
    var p = 0.5 + 0.5 * sin(global.tick * 0.08);
    draw_glow(sx, sy, 16, COL_GOLD, 0.5 * p);
    draw_set_colour(COL_GOLD);
    draw_set_alpha(0.6 + 0.4 * p);
    draw_circle(sx, sy, 5, true);
    draw_set_alpha(0.8);
    draw_set_colour(COL_WHITE);
    draw_circle(sx, sy, 2, false);
    draw_set_alpha(1);
}