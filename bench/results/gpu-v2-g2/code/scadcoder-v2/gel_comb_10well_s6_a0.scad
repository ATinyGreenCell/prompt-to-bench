// Agarose gel comb - a flat plate with a back bar and a row of rectangular teeth for casting
// horizontal gels. NOVEL general part, printed lying flat on the bed.
//

teeth = 10;
bar   = 70;
t     = 1.5;
g     = 1.5;
w     = 5;
l     = 12;

$fn = 48;

teeth_size = [w, l];
gap         = [g, 0];
base        = [bar, l + 1.5];                 // the back bar (spine)
projection  = [w + g, l];                     // one tooth plus its following gap

difference() {
    union() {
        translate([bar / 2, 0, 0]) rotate([-90, 0, 0]) cylinder(h = bar, d = t);           // back bar (spine)
        for (i = [0 : teeth - 1])
            translate([bar / 2 - (w + g) * teeth / 2 + (w + g / 2) * (i + 1), 0, 0])
                rotate([-90, 0, 0]) cube(teeth_size, center = true);                         // teeth
    }
    for (i = [0 : teeth - 1])
        translate([bar / 2 - (w + g) * teeth / 2 + (w + g / 2) * (i + 1), l + 0.75, 0])
            rotate([-90, 0, 0]) cylinder(h = t + 1.5, d = w + g);                           // empty below each tooth
}