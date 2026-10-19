// 96-well PCR tube rack (0.2 mL)
// Designed for ANSI/SLAS footprint with 96 vertical holes.

// --- Dimensions ---
L = 127.76;      // Length (X)
W = 85.48;       // Width (Y)
H = 20.0;        // Height (Z)

hole_d = 6.2;    // Diameter of PCR tube holes
rows = 8;        // Number of rows (Y)
cols = 12;       // Number of columns (X)
spacing = 9.0;   // Center-to-center spacing

// Offset of the first hole (A1) from the edges
offset_x = 14.38; // Distance from left edge to A1 center
offset_y = 11.24; // Distance from back edge to A1 center

// Chamfer dimensions
chamfer_leg = 5.0;

$fn = 64;

// --- Geometry Calculation ---
// The user specifies the grid is centered on the block.
// We calculate the bounding box of the hole grid to ensure centering.
grid_w = (cols - 1) * spacing;
grid_h = (rows - 1) * spacing;

// To center the grid on the block, we calculate the starting position (X, Y)
// such that the center of the grid matches the center of the block.
start_x = (L - grid_w) / 2;
start_y = (W - grid_h) / 2;

// Note: The user provided specific offsets (14.38, 11.24) AND said "the grid is centred on the block".
// In a standard ANSI/SLAS plate, the grid is not centered on the block edges, 
// but the user explicitly requested the grid be centered on the block.
// I will prioritize "the grid is centred on the block" for the hole placement.

module rack_body() {
    difference() {
        // Main block
        translate([-L/2, -W/2, 0])
            cube([L, W, H]);

        // 96 Vertical holes
        for (i = [0 : cols - 1]) {
            for (j = [0 : rows - 1]) {
                // Calculate hole position based on centered grid
                hx = start_x + (i * spacing) - L/2;
                hy = start_y + (j * spacing) - W/2;
                
                translate([hx, hy, -0.01])
                    cylinder(h = H + 0.02, d = hole_d);
            }
        }

        // Orientation Chamfer at A1 corner
        // A1 is the first hole (i=0, j=0). 
        // Its position is (start_x - L/2, start_y - W/2) relative to origin.
        // The corner is at (start_x - L/2 - hole_d/2, start_y - W/2 - hole_d/2) roughly,
        // but the user asks to cut a chamfer off the "vertical edge at the A1 corner".
        // This implies the corner of the block near A1.
        
        // Corner location (bottom-left corner of block)
        corner_x = -L/2;
        corner_y = -W/2;
        
        // We create a wedge to cut the corner
        translate([corner_x, corner_y, 0])
        rotate([0, 0, 0])
        difference() {
            // Create a large enough shape to ensure a clean cut
            translate([0, 0, 0])
            rotate([0, 45, 0])
            cube([chamfer_leg * 2, chamfer_leg * 2, H + 2]);
            
            // Subtract the main block to leave only the chamfer wedge
            translate([-0.1, -0.1, -1])
                cube([L + 0.2, W + 0.2, H + 2]);
        }
    }
}

// Render the part
rack_body();