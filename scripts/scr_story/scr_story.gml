// scr_story.gml — all narrative content: the five episodes, flashbacks, and the
// dialogue that fires from trigger zones / meetings as you play.
//
// Beat types:
//   "subtitle"   floating ambient lower-third line (does not pause).
//   "comm"       framed dialogue card with speaker (soft-pauses, advance with E/ACTION).
//   "meeting"    face-to-face; works like comm but with an on-screen speaker figure.
//   "objective"  objective banner hook.
//   "end"        episode end marker -> cut to next scene.

// A level spec is built as an array of "beats". Each beat is a struct:
//  { type, who, text, dur, size }  — dur = seconds a subtitle stays (0 = default),
//  size = font size multiplier for subtitle callouts.

function story_config() {
    return {
        episode: 0,      // 0..6 (1..5 episodes; flashbacks encoded with +100)
        scene: "intro",  // current scene key
        beat: 0,         // index into current beat list
        beats: [],       // current (possibly remaining) beat queue
        beat_x: 0,       // trigger positions are stored in the level builder instead
        queue: ds_queue_create(),
        next_scene: "",
        active: false,   // a comm/meeting currently blocking
        started: false,
    };
}

// Convert a compact beat shorthand into full struct list.
function beats(_list) {
    var out = [];
    for (var i = 0; i < array_length(_list); i++) {
        var b = _list[i];
        if (is_string(b)) b = { type: "subtitle", who: "James", text: b, dur: 3, size: 1 };
        if (b.type == "comm"    && !variable_struct_exists(b, "who"))  b.who = "James";
        if (b.type == "meeting" && !variable_struct_exists(b, "who"))  b.who = "Books";
        if (b.type == "subtitle" && !variable_struct_exists(b, "dur")) b.dur = 3;
        if (b.type == "subtitle" && !variable_struct_exists(b, "size")) b.size = 1;
        out[array_length(out)] = b;
    }
    return out;
}

// ---------------------------------------------------------------- EPISODE 1
function ep1_intro_beats() {
    return beats([
        { type: "title", who: "", text: "EPISODE 1 — BREADCRUMBS\nStratum: The Sink", dur: 4, size: 1.4 },
        { type: "subtitle", who: "James", text: "Six months. And now a paper bird.", dur: 4, size: 1 },
        { type: "comm", who: "James", text: "A street-kid courier just grabbed the data-chip folded inside." },
        { type: "objective", text: "Catch the courier" },
    ]);
}

function ep1_beats() {
    return beats([
        { type: "comm", who: "Books", text: "James! Picked you up on the old earpiece. You're really doing this, son?" },
        { type: "comm", who: "James", text: "She's my sister, Books." },
        { type: "comm", who: "Books", text: "And you owe half the Mire a favour or two. They know their old runner." },
        { type: "objective", text: "Follow the courier through the Sink" },
        { type: "subtitle", who: "", text: "Vault the gaps — run, jump, keep your line.", dur: 4, size: 1.1 },
        { type: "subtitle", who: "Books", text: "Courier's cut left, toward the junk quarter.", dur: 3, size: 1 },
        { type: "comm", who: "Books", text: "Drop by my shop before you kill yourself. I got eyes on this." },
        { type: "objective", text: "Reach Books' junk-shop" },
    ]);
}

function ep1_meeting_beats() {
    return beats([
        { type: "meeting", who: "Books", text: "He's heading for the Floodworks. That's Saint-Cloud's drowned ground." },
        { type: "meeting", who: "Books", text: "Millie's not who you remember, son. She walked away from you on purpose." },
        { type: "comm", who: "James", text: "I don't believe that." },
        { type: "objective", text: "Corner the courier on the rooftops" },
    ]);
}

function ep1_flashback_beats() {
    return beats([
        { type: "title", who: "", text: "FLASHBACK — THE CRANE\nSixteen years ago", dur: 4, size: 1.4 },
        { type: "subtitle", who: "", text: "The Sink, at summer dusk. Washing-lines strung between rooftops.", dur: 5, size: 1 },
        { type: "subtitle", who: "Millie", text: "James! You're too slow, old man!", dur: 3, size: 1 },
        { type: "subtitle", who: "James", text: "I'm sixteen, you menace —", dur: 3, size: 1 },
        { type: "objective", text: "Chase James to the rooftop" },
        { type: "subtitle", who: "", text: "Mara's lullaby drifts up from the open window.", dur: 5, size: 1.1 },
        { type: "meeting", who: "Millie", text: "See? Fold it like this. If we ever get lost, leave a trail of these." },
        { type: "meeting", who: "Millie", text: "I'll always find the next one. Promise me you'll remember." },
        { type: "subtitle", who: "", text: "She presses a white paper crane into his hand.", dur: 4, size: 1.1 },
        { type: "flash_end", who: "", text: "", dur: 0 },
    ]);
}

