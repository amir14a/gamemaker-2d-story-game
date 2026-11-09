// scr_story.gml — all narrative content: the five episodes, flashbacks, and the
// dialogue that fires from trigger zones / meetings as you play.
//
// Beat types:
//   "subtitle"   floating ambient lower-third line (does not pause).
//   "comm"       framed dialogue card with speaker (soft-pauses, advance with E/ACTION).
//   "meeting"    face-to-face; works like comm but with an on-screen speaker figure.
//   "objective"  objective banner hook.
//   "flash_end"  end of a flashback -> next scene.
//   "credits"    show the credits screen.
//
// IMPORTANT: beats are built with the B() helper (explicit property assignment)
// rather than nested struct/array literals, because nested literals are
// unreliable in the HTML5/WASM runner and produce undefined structs at runtime.

function story_config() {
    var s = {};
    s.episode = 0;
    s.scene = "intro";
    s.beat = 0;
    s.beats = [];
    s.beat_x = 0;
    s.next_scene = "";
    s.active = false;
    s.started = false;
    return s;
}

// Build a single beat struct via explicit assignment (no literals).
function B(_type, _who, _text, _dur, _size) {
    var b = {};
    b.type = _type;
    b.who = _who;
    b.text = _text;
    b.dur = _dur;
    b.size = _size;
    return b;
}

// ---------------------------------------------------------------- EPISODE 1
function ep1_intro_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "EPISODE 1 — BREADCRUMBS\nStratum: The Sink", 4, 1.4);
    a[array_length(a)] = B("subtitle", "James", "Six months. And now a paper bird.", 4, 1);
    a[array_length(a)] = B("comm", "James", "A street-kid courier just grabbed the data-chip folded inside.", 0, 0);
    a[array_length(a)] = B("objective", "", "Catch the courier", 0, 0);
    return a;
}

function ep1_beats() {
    var a = [];
    a[array_length(a)] = B("comm", "Books", "James! Picked you up on the old earpiece. You're really doing this, son?", 0, 0);
    a[array_length(a)] = B("comm", "James", "She's my sister, Books.", 0, 0);
    a[array_length(a)] = B("comm", "Books", "And you owe half the Mire a favour or two. They know their old runner.", 0, 0);
    a[array_length(a)] = B("objective", "", "Follow the courier through the Sink", 0, 0);
    a[array_length(a)] = B("subtitle", "", "Vault the gaps — run, jump, keep your line.", 4, 1.1);
    a[array_length(a)] = B("subtitle", "Books", "Courier's cut left, toward the junk quarter.", 3, 1);
    a[array_length(a)] = B("comm", "Books", "Drop by my shop before you kill yourself. I got eyes on this.", 0, 0);
    a[array_length(a)] = B("objective", "", "Reach Books' junk-shop", 0, 0);
    return a;
}

function ep1_meeting_beats() {
    var a = [];
    a[array_length(a)] = B("meeting", "Books", "He's heading for the Floodworks. That's Saint-Cloud's drowned ground.", 0, 0);
    a[array_length(a)] = B("meeting", "Books", "Millie's not who you remember, son. She walked away from you on purpose.", 0, 0);
    a[array_length(a)] = B("comm", "James", "I don't believe that.", 0, 0);
    a[array_length(a)] = B("objective", "", "Corner the courier on the rooftops", 0, 0);
    return a;
}

function ep1_flashback_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "FLASHBACK — THE CRANE\nSixteen years ago", 4, 1.4);
    a[array_length(a)] = B("subtitle", "", "The Sink, at summer dusk. Washing-lines strung between rooftops.", 5, 1);
    a[array_length(a)] = B("subtitle", "Millie", "James! You're too slow, old man!", 3, 1);
    a[array_length(a)] = B("subtitle", "James", "I'm sixteen, you menace —", 3, 1);
    a[array_length(a)] = B("objective", "", "Chase James to the rooftop", 0, 0);
    a[array_length(a)] = B("subtitle", "", "Mara's lullaby drifts up from the open window.", 5, 1.1);
    a[array_length(a)] = B("meeting", "Millie", "See? Fold it like this. If we ever get lost, leave a trail of these.", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "I'll always find the next one. Promise me you'll remember.", 0, 0);
    a[array_length(a)] = B("subtitle", "", "She presses a white paper crane into his hand.", 4, 1.1);
    a[array_length(a)] = B("flash_end", "", "", 0, 0);
    return a;
}

