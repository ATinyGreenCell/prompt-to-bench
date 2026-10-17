// Rack for six 50 mL conical (Falcon-type) tubes
// Printed upside down: plate on bed, walls rising from plate edges.
// After printing, flip over so rack stands on walls and tubes pass through holes.

// ---------------- Parameters ----------------
plate_x      = 130;    // plate length along X (mm)
plate_y      = 90;     // plate width along Y (mm)
plate_t      = 4;      // plate thickness along Z (mm)

n_rows       = 2;      // number of tube rows (along Y)
n_cols       = 3;      // number of tubes per row (along X)
hole_d       = 30.5;   // tube hole diameter (mm)
pitch        = 40;     // centre-to-centre spacing, both directions (mm)

wall_h       = 70;     // wall height above plate (z = plate_t to 70)
eps          = 0.5;    // cutter overshoot past faces (mm)

$fn = 96;              // circle resolution

// ---------------- Derived ----------------
pitch_x = pitch;       // X spacing between tube centres
pitch_y = pitch;       // Y spacing between rows

// Plate centred in XY: edges at -plate_x/2 .. plate_x/2, etc.
plate_min_x = -plate_x / 2;
plate_max_x =  plate_x / 2;
plate_min_y = -plate_y / 2;
plate_max_y =  plate_y / 2;

// Wall footprints: thin slabs along long edges, flush with plate
wall_left  = [plate_min_x, plate_min_y, plate_t, plate_x, 2, plate_t];
wall_right = [plate_max_x - plate_x + plate_min_x, plate_min_y, plate_t, plate_x, 2, plate_t];

// ---------------- Model ----------------
difference() {
    union() {
        // Flat plate on the bed
        translate([plate_min_x, plate_min_y, 0])
            cube([plate_x, plate_y, plate_t]);

        // Two solid walls rising from plate edges to z = wall_h + plate_t
        translate([plate_min_x, plate_min_y, plate_t])
            cube(wall_left);
        translate([plate_max_x - plate_x + plate_min_x, plate_min_y, plate_t])
            cube(wall_right);
    }

    // Six through-holes for tubes, 2 rows x 3 columns, centred on plate
    for (i = [0 : n_rows - 1])
        for (j = [0 : n_cols - 1])
            translate([
                plate_min_x + j * pitch_x + pitch_x / 2,
                plate_min_y + i * pitch_y + pitch_y / 2,
                -eps
            ])
                cylinder(d = hole_d, h = plate_t + wall_h + 2 * eps);
}