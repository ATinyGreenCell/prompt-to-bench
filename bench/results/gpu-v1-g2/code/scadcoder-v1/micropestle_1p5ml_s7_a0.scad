// Pestle for a microcentrifuge tube - a cylindrical handle with grip grooves, a tapered cone,
// and a rounded tip. NOVEL general part.
//

handle_d = 8;
cone     = 62 - 45;
tip_d    = 3;
grooves  = 4;

$fn = 64;

union() {
    cylinder(h = 45, d = handle_d);
    translate([0, 0, 45]) cylinder(h = cone, d1 = handle_d, d2 = tip_d);
    translate([0, 0, 62]) sphere(d = tip_d);
    for (z = [10, 15, 20, 25])
        translate([0, 0, z]) rotate([0, 90, 0]) difference() {
            cylinder(h = 2, d = 2.2);                 // cutter
            translate([-(handle_d / 2 + 1), -1, 0]) rotate([1, 0, 0]) cube([handle_d + 2, 2, 2]);
            translate([-(handle_d / 2 + 1), 1, 0])  rotate([1, 0, 0]) cube([handle_d + 2, 2, 2]);
        }
}