function ep1_cliff_beats() {
    var a = [];
    a[array_length(a)] = B("meeting", "Kid", "She paid me to slow you down! I'm just a courier, please —", 0, 0);
    a[array_length(a)] = B("subtitle", "", "A red dot settles on the kid's chest.", 3, 1.2);
    a[array_length(a)] = B("subtitle", "", "The Mire sniper fires once. The roof gives way.", 3, 1.2);
    a[array_length(a)] = B("subtitle", "", "James falls three floors into the black water.", 3, 1.1);
    a[array_length(a)] = B("objective", "", "Get to the Floodworks", 0, 0);
    return a;
}

// ---------------------------------------------------------------- EPISODE 2
function ep2_intro_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "EPISODE 2 — THE LOOP\nStratum: The Loop", 4, 1.4);
    a[array_length(a)] = B("comm", "Books", "Only way to the Floodworks is the Loop. Cray's people own it tonight.", 0, 0);
    a[array_length(a)] = B("comm", "Books", "Find a car. Don't stop.", 0, 0);
    a[array_length(a)] = B("objective", "", "Hot-wire a courier hauler", 0, 0);
    return a;
}

function ep2_beats() {
    var a = [];
    a[array_length(a)] = B("subtitle", "", "The ring-road climbs and dives. Lean into it.", 4, 1.1);
    a[array_length(a)] = B("comm", "Books", "Interceptors on your tail, between the traffic!", 0, 0);
    a[array_length(a)] = B("objective", "", "Shoot the interceptors off your tail", 0, 0);
    a[array_length(a)] = B("subtitle", "", "A second voice breaks the channel — clipped, familiar.", 4, 1.1);
    a[array_length(a)] = B("comm", "???", "— ake the ... side ramp ... can't reach you ... —", 0, 0);
    a[array_length(a)] = B("objective", "", "Cross the wreck-jam on foot", 0, 0);
    return a;
}

function ep2_flashback_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "FLASHBACK — FIRST LIGHT\nSix years ago", 4, 1.4);
    a[array_length(a)] = B("subtitle", "", "3 a.m. on the empty old Loop, a borrowed car.", 4, 1);
    a[array_length(a)] = B("subtitle", "Millie", "Watch this.", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "Every camera in the district, lit at once. The city can be seen, James.", 0, 0);
    a[array_length(a)] = B("meeting", "James", "You're terrifying. Where'd you learn that?", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "The same place I learned everything. Nobody teaches girls in the Sink.", 0, 0);
    a[array_length(a)] = B("subtitle", "", "The seed of the Ghost.", 4, 1.1);
    a[array_length(a)] = B("flash_end", "", "", 0, 0);
    return a;
}

function ep2_cliff_beats() {
    var a = [];
    a[array_length(a)] = B("comm", "Millie", "James. Stop. If you come down here, you undo everything I've bled for.", 0, 0);
    a[array_length(a)] = B("comm", "Millie", "Please — go home.", 0, 0);
    a[array_length(a)] = B("subtitle", "", "A charge blows the ramp. The wreck plunges into the flooded dark.", 3, 1.2);
    a[array_length(a)] = B("objective", "", "She's alive. And she doesn't want to be found.", 0, 0);
    return a;
}

// ---------------------------------------------------------------- EPISODE 3
function ep3_intro_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "EPISODE 3 — DROWNED LIGHT\nStratum: The Floodworks", 4, 1.4);
    a[array_length(a)] = B("subtitle", "", "Neon signs gutter under the water. Streets have become canals.", 5, 1);
    a[array_length(a)] = B("objective", "", "Swim the drowned avenue", 0, 0);
    return a;
}

function ep3_beats() {
    var a = [];
    a[array_length(a)] = B("subtitle", "", "Breath matters down here — surface to breathe.", 4, 1.1);
    a[array_length(a)] = B("comm", "Books", "There's a cathedral half-swallowed by the flood. Whatever she's doing, it's in there.", 0, 0);
    a[array_length(a)] = B("objective", "", "Climb the drowned rigging", 0, 0);
    a[array_length(a)] = B("subtitle", "", "The nave stretches long and flooded. Run it.", 4, 1);
    a[array_length(a)] = B("objective", "", "Reach the top of the cathedral", 0, 0);
    a[array_length(a)] = B("subtitle", "", "Maps. A wall of Saint-Cloud's crimes. Paper cranes strung like prayer flags.", 5, 1.1);
    a[array_length(a)] = B("meeting", "James", "This isn't a prison. This is a command post.", 0, 0);
    return a;
}

