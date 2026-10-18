// Straight hose-barb reducer - joins 8mm ID tubing to 5mm ID tubing.
// Prints upright along Z, centred on origin in X and Y.
// Single continuous body with correct Z-stacking.

$fn = 128;

// --- Dimensions ---
z_start      = 0;
z_8mm_top    = 20;
z_collar_bot = 20;
z_collar_top = 25;
z_5mm_bot    = 25;
z_end        = 41;

// 8mm Barb Parameters (z=0 to 20)
// Two stacked barbs, 10mm tall each.
// Profile: OD 7.5 -> 9.5 -> 7.5 (step) -> 7.5 (close)
barb_8_bottom_od = 7.5;
barb_8_top_od    = 9.5;
barb_8_step_od   = 7.5;
barb_8_height    = 10;

// 5mm Barb Parameters (z=25 to 41)
// Two stacked barbs, 8mm tall each.
// Profile: OD 6.5 -> 5.0 -> 6.5 (step) -> 6.5 (close)
barb_5_bottom_od = 6.5;
barb_5_top_od    = 5.0;
barb_5_step_od   = 6.5;
barb_5_height    = 8;

// Common
bore_diameter = 3;
collar_diameter = 12;

// --- Main Body Construction ---
// We build the profile as a list of [radius, z] points for rotate_extrude.
// This ensures a single solid body.

// 1. 8mm Barb 1 (z=0 to 10)
// Points: [3.75, 0] -> [4.75, 10] -> [3.75, 10] -> [3.75, 0]
p1 = [
    [barb_8_bottom_od / 2, 0],
    [barb_8_top_od / 2, 10],
    [barb_8_step_od / 2, 10],
    [barb_8_bottom_od / 2, 0]
];

// 2. 8mm Barb 2 (z=10 to 20)
// Points: [3.75, 10] -> [4.75, 20] -> [3.75, 20] -> [3.75, 10]
p2 = [
    [barb_8_bottom_od / 2, 10],
    [barb_8_top_od / 2, 20],
    [barb_8_step_od / 2, 20],
    [barb_8_bottom_od / 2, 10]
];

// 3. Collar (z=20 to 25)
// Points: [6.0, 20] -> [6.0, 25] -> [6.0, 25] -> [6.0, 20]
p3 = [
    [collar_diameter / 2, 20],
    [collar_diameter / 2, 25],
    [collar_diameter / 2, 25],
    [collar_diameter / 2, 20]
];

// 4. 5mm Barb 1 (z=25 to 33)
// Points: [3.25, 25] -> [2.5, 33] -> [3.25, 33] -> [3.25, 25]
p4 = [
    [barb_5_bottom_od / 2, 25],
    [barb_5_top_od / 2, 33],
    [barb_5_step_od / 2, 33],
    [barb_5_bottom_od / 2, 25]
];

// 5. 5mm Barb 2 (z=33 to 41)
// Points: [3.25, 33] -> [2.5, 41] -> [3.25, 41] -> [3.25, 33]
p5 = [
    [barb_5_bottom_od / 2, 33],
    [barb_5_top_od / 2, 41],
    [barb_5_step_od / 2, 41],
    [barb_5_bottom_od / 2, 33]
];

// Combine all segments into one continuous profile
// Note: The last point of each segment matches the first point of the next,
// ensuring a smooth transition in the extrusion.
// We concatenate the lists: p1 + p2 + p3 + p4 + p5
// However, since p1 ends at z=0 and p2 starts at z=10, we need to ensure continuity.
// Actually, the previous logic had a gap between p1 end (z=0) and p2 start (z=10).
// Let's rebuild the profile list explicitly to ensure continuity from z=0 to z=41.

// Corrected Profile Construction:
// Segment 1: z=0 to 10 (Barb 1)
// Segment 2: z=10 to 20 (Barb 2)
// Segment 3: z=20 to 25 (Collar)
// Segment 4: z=25 to 33 (Barb 1)
// Segment 5: z=33 to 41 (Barb 2)

// We will construct the full polygon list manually to avoid list concatenation issues in OpenSCAD.
// Format: [radius, z]

full_profile = [
    // Segment 1: 8mm Barb 1 (z=0 to 10)
    [barb_8_bottom_od / 2, 0],
    [barb_8_top_od / 2, 10],
    [barb_8_step_od / 2, 10],
    [barb_8_bottom_od / 2, 10], // Connect to next segment
    
    // Segment 2: 8mm Barb 2 (z=10 to 20)
    [barb_8_top_od / 2, 20],
    [barb_8_step_od / 2, 20],
    [barb_8_bottom_od / 2, 20], // Connect to next segment
    
    // Segment 3: Collar (z=20 to 25)
    [collar_diameter / 2, 25],
    [collar_diameter / 2, 25],
    [collar_diameter / 2, 25], // Connect to next segment
    
    // Segment 4: 5mm Barb 1 (z=25 to 33)
    [barb_5_bottom_od / 2, 33],
    [barb_5_top_od / 2, 33],
    [barb_5_step_od / 2, 33],
    [barb_5_bottom_od / 2, 33], // Connect to next segment
    
    // Segment 5: 5mm Barb 2 (z=33 to 41)
    [barb_5_top_od / 2, 41],
    [barb_5_step_od / 2, 41],
    [barb_5_bottom_od / 2, 41],
    [barb_5_bottom_od / 2, 41] // Close the loop
];

difference() {
    // Create the main body by rotating the profile
    rotate_extrude() polygon(full_profile);
    
    // Cut the bore through the entire length
    // Extend slightly past ends to ensure clean cut
    translate([0, 0, z_start - 1]) cylinder(h = (z_end - z_start) + 2, d = bore_diameter);
}