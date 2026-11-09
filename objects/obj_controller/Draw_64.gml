// obj_controller — DRAW (GUI) event. This is where ALL vector art is rendered:
// skyline, ambient motes, characters, UI (subtitles, comm cards, HUD, touch UI).
// Everything is drawn in GUI space to keep resolution independent.

// ---- menu / pause / select overlay ----
if (global.game_state != "play") {
    menu_draw();
    exit;
}

// Camera shake offset
var shx = 0, shy = 0;
if (global.cam_shake > 0) {
    shx = random_range(-global.cam_shake, global.cam_shake);
    shy = random_range(-global.cam_shake, global.cam_shake);
}

// ---- background gradient ----
var gcol1 = global.stratum == STRATUM_APEX ? COL_BG : COL_BG;
var gcol2 = global.stratum == STRATUM_FOUNDRY ? make_colour_rgb(30,10,20) : COL_BG2;
draw_set_color(gcol1);
draw_set_alpha(1);
draw_rectangle(0, 0, global.vpW, global.vpH, false);
// subtle vertical glow band
draw_set_alpha(0.5);
draw_set_colour(gcol2);
draw_rectangle(0, global.vpH * 0.4, global.vpW, global.vpH, false);
draw_set_alpha(1);

// ---- parallax skyline (camera relative) ----
var cam = global.cam_x;
var ll = array_length(global.layers);
for (var L = 0; L < ll; L++) {
    var lay = global.layers[L];
    var off = cam * lay.speed;
    var nb = array_length(lay.buildings);
    var ground = global.vpH - 40;
    for (var i = 0; i < nb; i++) {
        var b = lay.buildings[i];
        var bx = b.x - (off mod (60 + L * 40 + 40));
        // wrap horizontally
        while (bx < -200) bx += 3400;
        while (bx > 3200) bx -= 3400;
        if (bx > global.vpW + 200) continue;
        var bh = b.h;
        var by = ground - bh;
        draw_set_colour(lay.col);
        draw_set_alpha(0.5 - L * 0.12);
        draw_rectangle(bx, by, bx + b.w, ground + 20, false);
        // window lights
        var wl = global.stratum == STRATUM_SINK ? COL_MAGENTA : COL_CYAN;
        draw_set_colour(wl);
        for (var wy = by + 10; wy < ground; wy += 10) {
            for (var wx = bx + 6; wx < bx + b.w - 4; wx += 12) {
                if (h32(222 + L, wx, wy) > 0.72) {
                    draw_set_alpha(0.8);
                    draw_rectangle(wx, wy, wx + 3, wy + 4, false);
                }
            }
        }
    }
}
draw_set_alpha(1);

// ---- ambient motes (e.g. rain / ash / sparks / bubbles) ----
for (var i = 0; i < array_length(global.motes); i++) {
    var m = global.motes[i];
    var mx = m.x, my = m.y;
    draw_set_color(m.col);
    draw_set_alpha(0.5);
    if (global.stratum == STRATUM_SINK) {
        draw_line(mx, my, mx, my + 6);
    } else {
        draw_circle(mx, my, 1, false);
    }
}
draw_set_alpha(1);

// ---- ground fog line ----
draw_set_color(COL_CYAN);
draw_set_alpha(0.25);
draw_line(0, global.vpH - 30, global.vpW, global.vpH - 30);
draw_set_alpha(1);

// ---- draw the world-space entities in GUI space via their render() methods ----
draw_set_colour(c_white);
draw_set_alpha(1);
with (obj_trigger) render();
with (obj_crane) render();
with (obj_hostile) render();
with (obj_vehicle) render();
with (obj_bullet) render();
with (obj_player) render();

// ---- objective banner ----
if (global.story.objective != "") {
    var ow = string_width(global.story.objective) + 40;
    var ox = global.vpW / 2 - ow / 2;
    draw_round_rect_glow(ox, 46, ox + ow, 78, 6, make_colour_rgb(10,14,28), COL_CYAN, 0.6);
    draw_set_colour(COL_CYAN);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(global.vpW / 2, 62, global.story.objective);
}

// ---- episode title splash ----
if (global.story.title_timer > 0) {
    var ta = min(1, global.story.title_timer / 30);
    draw_set_alpha(ta);
    draw_round_rect_glow(0, global.vpH / 2 - 70, global.vpW, global.vpH / 2 + 40, 0,
        make_colour_rgb(6,8,20), COL_MAGENTA, 0.5 * ta);
    draw_set_color(COL_WHITE);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(FONT_TITLE);
    draw_text(global.vpW / 2, global.vpH / 2 - 20, global.story.title_text);
    draw_set_font(-1);
    draw_set_alpha(1);
}

// ---- floating subtitle ----
if (global.story.subtitle != undefined && !global.story.active) {
    var st = global.story.subtitle;
    var sa = 1;
    if (global.story.subtitle_timer < 40) sa = global.story.subtitle_timer / 40;
    var who = st.who != "" ? st.who + ":  " : "";
    var str = who + st.text;
    // wrap
    var maxw = global.vpW * 0.8;
    var lines = scr_text_wrap(str, maxw);
    var n = array_length(lines);
    var sh = n * 20 + 24;
    var sy = global.vpH - sh - 54;
    draw_set_alpha(sa);
    draw_round_rect_glow(global.vpW * 0.1, sy, global.vpW * 0.9, sy + sh, 8,
        make_colour_rgb(8,10,24), COL_CYAN, 0.4 * sa);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var wx = global.vpW / 2;
    for (var i = 0; i < n; i++) {
        draw_set_color(i == 0 && st.who != "" ? speaker_colour(st.who) : COL_WHITE);
        draw_text(wx, sy + 10 + i * 20, lines[i]);
    }
    draw_set_alpha(1);
}

// ---- comm / meeting dialogue card ----
if (global.story.active && global.story.dialogue != undefined) {
    var d = global.story.dialogue;
    var sc = speaker_colour(d.who);
    // dim background
    draw_set_alpha(0.35);
    draw_set_colour(c_black);
    draw_rectangle(0, 0, global.vpW, global.vpH, false);
    draw_set_alpha(1);

    // speaker label
    draw_round_rect_glow(global.vpW * 0.12, global.vpH * 0.62, global.vpW * 0.88, global.vpH * 0.92, 10,
        make_colour_rgb(12,14,30), sc, 0.7);
    draw_set_color(sc);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(global.vpW * 0.14, global.vpH * 0.64, d.who);

    // body (typewriter)
    var full = d.text;
    var show = typewriter_str(full, floor(global.story.type_chars));
    var lines = scr_text_wrap(show, global.vpW * 0.72);
    draw_set_color(COL_WHITE);
    for (var i = 0; i < array_length(lines); i++) {
        draw_text(global.vpW * 0.14, global.vpH * 0.68 + i * 22, lines[i]);
    }
    // advance hint
    draw_set_color(COL_GREY);
    draw_set_halign(fa_right);
    draw_text(global.vpW * 0.86, global.vpH * 0.89, "E / ACTION ▸");

    // meeting: draw a shadowed speaker figure on the left
    if (d.type == "meeting") {
        draw_meeting_figure(d.who);
    }
}

// ---- HUD (health + breath) ----
if (!global.story.credits) {
    draw_hud();
}

// ---- mobile touch controls ----
if (global.touch_enabled) {
    draw_touch_ui();
}

// ---- credits / end screen ----
if (global.story.credits) {
    draw_credits();
}

// reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);