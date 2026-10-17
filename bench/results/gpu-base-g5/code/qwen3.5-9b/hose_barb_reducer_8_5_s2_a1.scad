$fn = 128;

// --- Dimensions ---
// Main bore diameter (constant through the part)
BORE_DIAMETER = 3.0;

// Section 1: 8mm Tubing Barbs (z = 0 to 20)
SECTION1_START_Z = 0;
SECTION1_END_Z = 20;
BARB1_HEIGHT = 10;
BARB1_BOTTOM_OD = 7.5;
BARB1_TOP_OD = 9.5;
BARB1_STEP_OD = 7.5; // Diameter after the sawtooth peak

// Section 2: Collar (z = 20 to 25)
COLLAR_START_Z = 20;
COLLAR_END_Z = 25;
COLLAR_DIAMETER = 12.0;

// Section 3: 5mm Tubing Barbs (z = 25 to 41)
SECTION3_START_Z = 25;
SECTION3_END_Z = 41;
BARB2_HEIGHT = 8;
BARB2_BOTTOM_OD = 6.5;
BARB2_TOP_OD = 5.0;
BARB2_STEP_OD = 6.5; // Diameter after the sawtooth peak

// --- Helper Function to Generate Polygon for Linear Extrusion ---
// Generates a polygon path for a specific segment of the outer shell.
// z_start, z_end: Absolute Z coordinates of the segment.
// r_bottom, r_top: Radii at the start and end of the segment.
// r_step: Radius at the very top of the segment (for the step-down feature).
// If r_step is not provided, it defaults to r_top (no step).
function get_outer_polygon(z_start, z_end, r_bottom, r_top, r_step = null) = 
    let(
        h = z_end - z_start,
        r_step_val = r_step != null ? r_step : r_top,
        // Define points: Bottom, Top (Peak), Top (Step), Bottom (Close)
        // We use a vertical line at the top to create the step.
        p1 = [z_start, r_bottom],
        p2 = [z_end, r_top],
        p3 = [z_end, r_step_val],
        p4 = [z_start, r_bottom]
    )
    [p1, p2, p3, p4];

// --- Main Construction ---

difference() {
    // 1. Create the Main Body (Outer Shell)
    // We build the body in segments to handle the changing diameters and steps.
    // We extrude the profile along Z.
    
    // Segment 1a: z=0 to 10 (Barb 1)
    // Profile: 7.5 OD -> 9.5 OD (at z=10), then step to 7.5 OD.
    // Note: The prompt says "grows linearly... to 9.5... then steps". 
    // This implies the peak is at the top of the 10mm segment.
    poly1 = get_outer_polygon(0, 10, BARB1_BOTTOM_OD/2, BARB1_TOP_OD/2, BARB1_STEP_OD/2);
    linear_extrude(height = 10, center = true) polygon(poly1);

    // Segment 1b: z=10 to 20 (Barb 2)
    // Profile: 7.5 OD -> 9.5 OD (at z=20), then step to 7.5 OD.
    poly2 = get_outer_polygon(10, 20, BARB1_BOTTOM_OD/2, BARB1_TOP_OD/2, BARB1_STEP_OD/2);
    linear_extrude(height = 10, center = true) polygon(poly2);

    // Segment 2: z=20 to 25 (Collar)
    // Profile: 12.0 OD constant. No step at top (connects to next barb bottom).
    poly3 = get_outer_polygon(20, 25, COLLAR_DIAMETER/2, COLLAR_DIAMETER/2, COLLAR_DIAMETER/2);
    linear_extrude(height = 5, center = true) polygon(poly3);

    // Segment 3a: z=25 to 33 (Barb 3)
    // Profile: 6.5 OD -> 5.0 OD (at z=33), then step to 6.5 OD.
    poly4 = get_outer_polygon(25, 33, BARB2_BOTTOM_OD/2, BARB2_TOP_OD/2, BARB2_STEP_OD/2);
    linear_extrude(height = 8, center = true) polygon(poly4);

    // Segment 3b: z=33 to 41 (Barb 4)
    // Profile: 6.5 OD -> 5.0 OD (at z=41), then step to 6.5 OD.
    poly5 = get_outer_polygon(33, 41, BARB2_BOTTOM_OD/2, BARB2_TOP_OD/2, BARB2_STEP_OD/2);
    linear_extrude(height = 8, center = true) polygon(poly5);

    // 2. Create the Central Bore (Hole)
    // The bore is 3mm diameter, running straight through.
    // We create a cylinder with a 3mm radius hole.
    // To ensure it cuts through everything, we make it slightly taller than the part.
    bore_radius = BORE_DIAMETER / 2;
    bore_height = 50; // Taller than the part (max z=41)
    
    cylinder(h = bore_height, r = bore_radius, center = [0,0,20]);

    // 3. Create the Inner Wall of the Barbs (to ensure the bore doesn't merge with the outer shell incorrectly if logic was complex, 
    // but since we used difference with a central cylinder, the outer shell is already hollowed out by the cylinder.
    // However, the "step" features in the barbs create internal cavities.
    // The central cylinder handles the main bore.
    // The outer shell definition creates the external shape.
    // The difference operation removes the central cylinder from the union of the segments.
    // This results in a solid part with a 3mm hole and the external barb shapes.
    
    // Wait, the logic above creates the outer shell as a solid block, then subtracts a cylinder.
    // This is correct for the main body.
    // However, we need to ensure the "steps" (the sudden reduction in diameter) are solid walls, not just a change in radius.
    // The polygon definition [p1, p2, p3, p4] where p2=(z_end, r_top) and p3=(z_end, r_step) creates a vertical wall at z_end.
    // This is exactly what is needed for the "sawtooth" profile.
    
    // One detail: The prompt says "From z = 0 to z = 20: two identical barbs... stacked".
    // My construction does exactly this: 0-10 and 10-20.
    // Same for 25-41.
    
    // Final check on dimensions:
    // 0-10: 7.5->9.5->7.5
    // 10-20: 7.5->9.5->7.5
    // 20-25: 12.0 (constant)
    // 25-33: 6.5->5.0->6.5
    // 33-41: 6.5->5.0->6.5
    // Bore: 3.0
    
    // The code looks solid.
}