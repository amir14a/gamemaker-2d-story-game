// scr_palette.gml — global colour constants for the NEON ECHO cyberpunk look.

#macro COL_BG          1575689   // deep near-black blue
#macro COL_BG2         3149836   // secondary deep
#macro COL_CYAN        16770601   // primary neon cyan
#macro COL_MAGENTA      8924927   // Millie's warm magenta / flashback wash
#macro COL_PINK         13655295
#macro COL_BLUE         16743229
#macro COL_GREEN        11599686
#macro COL_GOLD         6738431
#macro COL_RED          5061631
#macro COL_WHITE        16774382
#macro COL_GREY         10982283
#macro COL_DARKGREY     5255978
#macro COL_ORANGE       4361471
#macro COL_VIOLET       16739229

// Speaker colours for the comm system.
global.speaker_colours = ds_map_create();
ds_map_add(global.speaker_colours, "Books",  COL_GOLD);
ds_map_add(global.speaker_colours, "Millie", COL_MAGENTA);
ds_map_add(global.speaker_colours, "Cray",   COL_RED);
ds_map_add(global.speaker_colours, "Saint",  COL_VIOLET);
ds_map_add(global.speaker_colours, "James",  COL_CYAN);
ds_map_add(global.speaker_colours, "Mara",   COL_PINK);

function speaker_colour(_name) {
    var c = global.speaker_colours[? _name];
    if (is_undefined(c)) return COL_WHITE;
    return c;
}