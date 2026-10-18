// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on the bed, walls rising in +Z.
// The rack is printed upside down and flipped over after printing.

$fn = 96;

// ---- Plate ----
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0 to 4

// ---- Holes ----
hole_d       = 30.5;  // through-hole diameter (mm)
hole_nx      = 3;     // holes along X
hole_ny      = 2;     // holes along Y
hole_pitch   = 40;    // centre-to-centre spacing in X and Y (mm)
eps          = 0.5;   // cutter overshoot past faces (mm)

// ---- Walls ----
wall_len     = plate_x; // wall length along X (mm)
wall_t       = 4;     // wall thickness along Y (mm)
wall_top_z   = 70;    // wall top height (mm)

// Derived
hole_x0 = -(hole_nx - 1) * hole_pitch / 2;
hole_y0 = -(hole_ny - 1) * hole_pitch / 2;

difference() {
    union() {
        // Base plate
        translate([-plate_x / 2, -plate_y / 2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges, flush with the plate
        for (s = [-1, 1])
            translate([s > 0 ? plate_x / 2 - wall_t : -plate_x / 2,
                       0, 0])
                cube([wall_len, wall_t, wall_top_z - plate_t + 0.01]);
    }

    // Through-holes in the plate (and any overcut into the walls)
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([hole_x0 + i * hole_pitch,
                       hole_y0 + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);
}