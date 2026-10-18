// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed (z = 0), walls rise to z = 70
// After printing, flip over so the rack stands on the two walls

// ---- Dimensions (mm) ----
plate_x     = 130;   // plate length along X
plate_y     = 90;    // plate width along Y
plate_t     = 4;     // plate thickness (z = 0 to 4)
hole_d      = 30.5;  // tube hole diameter
hole_nx     = 3;     // holes per row along X
hole_ny     = 2;     // number of rows along Y
hole_pitch  = 40;    // centre-to-centre spacing (both X and Y)
wall_h      = 70;    // wall height above plate
eps         = 0.5;   // cutter overshoot past faces

$fn = 96;            // curve resolution

// ---- Model ----
difference() {
    union() {
        // Plate
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);
        // Two solid walls along the long edges (X), flush with plate
        for (s = [-1, 1])
            translate([s * plate_x/2 - 1, -plate_y/2, 0])
                cube([plate_x - 2, plate_y, wall_h]);
    }
    // Tube holes through the plate
    for (i = [0 : hole_ny - 1])
        for (j = [0 : hole_nx - 1])
            translate([(j - (hole_nx - 1)/2) * hole_pitch,
                       (i - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps, $fn = 96);
}