// scr_input.gml — abstracted input so the whole game works with
// keyboard (desktop/web) and Android touch controls without source changes.

// The on-screen virtual joystick + buttons are drawn and managed by obj_controller.

#macro BTN_LEFT     0
#macro BTN_RIGHT    1
#macro BTN_UP       2
#macro BTN_DOWN     3
#macro BTN_JUMP     4
#macro BTN_ACTION   5
#macro BTN_SHOOT    6
#macro BTN_PAUSE    7

// Touch button hit regions (screen-space, top-left origin). Populated lazily per frame.
function scr_btn_region(_btn) {
    var gv = global.vpW, gh = global.vpH;
    var s = clamp(gv / 960.0, 0.6, 1.8);
    var r = 56 * s;
    var ax = 8 * s, ay = gh - r - 8 * s;
    var c = r * 0.8;
    switch (_btn) {
        case BTN_LEFT:    return [ax,            ay, ax + c,        ay + c];
        case BTN_RIGHT:   return [ax + c + 6*s,  ay, ax + c*2 + 6*s, ay + c];
        case BTN_JUMP:    return [ax,            ay - c - 6*s, ax + c, ay - 6*s];
        case BTN_ACTION:  return [gv - r - 8*s,  gh - r - 8*s, gv - 8*s, gh - 8*s];
        case BTN_SHOOT:   return [gv - r - 8*s,  gh - r*2 - 16*s, gv - 8*s, gh - r - 16*s];
        case BTN_PAUSE:   return [gv - r - 8*s, 8*s, gv - 8*s, 8*s + c];
    }
    return [0, 0, 0, 0];
}

// Keyboard binding.
function kbd_btn(_btn) {
    switch (_btn) {
        case BTN_LEFT:    return vk_left;
        case BTN_RIGHT:   return vk_right;
        case BTN_UP:      return vk_up;
        case BTN_DOWN:    return vk_down;
        case BTN_JUMP:    return vk_space;
        case BTN_ACTION:  return ord("E");
        case BTN_SHOOT:   return ord("F");
        case BTN_PAUSE:   return vk_escape;
    }
    return -1;
}

// Held, edge-pressed, edge-released.
function btn(_b) {
    if (!global.touch_enabled) {
        var k = kbd_btn(_b);
        if (_b == BTN_UP || _b == BTN_DOWN) {
            // vertical also mapped to W/S for comfort
            var ka = (_b == BTN_UP) ? ord("W") : ord("S");
            return keyboard_check(k) || keyboard_check(ka);
        }
        return keyboard_check(k);
    }
    return global.vbtn_held[_b];
}

function btn_pressed(_b) {
    if (!global.touch_enabled) {
        var k = kbd_btn(_b);
        var r = keyboard_check_pressed(k);
        if (_b == BTN_UP)   r = r || keyboard_check_pressed(ord("W"));
        if (_b == BTN_DOWN) r = r || keyboard_check_pressed(ord("S"));
        return r;
    }
    // edge detection is handled by the touch manager on mobile
    return global.vbtn_pressed[_b];
}

function btn_released(_b) {
    if (!global.touch_enabled) {
        return keyboard_check_released(kbd_btn(_b));
    }
    return global.vbtn_released[_b];
}

// Horizontal axis (-1..1) and vertical axis.
function axis_x() {
    if (!global.touch_enabled) {
        return keyboard_check(vk_right) - keyboard_check(vk_left);
    }
    return (btn(BTN_RIGHT) ? 1 : 0) - (btn(BTN_LEFT) ? 1 : 0);
}

function axis_y() {
    return (btn(BTN_DOWN) ? 1 : 0) - (btn(BTN_UP) ? 1 : 0);
}