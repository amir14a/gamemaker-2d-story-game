// obj_hostile — a Mire thug / Saint-Cloud interceptor that patrols and shoots.
// Drawn as a menacing vector figure. They take damage from bullets.

hp = 3;
dir = 1;
shoot_cd = 60;
walk_anim = 0;
anchor = x;

function hostile_step() {
    walk_anim += 0.1;
    // simple patrol within a range
    x += dir * 1.2;
    if (abs(x - anchor) > 120) dir = -dir;
    // shoot at player if aligned and close
    shoot_cd--;
    if (shoot_cd <= 0 && instance_exists(obj_player) && !global.story.active) {
        var p = obj_player;
        if (abs(p.y - y) < 40 && abs(p.x - x) < 380) {
            shoot_cd = 70;
            with (instance_create_layer(x + dir * 16, y - 6, "Instances", obj_bullet)) {
                dir = other.dir;
                spd = 7;
                enemy_bullet = true;
            }
        }
    }
    if (hp <= 0) instance_destroy(self);
}

function render() {
    var sx = x - global.cam_x;
    var sy = y - global.cam_y;
    draw_glow(sx, sy + 2, 14, COL_RED, 0.3);
    draw_set_colour(make_colour_rgb(30,20,40));
    draw_roundrect_ext(sx - 11, sy - 24, sx + 11, sy, 6, 6, false);
    draw_set_colour(make_colour_rgb(10,10,20));
    draw_circle(sx, sy - 30, 9, false);
    draw_set_colour(COL_RED);
    draw_set_alpha(0.9);
    draw_roundrect_ext(sx - 8, sy - 32, sx + 8, sy - 27, 2, 2, false);
    draw_set_alpha(1);
    draw_set_colour(COL_DARKGREY);
    draw_line_width(sx + dir * 8, sy - 14, sx + dir * 18, sy - 8, 3);
}