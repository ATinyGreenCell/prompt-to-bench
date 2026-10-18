// Tubing and stand-rod snap-on clip
// Print orientation: flat on bed, z = 0 up to z = 10

// ---- Stand rod ----
stand_d  = 12.7;   // stand rod diameter
stand_t  = 3;      // stand ring wall thickness
stand_r  = stand_d / 2 + stand_t;  // stand ring outer radius = 18.7

// ---- Tubing ----
tube_d   = 6;      // tubing inner diameter
tube_w   = 2;      // tubing wall thickness
tube_i   = tube_d / 2 + tube_w;   // tubing outer radius = 5
tube_x   = 15;     // tubing ring centre X

// ---- Opening ----
open_w   = 10;     // stand ring opening width (X)
open_y   = 5;      // stand ring opening half-height (Y)

// ---- Bridge ----
bridge_w = 6;      // bridge width (Y)
bridge_x0 = 8;     // bridge start (X)
bridge_x1 = 12;    // bridge end (X)

// ---- Misc ----
eps = 0.5;         // cutter overshoot past faces
$fn = 128;         // curve resolution

difference() {
    union() {
        // Stand ring
        cylinder(r = stand_r, h = 10);
        // Tubing ring
        translate([tube_x, 0, 0])
            cylinder(r = tube_i, h = 10);
        // Solid bridge
        translate([bridge_x0, -bridge_w / 2, 0])
            cube([bridge_x1 - bridge_x0, bridge_w, 10]);
    }
    // Stand ring opening, cut through full Z
    translate([-stand_r, -open_y, -eps])
        cube([open_w, 2 * open_y, 10 + 2 * eps]);
    // Tubing ring opening, cut through full Z
    translate([tube_x + tube_i, -open_y / 2, -eps])
        cube([open_w, open_y, 10 + 2 * eps]);
}