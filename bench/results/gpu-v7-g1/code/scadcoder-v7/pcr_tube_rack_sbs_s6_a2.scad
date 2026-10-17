// 96-well PCR tube rack (0.2 mL) - microplate footprint
// Print orientation: base on XY plane, builds upward (+Z)

// ---------- Parameters ----------
block_l   = 127.76;   // block length along X
block_w   = 85.48;    // block width along Y
block_h   = 20;       // block height along Z

hole_d    = 6.2;      // through-hole diameter
hole_nx   = 12;       // number of columns along X
hole_ny   = 8;        // number of rows along Y
hole_pitch = 9.0;     // centre-to-centre spacing

x0        = 14.38;    // centre of A1 from left edge
y0        = 11.24;    // centre of A1 from back edge

chamfer   = 5;        // chamfer leg length
chamfer_a = 45;       // chamfer angle (degrees)

eps       = 0.5;      // cutter overshoot past faces
$fn       = 64;       // curve resolution

// ---------- Derived ----------
x1 = x0 + (hole_nx - 1) * hole_pitch;   // centre of A12 from left edge
y1 = y0 + (hole_ny - 1) * hole_pitch;   // centre of A8 from back edge

// ---------- Model ----------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // Through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([x0 + i * hole_pitch - hole_d/2,
                       y0 + j * hole_pitch - hole_d/2,
                       -eps])
                cylinder(d = hole_d, h = block_h + 2*eps);

    // Orientation chamfer at A1 corner (vertical edge, 45 deg, 5 mm legs)
    translate([-block_l/2 - chamfer, -block_w/2 - chamfer, 0])
        linear_extrude(block_h)
            polygon([[-chamfer, -chamfer],
                     [chamfer, -chamfer],
                     [chamfer, chamfer],
                     [-chamfer, chamfer]]);
}