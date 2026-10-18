// Tubing and stand rod snap-on clip
// Print orientation: flat on bed, z = 0 up to z = 10

// ---- Stand rod ring ----
stand_d  = 12.7;   // stand rod diameter
stand_w  = 3;      // stand ring wall
stand_r  = stand_d / 2 + stand_w;  // 18.7 mm outer radius
stand_x  = -15;    // opening extends to x = -15 (clearance)

// ---- Tubing ring ----
tube_d   = 6;      // tubing inner diameter
tube_w   = 2;      // tubing wall
tube_r   = tube_d / 2 + tube_w;   // 5 mm outer radius
tube_x   = 15;     // tubing ring centre x
tube_y   = 0;      // tubing ring centre y
tube_x0  = tube_x - 15;  // opening start x (9)
tube_x1  = tube_x + 15;  // opening end x (30)

// ---- Bridge ----
bridge_w = 6;      // bridge width (Y)
bridge_x0 = 8;     // bridge start x
bridge_x1 = 12;    // bridge end x

// ---- Misc ----
eps = 0.5;         // cutter overshoot
$fn = 96;

difference() {
    union() {
        // Stand ring
        cylinder(r = stand_r, h = 10);
        // Tubing ring
        translate([tube_x, tube_y, 0])
            cylinder(r = tube_r, h = 10);
        // Bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Stand rod opening
    translate([stand_x, -5, -eps])
        cube([15, 10, 10 + 2 * eps]);
    // Tubing opening
    translate([tube_x0, -2.25, -eps])
        cube([tube_x1 - tube_x0, 4.5, 10 + 2 * eps]);
}