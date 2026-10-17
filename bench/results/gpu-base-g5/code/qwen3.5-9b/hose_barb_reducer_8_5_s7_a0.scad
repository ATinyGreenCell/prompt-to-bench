// Hose-Barb Reducer Design
// Units: mm
// Orientation: Standing upright on XY plane (Z axis up)

// --- Dimensions ---
// Main bore diameter (constant through the part)
$main_bore_d = 3.0;

// Upper Section (8mm tubing)
$z_start_upper = 0;
$z_end_upper = 20;
$barb_count_upper = 2;
$barb_height_upper = 10;
$barb_od_bottom_upper = 7.5;
$barb_od_top_upper = 9.5;
$barb_od_step_upper = 7.5; // Step down to this OD after the taper

// Collar Section
$z_start_collar = 20;
$z_end_collar = 25;
$collar_od = 12.0;

// Lower Section (5mm tubing)
$z_start_lower = 25;
$z_end_lower = 41;
$barb_count_lower = 2;
$barb_height_lower = 8;
$barb_od_bottom_lower = 6.5;
$barb_od_top_lower = 5.0;
$barb_od_step_lower = 6.5; // Step out to this OD after the taper

// --- Helper Functions ---

// Function to create a stepped tapered barb
// z_start, z_end: vertical range
// od_bottom, od_top: outer diameter at bottom and top of the tapered section
// od_step: outer diameter of the flat section below the taper
// count: number of barbs to stack
// direction: "up" (taper grows) or "down" (taper shrinks)
function create_barb_stack(z_start, z_end, od_bottom, od_top, od_step, count, direction) = 
    for (i = [0 : count-1]) {
        translate([0, 0, z_start + (i * ($barb_height_upper + $barb_height_lower))]) {
            // Calculate the specific height range for this barb
            // Note: The prompt implies a specific geometry where barbs are stacked.
            // We assume they are stacked directly on top of each other or with minimal gap.
            // Given "stacked", we place them sequentially.
            
            // Let's refine the Z positioning based on the prompt's specific segments.
            // The prompt describes the geometry in Z segments.
            // Upper: 0-20 (2 barbs, 10mm each). 
            // Lower: 25-41 (2 barbs, 8mm each).
            // There is a gap between 20 and 25 (the collar).
            
            // We will generate the geometry based on the absolute Z coordinates defined in the prompt.
            // Upper Barbs are in 0-20.
            // Lower Barbs are in 25-41.
            
            // Since we are inside a loop for count, we need to calculate the specific Z offset for this instance.
            // However, the prompt defines the Z ranges globally.
            // Let's restructure the logic to match the Z ranges exactly.
            
            // We will handle the specific Z ranges in the main block to ensure precision.
            // This function is a placeholder for the logic that will be implemented in the main block.
        }
    }

// --- Main Geometry Construction ---

// Set resolution for curved surfaces
$fn = 64;

// 1. Main Body (The central bore and the collar)
// The main body is a cylinder with a hole.
// It spans from z=0 to z=41.
// However, the outer diameter changes.
// We will build the solid parts and subtract the bore.

// Part A: Upper Barbs (0 to 20)
// Two barbs stacked. 
// Barb 1: z=0 to 10. Taper 7.5 -> 9.5. Step 9.5 -> 7.5.
// Barb 2: z=10 to 20. Taper 7.5 -> 9.5. Step 9.5 -> 7.5.
// Wait, the prompt says "From z = 0 to z = 20: two identical barbs... stacked".
// And "each barb is 10 mm tall".
// So Barb 1 is 0-10, Barb 2 is 10-20.
// Profile: Bottom (z=0) OD=7.5. Top of Barb 1 (z=10) OD=9.5.
// Then "steps straight back to 7.5". This happens at z=10.
// Barb 2 starts at z=10. Bottom OD=7.5. Top (z=20) OD=9.5.
// Steps back to 7.5 at z=20.

// Part B: Collar (20 to 25)
// Cylinder OD=12.

// Part C: Lower Barbs (25 to 41)
// Two barbs stacked.
// Barb 1: z=25 to 33. Taper 6.5 -> 5.0. Step 5.0 -> 6.5.
// Barb 2: z=33 to 41. Taper 6.5 -> 5.0. Step 5.0 -> 6.5.

// We will construct the solid by unioning these sections, then subtracting the bore.

// Define the upper barbs
upper_barb_1 = 
    linear_extrude(height=10, center=true)
    circle(d=$barb_od_bottom_upper); // Base
    // Actually, we need the profile.
    // Let's use polygon for the cross section.
    // Points: (0,0), (r_bottom, 0), (r_top, h), (r_step, h), (r_step, 0) -> close loop?
    // No, the profile is:
    // z=0, r=3.75
    // z=10, r=4.75
    // z=10, r=3.75 (step)
    // z=0, r=3.75
    // This creates a shape that is wider at the top of the taper, then steps down.
    
    // Let's define the profile points for Upper Barb 1 (z=0 to 10)
    // Radius at z=0: 3.75
    // Radius at z=10: 4.75
    // Radius at z=10 (step): 3.75
    // This implies the step is at the very top.
    
    // Polygon points (x, y) where y is radius, x is z? No, linear_extrude extrudes along Z.
    // So we define (x, y) where x is Z, y is Radius.
    // Start (0, 3.75)
    // End (10, 4.75)
    // Step (10, 3.75)
    // Close (0, 3.75)
    
    polygon(points=[
        [0, $barb_od_bottom_upper/2],
        [$barb_height_upper, $barb_od_top_upper/2],
        [$barb_height_upper, $barb_od_step_upper/2],
        [0, $barb_od_bottom_upper/2]
    ]);

upper_barb_2 = 
    translate([0, 0, $barb_height_upper])
    linear_extrude(height=$barb_height_upper, center=true)
    polygon(points=[
        [0, $barb_od_bottom_upper/2],
        [$barb_height_upper, $barb_od_top_upper/2],
        [$barb_height_upper, $barb_od_step_upper/2],
        [0, $barb_od_bottom_upper/2]
    ]);

// Define the collar
collar = 
    translate([0, 0, $z_end_upper])
    cylinder(h=$z_end_collar - $z_start_collar, d=$collar_od, center=true);

// Define the lower barbs
// Barb 1: z=25 to 33. Taper 6.5 -> 5.0. Step 5.0 -> 6.5.
// Radius bottom: 3.25. Radius top: 2.5. Step: 3.25.
lower_barb_1 = 
    translate([0, 0, $z_start_lower])
    linear_extrude(height=$barb_height_lower, center=true)
    polygon(points=[
        [0, $barb_od_bottom_lower/2],
        [$barb_height_lower, $barb_od_top_lower/2],
        [$barb_height_lower, $barb_od_step_lower/2],
        [0, $barb_od_bottom_lower/2]
    ]);

lower_barb_2 = 
    translate([0, 0, $z_start_lower + $barb_height_lower])