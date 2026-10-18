// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls up, holes facing up
// Flip over after printing so the rack stands on the walls

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0 to 4)

hole_d       = 30.5;  // through-hole diameter
hole_nx      = 3;     // holes along X (row length)
hole_ny      = 2;     // holes along Y (row count)
hole_pitch   = 40;    // centre-to-centre spacing in X and Y

wall_len     = 130;   // wall length along X
wall_t       = 4;     // wall thickness along Y
wall_top_z   = 70;    // wall top height (absolute Z)

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -wall_t/2, 0])
                cube([wall_len, wall_t, wall_top_z]);
    }

    // Through-holes in a 2 x 3 grid, centred on the plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch - plate_x/2 + hole_pitch/2,
                       (j - (hole_ny - 1)/2) * hole_pitch - plate_y/2 + hole_pitch/2,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);
}