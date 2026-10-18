// Tubing snap clip for a 12.7 mm (1/2 inch) lab stand rod
// Print orientation: flat on the bed, opens upward in +Z

// ---------- Parameters ----------
rod_d      = 12.7;   // stand rod diameter
ring_w     = 3;      // rod ring wall thickness
ring_od    = rod_d + 2*ring_w;  // rod ring outer diameter (18.7 mm)
ring_id    = rod_d;  // rod ring inner diameter (12.7 mm)

tub_d      = 6;      // tubing inner diameter
tub_w      = 2;      // tubing wall thickness
tub_od     = tub_d + 2*tub_w;    // tubing outer diameter (10 mm)
tub_x      = 15;     // tubing ring centre X position

bridge_x0  = 8;      // bridge start (X)
bridge_x1  = 12;     // bridge end (X)
bridge_w   = 6;      // bridge width (Y)

opening    = 10;     // rod ring opening width along -X (y from -5 to 5)
eps        = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Rod ring
        cylinder(d = ring_od, h = 10);

        // Tubing ring
        translate([tub_x, 0, 0])
            cylinder(d = tub_od, h = 10);

        // Solid bridge between the rings
        translate([bridge_x0, -bridge_w/2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // Rod ring opening cut out of the -X side
    translate([-ring_od - eps, -opening/2, -eps])
        cube([ring_od + 2*eps, opening, 10 + 2*eps]);

    // Tubing ring opening cut out of the +X side
    translate([tub_x, -2.25, -eps])
        cube([ring_od + 2*eps, 4.5, 10 + 2*eps]);
}