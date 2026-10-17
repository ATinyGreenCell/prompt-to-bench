// Tubing organiser clip for a 12.7 mm lab stand rod
// Print orientation: flat on the bed, z = 0 up to z = 10

// ---------------- Parameters ----------------
ring_d      = 12.7;   // rod ring inner diameter (stand rod)
ring_w      = 3;      // rod ring wall thickness
ring_o      = ring_d + 2 * ring_w;  // rod ring outer diameter (18.7)

tub_d       = 6;      // tubing ring inner diameter
tub_w       = 2;      // tubing ring wall thickness
tub_x       = 15;     // tubing ring centre X position
tub_o       = tub_d + 2 * tub_w;    // tubing ring outer diameter (10)

bridge_x0   = 8;      // bridge start X
bridge_x1   = 12;     // bridge end X
bridge_w    = bridge_x1 - bridge_x0;  // bridge width (6)

cut_r       = 10;     // opening width for rod ring (-X side)
cut_t       = 4.5;    // opening width for tubing ring (+X side)

eps         = 0.5;    // cutter overshoot past faces
$fn         = 96;     // curve resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Rod ring, centred at origin
        cylinder(d = ring_o, h = 10);

        // Tubing ring, centred at x = 15, y = 0
        translate([tub_x, 0, 0])
            cylinder(d = tub_o, h = 10);

        // Solid bridge between x = 8 and x = 12
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_w, bridge_w, 10]);
    }

    // Opening in rod ring: x < 0 and -5 < y < 5
    translate([-ring_o / 2 - eps, -5, 0])
        cube([cut_r + 2 * eps, 10, 10 + eps]);

    // Opening in tubing ring: x > 15 and -2.25 < y < 2.25
    translate([tub_x, -cut_t / 2, 0])
        cube([tub_x - (-cut_t / 2) + eps, cut_t, 10 + eps]);
}