// Six-way conical tube rack (Falcon-style)
// Print orientation: base plate flat on bed, walls rising in +Z.
// After printing, flip the part. The rack then stands on the two walls,
// with open ends facing down, and tubes pass through the holes.

// ---------------- Parameters ----------------
plate_x      = 130;   // base plate length along X (mm)
plate_y      = 90;    // base plate width along Y (mm)
plate_t      = 4;     // base plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_pitch   = 40;    // centre-to-centre hole spacing, X and Y (mm)
hole_nx      = 3;     // holes along X per row
hole_ny      = 2;     // number of rows along Y

wall_len     = 130;   // wall length along X (mm)
wall_h       = 70;    // wall height from top of plate (mm), z = 4..74

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // curve resolution

// ---------------- Model ----------------
difference() {
    // Base plate
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges, flush with the plate
    for (s = [-1, 1])
        translate([s > 0 ? plate_x/2 - wall_len : -plate_x/2,
                   s * (plate_y/2 - 0.01),
                   plate_t])
            cube([wall_len, 0.02, wall_h]);

    // Tube holes through the plate (and slightly into the walls)
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}