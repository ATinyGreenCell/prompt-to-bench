// Tubing and stand rod snap-on clip
// Print orientation: flat on bed, z = 0 up to z = 10

// ---------- Parameters ----------
stand_d      = 12.7;   // stand rod diameter
stand_wall   = 3;      // stand ring wall thickness
stand_open   = 10;     // stand ring opening width (y)
stand_r      = stand_d/2 + stand_wall; // stand ring outer radius (18.7)

tubing_d     = 6;      // tubing inner diameter
tubing_wall  = 2;      // tubing ring wall thickness
tubing_x     = 15;     // tubing ring centre x
tubing_r     = tubing_d/2 + tubing_wall; // tubing ring outer radius (10)
tubing_open  = 4.5;    // tubing ring opening width (y)

bridge_w     = 6;      // bridge width (Y)
bridge_x0    = 8;      // bridge start (X)
bridge_x1    = 12;     // bridge end (X)

eps          = 0.5;    // cutter overshoot
$fn          = 96;     // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Stand ring
        cylinder(r = stand_r, h = 10);
        // Tubing ring
        translate([tubing_x, 0, 0])
            cylinder(r = tubing_r, h = 10);
        // Bridge
        translate([bridge_x0, -bridge_w/2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }

    // Stand ring opening: x < 0 and -5 < y < 5
    translate([-stand_r - eps, -stand_open/2, -eps])
        cube([stand_r + eps + 1, stand_open, 10 + 2*eps]);

    // Tubing ring opening: x > 15 and -2.25 < y < 2.25
    translate([tubing_x + tubing_r + eps, -tubing_open/2, -eps])
        cube([tubing_r + eps + 1 - tubing_x, tubing_open, 10 + 2*eps]);
}