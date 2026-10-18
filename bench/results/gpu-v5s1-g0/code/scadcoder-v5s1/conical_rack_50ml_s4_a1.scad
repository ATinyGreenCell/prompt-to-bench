// Rack for six 50 mL conical (Falcon-type) tubes
// Print upside down, then flip over so the two side walls stand on the bed
// and the tube holes face upward.

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0 to 4

hole_d       = 30.5;  // through-hole diameter (mm)
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y (mm)

wall_h       = 70;    // side wall height above plate (mm), z = 4 to 74
wall_t       = 4;     // side wall thickness along Y (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// ---------------- Model ----------------
difference() {
    union() {
        // Base plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid side walls, flush with the long edges
        for (s = [-1, 1])
            translate([s > 0 ? plate_x/2 - wall_t : -plate_x/2, -wall_t, plate_t])
                cube([plate_x, wall_t, wall_h]);
    }

    // Through-holes, centred on the plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}