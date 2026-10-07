// micropestle with one grip groove instead of four

/* [Pestle] */
handle_d = 8;
handle_h = 45;
tip_d = 3;                   // rounded tip diameter
cone_h = 17;                 // matches the conical bottom of a 1.5 mL tube
groove_z = [10]; // grip groove centres [mm]
groove_w = 2;
groove_depth = 1;

/* [Hidden] */
$fn = 64;
eps = 0.01;

difference() {
    union() {
        cylinder(d = handle_d, h = handle_h);
        translate([0, 0, handle_h]) cylinder(d1 = handle_d, d2 = tip_d, h = cone_h);
        translate([0, 0, handle_h + cone_h]) sphere(d = tip_d);
    }
    for (z = groove_z)
        translate([0, 0, z - groove_w / 2])
            difference() {
                cylinder(d = handle_d + 1, h = groove_w);
                translate([0, 0, -eps]) cylinder(d = handle_d - 2 * groove_depth, h = groove_w + 2 * eps);
            }
}
