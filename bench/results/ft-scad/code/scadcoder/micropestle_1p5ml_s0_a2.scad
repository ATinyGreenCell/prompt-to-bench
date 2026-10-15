// Lab pestle - a cylindrical handle with grip grooves that tapers into a rounded tip,
// to grind tissue in a microcentrifuge tube. NOVEL general part.
//

tube_d   = 8;
tip_d    = 3;
handle_z = 45;
cone_z   = 62;
groove_h = 2;
groove_d = 1;

$fn = 64;

difference() {
    union() {
        cylinder(h = handle_z, d = tube_d);
        translate([0, 0, handle_z - 0.01]) cylinder(h = cone_z, d1 = tube_d, d2 = tip_d);
        translate([0, 0, handle_z + cone_z - 1]) sphere(d = tip_d);
    }
    for (z = [handle_z * 0.25, handle_z * 0.5, handle_z * 0.75])
        translate([0, 0, -1]) cylinder(h = groove_h, d = tube_d * 0.8, center = true);
}