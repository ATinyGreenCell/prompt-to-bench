// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Units: mm. Print orientation: base on XY plane, builds +Z.

// ---- Block ----
block_len   = 127.76;   // X length
block_wid   = 85.48;    // Y width
block_ht    = 20;       // Z height

// ---- Holes ----
hole_count  = 96;       // 8 rows x 12 columns
hole_d      = 6.2;      // through-hole diameter
hole_pitch  = 9.0;      // centre-to-centre spacing
first_x     = 14.38;    // A1 centre, from left edge
first_y     = 11.24;    // A1 centre, from back edge

// ---- Chamfer ----
chamfer     = 5;        // 45-degree leg length at A1 corner

// ---- Misc ----
eps         = 0.5;      // cutter overshoot past faces
$fn         = 64;

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid
    for (i = [0 : hole_count/col - 1])
        for (j = [0 : row - 1])
            translate([first_x + i*hole_pitch - (col - 1)*hole_pitch/2,
                       first_y + j*hole_pitch - (row - 1)*hole_pitch/2,
                       -eps])
                cylinder(d = hole_d, h = block_ht + 2*eps);

    // Chamfer at A1 (x = first_x, y = first_y)
    translate([first_x, first_y, 0])
        linear_extrude(height = block_ht)
            polygon([
                [0, 0],
                [block_len/2 + chamfer, 0],
                [block_len/2 + chamfer, block_wid/2 + chamfer],
                [0, block_wid/2 + chamfer]
            ]);
}