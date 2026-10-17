// 6 x 50 mL conical tube rack (Falcon-type)
// Print orientation: flat plate on bed, walls rising up.
// After printing, flip the part so it stands on the walls.

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm)

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // number of rows along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y (mm)

wall_t       = 4;     // wall thickness (mm)
wall_h       = 66;    // wall height above plate top (mm) -> z = 70 total

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// ---------- Derived ----------
wall_top_z   = plate_t + wall_h;   // top of walls (z = 70)

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -plate_y/2, 0])
                cube([wall_t, plate_y, wall_h]);
    }

    // Through-holes for tubes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}