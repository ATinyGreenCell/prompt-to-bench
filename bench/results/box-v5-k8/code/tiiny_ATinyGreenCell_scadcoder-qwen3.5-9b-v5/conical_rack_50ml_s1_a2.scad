// 6 x 50 mL conical (Falcon-type) tube rack
// Print orientation: flat plate on bed, walls rising to z = 70
// Flip after printing: stands on walls, tubes pass through holes

// ---------- Parameters ----------
plate_x      = 130;   // plate length (X)
plate_y      = 90;    // plate width (Y)
plate_t      = 4;     // plate thickness (Z)

hole_d       = 30.5;  // through-hole diameter
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing (both directions)

wall_t       = 4;     // wall thickness (Y)
wall_h       = 70;    // wall top height (Z)

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // curve resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Long-edge walls
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -plate_y/2, 0])
                cube([wall_t, plate_y, wall_h]);
    }

    // Through-holes, centred on plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch - plate_x/2,
                       (j - (hole_ny - 1)/2) * hole_pitch - plate_y/2,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);
}