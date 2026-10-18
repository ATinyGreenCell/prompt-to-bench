// 96-well PCR tube rack - microplate footprint (ANSI/SLAS)
// Print orientation: base on XY plane, builds up +Z

// ---- Block dimensions ----
block_len   = 127.76;   // X length (mm)
block_wid   = 85.48;    // Y width (mm)
block_ht    = 20;       // Z height (mm)

// ---- Hole pattern ----
hole_count  = 96;       // 8 rows x 12 columns
hole_d      = 6.2;      // through-hole diameter (mm)
hole_pitch  = 9.0;      // centre-to-centre spacing (mm)
hole_x0     = 14.38;    // first hole offset from left edge (mm)
hole_y0     = 11.24;    // first hole offset from back edge (mm)

// ---- Chamfer (orientation mark at A1 corner) ----
chamfer_leg = 5;        // 45-degree chamfer leg length (mm)

// ---- Misc ----
eps         = 0.5;      // cutter overshoot past faces (mm)
$fn         = 96;

difference() {
    // Main block
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid
    for (i = [0 : hole_count - 1]) {
        x = hole_x0 + (i % 12) * hole_pitch;
        y = hole_y0 + (i / 12) * hole_pitch;
        translate([x - eps, y - eps, -eps])
            cylinder(d = hole_d, h = block_ht + 2*eps);
    }

    // Chamfer at A1 (left, back, top corner)
    translate([-block_len/2, -block_wid/2, block_ht])
        linear_extrude(height = block_wid + eps)
            polygon([
                [-block_len/2 - eps, block_ht + eps],
                [-block_len/2,       block_ht + eps],
                [-block_len/2,       block_ht - chamfer_leg]
            ]);
}