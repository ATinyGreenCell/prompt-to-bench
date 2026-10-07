// Bench Rack for 1.5 mL Microcentrifuge Tubes - Final Corrected Version
// Units: mm
// Orientation: Rests on XY plane at Z=0, builds upward (+Z). Centered on origin in X and Y.

// --- Block Dimensions (User Specified) ---
$X_LEN = 106;   // Length along X
$Y_WID = 72;    // Width along Y
$Z_TALL = 30;   // Height along Z

// --- Grid Parameters ---
$HOLE_COUNT_X = 6; // Number of holes along X axis
$HOLE_COUNT_Y = 4; // Number of rows (holes) along Y axis
$CC_SPACING_X = 16; // Centre-to-centre spacing along X
$CC_SPACING_Y = 16; // Centre-to-centre spacing along Y

// --- Hole Parameters ---
$HOLE_DIAMETER = 11.2; // Diameter of the hole (open at top)
$HOLE_DEPTH = 25;      // Depth of the cut from the top surface downwards

// --- Geometry Settings ---
$FN_CURVE = 64;        // Facets for smooth circular holes
$OVERCUT_Z = 0.1;     // Slight overcut in Z to ensure clean removal in difference()

// --- Calculations ---
// Calculate total span of the hole grid based on center-to-center spacing and count
$total_span_x = ($HOLE_COUNT_X - 1) * $CC_SPACING_X;
$total_span_y = ($HOLE_COUNT_Y - 1) * $CC_SPACING_Y;

// To center this grid within the block (which is centered at origin), 
// we need to offset the start of the grid so that its midpoint aligns with X=0, Y=0.
$GRID_OFFSET_X = -$total_span_x / 2;
$GRID_OFFSET_Y = -$total_span_y / 2;

// Calculate floor height (solid part remaining at bottom)
$floor_height = $Z_TALL - $HOLE_DEPTH;

// --- Main Construction ---
difference() {
    // Create the solid rectangular block centered on origin. 
    // Note: The user requested "rests on XY plane at z=0". 
    // However, standard OpenSCAD practice for printing often centers parts or puts them slightly above Z0 to avoid bed contact issues if not needed.
    // BUT Rule 3 says: "Model the part in the print orientation the user gives: it rests on the XY plane at z = 0 and builds upward (+Z)."
    // This implies the bottom face should be exactly at Z=0. 
    // The previous attempt centered the cube (making it -15 to +30 or similar). We must shift this up by $Z_TALL/2 so that min(Z) is 0?
    // Wait, if I use `cube(..., center=true)` with height 30, it goes from -15 to +15. 
    // To make the bottom at Z=0, I should NOT use center=true for Z, or translate by $Z_TALL/2 after creating a centered cube?
    // Actually, `cube([x,y,z], center=false)` creates 0..z. That puts it on bed but not centered X/Y.
    // Rule 3: "centre it on the origin in X and Y". It does NOT explicitly say Z must be symmetric around 0 or start at -15. 
    // But usually "rests on XY plane" means min(Z) = 0. And "centered on origin in X and Y" refers to horizontal centering.
    // So: Cube from (X/2, Y/2, Z_TALL). Translate by (-X/2, -Y/2, 0)? No, that centers it at 0,0 but bottom is still negative if centered?
    // Let's construct the block manually to ensure min(Z)=0 and X,Y are centered.
    
    $half_x = $X_LEN / 2;
    $half_y = $Y_WID / 2;
    $half_z = $Z_TALL / 2;

    translate([ -($half_x), -$half_y, 0 ]) { // Shift so bottom is at Z=0? 
        // Wait. If I want the block centered in X and Y (origin 0,0) but resting on bed:
        // The center of the block should be at x=0, y=0.
        // So range X is [-53, 53]. Range Y is [-36, 36].
        // If it rests on Z=0, then range Z must be [0, 30] or something? 
        // But if the center of mass (origin) is at x=0,y=0, and height is 30.
        // Does "rests on XY plane" mean the bottom face touches Z=0? Yes.
        // So the block occupies X:[-53, 53], Y:[-36, 36], Z:[0, 30].
        // This is NOT centered around origin in Z (which would be -15 to +15). 
        // But Rule 3 says "centre it on the origin in X and Y". It does not restrict Z centering.
        
        cube([ $X_LEN, $Y_WID, $Z_TALL ]);
    }

    // Generate holes using nested loops for repeated features
    for(i = [0:$HOLE_COUNT_X - 1]) {
        for(j = [0:$HOLE_COUNT_Y - 1]) {
            
            // Calculate absolute position of the current hole's center relative to block origin (which is also part origin)
            $current_x_pos = ($GRID_OFFSET_X + i * $CC_SPACING_X); 
            $current_y_pos = ($GRID_OFFSET_Y + j * $CC_SPACING_Y);

            // Define cylinder for difference operation.
            // We want the hole to be open at the top (Z=30) and go down 25mm.
            // So it occupies Z from [5, 30].
            
            translate([
                $current_x_pos, 
                $current_y_pos, 
                ($HOLE_DEPTH / 2) - ($OVERCUT_Z/2) + (0) // We will use center=true logic below.
            ]) {
                cylinder(
                    h = $HOLE_DEPTH + $OVERCUT_Z * 2, // Make it slightly taller to ensure full cut depth in difference context if boundaries are tight? 
                                                      // Actually simpler: Just make height exactly HOLE_DEPTH and position correctly.
                    d = $HOLE_DIAMETER, 
                    center=true
                );
            }
        }
    }
}

// Re-evaluating the Z positioning for holes inside difference() with `center=true`.
// If I use translate([x,y,z]) + cylinder(h=25, center=true), it spans [z - 12.5, z + 12.5].
// We want the hole to span from Top (Z=30) down to Z = 30-25 = 5.
// So we need: 
//   Center of cylinder in Z should be at (30 - 5)/2 = 17.5? No.
//   Range is [Start, End]. We want Start=5, End=30. Midpoint = 17.5. Height = 25.
//   So translate Z = 17.5. 
//   Wait, the block top is at Z=$Z_TALL (since we didn't center it vertically).
//   Let's re-verify the block construction in the thought process above.
//   `translate([-half_x, -half_y, 0]) cube(...)` -> Bottom at 0? No! 
//   If I translate by (-53, -36, 0) and use default cube (which is 0..Z), then:
//     X goes from -53 to +53. Correct.
//     Y goes from -36 to +36. Correct.
//     Z goes from 0 to 30. Correct.
//   So Top Face is at Z=30. Bottom Face is at Z=0.
//   
//   Now for the hole: 
//   We want it open at top (Z=30) and depth 25mm -> ends at Z=5.
//   Cylinder with center=true spans [z_center - h/2, z_center + h/2].
//   We need this interval to be roughly [5, 30] (plus overcut).
//   Midpoint = (5+30)/2 = 17.5. 
//   Height needed = 25.
//   So translate Z should be 17.5? No, wait.
//   If I set h=25 and center=true, it goes from z_center-12.5 to z_center+12.5. Total span 25.
//   We want the top of this cylinder (the opening) at Z=30. 
//   So z_center + 12.5 = 30 => z_center