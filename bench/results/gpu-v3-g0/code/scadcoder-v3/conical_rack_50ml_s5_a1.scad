// Rack for six 50 mL conical (Falcon-type) tubes
// Printed upside down: plate on bed, walls rising from long edges
// After printing, flip over so rack stands on walls and tubes pass through holes

$fn = 96;

// ---- Plate ----
plate_x = 130;      // plate length (X)
plate_y = 90;       // plate width (Y)
plate_t = 4;        // plate thickness (Z)

// ---- Holes ----
hole_d     = 30.5;  // through-hole diameter
hole_nx    = 3;     // holes along X
hole_ny    = 2;     // holes along Y
hole_pitch = 40;    // centre-to-centre spacing (X and Y)

// ---- Walls ----
wall_h = 70;        // wall height above plate (z = 4 to 70)

// ---- Cutting overlap ----
eps = 0.5;          // extension past faces for clean cuts

difference() {
    union() {
        // Plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);
        // Two solid walls along long edges
        for (edge = [-plate_y/2, plate_y/2])
            translate([-plate_x/2, edge, 0])
                cube([plate_x, 4, wall_h]);
    }

    // Six through-holes, centred on plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}