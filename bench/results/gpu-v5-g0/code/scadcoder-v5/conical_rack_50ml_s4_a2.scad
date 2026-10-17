// 6 x 50 mL conical (Falcon-type) tube rack
// Print orientation: flat plate on bed, walls rising to z = 70
// After printing, flip over so walls stand on the bed and tubes pass through holes

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0 to 4

hole_d       = 30.5;  // through-hole diameter (mm)
hole_nx      = 3;     // holes along X (2 rows)
hole_ny      = 2;     // holes along Y (3 columns)
hole_pitch   = 40;    // centre-to-centre spacing in both directions (mm)

wall_h       = 70;    // wall height from top of plate (mm), z = 4 to 74
wall_t       = 4;     // wall thickness along Y (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// ---------- Model ----------
difference() {
    union() {
        // Flat base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges, flush with plate's long edge
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2, 0, plate_t])
                cube([wall_t, plate_y + eps, wall_h]);
    }

    // Through-holes, centred on the plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch - plate_x/2,
                       (j - (hole_ny - 1)/2) * hole_pitch - plate_y/2,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);
}