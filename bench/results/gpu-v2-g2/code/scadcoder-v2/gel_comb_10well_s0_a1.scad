// Agarose gel comb - a flat plate with a back bar and a row of rectangular teeth for casting
// horizontal gels. NOVEL general part, printed lying flat on the bed.
//

teeth = 10;
bar   = 70;
t     = 1.5;
w     = 12;
d     = 5;
g     = 1.5;

$fn = 48;

tooth_w = d;
space   = g;

difference() {
    union() {
        cube([bar, w, t]);                                     // back bar
        for (i = [0 : teeth - 1])
            translate([-(teeth * tooth_w + (teeth - 1) * space) / 2 - i * (tooth_w + space), w / 2, 0])
                cube([tooth_w, w, t]);                         // teeth
    }
    for (i = [0 : teeth - 1])
        translate([-(teeth * tooth_w + (teeth - 1) * space) / 2 - i * (tooth_w + space), w / 2, 0])
            cube([tooth_w, w, t + 1]);                         // cut through the tips of the teeth
}