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
            translate([L / 2 - (teeth_l + P / 2) + i * P, -(teeth_l / 2), 0])
                cube([teeth_d, teeth_l, base_t]);   // teeth, hanging in -Y
    }
    for (i = [0 : cols - 1])
        translate([L / 2 - (teeth_l + P / 2) + i * P, -(teeth_l / 2 + 1), 0])
            cube([teeth_d + 0.01, teeth_l + 2, base_t + 1]);   // pocket in each tooth
}