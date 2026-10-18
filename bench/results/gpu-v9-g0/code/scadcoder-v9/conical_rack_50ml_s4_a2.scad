// Rack for six 50 mL conical (Falcon-type) tubes
// Print orientation: flat plate on bed, walls rising to z = 70
// After printing, flip the part so the walls stand on the bed

// ---------------- Parameters ----------------
plate_x      = 130;   // plate length along X (mm)
plate_y      = 90;    // plate width along Y (mm)
plate_t      = 4;     // plate thickness (mm), z = 0..4

hole_d       = 30.5;  // through-hole diameter (mm)
hole_nx      = 3;     // holes per row along X
hole_ny      = 2;     // number of rows along Y
hole_pitch   = 40;    // centre-to-centre spacing, X and Y (mm)

wall_t       = 4;     // wall thickness along Y (mm)
wall_top_z   = 70;    // top of walls (mm)

eps          = 0.5;   // cutter overshoot past faces (mm)
$fn          = 96;    // circle resolution

// ---------------- Derived ----------------
wall_h = wall_top_z - plate_t;   // wall height above plate (66 mm)

// ---------------- Model ----------------
union() {
    // Base plate
    translate([-plate_x/2, -plate_y/2, 0])
        cube([plate_x, plate_y, plate_t]);

    // Through-holes, centred on plate
    for (i = [0 : hole_nx - 1])
        for (j = [0 : hole_ny - 1])
            translate([(i - (hole_nx - 1)/2) * hole_pitch,
                       (j - (hole_ny - 1)/2) * hole_pitch,
                       -eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);

    // Two solid walls along the long edges (flush with plate)
    for (s = [-1, 1])
        translate([0, s * (plate_y/2 - wall_t), plate_t])
            cube([plate_x, wall_t, wall_h]);
}