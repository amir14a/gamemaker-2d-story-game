// scr_scene.gml — builds each scene's world content: sets the movement mode,
// spawns hostiles/cranes/vehicles/goal triggers, and switches the player between
// James (present) and Millie (flashback).

// Called from obj_controller whenever a new scene starts.
function scene_build(_scene) {
    // clear dynamic instances (keep the controller and the player)
    with (obj_hostile) instance_destroy();
    with (obj_crane) instance_destroy();
    with (obj_vehicle) instance_destroy();
    with (obj_trigger) instance_destroy();
    with (obj_bullet) instance_destroy();

    var str = stratum_for_scene(_scene);
    var fb = scene_is_flashback(_scene);

    // set player identity + mode
    with (obj_player) {
        is_millie = fb;
        x = 200;
        y = room_height - 120;
        on_ground = true;
        climbing = false;
    }
    global.health = 100;
    global.breath = 100;

    // movement mode per scene
    global.scene_mode = "run";
    if (_scene == "ep2" || _scene == "ep2_intro") global.scene_mode = "drive";
    if (_scene == "ep4" || _scene == "ep4_intro") global.scene_mode = "ride";
    if (_scene == "ep3" || _scene == "ep3_intro") global.scene_mode = "swim";
    if (_scene == "ep5" || _scene == "ep5_intro") global.scene_mode = "climb";

    // ------------------------------------------------- place content per scene
    // Goal trigger: reaching it advances the current beat (story paced by movement).
    // We scatter cranes (breadcrumbs) between start and goal in flashbacks.
    var goal_x = 0, goal_y = room_height - 140;

    switch (_scene) {
        case "ep1_intro":
        case "ep1":
            spawn_hostiles(4, 500, 2000, room_height - 90);
            goal_x = 3000;
            spawn_goal(goal_x, goal_y);
            spawn_cranes(4, 600, 2400);
            break;
        case "ep1_meeting":
            // Books' junk shop: a meeting stop; a crane marks the shop.
            spawn_crane(1600, room_height - 140);
            goal_x = 1800;
            spawn_goal(goal_x, goal_y);
            break;
        case "ep1_flashback":
            goal_x = 2600;
            spawn_goal(goal_x, room_height - 120);
            spawn_cranes(6, 500, 2400);
            break;
        case "ep1_cliff":
            goal_x = 1200;
            spawn_goal(goal_x, goal_y);
            spawn_hostiles(2, 700, 1100, room_height - 90);
            break;
        case "ep2_intro":
        case "ep2":
            spawn_vehicle(false, 500, room_height - 120);
            spawn_hostiles(5, 800, 2600, room_height - 90);
            goal_x = 3200;
            spawn_goal(goal_x, goal_y);
            break;
        case "ep2_flashback":
            spawn_vehicle(false, 400, room_height - 130);
            goal_x = 2800;
            spawn_goal(goal_x, room_height - 120);
            break;
        case "ep2_cliff":
            goal_x = 1000;
            spawn_goal(goal_x, goal_y);
            break;
        case "ep3_intro":
        case "ep3":
            spawn_hostiles(4, 500, 1800, room_height - 120);
            goal_x = 2800;
            spawn_goal(goal_x, room_height - 200);
            spawn_cranes(3, 700, 2200);
            break;
        case "ep3_meeting":
            spawn_crane(1500, room_height - 160);
            goal_x = 1600;
            spawn_goal(goal_x, room_height - 180);
            break;
        case "ep3_flashback":
            goal_x = 2400;
            spawn_goal(goal_x, room_height - 120);
            spawn_cranes(5, 500, 2200);
            break;
        case "ep3_cliff":
            goal_x = 1100;
            spawn_goal(goal_x, goal_y);
            break;
        case "ep4_intro":
        case "ep4":
            spawn_vehicle(true, 500, room_height - 110);
            spawn_hostiles(6, 700, 2800, room_height - 80);
            goal_x = 3200;
            spawn_goal(goal_x, goal_y);
            break;
        case "ep4_flashback":
            goal_x = 2400;
            spawn_goal(goal_x, room_height - 120);
            spawn_cranes(4, 500, 2200);
            break;
        case "ep4_cliff":
            goal_x = 1000;
            spawn_goal(goal_x, goal_y);
            break;
        case "ep5_intro":
        case "ep5":
            spawn_hostiles(5, 500, 2600, room_height - 90);
            goal_x = 3000;
            spawn_goal(goal_x, room_height - 200);
            break;
        case "ep5_flashback":
            goal_x = 1800;
            spawn_goal(goal_x, room_height - 120);
            spawn_cranes(3, 600, 1600);
            break;
        case "ep5_end":
            goal_x = 2400;
            spawn_goal(goal_x, room_height - 120);
            break;
    }
}

function spawn_hostiles(_n, _x1, _x2, _y) {
    for (var i = 0; i < _n; i++) {
        var hx = lerp(_x1, _x2, (i + 0.5) / _n);
        with (instance_create_layer(hx, _y, "Instances", obj_hostile)) {
            anchor = x;
            dir = (i mod 2 == 0) ? 1 : -1;
        }
    }
}

function spawn_crane(_x, _y) {
    instance_create_layer(_x, _y, "Instances", obj_crane);
}

function spawn_cranes(_n, _x1, _x2) {
    for (var i = 0; i < _n; i++) {
        var cx = lerp(_x1, _x2, (i + 0.5) / _n);
        spawn_crane(cx, room_height - 130 - (i mod 2) * 40);
    }
}

function spawn_goal(_x, _y) {
    // A tall vertical strip so a running/climbing/swimming player always crosses it:
    // from near the top of the play band down to the ground line.
    var t = instance_create_layer(_x, 40, "Instances", obj_trigger);
    t.w = 60;
    t.h = room_height - 120;
    t.trigger_id = -1;
}

function spawn_vehicle(_bike, _x, _y) {
    var v = instance_create_layer(_x, _y, "Instances", obj_vehicle);
    v.is_bike = _bike;
    v.riding = false;
}