// Agarose gel comb - a flat plate with a back bar and a row of rectangular teeth for casting
// horizontal gels. NOVEL general part, printed lying flat on the bed.
//

teeth  = 10;
bar_l  = 70;
bar_w  = 12;
teth_w = 5;
teth_l = 12;
gap    = 1.5;
thick  = 1.5;

$fn = 48;

teeth_x = teth_w + gap;
bar_f  = (bar_l - (teeth_x * (teeth - 1))) / 2 + teth_w / 2;   // start X of the first tooth
h      = bar_w;                                               // the spine and teeth share the full width

difference() {
    union() {
        cube([bar_l, bar_w, thick]);                 // back bar
        for (i = [0 : teeth - 1])
            translate([bar_f + i * teeth_x, 0, 0]) cube([teeth_x, teth_l, thick]);   // teeth
    }
    for (i = [0 : teeth - 1])
        translate([bar_f + i * teeth_x, teth_l + 0.01, 0]) cube([teeth_x, teth_l + 0.01, thick]);   // cut through the teeth to form the channels
}