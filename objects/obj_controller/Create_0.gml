// obj_controller — the persistent game manager. Owns the narrative state machine,
// the touch UI, the camera, and all the procedural vector rendering.

// ------------------------------------------------------------------ CREATE
// (create event body for obj_controller)

randomize();

global.vpW = 960;
global.vpH = 540;
global.tick = 0;

// input / touch
global.touch_enabled = (os_browser != browser_not_a_browser) ? false : (os_type == os_android || os_type == os_ios);
global.vbtn_held = array_create(8, false);
global.vbtn_pressed = array_create(8, false);
global.vbtn_released = array_create(8, false);
global.touch_ids = array_create(8, -1);

// story state
global.story = story_config();
global.story.scene_index = 0;
global.story.scene = story_scene_sequence()[0];
global.story.beats = story_beats_for(global.story.scene);
global.story.beat = 0;
global.story.queue = ds_queue_create();
global.story.active = false;
global.story.dialogue = null;       // currently displaying comm/meeting struct
global.story.type_chars = 0;
global.story.subtitle = null;
global.story.subtitle_timer = 0;
global.story.objective = "";
global.story.title_timer = 0;
global.story.title_text = "";
global.story.flash_timer = -1;
global.story.credits = false;
global.story.over = false;

// dialogue queue timing
global.diag_timer = 0;
global.beat_delay_timer = 60;
global.credits_timer = 0;

// world
global.stratum = stratum_for_scene(global.story.scene);
global.layers = build_parallax(global.stratum, global.tick);
global.motes = build_motes(global.stratum, 70);

// camera
global.cam_x = 0;
global.cam_y = 0;
global.cam_shake = 0;

text_init();

// hud
global.breath = 100;
global.health = 100;

// game flow
global.game_state = "menu";   // menu | play | pause | select
global.menu_sel = 0;
global.cranes_collected = 0;
global.scene_guard = -1;

// CREATE the player in the room (single rm_game, rebuilt per scene)
global.scene_h     = 0;   // total logical world height varies (some scenes climb up)
global.scene_mode  = "run"; // run | drive | ride | swim | climb | end

instance_create_layer(room_width / 2, room_height - 80, "Instances", obj_player);

// build the opening scene's world content
scene_build(global.story.scene);

// Start the scene by priming the first beat.
story_prime_next();

function story_prime_next() {
    // pop next beat from current list (or refill scene when list exhausted)
    if (global.story.beat >= array_length(global.story.beats)) {
        global.story.beat = 0;
    }
    var b = global.story.beats[global.story.beat];
    global.story.beat++;
    fire_beat(b);
}

function fire_beat(_b) {
    switch (_b.type) {
        case "title":
            global.story.title_text = _b.text;
            global.story.title_timer = _b.dur * 60;
            global.beat_delay_timer = _b.dur * 60 * 0.6;
            break;
        case "objective":
            global.story.objective = _b.text;
            global.beat_delay_timer = 40;
            break;
        case "subtitle":
            global.story.subtitle = _b;
            global.story.subtitle_timer = max(60, _b.dur * 60);
            global.beat_delay_timer = _b.dur * 60;
            break;
        case "comm":
        case "meeting":
            global.story.active = true;
            global.story.dialogue = _b;
            global.story.type_chars = 0;
            global.diag_timer = 0;
            break;
        case "flash_end":
        case "end":
            story_next_scene();
            break;
        case "credits":
            global.story.credits = true;
            global.story.active = false;
            break;
    }
}

// Drain the next (non-blocking) beat once the pacing timer elapses.
function story_advance() {
    if (global.story.beat < array_length(global.story.beats)) {
        fire_beat(global.story.beats[global.story.beat]);
        global.story.beat++;
    }
}

// Advance to the next scene in the sequence (or credits at the end).
function story_next_scene() {
    // guard against double-fires (a goal hit and a "flash_end" beat in the same frame)
    if (global.scene_guard == global.tick) return;
    global.scene_guard = global.tick;
    global.story.scene_index++;
    if (global.story.scene_index >= array_length(story_scene_sequence())) {
        global.story.credits = true;
        global.story.over = true;
        global.story.active = false;
        return;
    }
    global.story.scene = story_scene_sequence()[global.story.scene_index];
    global.story.beats = story_beats_for(global.story.scene);
    global.story.beat = 0;
    global.story.dialogue = null;
    global.story.subtitle = null;
    global.story.active = false;
    global.stratum = stratum_for_scene(global.story.scene);
    global.layers = build_parallax(global.stratum, global.tick);
    global.motes = build_motes(global.stratum, 70);
    scene_build(global.story.scene);
    // prime the first beat of the new scene
    global.beat_delay_timer = 40;
    save_game();
}

// The player reaches the end of the current playable section: advance the scene.
function player_reached_goal() {
    story_next_scene();
}