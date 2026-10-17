// Rack for six 50 mL conical (Falcon-type) tubes
// Printed upside down, then flipped over.
// Units: mm

$fn = 96;

// ---- Plate ----
plate_x     = 130;   // plate length (X)
plate_y     = 90;    // plate width (Y)
plate_t     = 4;     // plate thickness (z = 0 to 4)

// ---- Holes ----
hole_d      = 30.5;  // through-hole diameter
hole_nx     = 3;     // holes along X
hole_ny     = 2;     // holes along Y
hole_pitch  = 40;    // centre-to-centre spacing (both directions)

// ---- Walls ----
wall_h      = 70;    // wall top height (z)
wall_t      = 4;     // wall thickness (Y)

// ---- Misc ----
eps         = 0.5;   // cutter overshoot past faces

difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -wall_t/2, 0])
                cube([wall_t, plate_y + wall_t, wall_h]);
    }

    // Through-holes, centred on the plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps, $fn = 96);
}