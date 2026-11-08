// scr_draw.gml — vector drawing primitives for a clean neon aesthetic.
// Everything in the game is drawn procedurally; there are no bitmap assets.

// Rounded rectangle (filled) with optional glowing outline.
function draw_round_rect_glow(_x1, _y1, _x2, _y2, _rad, _fill, _outline, _alpha_outline) {
    draw_set_alpha(1);
    draw_set_colour(_fill);
    draw_roundrect_ext(_x1, _y1, _x2, _y2, _rad, _rad, false);
    if (_alpha_outline > 0) {
        draw_set_alpha(_alpha_outline);
        draw_set_colour(_outline);
        draw_roundrect_ext(_x1, _y1, _x2, _y2, _rad, _rad, true);
        draw_set_alpha(1);
    }
}

// Soft glow circle behind a bright point / light.
function draw_glow(_x, _y, _r, _col, _a) {
    var steps = 4;
    for (var i = 0; i < steps; i++) {
        var t = (i + 1) / steps;
        draw_set_alpha(_a * (1 - t) * 0.5);
        draw_set_colour(_col);
        draw_circle_colour(_x, _y, _r * t, _col, c_black, false);
    }
    draw_set_alpha(1);
}

// Hex-to-RGB helpers (all our constants are $BBGGRR GameMaker order already).
function col_lerp(_c1, _c2, _t) {
    _t = clamp(_t, 0, 1);
    return make_colour_rgb(
        lerp(colour_get_red(_c1),   colour_get_red(_c2),   _t),
        lerp(colour_get_green(_c1), colour_get_green(_c2), _t),
        lerp(colour_get_blue(_c1),  colour_get_blue(_c2),  _t)
    );
}

// One full vertical-scanline scanline + horizontal grid "retro CRT" overlay effect.
function draw_crt_overlay(_x, _y, _w, _h, _alpha) {
    draw_set_alpha(_alpha);
    draw_set_colour(COL_CYAN);
    var step = 4;
    for (var yy = _y; yy < _y + _h; yy += step) {
        draw_line(_x, yy, _x + _w, yy);
    }
    draw_set_colour(COL_MAGENTA);
    for (var xx = _x; xx < _x + _w; xx += step * 40) {
        draw_line(xx, _y, xx, _y + _h);
    }
    draw_set_alpha(1);
}

// A single "star" (lit window) twinkle point.
function draw_star(_x, _y, _r, _col, _t) {
    var tw = 0.5 + 0.5 * sin(_t * 0.05 + _x * 0.7 + _y * 1.3);
    draw_glow(_x, _y, _r * 2, _col, 0.6 * tw);
    draw_set_alpha(0.6 + 0.4 * tw);
    draw_set_colour(_col);
    draw_circle(_x, _y, _r, false);
    draw_set_alpha(1);
}