function ep1_cliff_beats() {
    return beats([
        { type: "meeting", who: "Kid", text: "She paid me to slow you down! I'm just a courier, please —" },
        { type: "subtitle", who: "", text: "A red dot settles on the kid's chest.", dur: 3, size: 1.2 },
        { type: "subtitle", who: "", text: "The Mire sniper fires once. The roof gives way.", dur: 3, size: 1.2 },
        { type: "subtitle", who: "", text: "James falls three floors into the black water.", dur: 3, size: 1.1 },
        { type: "objective", text: "Get to the Floodworks" },
    ]);
}

// ---------------------------------------------------------------- EPISODE 2
function ep2_intro_beats() {
    return beats([
        { type: "title", who: "", text: "EPISODE 2 — THE LOOP\nStratum: The Loop", dur: 4, size: 1.4 },
        { type: "comm", who: "Books", text: "Only way to the Floodworks is the Loop. Cray's people own it tonight." },
        { type: "comm", who: "Books", text: "Find a car. Don't stop." },
        { type: "objective", text: "Hot-wire a courier hauler" },
    ]);
}

function ep2_beats() {
    return beats([
        { type: "subtitle", who: "", text: "The ring-road climbs and dives. Lean into it.", dur: 4, size: 1.1 },
        { type: "comm", who: "Books", text: "Interceptors on your tail, between the traffic!" },
        { type: "objective", text: "Shoot the interceptors off your tail" },
        { type: "subtitle", who: "", text: "A second voice breaks the channel — clipped, familiar.", dur: 4, size: 1.1 },
        { type: "comm", who: "???", text: "— ake the ... side ramp ... can't reach you ... —" },
        { type: "objective", text: "Cross the wreck-jam on foot" },
    ]);
}

function ep2_flashback_beats() {
    return beats([
        { type: "title", who: "", text: "FLASHBACK — FIRST LIGHT\nSix years ago", dur: 4, size: 1.4 },
        { type: "subtitle", who: "", text: "3 a.m. on the empty old Loop, a borrowed car.", dur: 4, size: 1 },
        { type: "subtitle", who: "Millie", text: "Watch this." },
        { type: "meeting", who: "Millie", text: "Every camera in the district, lit at once. The city can be seen, James." },
        { type: "meeting", who: "James", text: "You're terrifying. Where'd you learn that?" },
        { type: "meeting", who: "Millie", text: "The same place I learned everything. Nobody teaches girls in the Sink." },
        { type: "subtitle", who: "", text: "The seed of the Ghost.", dur: 4, size: 1.1 },
        { type: "flash_end", who: "", text: "", dur: 0 },
    ]);
}

function ep2_cliff_beats() {
    return beats([
        { type: "comm", who: "Millie", text: "James. Stop. If you come down here, you undo everything I've bled for." },
        { type: "comm", who: "Millie", text: "Please — go home." },
        { type: "subtitle", who: "", text: "A charge blows the ramp. The wreck plunges into the flooded dark.", dur: 3, size: 1.2 },
        { type: "objective", text: "She's alive. And she doesn't want to be found." },
    ]);
}

// ---------------------------------------------------------------- EPISODE 3
function ep3_intro_beats() {
    return beats([
        { type: "title", who: "", text: "EPISODE 3 — DROWNED LIGHT\nStratum: The Floodworks", dur: 4, size: 1.4 },
        { type: "subtitle", who: "", text: "Neon signs gutter under the water. Streets have become canals.", dur: 5, size: 1 },
        { type: "objective", text: "Swim the drowned avenue" },
    ]);
}

function ep3_beats() {
    return beats([
        { type: "subtitle", who: "", text: "Breath matters down here — surface to breathe.", dur: 4, size: 1.1 },
        { type: "comm", who: "Books", text: "There's a cathedral half-swallowed by the flood. Whatever she's doing, it's in there." },
        { type: "objective", text: "Climb the drowned rigging" },
        { type: "subtitle", who: "", text: "The nave stretches long and flooded. Run it.", dur: 4, size: 1 },
        { type: "objective", text: "Reach the top of the cathedral" },
        { type: "subtitle", who: "", text: "Maps. A wall of Saint-Cloud's crimes. Paper cranes strung like prayer flags.", dur: 5, size: 1.1 },
        { type: "meeting", who: "James", text: "This isn't a prison. This is a command post." },
    ]);
}

