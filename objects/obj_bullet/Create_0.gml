// obj_bullet — a projectile. Fired by the player (cyan) or enemies (red/orange).

dir = 1;
spd = 9;
enemy_bullet = false;
life = 0;

function bullet_step() {
    x += dir * spd;
    life++;
    if (life > 90) { instance_destroy(self); exit; }

    // hit hostiles (player bullets)
    if (!enemy_bullet) {
        with (obj_hostile) {
            if (point_distance(other.x, other.y, x, y) < 20) {
                hp -= 1;
                if (hp <= 0) instance_destroy(id);
                instance_destroy(other.id);
                exit;
            }
        }
    }
    // hit player (enemy bullets)
    if (enemy_bullet && instance_exists(obj_player)) {
        if (point_distance(x, y, obj_player.x, obj_player.y) < 18) {
            global.health = max(0, global.health - 12);
            global.cam_shake = 6;
            instance_destroy(self);
            exit;
        }
    }
}

function render() {
    var sx = x - global.cam_x;
    var sy = y - global.cam_y;
    draw_glow(sx, sy, 5, enemy_bullet ? COL_ORANGE : COL_CYAN, 0.5);
    draw_set_colour(enemy_bullet ? COL_ORANGE : COL_CYAN);
    draw_line_width(sx - dir * 8, sy, sx + dir * 4, sy, 2);
}