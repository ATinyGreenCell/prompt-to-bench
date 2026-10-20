// Bench rack for 1.5 mL microcentrifuge tubes
// Solid block with 24 vertical holes (4 rows x 6 columns)

// Block dimensions
block_length = 106;   // X
block_width  = 72;    // Y
block_height = 30;    // Z

// Hole grid
rows_y = 4;           // number of rows along Y
cols_x = 6;           // number of columns along X
pitch_x = 16;         // centre-to-centre spacing along X
pitch_y = 16;         // centre-to-centre spacing along Y
hole_diameter = 11.2; // hole diameter
hole_depth = 25;      // hole depth from top
floor_thickness = 5;  // solid floor thickness (30 - 25)

// Print orientation: block rests on XY plane at z=0, centred in X and Y

$fn = 64;

// Main block
block = cube([block_length, block_width, block_height], center=[true, true, false]);

// Cutting cylinder: extends 1 mm past the top face (z=31) and 1 mm past the floor (z=-1)
// so no faces are exactly coplanar
cut_cyl_height = hole_depth + 2; // 27 mm, from z=-1 to z=27

// Hole positions: grid centred on the block
// X positions: 6 columns, pitch 16 -> span = 5*16 = 80, from -40 to +40
// Y positions: 4 rows, pitch 16 -> span = 3*16 = 48, from -24 to +24
hole_x_positions = [-40, -24, -8, 8, 24, 40];
hole_y_positions = [-24, -8, 8, 24];

difference() {
    block;
    for (x in hole_x_positions) {
        for (y in hole_y_positions) {
            translate([x, y, -1]) {
                cylinder(h = cut_cyl_height, d = hole_diameter);
            }
        }
    }
}