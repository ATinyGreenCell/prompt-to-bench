// Dimensions for the sowing template
D_DISC = 85;          // Diameter of the main disc (mm)
T_DISC = 2;           // Thickness of the disc (mm)
D_HOLE = 3;           // Diameter of the through-holes (mm)
P_HOLE = 9;           // Pitch (center-to-center spacing) of the hole grid (mm)
N_HOLE = 7;           // Number of holes per row/column (7x7 grid)
W_NOTCH = 10;         // Width of the orientation notch (mm)
D_NOTCH = 4;          // Depth of the orientation notch (mm)
R_DISC = D_DISC / 2;  // Radius of the disc (mm)

// Calculate grid bounds
// Grid is centered at origin. Total width = (N-1)*P.
// Extent from center = (N-1)*P / 2.
GRID_EXTENT = (N_HOLE - 1) * P_HOLE / 2;

// Main body: Disc
module sowing_template() {
    // Main disc
    difference() {
        // The main disc
        cylinder(h = T_DISC, r = R_DISC, $fn = 64);
        
        // Cut out the holes
        for (i := [0:N_HOLE-1]) {
            for (j := [0:N_HOLE-1]) {
                // Calculate center of each hole
                // Center of grid is at (0,0).
                // i=0 is left, i=6 is right.
                // x = (i - (N-1)/2) * P
                // y = (j - (N-1)/2) * P
                x_pos = (i - (N_HOLE - 1) / 2) * P_HOLE;
                y_pos = (j - (N_HOLE - 1) / 2) * P_HOLE;
                
                translate([x_pos, y_pos, 0]) {
                    cylinder(h = T_DISC + 0.01, r = D_HOLE / 2, $fn = 64);
                }
            }
        }
        
        // Cut out the orientation notch
        // Notch is on +Y side, centered on Y axis (X=0).
        // Width 10mm (X), Depth 4mm (Y).
        // Notch extends from Y = R_DISC - D_NOTCH to Y = R_DISC.
        // We cut a rectangle that extends slightly past the rim to ensure clean cut.
        notch_depth = D_NOTCH + 0.01;
        notch_width = W_NOTCH + 0.01;
        
        // Position the notch cutter:
        // Centered at X=0.
        // Y position: The notch goes from the rim inward.
        // Rim is at Y = R_DISC. Notch depth is D_NOTCH.
        // So the cutout box should go from Y = R_DISC - D_NOTCH to Y = R_DISC + 0.01 (to be safe).
        // Actually, to cut "in from the rim", we define the box starting at the rim and going in.
        // Let's define the box center.
        // Box Y range: [R_DISC - D_NOTCH, R_DISC + 0.01]
        // Box X range: [-W_NOTCH/2, W_NOTCH/2]
        // Box Z range: [0, T_DISC + 0.01]
        
        // Calculate the center of the notch box
        notch_center_y = R_DISC - D_NOTCH / 2 - 0.005;
        
        translate([0, notch_center_y, 0]) {
            cube([notch_width, notch_depth + 0.01, T_DISC + 0.01], center = true);
        }
    }
}

sowing_template();