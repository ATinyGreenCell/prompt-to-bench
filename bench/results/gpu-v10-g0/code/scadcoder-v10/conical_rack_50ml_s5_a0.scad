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
hole_rows    = 2;     // holes along Y
hole_cols    = 3;     // holes along X

wall_len     = plate_x; // wall length along X (mm)
wall_t       = 4;     // wall thickness along Y (mm)
wall_h       = 70;    // wall top height (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 128;   // circle resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -plate_y/2, 0])
                cube([wall_len, wall_t, wall_h]);
    }

    // Six through-holes for the tubes
    for (i = [0 : hole_count - 1]) {
        r = hole_d/2 + eps;
        y = (i % hole_rows) * hole_pitch - (hole_rows - 1) * hole_pitch/2;
        x = (i / hole_rows) * hole_pitch - (hole_cols - 1) * hole_pitch/2;
        translate([x, y, -eps])
            cylinder(d = hole_d, h = wall_h + 2*eps);
    }
}