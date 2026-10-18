// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on the bed, holes facing up.
// After printing, flip the part so the two walls are on the bed.

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // number of holes along X
hole_ny      = 2;     // number of holes along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y (mm)

wall_h       = 66;    // wall height above plate (mm), top at z = 70

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges (flush with plate ends)
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - 1 : -plate_x/2, 0, 0])
                cube([130, wall_h, plate_t]);
    }

    // Tube holes through the plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}