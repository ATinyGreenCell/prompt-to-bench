// Bench rack for 1.5 mL microcentrifuge tubes
// All dimensions are in millimetres

// Block dimensions
block_x = 106;   // length along X
block_y = 72;    // width  along Y
block_z = 30;    // height  along Z (bottom at z = 0)

// Hole parameters
hole_dia   = 11.2;   // diameter of each tube hole
hole_depth = 25;     // depth of each hole (from top surface)
floor_thick = 5;     // solid floor thickness left at bottom

// Grid layout
cols = 6;   // number of holes along X
rows = 4;   // number of holes along Y
spacing = 16; // centre‑to‑centre spacing (both X and Y)

// Global resolution for curved features
$fn = 64;

// Module for the solid rectangular block (resting on XY plane at z = 0)
module rack() {
    // The cube is centered, then translated so its bottom sits at z = 0
    translate([0, 0, block_z/2])
        cube([block_x, block_y, block_z], center = true);
}

// Assemble the part with holes
difference() {
    rack();   // solid block

    // Cut the 24 holes (4 rows × 6 columns)
    for (i = [0:cols-1])
        for (j = [0:rows-1])
            translate([
                (i - (cols-1)/2) * spacing,   // X position, centred on block
                (j - (rows-1)/2) * spacing,   // Y position, centred on block
                floor_thick - 0.01            // Z position: just below the solid floor
            ])
                cylinder(d = hole_dia,
                         h = hole_depth + 0.02,   // extend 0.01 mm beyond top and bottom
                         $fn = $fn);
}