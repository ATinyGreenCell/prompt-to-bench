// Bench rack for 1.5 mL microcentrifuge tubes
// Print orientation: block rests on XY plane, holes open upward (+Z)

// ---------------- Parameters ----------------
block_x      = 106;    // block length (X)
block_y      = 72;     // block width (Y)
block_z      = 30;     // block height (Z)

cols         = 6;      // holes along X
rows         = 4;      // holes along Y
pitch        = 16;     // centre-to-centre spacing, both directions

hole_d       = 11.2;   // hole diameter
hole_depth   = 25;     // hole depth from top surface
floor_t      = block_z - hole_depth; // solid floor thickness (5 mm)

overcut      = 0.5;    // extension of cutters past top face

$fn = 96;              // circle resolution

// Grid origin so the grid is centred on the block
grid_x0 = -(cols - 1) * pitch / 2;
grid_y0 = -(rows - 1) * pitch / 2;

// ---------------- Model ----------------
difference() {
    // Solid block, centred in X/Y, sitting on z = 0
    translate([-block_x / 2, -block_y / 2, 0])
        cube([block_x, block_y, block_z]);

    // Tube holes: blind, open at top, 5 mm floor
    for (i = [0 : cols - 1])
        for (j = [0 : rows - 1])
            translate([grid_x0 + i * pitch, grid_y0 + j * pitch, floor_t])
                cylinder(d = hole_d, h = hole_depth + overcut, $fn = 96);
}