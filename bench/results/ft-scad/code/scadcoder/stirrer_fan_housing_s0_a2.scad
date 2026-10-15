// Magnetic stirrer box - an upside-down open box that covers a PC case fan and has a
// screw hole pattern and a power cable notch. NOVEL general part.
//

fan_d  = 80;
wall   = 2.5;
top    = 2;
length = 90;
width  = 90;
screw  = 4.5;
grid   = 71.5;
notch  = 12;
cut    = 8;

$fn = 32;

difference() {
    union() {
        cube([length, width, wall]);                 // sides
        translate([0, 0, wall]) cube([fan_d, fan_d, wall]);   // fan pocket
        translate([0, 0, top - 0.01]) cube([length, width, top]); // top plate
    }
    for (z = [wall + 0.01, height - cut - 0.01])
        translate([-1, width / 2, z]) rotate([-90, 0, 0]) rectangle(sizes = [notch, wall * 2]);
    for (i = [-grid / 2, grid / 2])
        for (j = [-grid / 2, grid / 2])
            translate([length + i, width + j, wall]) cylinder(h = top, d = screw);
}