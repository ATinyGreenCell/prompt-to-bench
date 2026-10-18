// 96-well PCR tube rack (0.2 mL) with ANSI/SLAS footprint
// Print orientation: base on XY plane, building up +Z

// ---------- Parameters ----------
block_len   = 127.76;   // block length along X (mm)
block_wid   = 85.48;    // block width along Y (mm)
block_ht    = 20;       // block height along Z (mm)

hole_d      = 6.2;      // through-hole diameter (mm)
hole_pitch  = 9.0;      // centre-to-centre spacing in X and Y (mm)
hole_count_r = 8;       // number of rows along Y
hole_count_c = 12;      // number of columns along X

corner_x    = 14.38;    // X of first hole (A1) from left edge (mm)
corner_y    = 11.24;    // Y of first hole (A1) from back edge (mm)

chamfer_leg = 5;        // 45-degree chamfer leg length on A1 corner (mm)
eps         = 0.5;      // cutter overshoot past faces (mm)

$fn = 64;

// ---------- Model ----------
difference() {
    // Main block
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Through-holes
    for (r = [0 : hole_count_r - 1])
        for (c = [0 : hole_count_c - 1])
            translate([corner_x + c * hole_pitch - block_len/2,
                       block_wid/2 - corner_y - r * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = block_ht + 2*eps);

    // Chamfer at A1 corner (vertical edge), 45 degrees, 5 mm legs
    translate([corner_x - chamfer_leg - block_len/2,
               corner_y - chamfer_leg - block_wid/2,
               block_ht])
        rotate([90, 0, 0])
            linear_extrude(height = chamfer_leg)
                polygon([[-chamfer_leg, -chamfer_leg],
                         [ chamfer_leg, -chamfer_leg],
                         [ chamfer_leg,  chamfer_leg],
                         [-chamfer_leg,  chamfer_leg]]);
}