function ep3_meeting_beats() {
    var a = [];
    a[array_length(a)] = B("meeting", "Millie", "Hello, James. You shouldn't have come.", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "The transit collapse that killed Mum and Dad? Saint-Cloud clearing a harvest site.", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "They strip bio-data from the Undercity's dead. I've been inside their system for six months.", 0, 0);
    a[array_length(a)] = B("meeting", "James", "You're the Ghost. The whole city whispers your name.", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "And now you led them straight to me. Go home, James.", 0, 0);
    a[array_length(a)] = B("objective", "", "—", 0, 0);
    return a;
}

function ep3_flashback_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "FLASHBACK — THE QUESTION\nThe night of the collapse", 4, 1.4);
    a[array_length(a)] = B("subtitle", "", "Search the rubble for them.", 3, 1.1);
    a[array_length(a)] = B("subtitle", "Millie", "Mum? Dad? Please —", 3, 1);
    a[array_length(a)] = B("objective", "", "Search the collapse site", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "A Saint-Cloud salvage tag. Where their bodies should be.", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "They were harvested. I'm going to burn it all down.", 0, 0);
    a[array_length(a)] = B("subtitle", "", "The idealist is born — and the vow.", 4, 1.1);
    a[array_length(a)] = B("flash_end", "", "", 0, 0);
    return a;
}

function ep3_cliff_beats() {
    var a = [];
    a[array_length(a)] = B("subtitle", "", "Cray's strike team breaches the command post.", 3, 1.2);
    a[array_length(a)] = B("meeting", "Millie", "Don't fight them. If I fight, they'll find what I hid in their network.", 0, 0);
    a[array_length(a)] = B("subtitle", "", "She presses a paper crane into James's hand as the divers drag her into the flood.", 4, 1.1);
    a[array_length(a)] = B("objective", "", "You led them straight to her.", 0, 0);
    return a;
}

// ---------------------------------------------------------------- EPISODE 4
function ep4_intro_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "EPISODE 4 — THE FOUNDRY\nStratum: The Foundry", 4, 1.4);
    a[array_length(a)] = B("comm", "Books", "This isn't your fault, James.", 0, 0);
    a[array_length(a)] = B("comm", "James", "It's exactly my fault.", 0, 0);
    a[array_length(a)] = B("objective", "", "Ride into Saint-Cloud's processing plant", 0, 0);
    return a;
}

function ep4_beats() {
    var a = [];
    a[array_length(a)] = B("subtitle", "", "Cray's riders close in. Shoot them off the arteries.", 4, 1.1);
    a[array_length(a)] = B("objective", "", "Ditch the bike, climb the refinery", 0, 0);
    a[array_length(a)] = B("subtitle", "", "Inside, the horror is plain: processing the Undercity's people into product.", 5, 1.1);
    a[array_length(a)] = B("meeting", "Cray", "In no hurry at all. Mother wanted you found.", 0, 0);
    a[array_length(a)] = B("meeting", "Cray", "So the Ghost would surface to save you. You're the bait, James. You always were.", 0, 0);
    a[array_length(a)] = B("objective", "", "Reach the processing core", 0, 0);
    return a;
}

function ep4_flashback_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "FLASHBACK — THE BARGAIN\nWeeks ago", 4, 1.4);
    a[array_length(a)] = B("subtitle", "", "Millie walks willingly into Saint-Cloud's intake.", 4, 1);
    a[array_length(a)] = B("meeting", "Millie", "They think they're taking a prisoner. They're taking a seed.", 0, 0);
    a[array_length(a)] = B("meeting", "Millie", "It will cost me my body. But it plants the exploit at their core.", 0, 0);
    a[array_length(a)] = B("subtitle", "", "She folds the second-to-last crane on the threshold.", 4, 1.1);
    a[array_length(a)] = B("flash_end", "", "", 0, 0);
    return a;
}

