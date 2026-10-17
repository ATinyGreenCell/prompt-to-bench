// 96-well PCR tube rack (0.2 mL, microplate footprint)
// Print orientation: base on XY plane, builds upward (+Z)

// ---------- Block ----------
block_len   = 127.76;   // block length along X (mm)
block_wid   = 85.48;    // block width along Y (mm)
block_ht    = 20;       // block height along Z (mm)

// ---------- Hole grid ----------
hole_count  = 96;       // total number of tube holes
hole_d      = 6.2;      // hole diameter (mm)
hole_pitch  = 9.0;      // centre-to-centre spacing (mm)
rows        = 8;        // number of rows along Y
cols        = 12;       // number of columns along X
x0          = 14.38;    // X offset of first hole from left edge (mm)
y0          = 11.24;    // Y offset of first hole from back edge (mm)

// ---------- Chamfer ----------
chamfer     = 5;        // 45-degree chamfer leg length at A1 corner (mm)

// ---------- Misc ----------
eps         = 0.5;      // overshoot for clean boolean cuts (mm)
$fn         = 96;       // circle resolution

difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // 96 vertical through-holes
    for (i = [0 : hole_count - 1]) {
        c = x0 + i % cols * hole_pitch;
        r = y0 + i / cols * hole_pitch;
        translate([c, r, -eps])
            cylinder(d = hole_d, h = block_ht + 2*eps);
    }

    // 45-degree chamfer at the A1 corner (vertical edge, top and bottom faces)
    translate([x0, y0, 0])
        cube([chamfer, chamfer, block_ht]);
}