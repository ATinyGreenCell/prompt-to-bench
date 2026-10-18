// 96-well PCR tube rack (0.2 mL) - ANSI/SLAS microplate footprint
// Print orientation: base on XY plane, builds up +Z, centred in X/Y

// ---------- Block ----------
block_l = 127.76;   // length along X (mm)
block_w = 85.48;    // width along Y (mm)
block_h = 20;       // height along Z (mm)

// ---------- Holes ----------
hole_d     = 6.2;   // hole diameter (mm)
hole_nx    = 12;    // columns along X
hole_ny    = 8;     // rows along Y
hole_pitch = 9.0;   // centre-to-centre spacing (mm)
hole_x0    = 14.38; // first hole X offset from left edge (mm)
hole_y0    = 11.24; // first hole Y offset from back edge (mm)

// ---------- Chamfer ----------
chamf_leg  = 5;     // chamfer leg length (mm)
chamf_ang  = 45;    // chamfer angle (degrees)

// ---------- Misc ----------
eps        = 0.5;   // cutter overshoot past faces (mm)
$fn        = 96;    // curve resolution

difference() {
    // Main block
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Tube through-holes (grid centred on block)
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i * hole_pitch - block_l/2,
                       hole_y0 + j * hole_pitch - block_w/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2 * eps);

    // 45-degree orientation chamfer at A1 corner (top edge, X/Y > 0)
    translate([block_l/2 - chamf_leg, block_w/2 - chamf_leg, block_h])
        rotate([90, 0, 0])
            linear_extrude(height = chamf_leg)
                polygon([[-chamf_leg, -chamf_leg],
                         [ chamf_leg, -chamf_leg],
                         [ chamf_leg,  chamf_leg]]);
}