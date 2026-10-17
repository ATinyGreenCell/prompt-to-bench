// Falcon tube cone rack for 6 x 50 mL tubes
// Print orientation: flat plate on bed (z = 0), walls rise to z = 70
// After printing, flip the part so it stands on the walls

// ---- Plate ----
plate_x = 130;      // plate length along X
plate_y = 90;       // plate width along Y
plate_t = 4;        // plate thickness (z = 0 to 4)

// ---- Holes ----
hole_d = 30.5;      // through-hole diameter (Falcon tube size)
hole_nx = 3;        // holes along X
hole_ny = 2;        // holes along Y
hole_pitch_x = 40;  // centre-to-centre spacing along X
hole_pitch_y = 40;  // centre-to-centre spacing along Y

// ---- Walls ----
wall_h = 70;        // wall height above plate (z = 4 to 74)
wall_t = 4;         // wall thickness along Y

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces
$fn = 96;           // circle resolution

difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - wall_t : -plate_x/2,
                       -plate_y/2, plate_t])
                cube([wall_t, plate_y, wall_h]);
    }

    // Through-holes, centred on the plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch_x,
                       (j - (hole_ny - 1)/2) * hole_pitch_y,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}