// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: plate flat on bed, walls rising to z = 70.
// After printing, flip the part so the walls stand on the bed and the
// holes face up for the tubes.

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // tube hole diameter (mm)
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // rows along Y
hole_pitch   = 40;    // centre-to-centre spacing, X and Y (mm)

wall_len     = 130;   // wall length along X (mm)
wall_t       = 4;     // wall thickness along Y (mm)
wall_h       = 70;    // wall height above plate top (mm), z = 4..74

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 128;   // circle resolution

// ---------------- Derived ----------------
wall_top_z   = plate_t + wall_h;   // 74 mm
first_x      = -(hole_nx - 1) * hole_pitch / 2;  // -40
first_y      = -(hole_ny - 1) * hole_pitch / 2;  // -20

// ---------------- Model ----------------
union() {
    // Base plate
    translate([-plate_x / 2, -plate_y / 2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Two solid walls along the long edges, flush with the plate
    for (s = [-1, 1])
        translate([s > 0 ? plate_x / 2 - wall_len : -plate_x / 2,
                   0, plate_t])
            cube([wall_len, wall_t, wall_h]);

    // Tube through-holes
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([first_x + i * hole_pitch,
                       first_y + j * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2 * eps);
}