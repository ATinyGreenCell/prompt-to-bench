// 96-well PCR tube rack (0.2 mL) - ANSI/SLAS footprint
// Print orientation: base on XY plane, builds up +Z

// ---- Block dimensions ----
block_len   = 127.76;   // X length (mm)
block_wid   = 85.48;    // Y width (mm)
block_ht    = 20;       // Z height (mm)

// ---- Holes ----
hole_d      = 6.2;      // hole diameter (mm)
hole_n      = 96;       // number of holes
hole_rows   = 8;        // rows along Y
hole_cols   = 12;       // columns along X
hole_pitch  = 9.0;      // centre-to-centre spacing (mm)

// ---- Corner chamfer (A1) ----
chamf       = 45;       // angle (deg)
chamf_leg   = 5;        // leg length along X and Y (mm)

// ---- Derived ----
overcut     = 0.5;      // extra length for cutting shapes (mm)
x0          = 14.38;    // first hole X from left edge (mm)
y0          = 11.24;    // first hole Y from back edge (mm)

$fn = 64;

difference() {
    // Main block
    translate([-block_len/2, -block_wid/2, 0])
        cube([block_len, block_wid, block_ht]);

    // Hole grid (through)
    for (i = [0 : hole_cols - 1])
        for (j = [0 : hole_rows - 1])
            translate([(i - (hole_cols - 1)/2) * hole_pitch + x0 - overcut,
                       (j - (hole_rows - 1)/2) * hole_pitch + y0 - overcut,
                       -overcut])
                cylinder(d = hole_d, h = block_ht + 2 * overcut);

    // 45-degree chamfer at A1 corner (vertical edge)
    translate([0, 0, 0])
        linear_extrude(height = block_ht, center = true)
            polygon(points = [
                [chamf_leg, chamf_leg],
                [chamf_leg + overcut, chamf_leg + overcut],
                [chamf_leg + overcut, -chamf_leg - overcut],
                [chamf_leg, -chamf_leg]
            ]);
}