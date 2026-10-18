// Hose-barb Reducer Design
// Units: millimetres
// Orientation: Standing upright along Z, resting on XY plane at z=0

// --- Dimensions ---
// Main bore diameter (constant through the part)
$main_bore_d = 3.0;

// Section 1: 8mm Tubing Barbs (z = 0 to 20)
$z_start_1 = 0;
$z_end_1 = 20;
$barb_height_1 = 10;
$barb_od_bottom_1 = 7.5;
$barb_od_top_1 = 9.5;
$barb_count_1 = 2;

// Section 2: Collar (z = 20 to 25)
$z_start_2 = 20;
$z_end_2 = 25;
$collar_od = 12.0;

// Section 3: 5mm Tubing Barbs (z = 25 to 41)
$z_start_3 = 25;
$z_end_3 = 41;
$barb_height_3 = 8;
$barb_od_bottom_3 = 6.5;
$barb_od_top_3 = 5.0;
$barb_count_3 = 2;

// --- Geometry Generation ---

// Function to generate the main body with the central bore
// We build the outer shell and subtract the bore cylinder
module main_body() {
    // Define the profile for the outer shell
    // We will use linear_extrude with a polygon defined by the varying ODs
    
    // Calculate total height
    $total_height = $z_end_3;
    
    // Define the profile points (x, z) where x is radius
    // We need to handle the "sawtooth" steps.
    // Profile logic:
    // 1. Barb 1 (z=0 to 10): OD grows 7.5 -> 9.5, then steps back to 7.5 at z=10? 
    //    Wait, the prompt says "From z=0 to z=20: two identical barbs... stacked".
    //    Usually "stacked" in a reducer means one barb on top of the other.
    //    Barb 1: z=0 to 10. Barb 2: z=10 to 20.
    //    Profile description: "OD grows linearly from 7.5 at bottom to 9.5 at top, then steps straight back to 7.5".
    //    This implies a single barb shape. If stacked, the second barb sits on the first.
    //    Does the second barb also grow? "Two identical barbs... stacked".
    //    Interpretation: 
    //    Barb 1 (z=0-10): Radius 3.75 -> 4.75. At z=10, it steps back to 3.75.
    //    Barb 2 (z=10-20): Radius 3.75 -> 4.75. At z=20, it steps back to 3.75.
    //    This creates a "stepped" look where the middle section (z=10) is narrow.
    
    // Let's refine the profile points based on "stacked identical barbs":
    // Barb 1: Bottom (z=0) R=3.75, Top (z=10) R=4.75. Step down at z=10 to R=3.75.
    // Barb 2: Bottom (z=10) R=3.75, Top (z=20) R=4.75. Step down at z=20 to R=3.75.
    
    // Collar: z=20 to 25. R=6.0.
    
    // Barb 3 (5mm): z=25 to 33 (25+8). R=3.25 -> 2.5. Step down at z=33 to R=3.25.
    // Barb 4 (5mm): z=33 to 41 (33+8). R=3.25 -> 2.5. Step down at z=41 to R=3.25.
    
    // Constructing the polygon for linear_extrude
    // Points: (radius, z)
    $pts = [
        [3.75, 0],           // Start Barb 1
        [4.75, 10],          // Top Barb 1
        [3.75, 10],          // Step down to Barb 2 base
        [4.75, 20],          // Top Barb 2
        [3.75, 20],          // Step down to Collar base
        [6.0, 20],           // Collar start
        [6.0, 25],           // Collar end
        [3.25, 25],          // Step down to Barb 3 base
        [2.5, 33],           // Top Barb 3
        [3.25, 33],          // Step down to Barb 4 base
        [2.5, 41],           // Top Barb 4
        [3.25, 41]           // Step down to end
    ];
    
    // Close the loop for the polygon (connect last point to first)
    // linear_extrude creates a closed shape if we provide the full perimeter or use hull/union.
    // Easier approach: Create the solid by extruding the profile and then unioning the steps if needed,
    // OR use a polygon that traces the full perimeter (up and down).
    
    // Let's create a polygon that goes up the outside and down the inside of the steps?
    // No, linear_extrude with a polygon creates a 2D shape extruded.
    // We need the 2D shape to be the cross-section of the object at any Z? No, that's rotate_extrude.
    // We are using linear_extrude to make the long part. The profile is in the XZ plane.
    // The profile must be a closed loop.
    
    // Profile Loop:
    // 1. Up the outside of Barb 1
    // 2. Down the inside of Barb 1 (the step)
    // 3. Up the outside of Barb 2
    // 4. Down the inside of Barb 2
    // 5. Up the outside of Collar
    // 6. Down the inside of Collar
    // 7. Up the outside of Barb 3
    // 8. Down the inside of Barb 3
    // 9. Up the outside of Barb 4
    // 10. Down the inside of Barb 4
    // 11. Close back to start.
    
    $profile_pts = [
        [3.75, 0],
        [4.75, 10],
        [3.75, 10],
        [4.75, 20],
        [3.75, 20],
        [6.0, 20],
        [6.0, 25],
        [3.25, 25],
        [2.5, 33],
        [3.25, 33],
        [2.5, 41],
        [3.25, 41],
        [3.75, 0] // Close loop
    ];
    
    // Extrude the profile
    linear_extrude(height=$total_height, center=false)
    polygon(points=$profile_pts, convexity=1);
    
    // Subtract the central bore
    difference() {
        // The main body is already created above? 
        // No, linear_extrude returns a shape. We need to subtract the hole.
        // Let's restructure: Create the solid, then difference with the hole.
    }
}

// Revised approach for clean subtraction
module build_part() {
    // Create the outer shell
    $shell = linear_extrude(height=$z_end_3, center=false)
        polygon(points=[
            [3.75, 0],
            [4.75, 10],
            [3.75, 10],
            [4.75, 20],
            [3.75, 20],
            [6.0, 20],
            [6.0, 25],
            [3.25, 25],
            [2.5, 33],
            [3.25, 33],
            [2.5, 41],
            [3.25, 41],
            [3.75, 0]