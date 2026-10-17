// Agarose gel comb - a flat plate with a back bar and a row of rectangular teeth, for casting
// horizontal (flat) gels. NOVEL general part.
//

cols   = 10;
teeth_d = 5.0;
teeth_l = 12;
spine_w = 12;
pitch   = 1.5;
t       = 1.5;

$fn = 48;

P = max(pitch, teeth_d + 1.5);                 // centre-to-centre spacing
L = spine_w + 2 * teeth_l + (cols - 1) * P;   // total X span
w = spine_w;                                  // constant width (Y)

difference() {
    union() {
        cube([L, w, t]);                       // base plate
        for (i = [0 : cols - 1])
            translate([-(spine_w / 2) + i * P, -(w / 2 + teeth_l), 0])
                cube([teeth_d, w + 2 * teeth_l, t]);   // teeth (overhang the front edge)
    }
    // channel: a spine along the back edge and a groove under each tooth, open at the top (z = t)
    for (i = [0 : cols - 1])
        translate([-(spine_w / 2) + i * P, -(w / 2 + teeth_l), -1])
            cube([teeth_d + 0.5, w + 2 * teeth_l, t + 2]);
    translate([0, -w / 2 - 1, -1]) cube([spine_w, w + 2, t + 2]);   // back bar groove
}