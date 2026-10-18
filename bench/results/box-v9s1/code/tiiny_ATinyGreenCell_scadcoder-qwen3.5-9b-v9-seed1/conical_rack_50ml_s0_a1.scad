// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: plate on bed (z = 0), walls rise to z = 70.
// After printing, flip the part over: it stands on the two walls and the
// tubes pass through the holes (the holes then run vertically downward).

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // number of holes along X
hole_ny      = 2;     // number of holes along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y (mm)

wall_len     = plate_x; // each wall runs the full plate length (mm)
wall_t       = 4;     // wall thickness along Y (mm)
wall_top_z   = 70;    // top of the walls (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------------- Derived ----------------
wall_h = wall_top_z - plate_t;  // wall height above the plate (66 mm)

// ---------------- Model ----------------
union() {
    // Base plate
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges, flush with the plate.
    // They run from the plate upward to z = 70.
    for (s = [-1, 1])
        translate([s > 0 ? plate_x/2 - wall_t : -plate_x/2,
                   -plate_y/2,
                   plate_t])
            cube([wall_len, wall_t, wall_h]);

    // Tube through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}