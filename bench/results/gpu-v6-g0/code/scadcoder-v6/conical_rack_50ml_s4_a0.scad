// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls up. After printing, flip over.
// Units: mm

// ---- Plate ----
plate_x = 130;      // plate length (X)
plate_y = 90;       // plate width (Y)
plate_t = 4;        // plate thickness (Z)

// ---- Holes ----
hole_d = 30.5;      // through-hole diameter
hole_nx = 3;        // holes along X
hole_ny = 2;        // holes along Y
hole_pitch_x = 40;  // centre-to-centre spacing along X
hole_pitch_y = 40;  // centre-to-centre spacing along Y

// ---- Walls ----
wall_len = plate_x; // wall length along X (flush with long edges)
wall_h = 70;        // wall top height (from bed)

// ---- Misc ----
eps = 0.5;          // cutter overshoot past faces
$fn = 96;           // circle resolution

difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along long edges
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - wall_len : -plate_x/2,
                       -plate_y/2, 0])
                cube([wall_len, plate_t - s, wall_h]);
    }

    // Six through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch_x,
                       (j - (hole_ny - 1)/2) * hole_pitch_y,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}