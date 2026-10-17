// Pestle for grinding tissue inside a 1.5 mL microcentrifuge tube - a cylindrical handle with
// grip grooves, a tapering cone, and a rounded tip. NOVEL general part, printable standing
// upright.
//

handle_d = 8;
cone_top = 8;
cone_bot = 3;
tip_d    = 3;
grooves  = 4;
width    = 2;
depth    = 1;

$fn = 64;

handle_h = 45;
cone_h   = 62 - 45;
tip_h    = 62;

difference() {
    union() {
        cylinder(h = handle_h, d = handle_d);
        translate([0, 0, handle_h]) cone(d1 = cone_top, d2 = cone_bot, h = cone_h);
        translate([0, 0, handle_h + cone_h]) sphere(d = tip_d);
    }
    for (z = [10, 15, 20, 25])
        translate([0, 0, z]) rotate([0, 90, 0]) cylinder(h = width, d = handle_d + 2 * depth);
    for (z = [10, 15, 20, 25])
        translate([0, 0, z]) rotate([0, 90, 0]) cylinder(h = width, d = handle_d + 2 * depth);
}