function ep4_cliff_beats() {
    var a = [];
    a[array_length(a)] = B("subtitle", "", "The cycle has started. Millie is inside it.", 3, 1.2);
    a[array_length(a)] = B("comm", "Saint", "You brought her home to me, James. Thank you. Now stand still and watch.", 0, 0);
    a[array_length(a)] = B("subtitle", "", "The core seals. The lights go red.", 3, 1.3);
    a[array_length(a)] = B("objective", "", "The darkest hour.", 0, 0);
    return a;
}

// ---------------------------------------------------------------- EPISODE 5
function ep5_intro_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "EPISODE 5 — CROWN OF STARS\nStratum: The Apex", 4, 1.4);
    a[array_length(a)] = B("comm", "James", "One way to stop the cycle: the override at the top of the Apex.", 0, 0);
    a[array_length(a)] = B("objective", "", "Climb the spire", 0, 0);
    return a;
}

function ep5_beats() {
    var a = [];
    a[array_length(a)] = B("subtitle", "", "Climb the exterior. Parkour the collapsing floors.", 4, 1.1);
    a[array_length(a)] = B("comm", "Books", "I'll buy you the way up. You climb, James. Don't look back.", 0, 0);
    a[array_length(a)] = B("subtitle", "", "The comm goes to static.", 3, 1.2);
    a[array_length(a)] = B("objective", "", "Reach the crown", 0, 0);
    a[array_length(a)] = B("meeting", "Saint", "The poor of Verge City are a resource. You were always the bait.", 0, 0);
    a[array_length(a)] = B("meeting", "James", "Not any more. Millie — now!", 0, 0);
    a[array_length(a)] = B("objective", "", "Broadcast her exploit to every screen in the city", 0, 0);
    return a;
}

function ep5_flashback_beats() {
    var a = [];
    a[array_length(a)] = B("title", "", "FLASHBACK — COUNTING STARS", 4, 1.4);
    a[array_length(a)] = B("subtitle", "", "Mara at the window. Two children counting lit windows like a sky.", 5, 1);
    a[array_length(a)] = B("comm", "Mara", "Count the stars with me. I'll always be one of them.", 0, 0);
    a[array_length(a)] = B("flash_end", "", "", 0, 0);
    return a;
}

function ep5_end_beats() {
    var a = [];
    a[array_length(a)] = B("subtitle", "", "The lights of Verge City flicker — and come up like stars.", 4, 1.2);
    a[array_length(a)] = B("subtitle", "", "The wounded spire floods and falls. Swim and run — the two of you, together.", 5, 1.1);
    a[array_length(a)] = B("meeting", "Millie", "She presses the last crane into your scarred hand and finishes the lullaby.", 0, 0);
    a[array_length(a)] = B("title", "", "Dawn, on the broken lip of the Apex. The city is finally visible.", 5, 1.2);
    a[array_length(a)] = B("title", "", "THE END.", 5, 1.6);
    a[array_length(a)] = B("credits", "", "", 0, 0);
    return a;
}

// A map from scene key -> beat factory, so the controller can hand them out
// as the player progresses and reach the end.
function story_scene_sequence() {
    var s = [];
    s[array_length(s)] = "ep1_intro";
    s[array_length(s)] = "ep1";
    s[array_length(s)] = "ep1_meeting";
    s[array_length(s)] = "ep1_flashback";
    s[array_length(s)] = "ep1_cliff";
    s[array_length(s)] = "ep2_intro";
    s[array_length(s)] = "ep2";
    s[array_length(s)] = "ep2_flashback";
    s[array_length(s)] = "ep2_cliff";
    s[array_length(s)] = "ep3_intro";
    s[array_length(s)] = "ep3";
    s[array_length(s)] = "ep3_meeting";
    s[array_length(s)] = "ep3_flashback";
    s[array_length(s)] = "ep3_cliff";
    s[array_length(s)] = "ep4_intro";
    s[array_length(s)] = "ep4";
    s[array_length(s)] = "ep4_flashback";
    s[array_length(s)] = "ep4_cliff";
    s[array_length(s)] = "ep5_intro";
    s[array_length(s)] = "ep5";
    s[array_length(s)] = "ep5_flashback";
    s[array_length(s)] = "ep5_end";
    return s;
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
