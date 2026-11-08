// scr_hud.gml — UI drawing helpers used by obj_controller: HUD, touch controls,
// speaker figures for meetings, and the credits screen. All vector art.

// The player HUD: health bar and breath meter (Swimming) bottom-right.
function draw_hud() {
    var bw = 220, bh = 14;
    var bx = global.vpW - bw - 20, by = 20;
    // health
    draw_round_rect_glow(bx, by, bx + bw, by + bh, 4, make_colour_rgb(10,14,28), COL_RED, 0.5);
    var w = bw * clamp(global.health / 100, 0, 1);
    draw_set_colour(COL_RED);
    draw_roundrect_ext(bx, by, bx + w, by + bh, 4, 4, false);
    draw_set_color(COL_WHITE);
    draw_set_halign(fa_right);
    draw_text(bx + bw, by - 18, "VITALS");
    // breath (only relevant in Floodworks / escape)
    if (global.stratum == STRATUM_FLOOD || global.scene_mode == "swim") {
        var bb = by + bh + 12;
        draw_round_rect_glow(bx, bb, bx + bw, bb + bh, 4, make_colour_rgb(10,14,28), COL_GREEN, 0.5);
        var wb = bw * clamp(global.breath / 100, 0, 1);
        draw_set_colour(COL_GREEN);
        draw_roundrect_ext(bx, bb, bx + wb, bb + bh, 4, 4, false);
        draw_set_color(COL_WHITE);
        draw_text(bx + bw, bb - 3, "BREATH");
    }
}

// On-screen touch controls (drawn in GUI space, matching scr_btn_region rects).
function draw_touch_ui() {
    var gv = global.vpW, gh = global.vpH;
    var s = clamp(gv / 960.0, 0.6, 1.8);
    var r = 56 * s;
    var c = r * 0.8;
    var ax = 8 * s, ay = gh - r - 8 * s;
    // d-pad
    var dpad = [[ax, ay, BTN_LEFT], [ax + c + 6*s, ay, BTN_RIGHT], [ax, ay - c - 6*s, BTN_JUMP]];
    for (var i = 0; i < 3; i++) {
        var tp = dpad[i];
        draw_touch_btn(tp[0], tp[1], c, c, tp[2]);
    }
    // action + shoot
    draw_touch_btn(gv - r - 8*s, gh - r - 8*s, r, r, BTN_ACTION);
    draw_touch_btn(gv - r - 8*s, gh - r*2 - 16*s, r, r, BTN_SHOOT);
}

function draw_touch_btn(_x, _y, _w, _h, _btn) {
    var held = global.vbtn_held[_btn];
    var labels = ["◀", "▶", "▲", "▼", "A", "E", "F", "II"];
    var col = held ? COL_CYAN : COL_DARKGREY;
    draw_set_alpha(0.55);
    draw_set_colour(col);
    draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 12, 12, false);
    draw_set_alpha(0.9);
    draw_set_colour(COL_WHITE);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_x + _w / 2, _y + _h / 2, labels[_btn]);
    draw_set_alpha(1);
}

// A stylised vector "bust" representing a speaker during face-to-face meetings,
// drawn as a dark silhouette with a neon rim and the speaker's colour accent.
function draw_meeting_figure(_who) {
    var cx = global.vpW * 0.22;
    var cy = global.vpH * 0.88;
    var sc = speaker_colour(_who);
    var t = global.tick;
    var bob = sin(t * 0.04) * 3;
    // body
    draw_set_colour(make_colour_rgb(16,18,34));
    draw_roundrect_ext(cx - 56, cy - 150 + bob, cx + 56, cy + 10, 18, 18, false);
    // shoulders/coat
    draw_set_colour(make_colour_rgb(22,24,44));
    draw_roundrect_ext(cx - 48, cy - 60 + bob, cx + 48, cy + 6, 14, 14, false);
    // head
    draw_set_colour(make_colour_rgb(40,44,70));
    draw_circle(cx, cy - 92 + bob, 26, false);
    // neon rim light
    draw_set_alpha(0.7);
    draw_set_colour(sc);
    draw_set_circle_precision(48);
    draw_circle(cx, cy - 92 + bob, 26, true);
    draw_set_alpha(1);
    // name tag
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(sc);
    draw_text(cx, cy - 170, _who);
}

// Credits / end screen.
function draw_credits() {
    draw_set_alpha(0.85);
    draw_set_colour(COL_BG);
    draw_rectangle(0, 0, global.vpW, global.vpH, false);
    draw_set_alpha(1);

    var lines = [
        "NEON ECHO",
        "",
        "The Story of James & Millie",
        "",
        "\"Count the stars with me. I'll always be one of them.\"",
        "— Mara Vance",
        "",
        "A 2D cyberpunk story in five episodes",
        "",
        "Characters",
        "James Vance · Millie Vance · Books Okonkwo · Cray · Saint / Mother",
        "Mara & Eli Vance",
        "",
        "Verge City — five strata",
        "The Sink · The Loop · The Floodworks · The Foundry · The Apex",
        "",
        "Written & built as a vector-art GameMaker project",
        "by DeepSeek Harness — no bitmaps, every asset drawn in code",
        "",
        "",
        "Thank you for playing.",
        "",
        "THE END.",
    ];
    var n = array_length(lines);
    var scroll = clamp((global.credits_timer / 2) - global.vpH, -global.vpH, 0);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    var y = global.vpH + scroll;
    for (var i = 0; i < n; i++) {
        var isHead = (i == 0);
        draw_set_color(isHead ? COL_CYAN : (string_pos("— Mara", lines[i]) ? COL_PINK : COL_WHITE));
        draw_set_font(isHead ? FONT_TITLE : -1);
        draw_text(global.vpW / 2, y, lines[i]);
        draw_set_font(-1);
        y += 26;
    }
    // hint
    draw_set_colour(COL_GREY);
    draw_text(global.vpW / 2, global.vpH - 30, "Press ESC / BACK  ·  or wait to return to menu");
}