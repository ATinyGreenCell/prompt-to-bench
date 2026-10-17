// Tubing organiser clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, z = 0 up to z = 10

// ---------- Parameters ----------
ring_d      = 12.7;   // rod ring inner diameter
ring_wall   = 3;      // rod ring wall thickness
ring_outer  = ring_d + 2 * ring_wall;  // 18.7 mm
opening_w   = 10;     // rod ring opening width (y span)

tub_d       = 6;      // tubing ring inner diameter
tub_wall    = 2;      // tubing ring wall thickness
tub_outer   = tub_d + 2 * tub_wall;    // 10 mm
tub_x       = 15;     // tubing ring centre X
tub_opening = 4.5;    // tubing ring opening width (x > tub_x)

bridge_w    = 6;      // bridge width in Y
bridge_x0   = 8;      // bridge start X
bridge_x1   = 12;     // bridge end X

eps         = 0.5;    // cutter overshoot past faces
$fn         = 96;     // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Rod ring, centred at origin
        cylinder(d = ring_outer, h = 10);

        // Tubing ring, centred at x = 15, y = 0
        translate([tub_x, 0, 0])
            cylinder(d = tub_outer, h = 10);

        // Solid bridge between x = 8 and x = 12
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // Opening in rod ring: -X side, -5 < y < 5
    translate([-ring_outer / 2 - eps, -opening_w / 2, -eps])
        cube([ring_outer / 2 + eps, opening_w, 10 + 2 * eps]);

    // Opening in tubing ring: +X side, -2.25 < y < 2.25
    translate([tub_x, -tub_opening / 2, -eps])
        cube([tub_outer - tub_x + eps, tub_opening, 10 + 2 * eps]);
}