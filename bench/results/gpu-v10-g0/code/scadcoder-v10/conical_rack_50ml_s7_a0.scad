// Tube rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising to z = 70
// After printing, flip over so the rack stands on the walls

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0 to 4)

hole_d       = 30.5;  // through-hole diameter
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing (both directions)

wall_len     = 130;   // wall length along X
wall_t       = 4;     // wall thickness along Y
wall_h       = 70;    // wall top height (z)

eps          = 0.5;   // cutter overshoot past faces

$fn = 96;             // smoothness of curved shapes

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - wall_len : -plate_x/2,
                       s > 0 ? plate_y/2 - wall_t : -plate_y/2,
                       plate_t])
                cube([wall_len, wall_t, wall_h - plate_t + eps]);
    }

    // Through-holes in a 3 x 2 grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}