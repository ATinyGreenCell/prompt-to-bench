// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising to z = 70
// After printing, flip over so the rack stands on the walls

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_count   = 6;     // number of holes
hole_pitch   = 40;    // centre-to-centre spacing, both directions (mm)
hole_rows    = 2;     // number of rows along Y
hole_cols    = 3;     // number of columns along X

wall_len     = plate_x; // wall length along X (mm)
wall_t       = 4;     // wall thickness along Y (mm)
wall_h       = 70;    // wall top height (mm), z = 4..74

eps          = 0.5;   // cutter overshoot past faces (mm)

$fn = 96;             // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -plate_y/2,
                       plate_t])
                cube([wall_len, wall_t, wall_h]);
    }

    // Holes in 2 rows (along Y) of 3 (along X), centred on plate
    for (i = [0 : hole_rows - 1])
        for (j = [0 : hole_cols - 1])
            translate([(j - (hole_cols - 1)/2) * hole_pitch,
                       (i - (hole_rows - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}