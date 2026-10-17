// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: block rests on XY plane, holes open upward (+Z)

// ---------- Block ----------
block_l = 106;     // block length (X)
block_w = 72;      // block width (Y)
block_h = 30;      // block height (Z)

// ---------- Holes ----------
cols      = 6;     // holes along X
rows      = 4;     // holes along Y
pitch_x   = 16;    // centre-to-centre spacing in X
pitch_y   = 16;    // centre-to-centre spacing in Y
hole_d    = 11.2;  // hole diameter
hole_depth = 25;   // hole depth from top surface
floor_t   = block_h - hole_depth; // solid floor thickness (5 mm)

// ---------- Misc ----------
overcut = 0.5;     // extension of cutters past the top face
$fn = 96;          // circle resolution

// Grid origin so the grid is centred on the block
grid_x0 = -(cols - 1) * pitch_x / 2;
grid_y0 = -(rows - 1) * pitch_y / 2;

difference() {
    // Solid block, centred in X/Y, sitting on z = 0
    translate([-block_l / 2, -block_w / 2, 0])
        cube([block_l, block_w, block_h]);

    // Tube holes
    for (i = [0 : cols - 1])
        for (j = [0 : rows - 1])
            translate([grid_x0 + i * pitch_x,
                       grid_y0 + j * pitch_y,
                       floor_t])
                cylinder(d = hole_d, h = hole_depth + overcut);
}