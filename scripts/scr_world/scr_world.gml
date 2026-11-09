// scr_world.gml — procedural world builder. Each stratum gets a distinct visual
// identity assembled from vector primitives and deterministic pseudo-random data.

#macro STRATUM_SINK        1
#macro STRATUM_LOOP        2
#macro STRATUM_FLOOD       3
#macro STRATUM_FOUNDRY     4
#macro STRATUM_APEX        5

// Deterministic hash so the world is stable across frames / sessions.
function h32(_seed, _x, _y) {
    // Safe deterministic hash: avoids bitwise ops on large doubles, which can
    // overflow int64 and trap the WASM runtime ("memory access out of bounds").
    var n = abs(_seed) * 374761393 + abs(_x) * 668265263 + abs(_y) * 2147483647;
    n = n mod 10000019;
    n = (n * 48271 + 12345) mod 10000019;
    return n / 10000019.0;
}

function stratum_for_scene(_scene) {
    var s = string(_scene);
    if (string_pos("ep1", s) == 1) return STRATUM_SINK;
    if (string_pos("ep2", s) == 1) return STRATUM_LOOP;
    if (string_pos("ep3", s) == 1) return STRATUM_FLOOD;
    if (string_pos("ep4", s) == 1) return STRATUM_FOUNDRY;
    if (string_pos("ep5", s) == 1) return STRATUM_APEX;
    return STRATUM_SINK;
}

function scene_is_flashback(_scene) {
    return string_pos("flashback", _scene) > 0;
}

// Build the parallax skyline + ground line for a given stratum. Stored in
// global.world arrays that the controller draws each frame (camera-relative).
function build_parallax(_stratum, _tick) {
    var layers = [];
    var np = 3;                                    // number of parallax depth layers
    for (var L = 0; L < np; L++) {
        var d = (L + 1) / np;                  // 1 = far, small; np = near
        var col_l = col_lerp(COL_BG, COL_CYAN, 0.25 + 0.25 * d);
        var w = [];
        var yy = 0;
        var h = 0;
        var step = 0;
        switch (_stratum) {
            case STRATUM_LOOP:
                h = 70 + L * 40;
                col_l = col_lerp(COL_CYAN, COL_BLUE, d);
                break;
            case STRATUM_FOUNDRY:
                h = 90 + L * 46;
                col_l = col_lerp(COL_ORANGE, COL_RED, d);
                break;
            case STRATUM_APEX:
                h = 200 + L * 30;
                col_l = col_lerp(COL_VIOLET, COL_CYAN, d);
                break;
            case STRATUM_FLOOD:
                h = 40 + L * 34;
                col_l = col_lerp(COL_BLUE, COL_GREEN, d);
                break;
            default: // SINK
                h = 120 + L * 30;
                col_l = col_lerp(COL_MAGENTA, COL_CYAN, d);
                break;
        }
        step = 60 + L * 40;
        // building silhouettes, deterministically varied
        for (var xx = -200; xx < 3200; xx += step) {
            var r = h32(9001 + L, xx, 0);
            var bh = h * (0.4 + r * 0.9 + L * 0.15);
            var bw = step * (0.5 + r * 0.5);
            w[array_length(w)] = { x: xx, w: bw, h: bh };
        }
        layers[array_length(layers)] = {
            depth: d,
            y0: 0,
            col: col_l,
            buildings: w,
            speed: 0.1 + d * 0.35,
        };
    }
    return layers;
}

// Ambient floating motes / rain / ash for the stratum.
function build_motes(_stratum, _count) {
    var arr = [];
    var name = "";
    var col = COL_CYAN;
    var spd = 1;
    switch (_stratum) {
        case STRATUM_SINK:    name = "rain";   col = COL_BLUE;    spd = 4; break;
        case STRATUM_LOOP:    name = "sparks"; col = COL_CYAN;    spd = 3; break;
        case STRATUM_FLOOD:   name = "bubbles"; col = COL_GREEN;  spd = 0.6; break;
        case STRATUM_FOUNDRY: name = "ash";    col = COL_ORANGE;  spd = 1.5; break;
        case STRATUM_APEX:    name = "stars";  col = COL_WHITE;   spd = 0.3; break;
    }
    for (var i = 0; i < _count; i++) {
        arr[array_length(arr)] = {
            x: global.vpW * h32(777, i, 0),
            y: global.vpH * h32(777, i, 1),
            spd: spd * (0.5 + h32(777, i, 2)),
            col: col
        };
    }
    return arr;
}