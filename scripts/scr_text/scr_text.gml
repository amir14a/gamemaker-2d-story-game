// scr_text.gml — small text-drawing helpers: typewriter effect, glow text,
// and the font constants. The game uses the built-in vector font (no bitmap).

#macro FONT_BODY    0   // default
#macro FONT_TITLE   0
#macro FONT_MONO    1   // using a slightly different built-in for "mono" flavour

// Set up fonts at boot: we rely on the default font + a few size presets so no
// external font asset is required.
function text_init() {
    draw_set_font(-1);
}

// Glow text: draw text multiple times with alpha falloff for a neon bloom.
function draw_text_glow(_x, _y, _str, _col, _alpha) {
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var h = string_height(_str);
    draw_set_alpha(_alpha * 0.35);
    draw_text_colour(_x, _y, _str, _col, _col, _col, _col, 4);
    draw_set_alpha(_alpha);
    draw_text(_x, _y, _str);
    draw_set_alpha(1);
}

// Typewriter: reveal `chars` characters of `str` (handles wrapped long lines OK).
function typewriter_str(_str, _chars) {
    var l = string_length(_str);
    if (_chars >= l) return _str;
    return string_copy(_str, 1, _chars);
}

// Word-wrap a string to a maximum pixel width, returning an array of lines.
function scr_text_wrap(_str, _maxw) {
    var words = [];
    var cur = "";
    var n = string_length(_str);
    var i = 1;
    while (i <= n) {
        var ch = string_char_at(_str, i);
        if (ch == "\n") {
            words[array_length(words)] = cur;
            cur = "";
            i++;
            continue;
        }
        var nxt = cur + ch;
        if (string_width(nxt) > _maxw && cur != "") {
            words[array_length(words)] = cur;
            cur = ch;
        } else {
            cur = nxt;
        }
        i++;
    }
    words[array_length(words)] = cur;
    return words;
}