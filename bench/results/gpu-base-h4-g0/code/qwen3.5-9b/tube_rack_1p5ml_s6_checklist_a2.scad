// Bench rack for 1.5 mL microcentrifuge tubes.
// Solid block with a grid of vertical holes.
// Orientation: Rests on XY plane at Z=0, builds upward.

// Block dimensions
L     = 106;   // Length (X)
W     = 72;    // Width (Y)
H     = 30;    // Height (Z)

// Grid configuration
n_rows = 4;    // Rows along Y
n_cols = 6;    // Columns along X
pitch_x = 16;  // Centre-to-centre spacing X
pitch_y = 16;  // Centre-to-centre spacing Y

// Hole dimensions
hole_d = 11.2; // Diameter
hole_depth = 25; // Depth from top

// Derived values
floor_thickness = H - hole_depth; // 5 mm
hole_radius = hole_d / 2;

// Calculate grid positions centred on the block
// Formula: (i - (n - 1) / 2) * pitch
// We generate two lists: one for X positions (columns) and one for Y positions (rows)
x_positions = [for (i = [0 : n_cols - 1]) (i - (n_cols - 1) / 2) * pitch_x];
y_positions = [for (i = [0 : n_rows - 1]) (i - (n_rows - 1) / 2) * pitch_y];

$fn = 64;

difference() {
    // Main solid block
    translate([-L / 2, -W / 2, 0]) cube([L, W, H]);
    
    // Cut out all holes
    // The cylinder is defined from Z=0 upwards. 
    // To create a hole from the top (Z=H) down to Z=floor_thickness,
    // we place the cylinder's base at Z=floor_thickness.
    for (x = x_positions) {
        for (y = y_positions) {
            translate([x, y, floor_thickness]) cylinder(h = hole_depth, d = hole_d);
        }
    }
}