function ep3_meeting_beats() {
    return beats([
        { type: "meeting", who: "Millie", text: "Hello, James. You shouldn't have come." },
        { type: "meeting", who: "Millie", text: "The transit collapse that killed Mum and Dad? Saint-Cloud clearing a harvest site." },
        { type: "meeting", who: "Millie", text: "They strip bio-data from the Undercity's dead. I've been inside their system for six months." },
        { type: "meeting", who: "James", text: "You're the Ghost. The whole city whispers your name." },
        { type: "meeting", who: "Millie", text: "And now you led them straight to me. Go home, James." },
        { type: "objective", text: "—" },
    ]);
}

function ep3_flashback_beats() {
    return beats([
        { type: "title", who: "", text: "FLASHBACK — THE QUESTION\nThe night of the collapse", dur: 4, size: 1.4 },
        { type: "subtitle", who: "", text: "Search the rubble for them.", dur: 3, size: 1.1 },
        { type: "subtitle", who: "Millie", text: "Mum? Dad? Please —", dur: 3, size: 1 },
        { type: "objective", text: "Search the collapse site" },
        { type: "meeting", who: "Millie", text: "A Saint-Cloud salvage tag. Where their bodies should be." },
        { type: "meeting", who: "Millie", text: "They were harvested. I'm going to burn it all down." },
        { type: "subtitle", who: "", text: "The idealist is born — and the vow.", dur: 4, size: 1.1 },
        { type: "flash_end", who: "", text: "", dur: 0 },
    ]);
}

function ep3_cliff_beats() {
    return beats([
        { type: "subtitle", who: "", text: "Cray's strike team breaches the command post.", dur: 3, size: 1.2 },
        { type: "meeting", who: "Millie", text: "Don't fight them. If I fight, they'll find what I hid in their network." },
        { type: "subtitle", who: "", text: "She presses a paper crane into James's hand as the divers drag her into the flood.", dur: 4, size: 1.1 },
        { type: "objective", text: "You led them straight to her." },
    ]);
}

// ---------------------------------------------------------------- EPISODE 4
function ep4_intro_beats() {
    return beats([
        { type: "title", who: "", text: "EPISODE 4 — THE FOUNDRY\nStratum: The Foundry", dur: 4, size: 1.4 },
        { type: "comm", who: "Books", text: "This isn't your fault, James." },
        { type: "comm", who: "James", text: "It's exactly my fault." },
        { type: "objective", text: "Ride into Saint-Cloud's processing plant" },
    ]);
}

function ep4_beats() {
    return beats([
        { type: "subtitle", who: "", text: "Cray's riders close in. Shoot them off the arteries.", dur: 4, size: 1.1 },
        { type: "objective", text: "Ditch the bike, climb the refinery" },
        { type: "subtitle", who: "", text: "Inside, the horror is plain: processing the Undercity's people into product.", dur: 5, size: 1.1 },
        { type: "meeting", who: "Cray", text: "In no hurry at all. Mother wanted you found." },
        { type: "meeting", who: "Cray", text: "So the Ghost would surface to save you. You're the bait, James. You always were." },
        { type: "objective", text: "Reach the processing core" },
    ]);
}

function ep4_flashback_beats() {
    return beats([
        { type: "title", who: "", text: "FLASHBACK — THE BARGAIN\nWeeks ago", dur: 4, size: 1.4 },
        { type: "subtitle", who: "", text: "Millie walks willingly into Saint-Cloud's intake.", dur: 4, size: 1 },
        { type: "meeting", who: "Millie", text: "They think they're taking a prisoner. They're taking a seed." },
        { type: "meeting", who: "Millie", text: "It will cost me my body. But it plants the exploit at their core." },
        { type: "subtitle", who: "", text: "She folds the second-to-last crane on the threshold.", dur: 4, size: 1.1 },
        { type: "flash_end", who: "", text: "", dur: 0 },
    ]);
}

function ep4_cliff_beats() {
    return beats([
        { type: "subtitle", who: "", text: "The cycle has started. Millie is inside it.", dur: 3, size: 1.2 },
        { type: "comm", who: "Saint", text: "You brought her home to me, James. Thank you. Now stand still and watch." },
        { type: "subtitle", who: "", text: "The core seals. The lights go red.", dur: 3, size: 1.3 },
        { type: "objective", text: "The darkest hour." },
    ]);
}

