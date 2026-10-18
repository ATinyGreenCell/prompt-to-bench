// Stand rod and tubing clip - prints flat as a 2-D profile in the XY plane
// Units: mm. $fn = 96 for the ring circles.

// ---------------- Parameters ----------------
ring_d        = 12.7;   // stand rod ring inner diameter
ring_wall     = 3;      // stand rod ring wall thickness
ring_outer    = ring_d + 2 * ring_wall; // 18.7 mm outer diameter
ring_open_w   = 10;     // width of the -X side opening (y = -5 to 5)

tub_d         = 6;      // tubing ring inner diameter
tub_wall      = 2;      // tubing ring wall thickness
tub_outer     = tub_d + 2 * tub_wall;   // 10 mm outer diameter
tub_open_w    = 4.5;    // width of the +X side opening (y = -2.25 to 2.25)

bridge_x0     = 8;      // bridge start (X)
bridge_x1     = 12;     // bridge end (X)
bridge_w      = bridge_x1 - bridge_x0;  // 6 mm wide (Y)

eps           = 0.5;    // cutter overshoot past faces
height        = 10;     // extrusion height (Z)

// ---------------- Model ----------------
difference() {
    union() {
        // Stand rod ring, centred at origin
        cylinder(d = ring_outer, h = height, $fn = 96);

        // Tubing ring, centred at x = 15, y = 0
        translate([15, 0, 0])
            cylinder(d = tub_outer, h = height, $fn = 96);

        // Solid bridge joining the two rings
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_w, bridge_w, height]);
    }

    // Opening in stand rod ring: x < 0, -5 < y < 5
    translate([-ring_open_w / 2 - eps, -5, -eps])
        cube([ring_open_w + 2 * eps, 10, height + 2 * eps]);

    // Opening in tubing ring: x > 15, -2.25 < y < 2.25
    translate([15, -tub_open_w / 2 - eps, -eps])
        cube([tub_open_w + 2 * eps, tub_open_w + 2 * eps, height + 2 * eps]);
}