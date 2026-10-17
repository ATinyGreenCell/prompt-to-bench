$fn = 128;

// --- Dimensions ---
// Main bore diameter (constant through the part)
BORE_DIAMETER = 3.0;

// Section 1: 8mm Tubing Barbs (z = 0 to 20)
// Two stacked barbs, 10mm each.
BARB1_HEIGHT = 10;
BARB1_BOTTOM_OD = 7.5;
BARB1_TOP_OD = 9.5;
BARB1_STEP_OD = 7.5; // Diameter after the sawtooth peak

// Section 2: Collar (z = 20 to 25)
COLLAR_HEIGHT = 5;
COLLAR_DIAMETER = 12.0;

// Section 3: 5mm Tubing Barbs (z = 25 to 41)
// Two stacked barbs, 8mm each.
BARB2_HEIGHT = 8;
BARB2_BOTTOM_OD = 6.5;
BARB2_TOP_OD = 5.0;
BARB2_STEP_OD = 6.5; // Diameter after the sawtooth peak

// --- Helper Function to Generate Profile Polygon ---
// Generates a polygon path for a specific segment of the outer shell.
// The profile is defined in the XZ plane (X is radius, Z is height).
// z_start, z_end: Absolute Z coordinates of the segment.
// r_bottom, r_top: Radii at the start and end of the segment.
// r_step: Radius at the very top of the segment (for the step-down feature).
function get_outer_profile(z_start, z_end, r_bottom, r_top, r_step) = 
    let(
        h = z_end - z_start,
        // Define points: Bottom, Top (Peak), Top (Step), Bottom (Close)
        // We use a vertical line at the top to create the step.
        p1 = [z_start, r_bottom],
        p2 = [z_end, r_top],
        p3 = [z_end, r_step],
        p4 = [z_start, r_bottom]
    )
    [p1, p2, p3, p4];

// --- Main Construction ---

difference() {
    // 1. Create the Main Body (Outer Shell)
    // We build the body in segments to handle the changing diameters and steps.
    // We use rotate_extrude to create the cylindrical shapes from the 2D profile.
    
    // Segment 1a: z=0 to 10 (Barb 1)
    // Profile: 7.5 OD -> 9.5 OD (at z=10), then step to 7.5 OD.
    poly1 = get_outer_profile(0, 10, BARB1_BOTTOM_OD/2, BARB1_TOP_OD/2, BARB1_STEP_OD/2);
    rotate_extrude() polygon(poly1);

    // Segment 1b: z=10 to 20 (Barb 2)
    // Profile: 7.5 OD -> 9.5 OD (at z=20), then step to 7.5 OD.
    poly2 = get_outer_profile(10, 20, BARB1_BOTTOM_OD/2, BARB1_TOP_OD/2, BARB1_STEP_OD/2);
    rotate_extrude() polygon(poly2);

    // Segment 2: z=20 to 25 (Collar)
    // Profile: 12.0 OD constant. No step at top (connects to next barb bottom).
    // To ensure a solid wall at the top, we step down to the same radius.
    poly3 = get_outer_profile(20, 25, COLLAR_DIAMETER/2, COLLAR_DIAMETER/2, COLLAR_DIAMETER/2);
    rotate_extrude() polygon(poly3);

    // Segment 3a: z=25 to 33 (Barb 3)
    // Profile: 6.5 OD -> 5.0 OD (at z=33), then step to 6.5 OD.
    poly4 = get_outer_profile(25, 33, BARB2_BOTTOM_OD/2, BARB2_TOP_OD/2, BARB2_STEP_OD/2);
    rotate_extrude() polygon(poly4);

    // Segment 3b: z=33 to 41 (Barb 4)
    // Profile: 6.5 OD -> 5.0 OD (at z=41), then step to 6.5 OD.
    poly5 = get_outer_profile(33, 41, BARB2_BOTTOM_OD/2, BARB2_TOP_OD/2, BARB2_STEP_OD/2);
    rotate_extrude() polygon(poly5);

    // 2. Create the Central Bore (Hole)
    // The bore is 3mm diameter, running straight through.
    // We create a cylinder with a 3mm radius hole.
    // To ensure it cuts through everything, we make it slightly taller than the part.
    bore_radius = BORE_DIAMETER / 2;
    bore_height = 50; // Taller than the part (max z=41)
    
    cylinder(h = bore_height, r = bore_radius, center = [0,0,20]);
}