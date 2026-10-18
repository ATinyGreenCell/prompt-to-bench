// Tubing clip for 12.7 mm stand rod
// Print orientation: flat on bed, extruded upward in Z

$fn = 96;
h      = 10;    // extrusion height
ring1_d = 12.7; // rod ring inner diameter
ring1_w = 3;    // rod ring wall
ring1_o = ring1_d + 2*ring1_w; // rod ring outer diameter (18.7)
ring2_d = 6;    // tubing ring inner diameter
ring2_w = 2;    // tubing ring wall
ring2_o = ring2_d + 2*ring2_w; // tubing ring outer diameter (10)
ring2_x = 15;   // tubing ring centre X
bridge_w = 6;   // bridge width (Y)
bridge_x1 = 8;  // bridge start X
bridge_x2 = 12; // bridge end X
eps = 0.5;      // cut overshoot

difference() {
    union() {
        // rod ring
        cylinder(d = ring1_o, h = h);
        // tubing ring
        translate([ring2_x, 0, 0])
            cylinder(d = ring2_o, h = h);
        // bridge
        translate([bridge_x1, -bridge_w/2, 0])
            cube([bridge_x2 - bridge_x1, bridge_w, h]);
    }
    // rod ring opening (-X side)
    translate([-ring1_o/2 - eps, -5, -eps])
        cube([ring1_o/2 + eps, 10, h + 2*eps]);
    // tubing ring opening (+X side)
    translate([ring2_x + eps, -ring2_d/2 - eps, -eps])
        cube([ring2_d/2 + eps, ring2_d + 2*eps, h + 2*eps]);
}