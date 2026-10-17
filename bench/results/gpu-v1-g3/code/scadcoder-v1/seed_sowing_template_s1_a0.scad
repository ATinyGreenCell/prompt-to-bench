// Petri dish sowing template - a flat disc with a regular grid of through-holes, for spacing
// seeds or small parts. A rectangular notch in the rim sets orientation. NOVEL general part.
//

petri_d = 90;
t       = 2;
holes   = 7;
pitch   = 9;
notch_w = 10;
notch_d = 4;

$fn = 72;

rim    = petri_d + 2 * t;
reduced = min(pitch * (holes - 1), rim - 2 * t - 2);          // keep holes clear of the rim
L      = reduced / 2;                                        // half the grid span
H      = t + 1;                                             // height so a countersink bit can start a hole

difference() {
    cylinder(h = t, d = petri_d);
    for (i = [-holes / 2 : 1 : holes / 2])
        translate([i * pitch, 0, -1]) cylinder(h = t + 2, d = 3);
    translate([0, -1, 0]) cylinder(h = t + 2, d = notch_w);   // orientation notch
}