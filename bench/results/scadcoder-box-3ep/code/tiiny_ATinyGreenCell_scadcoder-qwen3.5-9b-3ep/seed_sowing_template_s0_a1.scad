// Petri dish sowing template - a flat disc with a grid of through-holes for seeding, with an
// orientation notch in the rim. NOVEL general part.
//

disc_d = 85;
t      = 2;
holes  = [7, 7];
hole_d = 3;
pitch  = 9;
notch_w = 10;
notch_d = 4;

$fn = 72;

flange_t = 1.5;

difference() {
    cylinder(h = t, d = disc_d);
    for (i = [0 : holes[0] - 1], j = [0 : holes[1] - 1])
        translate([j * pitch - (pitch * (holes[1] - 1)) / 2,
                    i * pitch - (pitch * (holes[0] - 1)) / 2, 0])
            cylinder(h = t + 1, d = hole_d);
    translate([0, disc_d / 2 - notch_d / 2, 0])
        difference()
            cylinder(h = flange_t + 1, d = disc_d);
    translate([0, disc_d / 2 - notch_d / 2, 0])
        cylinder(h = flange_t + 1, d = disc_d - notch_w);
}