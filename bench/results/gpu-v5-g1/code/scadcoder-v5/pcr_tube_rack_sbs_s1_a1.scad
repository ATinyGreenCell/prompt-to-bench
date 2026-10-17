// 96-well PCR tube rack (0.2 mL, standard microplate footprint)
// Units: mm. Print orientation: base on XY plane, building up +Z.

// ---------------- Parameters ----------------
plate_length    = 127.76;   // block length along X (plate X)
plate_width     = 85.48;    // block width along Y (plate Y)
block_height    = 20;       // block height along Z

hole_diameter   = 6.2;      // through-hole diameter for tubes
hole_count      = 96;       // total number of holes (8 x 12)
hole_pitch      = 9.0;      // centre-to-centre spacing in X and Y

a1_x_offset     = 14.38;    // A1 hole centre distance from left edge
a1_y_offset     = 11.24;    // A1 hole centre distance from back edge
chamfer_leg     = 5;        // 45-degree chamfer leg length at A1 corner

eps             = 0.5;      // overshoot for clean boolean cuts
$fn             = 64;       // curve resolution

// ---------------- Derived ----------------
rows    = 8;
cols    = 12;
x0      = a1_x_offset - (cols - 1) * hole_pitch / 2;  // first X (centred grid)
y0      = a1_y_offset - (rows - 1) * hole_pitch / 2;  // first Y (centred grid)

// ---------------- Model ----------------
difference() {
    // Main block, centred in X/Y, resting on z = 0
    translate([-plate_length / 2, -plate_width / 2, 0])
        cube([plate_length, plate_width, block_height]);

    // Through-holes
    for (i = [0 : rows - 1])
        for (j = [0 : cols - 1])
            translate([x0 + j * hole_pitch, y0 + i * hole_pitch, -eps])
                cylinder(d = hole_diameter, h = block_height + 2 * eps);

    // Orientation chamfer at the A1 corner (vertical edge, 45 degrees)
    translate([x0, y0, 0])
        linear_extrude(height = block_height + eps)
            polygon([[-eps, -eps], [chamfer_leg - eps, -eps],
                     [chamfer_leg - eps, chamfer_leg - eps],
                     [-eps, chamfer_leg - eps]]);
}