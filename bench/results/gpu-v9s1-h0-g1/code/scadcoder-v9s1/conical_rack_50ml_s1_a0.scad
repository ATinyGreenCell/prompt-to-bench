// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: plate flat on bed, walls rising in +Z
// After printing, flip the part so it stands on the two walls

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // number of rows along Y
hole_pitch   = 40;    // centre-to-centre spacing, X and Y (mm)

wall_len     = 130;   // wall length along X (mm)
wall_h       = 70;    // wall height above plate (mm), z = 4..74

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// Derived
wall_top_z   = plate_t + wall_h;   // 74 mm

// ---------------- Model ----------------
union() {
    // Base plate with tube holes
    difference() {
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        for (i = [0 : hole_nx - 1])
            for (j = [0 : hole_ny - 1])
                translate([(i - (hole_nx - 1)/2) * hole_pitch,
                           (j - (hole_ny - 1)/2) * hole_pitch,
                           -eps])
                    cylinder(d = hole_d, h = plate_t + 2*eps);
    }

    // Two solid walls along the long edges
    for (s = [-1, 1]) {
        translate([s > 0 ? plate_x/2 - wall_len : -plate_x/2,
                   -plate_y/2,
                   plate_t])
            cube([wall_len, plate_y, wall_h]);
    }
}