// scr_palette.gml — global colour constants for the NEON ECHO cyberpunk look.

#macro COL_BG          $090b18   // deep near-black blue
#macro COL_BG2         $0c1030   // secondary deep
#macro COL_CYAN        $29e6ff   // primary neon cyan
#macro COL_MAGENTA      $ff2e88   // Millie's warm magenta / flashback wash
#macro COL_PINK         $ff5cd0
#macro COL_BLUE         $3d7bff
#macro COL_GREEN        $46ffb0
#macro COL_GOLD         $ffd166
#macro COL_RED          $ff3b4d
#macro COL_WHITE        $eef4ff
#macro COL_GREY         $8b93a7
#macro COL_DARKGREY     $2a3350
#macro COL_ORANGE       $ff8c42
#macro COL_VIOLET       $9d6bff

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