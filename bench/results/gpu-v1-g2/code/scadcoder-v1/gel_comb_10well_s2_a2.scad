// Agarose gel comb - a flat plate with a back bar and a row of rectangular teeth, for casting
// horizontal gels. NOVEL general part.
//

cols   = 10;
teeth_d = 5.0;
teeth_l = 12;
pitch  = 1.5;
bar_w   = 12;
t       = 1.5;

$fn = 48;

p2 = teeth_d + pitch;                 // centre-to-centre pitch
Lx = 70;                              // spine length (X)
wy = bar_w + 2 * teeth_l;             // overall width (Y): spine + 2x the overhanging teeth

difference() {
    translate([-Lx / 2, -wy / 2, 0]) cube([Lx, wy, t]);
    for (i = [-cols / 2 : 1 : cols / 2 - 1])
        translate([0, i * p2 + (cols % 2 == 1 ? pitch / 2 : 0), -1]) cube([teeth_d, teeth_l, t + 2]);   // teeth pockets
}