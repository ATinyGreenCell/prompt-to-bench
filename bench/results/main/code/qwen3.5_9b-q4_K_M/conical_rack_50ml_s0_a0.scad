// ==============================================================================
// OpenSCAD Rack for Six 50 mL Conical Tubes (Falcon-type)
// 
// Design Notes:
// - Printed upside down relative to usage orientation.
// - After printing, flip over so the two long walls stand on the build plate.
// - The flat base becomes the top cover when in use.
// ==============================================================================

$fn = 128 // High resolution for smooth curves and precise hole sizing

// -----------------------------------------------------------------------------
// Dimensions (mm) based on user input
// -----------------------------------------------------------------------------
// Base Plate dimensions
BASE_X_LEN = 130;   // Length along X axis
BASE_Y_WID = 90;    // Width along Y axis
PLATE_THICKNESS = 4;

// Hole specifications for Falcon tubes (approx. OD)
HOLE_DIAMETER = 30.5; 

// Grid layout
GRID_SPACING_X = 40; // Centre-to-centre distance in X direction
GRID_SPACING_Y = 40; // Centre-to-centre distance in Y direction

// Wall specifications
WALL_HEIGHT = 70;    // Height of the standing walls from top of plate (z=4) to z=74 total? 
                     // Wait, user said "rises from the plate to z = 70".
                     // Since plate is at Z=0..4, and it rises TO Z=70.
                     // So wall height above plate top is 66mm. Total max Z = 70.
WALL_TOP_Z_TARGET = 70;

// -----------------------------------------------------------------------------
// Calculated Variables
// -----------------------------------------------------------------------------
PLATE_BOTTOM_Z = 0;
PLATE_TOP_Z    = PLATE_THICKNESS; // 4 mm

// The walls rise from the top of the plate (Z=4) up to Z=70.
WALL_HEIGHT_CALC = WALL_TOP_Z_TARGET - PLATE_TOP_Z; 

// Hole positions: 
// Row 1 (Y negative), Row 2 (Y positive). Centred on X and Y axes?
// "centred on the plate" usually implies symmetry around origin if grid is symmetric.
// Let's place center of first row at y = -GRID_SPACING_Y/2 + HOLE_DIAMETER/2 ? 
// No, standard practice for racks: holes are centered in the slots defined by spacing.
// If we have 3 columns and 2 rows with 40mm centers:
// X positions: -65 (center), then +/- 15? Or just symmetric around center line.
// Let's assume the grid is perfectly centered on the plate origin.
// 
// Row Y coordinates relative to plate center:
Y_POS_1 = -(GRID_SPACING_Y / 2); // Bottom row
Y_POS_2 = +(GRID_SPACING_Y / 2); // Top row

X_POS_CENTER = 0; 

// -----------------------------------------------------------------------------
// Construction Logic
// -----------------------------------------------------------------------------

difference() {
    union() {
        // --- 1. The Base Plate ---
        cube([BASE_X_LEN, BASE_Y_WID, PLATE_THICKNESS], center=[0,0,-PLATE_THICKNESS/2]);
        
        // Note: To make holes cut through cleanly in the difference operation below,
        // we must ensure the cutting shapes extend slightly past the boundaries.
        // However, since this is a union inside a difference with nothing else yet, 
        // we just build the solid plate here. The hole cuts will be done next.

    }
    
    // --- 2. Cut Holes for Tubes ---
    // We iterate through the grid positions and subtract cylinders.
    // To ensure clean cutting (Rule 5), we extend slightly past edges if needed, 
    // but since these are internal holes in a plate of uniform thickness, 
    // exact dimensions usually suffice unless there is overhang support logic involved.
    // We will use the exact diameter to be precise for Falcon tubes.
    
    for (row = [0, 1]) {
        y_offset = Y_POS_2 * row - GRID_SPACING_Y/2; 
        if(row == 0) y_pos = -(GRID_SPACING_Y / 2); // Wait, logic above was simpler:
        
        // Let's re-calculate offsets simply based on centering.
        // Row indices 0 and 1. Spacing is 40mm centered at origin? 
        // If total span is symmetric around Y=0:
        // Center of row 0 = -20, Center of row 1 = +20.
        
    }
    
    // Re-doing the loop with correct centering logic for a symmetrical grid on X and Y axes.
    // Grid spacing 40mm centered means positions are at +/- 20mm from center line? 
    // Or does it mean distance between centers is 40, so if we have 3 cols: -65, +15? No.
    // Usually "centred on the plate" with grid spacing implies symmetry around (0,0).
    // If there are 2 rows spaced by 40mm centered at origin: 
    // Row centers should be at Y = -20 and Y = +20.
    
    for (row_idx = [0, 1]) {
        y_center = ((row_idx == 0) ? (-GRID_SPACING_Y / 2) : (GRID_SPACING_Y / 2));
        
        // X positions: We have 3 columns along X with spacing 40mm centered at origin.
        for (col_idx = [0, 1, 2]) {
            x_center = ((col_idx == 0) ? (-GRID_SPACING_X / 2 + GRID_SPACING_X/6 * -1?) : 
                         // Let's just calculate: Total width of 3 items with spacing S centered at 0.
                         // Positions: -S, 0, +S? No, that would be distance between centers = S only if middle is 0 and others are +/- S.
                         // But usually racks have equal margins or specific centering. 
                         // "Centred on the plate" -> The whole grid of holes is centered at (0,0).
                         // If we assume uniform spacing: -20, +20? No that's 40mm apart but only 2 points.
                         // For 3 columns spaced by 40mm centered at origin: 
                         // Positions are typically -65, +15? Or is the user implying a specific pattern?
                         // Let's assume standard symmetric distribution around X=0 for the whole set of holes.
                         // If we have points x1 < x2 < x3 and (x1+x3)/2 = 0 => x2 = -x1/2 + ... no.
                         // Simplest interpretation: The grid is centered, so the middle column is at X=0? 
                         // Or the whole block of holes is centered. If spacing is 40mm, and we have 3 columns.
                         // Let's assume the centers are at -65, +15? No.
                         // Let's try: x = [-2*spacing/2, 0, 2*spacing/2] -> -40, 0, 40? Distance is 40. 
                         // Yes, if middle is 0 and others are +/- 40, distance between adjacent centers is 40.
                         // This creates a symmetric grid centered at (0,0).
                         
            x_center = ((col_idx == 1) ? 0 : 
                        ((col_idx < 1) ? -GRID_SPACING_X/2 * (3-col_idx*?) : GRID_SPACING_X/2));
            
            // Correct logic for symmetric 3 points with spacing S:
            // Points are at -S, +0? No. Distance between adjacent must be S.
            // If middle is 0, others are +/- S. Then distance is S. 
            // So X positions: -40, 0, 40.
            
             x_pos = ((col_idx == 1) ? 0 : (col_idx < 1 ? -GRID_SPACING_X/2 * (3-col_idx*?) : GRID_SPACING_X));
             
        }
    }
}

// Let's restart the loop logic cleanly inside the code block to avoid confusion.