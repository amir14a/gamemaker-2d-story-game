// obj_player — the playable character (James in present, Millie in flashbacks).
// Handles running, jumping/vaulting, climbing, shooting, and swimming, then draws
// a clean vector character with a neon scarf/noise.

// State vars
vx = 0;
vy = 0;
facing = 1;          // 1 = right, -1 = left
on_ground = false;
can_climb = false;
climbing = false;
swimming = false;
shoot_cd = 0;
coyote = 0;
jump_buffer = 0;
walk_anim = 0;
is_millie = false;   // set when playing flashbacks (changed by scene)

// movement tuning
RUN_SPD = 3.6;
JUMP_V  = -9.0;
GRAV    = 0.5;
MAX_VY  = 12;

// world bounds (these scenes are open-run areas, but we keep the player in a band)
WORLD_W = 3400;

// physics (custom, tile-free: we use simple ground line + platform segments)
function player_step() {
    shoot_cd = max(0, shoot_cd - 1);
    walk_anim += abs(axis_x()) * 0.2;

    // determine mode from level
    var mode = global.scene_mode;

    if (mode == "swim") {
        swipe();
    } else if (mode == "climb") {
        climb();
    } else if (mode == "drive" || mode == "ride") {
        // handled by vehicle; the player "rides" and we ignore direct control
        follow_vehicle();
    } else {
        groundrun();
    }

    // shooting (James / Millie both can fire; only James in action scenes mostly)
    if (btn(BTN_SHOOT) && shoot_cd <= 0 && !global.story.active && mode != "drive" && mode != "ride") {
        fire_bullet();
    }

    // clamp world horizontal
    x = clamp(x, 30, WORLD_W - 30);
}

function groundrun() {
    var ax = axis_x();
    var spd = RUN_SPD * (btn(BTN_JUMP) ? 1.25 : 1.0);   // slight boost while airborne-ish
    vx = ax * spd;
    if (ax != 0) facing = ax;

    // jump (with coyote time + buffer)
    if (btn_pressed(BTN_JUMP)) jump_buffer = 8;
    jump_buffer = max(0, jump_buffer - 1);
    if (on_ground) coyote = 6; else coyote = max(0, coyote - 1);

    if (jump_buffer > 0 && coyote > 0) {
        vy = JUMP_V;
        on_ground = false;
        coyote = 0;
        jump_buffer = 0;
    }

    // gravity
    if (!on_ground) {
        vy += GRAV;
        vy = min(vy, MAX_VY);
    }
    y += vy;

    // ground collision (single ground line near bottom of world band)
    var ground_y = room_height - 70;
    if (climbing) {
        // climbing branch handled by climb(); no gravity
    } else if (y >= ground_y) {
        y = ground_y;
        vy = 0;
        on_ground = true;
    } else {
        on_ground = false;
    }
    x += vx;

    // optional climb trigger near vertical ropes (represented by can_climb zones)
    if (can_climb && btn(BTN_UP)) climbing = true;
    if (climbing && !btn(BTN_UP) && !btn(BTN_DOWN) && on_ground) climbing = false;
}

function climb() {
    // vertical ascent scene: move up/down and side-to-side along the shaft
    var ay = axis_y();
    var ax = axis_x();
    vx = ax * RUN_SPD * 0.6;
    vy = -ay * RUN_SPD * 0.8;
    x += vx;
    y += vy;
    y = clamp(y, 60, room_height - 70);
    if (ax != 0) facing = ax;
}

function swipe() {
    // swimming: buoyancy + directional thrust
    var ax = axis_x();
    var ay = axis_y();
    vx += ax * 0.5;
    vy += ay * 0.5;
    vx *= 0.9;
    vy *= 0.9;
    // slow upward drift (buoyancy) unless pressing down
    vy -= 0.12;
    x += vx;
    y += vy;
    y = clamp(y, 60, room_height - 70);
    if (ax != 0) facing = ax;

    // breath meter
    global.breath -= 0.08;
    if (abs(y - 40) < 8) global.breath = min(100, global.breath + 1.5);
    global.breath = clamp(global.breath, 0, 100);
    if (global.breath <= 0) global.health = max(0, global.health - 0.4);
}

function follow_vehicle() {
    // the vehicle drives the position; the player holds on
    // (no-op: obj_vehicle moves and the camera follows it via a linked reference)
}

function fire_bullet() {
    shoot_cd = 14;
    var bx = x + facing * 22;
    var by = y - 8;
    with (instance_create_layer(bx, by, "Instances", obj_bullet)) {
        dir = other.facing;
        spd = 9;
    }
    // small recoil feedback
    vy -= 1.2;
}

// Render the character as vector art in GUI space (camera-relative).
function render() {
    var sx = x - global.cam_x;
    var sy = y - global.cam_y;

    var t = global.tick + (global.story.active ? 0 : walk_anim * 8);
    var bobbob = (global.story.active ? 0 : sin(walk_anim * 6) * 1.5);
    var isM = is_millie;

    var suit   = isM ? COL_MAGENTA : COL_CYAN;
    var suit_d = isM ? make_colour_rgb(120,20,70) : make_colour_rgb(20,70,90);
    var skin   = make_colour_rgb(226,178,150);
    var hair   = isM ? make_colour_rgb(40,16,30) : make_colour_rgb(22,22,32);
    var scarf  = isM ? COL_PINK : COL_CYAN;

    draw_glow(sx, sy + 4, 18, suit, 0.35);

    var leg_swing = sin(walk_anim * 8) * 4;
    draw_set_colour(suit_d);
    draw_line_width(sx, sy - 10 + bobbob, sx - leg_swing, sy, 4);
    draw_line_width(sx, sy - 10 + bobbob, sx + leg_swing, sy, 4);

    draw_set_colour(suit_d);
    draw_roundrect_ext(sx - 10, sy - 26 + bobbob, sx + 10, sy - 8 + bobbob, 6, 6, false);
    draw_set_colour(suit);
    draw_set_alpha(0.8);
    draw_circle(sx + facing * 2, sy - 18 + bobbob, 2, false);
    draw_set_alpha(1);

    var arm_swing = sin(walk_anim * 8) * -3;
    draw_set_colour(suit_d);
    draw_line_width(sx, sy - 22 + bobbob, sx + facing * 8, sy - 12 + bobbob + arm_swing, 3);

    draw_set_colour(skin);
    draw_circle(sx, sy - 34 + bobbob, 9, false);
    draw_set_colour(hair);
    draw_roundrect_ext(sx - 9, sy - 40 + bobbob, sx + 9, sy - 30 + bobbob, 5, 5, false);

    draw_set_colour(scarf);
    var sc = sin(t * 0.1) * 3;
    draw_line_width(sx - facing * 8, sy - 30 + bobbob, sx - facing * 20, sy - 26 + bobbob + sc, 3);

    draw_set_alpha(1);
    draw_set_colour(c_white);
}