// Rack for six 50 mL conical tubes.
// Print orientation: Flat plate on bed (z=0), walls rising to z=70.
// After printing, flip over so walls stand on the bed and tubes hang down.

// Plate dimensions
L     = 130; // Length (X)
W     = 90;  // Width (Y)
t     = 4;   // Plate thickness (Z)

// Hole dimensions and layout
n_rows = 2; // Rows along Y
n_cols = 3; // Columns along X
hole_d = 30.5; // Hole diameter
c_x    = 40;   // Centre-to-centre spacing X
c_y    = 40;   // Centre-to-centre spacing Y

// Wall dimensions
wall_top_z = 70; // Target Z coordinate for the top of the walls
wall_t = 4;  // Wall thickness (Y)

// Derived positions
// X positions: -40, 0, 40 (3 cols, spacing 40, centered)
// Y positions: -20, 20 (2 rows, spacing 40, centered)

$fn = 64;

module rack() {
    // 1. The Base Plate
    // Flat plate 130x90x4, centered on origin, sitting on z=0.
    translate([-L/2, -W/2, 0]) cube([L, W, t]);

    // 2. The Through-Holes
    // 6 holes, 30.5mm diameter.
    // Grid: 3 columns (X), 2 rows (Y).
    // Spacing: 40mm in both directions.
    // X coords: -40, 0, 40
    // Y coords: -20, 20
    
    for (i = [-1, 0, 1]) {
        for (j = [-1, 0]) {
            // Calculate X and Y based on loop indices
            // i: -1, 0, 1 -> X: -40, 0, 40
            // j: -1, 0   -> Y: -20, 20
            x_pos = i * 40;
            y_pos = (j + 0.5) * 40; // -0.5*40 = -20, 0.5*40 = 20
            
            translate([x_pos, y_pos, 0]) {
                cylinder(h = t + 1, d = hole_d); // Extend slightly past plate
            }
        }
    }

    // 3. The Side Walls
    // Two walls along the long edges (X axis).
    // Length 130 (X), Thickness 4 (Y).
    // Rise from plate top (z=4) to z=70. Total height from bed = 70.
    // They are flush with the plate's long edge.
    // Plate Y range: -45 to 45.
    // Left wall: at Y = -45.
    // Right wall: at Y = 45.
    
    // Left Wall
    translate([-L/2, -W/2, 0]) cube([L, wall_t, wall_top_z]);
    
    // Right Wall
    translate([-L/2, W/2 - wall_t, 0]) cube([L, wall_t, wall_top_z]);
}

rack();