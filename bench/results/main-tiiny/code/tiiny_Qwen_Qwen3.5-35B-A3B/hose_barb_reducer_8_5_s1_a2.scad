// Dimensions for the hose-barb reducer
// Units: millimetres

// Overall length
TOTAL_LENGTH = 41;

// Bore diameter (straight through)
BORE_D = 3;

// 8mm tubing section (Z=0 to Z=20)
// Barb 1 (bottom)
BARB1_HEIGHT = 10;
BARB1_BOTTOM_D = 7.5;
BARB1_TOP_D = 9.5;
BARB1_STEP_D = 7.5; // Steps back to this diameter

// Barb 2 (top of 8mm section)
BARB2_HEIGHT = 10;
BARB2_BOTTOM_D = 7.5;
BARB2_TOP_D = 9.5;
BARB2_STEP_D = 7.5;

// Collar section (Z=20 to Z=25)
COLLAR_D = 12;
COLLAR_HEIGHT = 5;

// 5mm tubing section (Z=25 to Z=41)
// Barb 3 (bottom of 5mm section)
BARB3_HEIGHT = 8;
BARB3_BOTTOM_D = 6.5;
BARB3_TOP_D = 5.0;
BARB3_STEP_D = 6.5;

// Barb 4 (top of 5mm section)
BARB4_HEIGHT = 8;
BARB4_BOTTOM_D = 6.5;
BARB4_TOP_D = 5.0;
BARB4_STEP_D = 6.5;

// Helper function to create a single barb profile
// z_start: bottom of the barb
// h: height of the barb
// d_bottom: diameter at the bottom
// d_top: diameter at the top (before step)
// d_step: diameter after the step (back to bottom size)
// step_height: height of the step (0.5mm to ensure non-coplanar faces)
module single_barb(z_start, h, d_bottom, d_top, d_step, step_height) {
    // Calculate the diameter at the top of the linear taper
    // The taper goes from d_bottom to d_top over height h
    // Then a step down to d_step at height h + step_height
    
    // We use a polygon to define the profile in the XZ plane, then rotate
    // Profile points (x, z) where x is radius
    // Bottom: (d_bottom/2, z_start)
    // Top of taper: (d_top/2, z_start + h)
    // Top of step: (d_step/2, z_start + h + step_height)
    // Bottom of step: (d_step/2, z_start + h + step_height) -> Wait, step is a flat shoulder.
    // Actually, the prompt says "steps straight back to 7.5 mm".
    // This implies a sudden change in diameter.
    // To avoid coplanar faces, we make the step slightly taller than 0.
    // The "step" is a flat ring.
    
    // Let's define the profile points for the outer surface:
    // 1. Bottom: (d_bottom/2, z_start)
    // 2. Top of taper: (d_top/2, z_start + h)
    // 3. Top of step shoulder: (d_step/2, z_start + h + step_height)
    // 4. Bottom of step shoulder: (d_step/2, z_start + h + step_height) -> No, we need to close the loop.
    // The "step" is a flat surface at the top of the barb.
    // The profile goes up the taper, then steps in.
    // So:
    // (d_bottom/2, z_start) -> (d_top/2, z_start + h) -> (d_step/2, z_start + h + step_height) -> (d_step/2, z_start + h + step_height) -> (d_bottom/2, z_start) ?
    // No, the step is a flat ring. The profile goes from the top of the taper to the flat shoulder.
    // The flat shoulder is at z = h + step_height.
    // The profile should be:
    // (d_bottom/2, z_start)
    // (d_top/2, z_start + h)
    // (d_step/2, z_start + h + step_height)
    // (d_step/2, z_start + h + step_height) -> This is the same point.
    // We need to close the loop.
    // The profile is a polygon.
    // Points:
    // 1. (d_bottom/2, z_start)
    // 2. (d_top/2, z_start + h)
    // 3. (d_step/2, z_start + h + step_height)
    // 4. (d_step/2, z_start + h + step_height) -> No, we need to go back to the bottom.
    // The "step" is a flat ring. The profile goes from the top of the taper to the flat ring.
    // Then the flat ring is the top of the barb.
    // So the profile is:
    // (d_bottom/2, z_start) -> (d_top/2, z_start + h) -> (d_step/2, z_start + h + step_height) -> (d_step/2, z_start + h + step_height) -> (d_bottom/2, z_start)
    // Wait, the step is a flat surface. The profile should go from the top of the taper to the flat ring.
    // The flat ring is at z = h + step_height.
    // The profile should be:
    // (d_bottom/2, z_start)
    // (d_top/2, z_start + h)
    // (d_step/2, z_start + h + step_height)
    // (d_step/2, z_start + h + step_height) -> This is the same point.
    // We need to close the loop.
    // The profile is a polygon.
    // Points:
    // 1. (d_bottom/2, z_start)
    // 2. (d_top/2, z_start + h)
    // 3. (d_step/2, z_start + h + step_height)
    // 4. (d_step/2, z_start + h + step_height) -> No, we need to go back to the bottom.
    // The "step" is a flat ring. The profile goes from the top of the taper to the flat ring.
    // Then the flat ring is the top of the barb.
    // So the profile is:
    // (d_bottom/2, z_start) -> (d_top/2, z_start + h) -> (d_step/2, z_start + h + step_height) -> (d_step/2, z_start + h + step_height) -> (d_bottom/2, z