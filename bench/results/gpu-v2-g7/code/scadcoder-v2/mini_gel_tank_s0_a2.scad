// Reservoir - a rectangular open-top tank with a raised floor and a solid platform that divides
// the bottom into two buffer chambers. Each end wall gets a horizontal X-running hole for an
// electrode wire. NOVEL general part (a generic reservoir, not any one labware item).
//

L   = 120;
W   = 70;
H   = 40;
wall = 3;
floor = 3;
platform_L = 60;
platform_h = 10;
wire_d = 2;

$fn = 64;

inner_H = H - wall;                 // open top, so the inner space goes up to z = H - wall
platform_z = floor + platform_h;   // top of the raised floor in each chamber

difference() {
    cube([L, W, H]);
    translate([0, 0, H - wall]) cube([L, W, wall]);              // cut the open-top cavity
    translate([0, 0, floor]) cube([L, W, floor]);                 // remove the floor, leaving two chambers
    translate([0, W / 2, floor]) cube([L, W, floor]);             // remove the floor on the other side too
    translate([-L / 2, W / 2, 0]) cube([platform_L, W, H - wall]);  // remove the space above the platform (a shelf the gel tray sits on)
    for (x = [-L / 2, L / 2])
        translate([x, 0, -1]) rotate([-90, 0, 0]) cylinder(h = W + 2, d = wire_d);   // horizontal X-running hole in each end wall
}