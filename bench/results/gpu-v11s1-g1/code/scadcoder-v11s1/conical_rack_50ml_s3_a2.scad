// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on the bed, holes vertical.
// After printing, flip over so the two wall strips become legs.

$fn = 64;

// ---- Plate ----
plate_x = 130;      // plate length along X
plate_y = 90;       // plate width along Y
plate_t = 4;        // plate thickness (z = 0 to 4)

// ---- Holes ----
hole_d     = 30.5;  // tube hole diameter
hole_nx    = 3;     // holes along X
hole_ny    = 2;     // holes along Y
hole_pitch = 40;    // centre-to-centre spacing (both directions)

// ---- Walls ----
wall_len = plate_x; // wall length along X
wall_t   = 4;       // wall thickness along Y
wall_h   = 66;      // wall height above plate (z = 4 to 70)

eps = 0.5;          // cutter overshoot

difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (a = [0, 180])
            rotate([0, 0, a])
                translate([0, -wall_t/2, plate_t - 0.01])
                    cube([wall_len, wall_t, wall_h + 0.01]);
    }

    // Tube holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + wall_h + 2*eps);
}