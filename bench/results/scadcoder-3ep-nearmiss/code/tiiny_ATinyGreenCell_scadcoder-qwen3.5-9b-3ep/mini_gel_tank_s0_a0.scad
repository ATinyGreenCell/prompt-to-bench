// Buffer tank for a mini horizontal gel-electrophoresis box. Open-top rectangular tank with a
// solid raised platform for the gel tray that divides the bottom into two buffer chambers. Each
// end wall gets a horizontal 2 mm hole along X at y = 0, z = 30 for the electrode wires.
//

X  = 120;
Y  = 70;
Z  = 40;
w  = 3;
floor = 3;
platform_L = 60;
platform_h = 10;

$fn = 64;

inner_X = X - 2 * w;
inner_Z = Z - floor;

difference() {
    cube([X, Y, Z]);
    translate([w, 0, floor]) cube([inner_X, Y, inner_Z]);     // hollow out the interior
    translate([w, w, 0]) cube([inner_X, Y, floor]);           // keep the floor solid
    translate([w, w, inner_Z - platform_h])
        cube([platform_L, Y, platform_h]);                     // raised platform for the gel tray

    for (x = [-X / 2, X / 2])
        translate([x, 0, -1]) rotate([-90, 0, 0]) cylinder(h = Z + 2, d = 2);  // electrode holes
}