// obj_controller — STEP event. Run the HUD, timers, camera and scene pacing.

global.tick++;

// --- touch input scan (mobile) ---
if (global.touch_enabled) {
    for (var i = 0; i < 8; i++) {
        global.vbtn_pressed[i] = false;
        global.vbtn_released[i] = false;
    }
    for (var t = 0; t < 16; t++) {
        if (!device_mouse_check_button(t, mb_left)) continue;
        var px = device_mouse_x(t);
        var py = device_mouse_y(t);
        var hit = -1;
        for (var b = 0; b < 8; b++) {
            var r = scr_btn_region(b);
            if (px >= r[0] && px <= r[2] && py >= r[1] && py <= r[3]) { hit = b; break; }
        }
        if (hit < 0) continue;
        global.vbtn_held[hit] = true;
        if (global.touch_ids[hit] == -1) global.vbtn_pressed[hit] = true;
        global.touch_ids[hit] = t;
    }
    for (var b = 0; b < 8; b++) {
        if (global.touch_ids[b] != -1 && !device_mouse_check_button(global.touch_ids[b], mb_left)) {
            global.vbtn_held[b] = false;
            global.vbtn_released[b] = true;
            global.touch_ids[b] = -1;
        }
    }
}

// --- menu / pause / select state ---
if (global.game_state != "play") {
    menu_step();
    // keep ambient motes alive on the menu
    for (var i = 0; i < array_length(global.motes); i++) {
        var m = global.motes[i];
        m.y -= m.spd;
        if (m.y < -10) { m.y = global.vpH + 10; m.x = global.vpW * h32(777, i, 0); }
    }
    exit;
}

// ===== playing state =====

// pause toggle
if (btn_pressed(BTN_PAUSE)) {
    global.game_state = "pause";
    global.menu_sel = 0;
    exit;
}

// --- subtitle timer ---
if (global.story.subtitle != undefined) {
    global.story.subtitle_timer--;
    if (global.story.subtitle_timer <= 0) global.story.subtitle = undefined;
}

// --- title timer ---
if (global.story.title_timer > 0) global.story.title_timer--;

// --- dialogue advance ---
if (global.story.active) {
    var full = global.story.dialogue.text;
    global.story.type_chars += 1.5;
    if (global.story.type_chars >= string_length(full)) global.story.type_chars = string_length(full);
    if (btn_pressed(BTN_ACTION) || btn_pressed(BTN_JUMP)) {
        if (global.story.type_chars < string_length(full)) {
            global.story.type_chars = string_length(full);
        } else {
            global.story.active = false;
            global.story.dialogue = undefined;
            alarm[0] = 20;
        }
    }
}

// --- non-blocking beat gate ---
if (!global.story.active && global.story.dialogue == undefined && !global.story.credits) {
    if (global.beat_delay_timer > 0) {
        global.beat_delay_timer--;
        if (global.beat_delay_timer <= 0) story_advance();
    }
}

// --- camera follows player ---
if (instance_exists(obj_player)) {
    var p = obj_player;
    var tx = p.x - global.vpW / 2;
    var ty = p.y - global.vpH / 2;
    global.cam_x = lerp(global.cam_x, tx, 0.08);
    global.cam_y = lerp(global.cam_y, ty, 0.08);
}

if (global.cam_shake > 0) global.cam_shake = max(0, global.cam_shake - 1);

for (var i = 0; i < array_length(global.motes); i++) {
    var m = global.motes[i];
    m.y -= m.spd;
    if (m.y < -10) { m.y = global.vpH + 10; m.x = global.vpW * h32(777, i, 0); }
}

// credits auto-advance to menu
if (global.story.credits) {
    global.credits_timer = global.credits_timer + 1;
    if (global.credits_timer > 60 * 30 || btn_pressed(BTN_ACTION)) {
        global.story.credits = false;
        global.story.over = true;
        global.game_state = "menu";
        global.menu_sel = 0;
    }
}