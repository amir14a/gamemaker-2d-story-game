// scr_save.gml — tiny JSON save system, persisted via GameMaker's file sandbox
// (works on desktop, HTML5 localStorage, and Android external storage).

function save_slot() {
    return "neon_echo_save.json";
}

function save_game() {
    var data = {
        scene: global.story.scene,
        scene_index: global.story.scene_index,
        episode: global.story.episode,
    };
    var s = json_stringify(data);
    if (os_browser == browser_not_a_browser) {
        // desktop / Android file write
        var dir = working_directory;
        var f = file_text_open_write(dir + save_slot());
        file_text_write_string(f, s);
        file_text_close(f);
    } else {
        // HTML5 localStorage via a tiny shim through the persistent buffer
        var b = buffer_create(string_byte_length(s) + 1, buffer_grow, 1);
        buffer_write(b, buffer_string, s);
        buffer_save(b, save_slot());
        buffer_delete(b);
    }
}

function load_game() {
    var s = null;
    var ok = false;
    // file_exists check
    if (os_browser == browser_not_a_browser) {
        if (file_exists(working_directory + save_slot())) {
            var f = file_text_open_read(working_directory + save_slot());
            s = file_text_read_string(f);
            file_text_close(f);
            ok = true;
        }
    } else {
        if (file_exists(save_slot())) {
            var b = buffer_load(save_slot());
            s = buffer_read(b, buffer_string);
            buffer_delete(b);
            ok = true;
        }
    }
    if (!ok || s == null || s == "") return null;
    return json_parse(s);
}

function load_state(_scene_index) {
    var d = load_game();
    if (d == null || is_undefined(d.scene_index)) {
        // fresh start
        global.story.scene_index = 0;
        global.story.scene = story_scene_sequence()[0];
        return;
    }
    global.story.scene_index = clamp(d.scene_index, 0, array_length(story_scene_sequence()) - 1);
    global.story.scene = story_scene_sequence()[global.story.scene_index];
}