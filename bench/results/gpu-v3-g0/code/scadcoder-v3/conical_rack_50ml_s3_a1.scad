// Rack for six 50 mL conical (Falcon-type) tubes
// Printed upside down: plate on bed, walls rising from plate edges
// After printing, flip over so rack stands on walls and tubes pass through holes

// ---------------- Parameters ----------------
plate_x      = 130;    // plate length along X (mm)
plate_y      = 90;     // plate width along Y (mm)
plate_t      = 4;      // plate thickness along Z (mm)

n_rows       = 2;      // number of tube rows (along Y)
n_cols       = 3;      // number of tubes per row (along X)
hole_d       = 30.5;   // tube hole diameter (mm)
pitch        = 40;     // centre-to-centre spacing, both directions (mm)

wall_h       = 70;     // wall height above plate (z = 4 to 70)
eps          = 0.5;    // cutter overshoot past faces (mm)

$fn = 96;              // curve resolution

// ---------------- Derived ----------------
plate_w = plate_y;     // short edge width

// ---------------- Model ----------------
difference() {
    union() {
        // Flat plate on the bed
        translate([-plate_x/2, -plate_y/2, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls along the long edges
        for (edge = [-1, 1])
            translate([-plate_x/2, edge*plate_w/2, 0])
                cube([plate_x, 4, plate_t + wall_h]);
    }

    // Tube holes: 2 rows (Y) x 3 columns (X), centred on plate
    for (i = [0 : n_rows - 1])
        for (j = [0 : n_cols - 1])
            translate([(j - (n_cols - 1)/2) * pitch,
                       (i - (n_rows - 1)/2) * pitch,
                       plate_t - eps])
                cylinder(d = hole_d, h = plate_t + 2*eps);
}