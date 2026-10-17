// Tubing organiser clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, builds up in +Z

// ---------------- Parameters ----------------
rod_d      = 12.7;   // stand rod diameter
ring_w     = 3;      // rod ring wall thickness
rod_r      = rod_d/2 + ring_w;  // rod ring outer radius (18.7 mm)

tub_d      = 6;      // tubing inner diameter
tub_w      = 2;      // tubing wall thickness
tub_r      = tub_d/2 + tub_w;  // tubing outer radius (5 mm)

bridge_x0  = 8;      // bridge start (X)
bridge_x1  = 12;     // bridge end (X)
bridge_w   = bridge_x1 - bridge_x0;  // bridge width (6 mm)

opening1_w = 10;     // rod ring opening width (Y)
opening2_w = 4.5;    // tubing opening width (Y)

eps        = 0.5;    // cutter overshoot past faces
$fn        = 96;     // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring, centred at origin
        cylinder(r = rod_r, h = 10);

        // Tubing ring, centred at x = 15, y = 0
        translate([15, 0, 0])
            cylinder(r = tub_r, h = 10);

        // Solid bridge between x = 8 and x = 12
        translate([bridge_x0, -bridge_w/2, 0])
            cube([bridge_w, bridge_w, 10]);
    }

    // Rod ring opening: x < 0 and -5 < y < 5
    translate([-rod_r - eps, -opening1_w/2, -eps])
        cube([rod_r + 2*eps, opening1_w, 10 + 2*eps]);

    // Tubing opening: x > 15 and -2.25 < y < 2.25
    translate([15, -opening2_w/2, -eps])
        cube([eps, opening2_w, 10 + 2*eps]);
}