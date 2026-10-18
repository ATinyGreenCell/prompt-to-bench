// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: plate flat on bed, walls rising to z = 70
// After printing, flip over so the rack stands on the two walls

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing, X and Y (mm)

wall_h       = 70;    // wall height above plate (mm), z = 4..74

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 128;   // circle resolution

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges, flush with plate
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - 1 : -plate_x/2,
                       s * (plate_y/2 - 1),
                       plate_t])
                cube([wall_len = plate_x, plate_y/2 - 1, wall_h]);
    }

    // Tube through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}