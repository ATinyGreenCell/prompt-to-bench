// Six 50 mL conical tube rack (Falcon-type)
// Print orientation: flat plate on bed, two end walls rising to z = 70
// After printing, flip the part so it stands on the walls and the tubes
// pass through the holes into the open bottom.

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // number of rows along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y (mm)

wall_len     = 130;   // end wall length along X (mm)
wall_h       = 70;    // end wall height (mm), z = 0..70

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    // Base plate
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges, flush with the plate
    for (s = [-1, 1])
        translate([s * (plate_x/2 - wall_len)/2,
                   s * (plate_y/2 - 4),
                   0])
            cube([wall_len, 4, wall_h]);

    // Tube through-holes in 2 rows (along Y) of 3 (along X)
    for (i = [-1 : hole_nx - 1])
        for (j = [-1 : hole_ny - 1])
            translate([i * hole_pitch, j * hole_pitch, -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}