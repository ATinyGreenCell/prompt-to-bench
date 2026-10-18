// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, holes facing up
// After printing: flip over so the plate is down and the walls support the tubes

// ---------- Parameters ----------
tube_d      = 30.5;   // tube outer diameter
hole_d      = tube_d + 0.5;  // through-hole diameter (slightly larger)
row_pitch   = 40;     // centre-to-centre spacing along X and Y
plate_x     = 130;    // plate length (X)
plate_y     = 90;     // plate width (Y)
plate_t     = 4;      // plate thickness (Z)
wall_h      = 66;     // wall height above plate (z = 4 to 70)
eps         = 0.5;    // cutter overshoot past faces

$fn = 96;

// ---------- Model ----------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two long-edge walls (along X), flush with the plate
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - 1 : -plate_x/2,
                       -plate_y/2, 0])
                cube([plate_x - sx > 0 ? 1 : plate_x,
                      plate_t, wall_h + plate_t]);
    }

    // Six through-holes: 2 rows (along Y) of 3 (along X)
    for (i = [-1, 1])
        for (j = [-1, 0, 1])
            translate([j * row_pitch, i * row_pitch, -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}