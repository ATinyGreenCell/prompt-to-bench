// Six-way conical tube rack (Falcon-style)
// Print orientation: plate flat on bed, walls rising in +Z; flipped after printing

// ---------- Parameters ----------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // holes per row along X
hole_py      = 40;    // row pitch along Y (mm)
hole_x       = 40;    // hole pitch along X (mm)
hole_count   = hole_nx * 2; // total holes (2 rows x 3)

wall_len     = plate_x; // wall length along X (mm)
wall_h       = 70;    // wall height above plate top (mm), z = 4..74

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// ---------- Model ----------
union() {
    // Base plate
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges, flush with the plate
    for (s = [-1, 1])
        translate([s * (plate_x/2 - 1),
                   s * (plate_y/2 - 1),
                   plate_t])
            cube([wall_len, plate_y/2 - 1, wall_h]);

    // Tube through-holes
    for (i = [0 : hole_count - 1]) {
        row = floor(i / hole_nx);   // 0 or 1
        col = i % hole_nx;
        translate([(col - (hole_nx - 1)/2) * hole_x,
                   (row - 0.5) * hole_py,
                   -eps])
            cylinder(d = hole_d, h = plate_t + 2*eps);
    }
}