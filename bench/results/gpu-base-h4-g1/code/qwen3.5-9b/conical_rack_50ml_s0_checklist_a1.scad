// Rack for six 50 mL conical tubes.
// Print orientation: Walls on bed (z=0), plate at top.
// After printing, flip over so walls are on the bed and tubes hang down.

// Plate dimensions
L     = 130; // Length (X)
W     = 90;  // Width (Y)
t     = 4;   // Plate thickness (Z)

// Tube hole dimensions
n_rows = 2; // Rows along Y
n_cols = 3; // Columns along X
hole_d = 30.5; // Hole diameter
pitch_x = 40; // Centre-to-centre spacing X
pitch_y = 40; // Centre-to-centre spacing Y

// Wall dimensions
wall_h = 70; // Wall height from plate top (total height = wall_h + t)
wall_t = 4;  // Wall thickness (Y)

// Geometry parameters
$fn = 64;

// Main body: Walls + Plate
difference() {
    union() {
        // 1. Two solid walls along the long edges (X axis), sitting on the bed (z=0)
        // Left wall (at Y = -W/2)
        translate([-L / 2, -W / 2, 0]) 
            cube([L, wall_t, wall_h]);
        
        // Right wall (at Y = +W/2)
        translate([-L / 2, W / 2 - wall_t, 0]) 
            cube([L, wall_t, wall_h]);

        // 2. The flat plate sitting on top of the walls
        translate([-L / 2, -W / 2, wall_h]) 
            cube([L, W, t]);
    }

    // Cut out the six tube holes
    // Holes go through the entire assembly (walls + plate)
    for (i = [0 : n_cols - 1]) {
        for (j = [0 : n_rows - 1]) {
            // Calculate X position: centered on plate, spaced by pitch_x
            // i=0 -> -pitch_x, i=1 -> 0, i=2 -> +pitch_x
            x_pos = (i - (n_cols - 1) / 2) * pitch_x;
            
            // Calculate Y position: centered on plate, spaced by pitch_y
            // j=0 -> -pitch_y/2, j=1 -> +pitch_y/2
            y_pos = (j - (n_rows - 1) / 2) * pitch_y;
            
            translate([x_pos, y_pos, 0]) 
                cylinder(h = wall_h + t + 1, d = hole_d); // Extend slightly past total height
        }
    }
}