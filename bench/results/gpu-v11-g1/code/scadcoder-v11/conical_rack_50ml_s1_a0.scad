// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on the bed (z = 0), walls build upward (+Z).
// The rack is printed upside down and flipped over after printing.
// Units: mm

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X
plate_y      = 90;    // plate width along Y
plate_t      = 4;     // plate thickness (z = 0 to 4)

hole_d       = 30.5;  // tube hole diameter
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // number of rows along Y
hole_pitch   = 40;    // centre-to-centre spacing (both directions)

wall_h       = 70;    // wall height above plate (z = 4 to 74)
wall_t       = 4;     // wall thickness (Y), flush with long edges

eps          = 0.5;   // cutter overshoot past faces
$fn          = 96;    // circle resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - 0.01 : -plate_x/2,
                       s*plate_y/2 - wall_t/2,
                       plate_t])
                cube([plate_x, wall_t, wall_h]);
    }

    // Six through-holes in a 2 x 3 grid
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}