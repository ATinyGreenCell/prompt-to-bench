// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube - a cylindrical handle with
// grip grooves, a tapering cone, and a rounded tip. NOVEL general part, printable standing
// upright.
//

handle_d = 8;
cone_top = 8;
cone_bot = 3;
tip_d    = 3;
groove_w = 2;
groove_d = 1;

$fn = 64;

handle_h = 45;
cone_h   = 62 - 45;
tip_h    = 62;

difference() {
    union() {
        cylinder(h = handle_h, d = handle_d);
        translate([0, 0, handle_h]) cylinder(h = cone_h, d1 = cone_top, d2 = cone_bot);
        translate([0, 0, handle_h + cone_h]) sphere(d = tip_d);
    }
    for (z = [10, 15, 20, 25])
        translate([0, 0, z]) cylinder(h = groove_w + 0.01, d = handle_d);
    for (z = [10, 15, 20, 25])
        translate([0, 0, z]) cylinder(h = groove_d + 0.01, d = handle_d - groove_w);
}