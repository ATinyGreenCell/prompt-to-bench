// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising to z = 70.
// After printing, flip the part so the walls stand on the bed and the
// tube holes face upward.
//
// Units: mm. $fn = 64 for round holes.

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0 to 4)

hole_d       = 30.5;  // through-hole diameter
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // rows along Y
hole_pitch   = 40;    // centre-to-centre spacing (X and Y)

wall_t       = 4;     // wall thickness (Y)
wall_h       = 70;    // wall top height (z)

eps          = 0.5;   // cutter overshoot past faces

$fn = 64;

// ---------------- Model ----------------
difference() {
    union() {
        // Flat base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -plate_y/2, 0])
                cube([wall_t, plate_y, wall_h]);
    }

    // Six through-holes, 2 rows x 3 columns, centred on the plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}