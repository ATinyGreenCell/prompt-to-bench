// Pestle for a 1.5 mL microcentrifuge tube - a cylindrical handle with a conical section and a
// rounded tip, with circumferential grip grooves. NOVEL general part.
//

handle_d = 8;
cone     = 8;
tip      = 3;
length   = 45;
grooves  = 4;

$fn = 64;

union() {
    cylinder(h = length, d = handle_d);
    translate([0, 0, length]) cone(d1 = handle_d, d2 = tip, h = cone);
    translate([0, 0, length + cone]) sphere(d = tip);
    for (z = [10, 15, 20, 25])
        translate([0, 0, z]) rotate([0, 90, 0]) difference() {
            cylinder(h = 2, d = 1);                 // groove cutter
            translate([-(handle_d / 2 + 1), -handle_d / 2 - 1, 0])
                rotate([0, 1, 0]) cube([handle_d + 2, handle_d + 2, 2]);
        }
}