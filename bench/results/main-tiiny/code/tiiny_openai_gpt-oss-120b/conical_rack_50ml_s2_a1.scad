// Parameters (mm)
plate_x = 130;          // plate length (X)
plate_y = 90;           // plate width (Y)
plate_thick = 4;        // plate thickness (Z)
hole_d = 30.5;          // tube hole diameter
hole_spacing = 40;     // centre‑to‑centre spacing of holes
wall_thick = 4;         // wall thickness (Y)
wall_top = 70;          // final Z height after flipping
wall_height = wall_top - plate_thick; // wall rise above plate
cut_extra = 0.5;        // extra length for cutting shapes

$fn = 128; // smooth circles

// Base plate (centered on origin)
module base_plate() {
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_thick]);
}

// Six through‑holes (2 rows × 3 columns)
module tube_holes() {
    for (i = [-1, 0, 1])
        for (j = [-0.5, 0.5])
            translate([i*hole_spacing, j*hole_spacing, -cut_extra])
                cylinder(h = plate_thick + 2*cut_extra,
                         r = hole_d/2);
}

// Walls along the long edges (attached to plate)
module edge_walls() {
    // South wall (negative Y)
    translate([-plate_x/2,
               -plate_y/2 - wall_thick,
               plate_thick])
        cube([