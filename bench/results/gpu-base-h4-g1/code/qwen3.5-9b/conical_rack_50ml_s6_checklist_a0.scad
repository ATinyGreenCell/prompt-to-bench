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
wall_h = 70; // Wall height (from plate top)
wall_t = 4;  // Wall thickness (Y)

// Derived positions
// Centres are calculated to be symmetric around the origin
// X positions: -60, 0, 60 (since 3 cols, spacing 40, total span 120, centred at 0)
// Y positions: -45, 45 (since 2 rows, spacing 40, total span 80, centred at 0)
// Note: The prompt says "2 rows ... of 3 ... 40 mm centre-to-centre in both directions".
// If total width is 90 and spacing is 40, the range is 80. 
// Positions: -40, 0, 40 would give 80 span. 
// However, "2 rows of 3" usually implies a grid. 
// Let's re-read: "2 rows (along Y) of 3 (along X)".
// This means 3 columns along X, 2 rows along Y.
// Spacing 40 in both directions.
// X coords: -40, 0, 40.
// Y coords: -40, 0, 40? No, that would be 3 rows.
// With 2 rows and spacing 40, the distance between row centers is 40.
// To center a 40mm span in a 90mm width: (90-40)/2 = 25mm offset from edge.
// So Y coords: -20, +20? No, spacing is 40.
// Let's assume the grid is defined by the spacing and count, then centered.
// X: 3 items, spacing 40. Range = 2 * 40 = 80. Centered in 130 -> offset 25.
//    Pos: -25-40=-65, -25, -25+40=15? No.
//    Standard centering: items at -40, 0, 40. Span 80. Center 0.
// Y: 2 items, spacing 40. Range = 1 * 40 = 40. Centered in 90 -> offset 25.
//    Pos: -20, +20. Span 40. Center 0.
// Let's verify the prompt's "40 mm centre-to-centre in both directions".
// If X spacing is 40 and Y spacing is 40.
// X positions: -40, 0, 40.
// Y positions: -20, 20. (Distance is 40).
// This fits the "2 rows of 3" description perfectly.

// Calculate specific coordinates for the loop
// X positions: -40, 0, 40
// Y positions: -20, 20

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
    // Rise from plate top (z=4) to z=70. Total height from bed = 74.
    // They are flush with the plate's long edge.
    // Plate Y range: -45 to 45.
    // Left wall: at Y = -45.
    // Right wall: at Y = 45.
    
    // Left Wall
    translate([-L/2, -W/2, 0]) cube([L, wall_t, wall_h + t]);
    
    // Right Wall
    translate([-L/2, W/2 - wall_t, 0]) cube([L, wall_t, wall_h + t]);
}

rack();