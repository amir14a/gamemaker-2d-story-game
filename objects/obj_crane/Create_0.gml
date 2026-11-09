// obj_crane — a paper crane collectible. The recurring motif. Collecting one
// shows the breadcrumb trail line, and (at key beats) advances the story.

spin = 0;
picked = false;
hover = 0;

function crane_collect() {
    if (!instance_exists(obj_player)) return;
    if (point_distance(x, y, obj_player.x, obj_player.y) < 24 && !picked) {
        picked = true;
        global.cam_shake = 3;
        global.cranes_collected = global.cranes_collected + 1;
        with (obj_controller) {
            var st = {};
            st.type = "subtitle";
            st.who = "";
            st.text = "A paper crane. The next breadcrumb.";
            st.dur = 2;
            st.size = 1;
            global.story.subtitle = st;
            global.story.subtitle_timer = 120;
        }
        instance_destroy(self);
    }
}

function render() {
    var sx = x - global.cam_x;
    var sy = y - global.cam_y + hover;
    draw_glow(sx, sy, 12, COL_WHITE, 0.4);
    draw_set_colour(make_colour_rgb(235,240,250));
    draw_set_alpha(0.95);
    var fold = sin(spin * 2) * 1.5;
    draw_triangle(sx, sy - 6, sx + 10, sy + 2, sx - 4, sy + 4 + fold, false);
    draw_triangle(sx, sy - 6, sx - 10, sy + 2, sx + 4, sy + 4 + fold, false);
    draw_triangle(sx, sy - 2, sx + 6, sy + 10, sx - 6, sy + 10, false);
    draw_set_alpha(1);
    draw_set_colour(make_colour_rgb(180,190,210));
    draw_set_alpha(0.6);
    draw_line(sx, sy - 2, sx, sy + 6);
    draw_set_alpha(1);
}