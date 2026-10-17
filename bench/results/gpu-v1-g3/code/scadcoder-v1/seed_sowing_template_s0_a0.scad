// Petri dish sowing template - a flat disc with a regular hole grid, for spacing seeds or
// punch biopsies. NOVEL general part.
//

petri_d = 90;
t       = 2;
grid    = 7;
hole    = 3;
pitch   = 9;
notch   = 10;
notch_d = 4;

$fn = 72;

difference() {
    cylinder(h = t, d = petri_d);
    for (i = [-(grid - 1) / 2 : grid - 1 / 2])
        translate([i * pitch, i * pitch, -1]) cylinder(h = t + 2, d = hole);
    translate([0, petri_d / 2 - notch_d, 0]) cube([petri_d + 2, notch, t + 2]);   // orientation notch
}