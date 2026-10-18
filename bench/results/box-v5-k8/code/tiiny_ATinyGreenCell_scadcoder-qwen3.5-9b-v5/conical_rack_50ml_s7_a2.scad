// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising to z = 70
// Flip after printing so the rack stands on the two walls

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0 to 4)

hole_d       = 30.5;  // through-hole diameter
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y

wall_len     = 130;   // wall length along X
wall_t       = 4;     // wall thickness along Y

wall_h       = 70;    // wall top height (z)
eps          = 0.5;   // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Flat plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges, flush with the plate's long edge
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -wall_t/2, 0])
                cube([wall_len, wall_t, wall_h]);
    }

    // Through-holes in 2 rows (along Y) of 3 (along X)
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);
}