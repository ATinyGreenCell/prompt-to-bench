// Agarose gel comb - a flat plate with a back bar and a row of rectangular teeth, for casting
// horizontal gels. NOVEL general part.
//

cols   = 10;
teeth_d = 5.0;
teeth_l = 12;
pitch  = 1.5;
base_t = 1.5;
back_w = 12;

$fn = 48;

P = max(pitch, teeth_d + 1.5);                 // keep a material wall between teeth
L = 70;                                        // spine length (X)
w = back_w + 2 * teeth_l + (cols - 1) * P;    // total width (Y)

difference() {
    union() {
        cube([L, back_w, base_t]);                 // spine (back bar)
        for (i = [0 : cols - 1])
            translate([L / 2 - (cols / 2) * (teeth_d + P), -teeth_l - back_w + i * P, 0])
                cube([teeth_d, teeth_l, base_t]);   // teeth, hanging in the -Y direction
    }
    for (i = [0 : cols - 1])
        translate([L / 2 - (cols / 2) * (teeth_d + P), 0, -1])
            cube([teeth_d + 0.5, teeth_l + 2, base_t + 2]);   // pocket for each tooth
}