// ---------------------------------------------------------------- EPISODE 5
function ep5_intro_beats() {
    return beats([
        { type: "title", who: "", text: "EPISODE 5 — CROWN OF STARS\nStratum: The Apex", dur: 4, size: 1.4 },
        { type: "comm", who: "James", text: "One way to stop the cycle: the override at the top of the Apex." },
        { type: "objective", text: "Climb the spire" },
    ]);
}

function ep5_beats() {
    return beats([
        { type: "subtitle", who: "", text: "Climb the exterior. Parkour the collapsing floors.", dur: 4, size: 1.1 },
        { type: "comm", who: "Books", text: "I'll buy you the way up. You climb, James. Don't look back." },
        { type: "subtitle", who: "", text: "The comm goes to static.", dur: 3, size: 1.2 },
        { type: "objective", text: "Reach the crown" },
        { type: "meeting", who: "Saint", text: "The poor of Verge City are a resource. You were always the bait." },
        { type: "meeting", who: "James", text: "Not any more. Millie — now!" },
        { type: "objective", text: "Broadcast her exploit to every screen in the city" },
    ]);
}

function ep5_flashback_beats() {
    return beats([
        { type: "title", who: "", text: "FLASHBACK — COUNTING STARS", dur: 4, size: 1.4 },
        { type: "subtitle", who: "", text: "Mara at the window. Two children counting lit windows like a sky.", dur: 5, size: 1 },
        { type: "comm", who: "Mara", text: "Count the stars with me. I'll always be one of them." },
        { type: "flash_end", who: "", text: "", dur: 0 },
    ]);
}

function ep5_end_beats() {
    return beats([
        { type: "subtitle", who: "", text: "The lights of Verge City flicker — and come up like stars.", dur: 4, size: 1.2 },
        { type: "subtitle", who: "", text: "The wounded spire floods and falls. Swim and run — the two of you, together.", dur: 5, size: 1.1 },
        { type: "meeting", who: "Millie", text: "She presses the last crane into your scarred hand and finishes the lullaby." },
        { type: "title", who: "", text: "Dawn, on the broken lip of the Apex. The city is finally visible.", dur: 5, size: 1.2 },
        { type: "title", who: "", text: "THE END.", dur: 5, size: 1.6 },
        { type: "credits", who: "", text: "", dur: 0 },
    ]);
}

// A map from scene key -> beat factory, so the controller can hand them out
// as the player progresses and reach the end.
function story_scene_sequence() {
    // 17 continuous scenes: 5 episodes + 5 flashbacks + intro/credits woven in.
    return [
        "ep1_intro", "ep1", "ep1_meeting", "ep1_flashback", "ep1_cliff",
        "ep2_intro", "ep2", "ep2_flashback", "ep2_cliff",
        "ep3_intro", "ep3", "ep3_meeting", "ep3_flashback", "ep3_cliff",
        "ep4_intro", "ep4", "ep4_flashback", "ep4_cliff",
        "ep5_intro", "ep5", "ep5_flashback", "ep5_end",
    ];
}

function story_beats_for(_scene) {
    switch (_scene) {
        case "ep1_intro":       return ep1_intro_beats();
        case "ep1":             return ep1_beats();
        case "ep1_meeting":     return ep1_meeting_beats();
        case "ep1_flashback":   return ep1_flashback_beats();
        case "ep1_cliff":       return ep1_cliff_beats();
        case "ep2_intro":       return ep2_intro_beats();
        case "ep2":             return ep2_beats();
        case "ep2_flashback":   return ep2_flashback_beats();
        case "ep2_cliff":       return ep2_cliff_beats();
        case "ep3_intro":       return ep3_intro_beats();
        case "ep3":             return ep3_beats();
        case "ep3_meeting":     return ep3_meeting_beats();
        case "ep3_flashback":   return ep3_flashback_beats();
        case "ep3_cliff":       return ep3_cliff_beats();
        case "ep4_intro":       return ep4_intro_beats();
        case "ep4":             return ep4_beats();
        case "ep4_flashback":   return ep4_flashback_beats();
        case "ep4_cliff":       return ep4_cliff_beats();
        case "ep5_intro":       return ep5_intro_beats();
        case "ep5":             return ep5_beats();
        case "ep5_flashback":   return ep5_flashback_beats();
        case "ep5_end":         return ep5_end_beats();
    }
    return [];
}