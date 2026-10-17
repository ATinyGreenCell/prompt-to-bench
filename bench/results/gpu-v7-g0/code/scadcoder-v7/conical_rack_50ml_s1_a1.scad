// 6 x 50 mL conical tube rack (Falcon-type)
// Print orientation: flat plate on bed (z = 0), walls build up to z = 70.
// After printing, flip the part over so it stands on the walls.

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (Z)

hole_d       = 30.5;  // tube hole diameter
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y

wall_t       = 4;     // wall thickness (Y)
wall_h       = 70;    // wall height above plate (Z)

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

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

    // Tube through-holes, centred on the plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}