// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, holes vertical.
// After printing, flip over so the two wall strips become the
// legs that support the rack (the tubes then sit in the cone).

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // number of holes along X
hole_ny      = 2;     // number of holes along Y
hole_pitch   = 40;    // centre-to-centre spacing along X and Y (mm)

wall_t       = 4;     // wall strip thickness along Y (mm)
wall_h       = 70;    // wall strip height above plate (mm), z = 4..74

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges (flush with plate ends)
        for (sx = [-1, 1])
            translate([sx > 0 ? plate_x/2 - 1 : -plate_x/2, -1, plate_t - 0.01])
                cube([plate_x + 2, wall_t + 2, wall_h + 0.01]);
    }

    // Tube holes through plate and walls
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + wall_h + 2*eps);
}