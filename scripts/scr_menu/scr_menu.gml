// scr_menu.gml — the title menu, pause menu, and episode-select screen.
// All rendered with the same vector/neon language as the rest of the game.

// menu state is global.game_state: "menu" | "play" | "pause" | "select"

function menu_draw() {
    // starfield background
    draw_set_colour(COL_BG);
    draw_rectangle(0, 0, global.vpW, global.vpH, false);
    for (var i = 0; i < 90; i++) {
        var sx = global.vpW * h32(55, i, 0);
        var sy = global.vpH * h32(55, i, 1);
        var pr = 0.5 + 0.5 * sin(global.tick * 0.03 + i);
        draw_glow(sx, sy, 2, (i mod 3 == 0) ? COL_MAGENTA : COL_CYAN, 0.5 * pr);
    }

    // title
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(0.9);
    draw_set_colour(COL_CYAN);
    draw_text_glow(global.vpW / 2, global.vpH * 0.18, "NEON ECHO", COL_CYAN, 0.9);
    draw_set_colour(COL_MAGENTA);
    draw_set_alpha(0.8);
    draw_text(global.vpW / 2, global.vpH * 0.18 + 40, "— the story of James & Millie —");

    // a folded paper crane icon
    draw_menu_crane(global.vpW / 2, global.vpH * 0.32, global.tick);

    draw_set_alpha(1);

    // menu items
    var items = menu_items();
    var n = array_length(items);
    var sel = global.menu_sel;
    var y0 = global.vpH * 0.5;
    for (var i = 0; i < n; i++) {
        var cy = y0 + i * 44;
        var isSel = (i == sel);
        draw_set_colour(isSel ? COL_CYAN : COL_GREY);
        draw_set_alpha(isSel ? 1 : 0.6);
        if (isSel) {
            draw_glow(global.vpW / 2, cy, 20, COL_CYAN, 0.4);
            draw_text(global.vpW / 2 - 120, cy, "▸");
            draw_text(global.vpW / 2 + 120, cy, "◂");
        }
        draw_text(global.vpW / 2, cy, items[i]);
    }
    draw_set_alpha(1);

    // hint
    draw_set_colour(COL_DARKGREY);
    draw_text(global.vpW / 2, global.vpH - 40, "↑ ↓  to choose   ·   E / ACTION  to confirm");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function menu_items() {
    switch (global.game_state) {
        case "menu":
            return ["▶  NEW GAME", "▷  CONTINUE", "☰  EPISODE SELECT"];
        case "pause":
            return ["▶  RESUME", "↻  RESTART EPISODE", "⌂  BACK TO TITLE"];
        case "select":
            // episode list (present-day chapters only)
            return [
                "EPISODE 1 — Breadcrumbs",
                "EPISODE 2 — The Loop",
                "EPISODE 3 — Drowned Light",
                "EPISODE 4 — The Foundry",
                "EPISODE 5 — Crown of Stars",
            ];
    }
    return [];
}

function menu_step() {
    var n = array_length(menu_items());
    if (btn_pressed(BTN_DOWN)) global.menu_sel = (global.menu_sel + 1) mod n;
    if (btn_pressed(BTN_UP))   global.menu_sel = (global.menu_sel + n - 1) mod n;
    if (btn_pressed(BTN_ACTION) || btn_pressed(BTN_JUMP)) {
        menu_confirm();
    }
}

function menu_confirm() {
    switch (global.game_state) {
        case "menu":
            if (global.menu_sel == 0) { start_new(); }
            else if (global.menu_sel == 1) { start_continue(); }
            else { global.game_state = "select"; global.menu_sel = 0; }
            break;
        case "pause":
            if (global.menu_sel == 0) { global.game_state = "play"; }
            else if (global.menu_sel == 1) { start_new(); }
            else { global.game_state = "menu"; global.menu_sel = 0; }
            break;
        case "select":
            global.story.scene_index = global.menu_sel * 4;   // map episode -> its intro scene
            global.story.scene_index = clamp(global.story.scene_index, 0, array_length(story_scene_sequence()) - 1);
            global.story.scene = story_scene_sequence()[global.story.scene_index];
            global.story.beats = story_beats_for(global.story.scene);
            global.story.beat = 0;
            global.story.active = false;
            global.story.dialogue = null;
            global.story.credits = false;
            scene_build(global.story.scene);
            global.game_state = "play";
            break;
    }
}

function start_new() {
    global.story.scene_index = 0;
    global.story.scene = story_scene_sequence()[0];
    global.story.beats = story_beats_for(global.story.scene);
    global.story.beat = 0;
    global.story.active = false;
    global.story.dialogue = null;
    global.story.credits = false;
    global.health = 100;
    global.breath = 100;
    scene_build(global.story.scene);
    // prime the first beat fresh
    global.beat_delay_timer = 20;
    global.game_state = "play";
}

function start_continue() {
    var d = load_game();
    if (d != null && !is_undefined(d.scene_index) && d.scene_index > 0) {
        global.story.scene_index = clamp(d.scene_index, 0, array_length(story_scene_sequence()) - 1);
        global.story.scene = story_scene_sequence()[global.story.scene_index];
    } else {
        global.story.scene_index = 0;
        global.story.scene = story_scene_sequence()[0];
    }
    global.story.beats = story_beats_for(global.story.scene);
    global.story.beat = 0;
    global.story.active = false;
    global.story.dialogue = null;
    global.story.credits = false;
    global.health = 100;
    global.breath = 100;
    scene_build(global.story.scene);
    global.beat_delay_timer = 20;
    global.game_state = "play";
}

function draw_menu_crane(_x, _y, _t) {
    var bob = sin(_t * 0.03) * 4;
    var s = 1.4;
    draw_glow(_x, _y + bob, 30, COL_WHITE, 0.4);
    draw_set_colour(make_colour_rgb(235,240,250));
    draw_triangle(_x, _y - 14*s + bob, _x + 22*s, _y + 4*s + bob, _x - 8*s, _y + 8*s + bob, false);
    draw_triangle(_x, _y - 14*s + bob, _x - 22*s, _y + 4*s + bob, _x + 8*s, _y + 8*s + bob, false);
    draw_triangle(_x, _y - 4*s + bob, _x + 13*s, _y + 22*s + bob, _x - 13*s, _y + 22*s + bob, false);
    draw_set_colour(make_colour_rgb(180,190,210));
    draw_set_alpha(0.6);
    draw_line(_x, _y - 4*s + bob, _x, _y + 14*s + bob);
    draw_set_alpha(1);
}