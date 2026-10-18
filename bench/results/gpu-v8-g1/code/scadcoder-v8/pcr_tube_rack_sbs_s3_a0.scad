// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Units: mm

// ---- Block ----
block_len   = 127.76;   // X length
block_wid   = 85.48;    // Y width
block_ht    = 20;       // Z height

// ---- Holes ----
hole_count  = 96;       // 8 rows x 12 columns
hole_d      = 6.2;      // diameter
pitch_x     = 9.0;      // column spacing (X)
pitch_y     = 9.0;      // row spacing (Y)
first_x     = 14.38;    // A1 distance from left edge
first_y     = 11.24;    // A1 distance from back edge
eps         = 0.5;      // cutter overshoot

$fn = 64;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid
    for (r = [0 : 7])
        for (c = [0 : 11])
            translate([-block_len/2 + first_x + c * pitch_x,
                       -block_wid/2 + first_y + r * pitch_y,
                       -eps])
                cylinder(d = hole_d, h = block_ht + 2 * eps);

    // Orientation chamfer at A1 corner (45 deg, 5 mm legs)
    translate([-block_len/2 + first_x, -block_wid/2 + first_y, 0])
        linear_extrude(height = block_ht)
            polygon([0, 0, block_ht, block_ht - 5, block_ht - 5, 0]);
}