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
    
    // Define the profile points (x = radius, y = height)
    // We need to handle the "sawtooth" profile for barbs and the straight sections
    
    // Helper to get radius at a specific height
    // This is simplified logic for the profile generation
    
    // Start with the base radius (half of main bore)
    $base_r = $main_bore_d / 2;
    
    // We will construct the profile as a list of points [x, y]
    // y goes from 0 to $total_height
    
    // Section 1: Barbs (0 to 20)
    // Two barbs stacked. Each is 10mm tall.
    // Barb 1: z=0 to 10. OD: 7.5 -> 9.5 -> 7.5
    // Barb 2: z=10 to 20. OD: 7.5 -> 9.5 -> 7.5
    // Between barbs (at z=10), OD is 7.5
    
    // Section 2: Collar (20 to 25)
    // OD: 12.0 constant
    
    // Section 3: Barbs (25 to 41)
    // Two barbs stacked. Each is 8mm tall.
    // Barb 1: z=25 to 33. OD: 6.5 -> 5.0 -> 6.5
    // Barb 2: z=33 to 41. OD: 6.5 -> 5.0 -> 6.5
    // Between barbs (at z=33), OD is 6.5
    
    // Generate profile points
    $points = [];
    
    // Add base point
    $points.push([ $base_r, 0 ]);
    
    // Section 1 Logic
    // Barb 1 Bottom (z=0): r = 7.5/2 = 3.75
    // Barb 1 Top (z=10): r = 9.5/2 = 4.75
    // Barb 1 Top Step (z=10): r = 7.5/2 = 3.75
    // Barb 2 Top (z=20): r = 9.5/2 = 4.75
    // Barb 2 Top Step (z=20): r = 7.5/2 = 3.75
    
    // We need to trace the outer envelope.
    // The profile is the maximum radius at any given Z.
    
    // z=0 to 10: Linear 3.75 -> 4.75
    $r1_bot = $barb_od_bottom_1 / 2;
    $r1_top = $barb_od_top_1 / 2;
    $points.push([ $r1_bot, 0 ]);
    $points.push([ $r1_top, $barb_height_1 ]);
    $points.push([ $r1_bot, $barb_height_1 ]); // Step down
    
    // z=10 to 20: Linear 3.75 -> 4.75
    $points.push([ $r1_bot, $barb_height_1 ]);
    $points.push([ $r1_top, $barb_height_1 + $barb_height_1 ]);
    $points.push([ $r1_bot, $barb_height_1 + $barb_height_1 ]); // Step down
    
    // z=20 to 25: Collar. OD 12.0 -> r = 6.0
    $r_coll = $collar_od / 2;
    $points.push([ $r1_bot, $barb_height_1 + $barb_height_1 ]); // Connect from 3.75 to 6.0
    $points.push([ $r_coll, $barb_height_1 + $barb_height_1 ]);
    $points.push([ $r_coll, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) ]);
    
    // z=25 to 41: Barbs
    // Barb 1: z=25 to 33. OD: 6.5 -> 5.0 -> 6.5
    // Barb 2: z=33 to 41. OD: 6.5 -> 5.0 -> 6.5
    
    $r3_bot = $barb_od_bottom_3 / 2;
    $r3_top = $barb_od_top_3 / 2;
    $h3 = $barb_height_3;
    
    // Connect from collar (6.0) to barb bottom (3.25)
    $points.push([ $r_coll, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) ]);
    $points.push([ $r3_bot, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) ]);
    
    // Barb 1
    $points.push([ $r3_bot, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) ]);
    $points.push([ $r3_top, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) + $h3 ]);
    $points.push([ $r3_bot, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) + $h3 ]); // Step
    
    // Barb 2
    $points.push([ $r3_bot, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) + $h3 ]);
    $points.push([ $r3_top, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) + $h3 + $h3 ]);
    $points.push([ $r3_bot, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) + $h3 + $h3 ]); // Step
    
    // Close the loop at the top
    $points.push([ $r3_bot, $barb_height_1 + $barb_height_1 + ($z_end_2 - $z_start_2) + $h3 + $h3 ]);
    $points.push([ $base_r, 0 ]);
    
    // Create the profile polygon
    $profile = polygon(points = $points);
    
    // Extrude the profile
    linear_extrude(height = $total_height, center = false) {
        $profile;
    }
    
    // Subtract the central bore
    // The bore is a cylinder of diameter $main_bore_d through the whole height
    difference() {
        // Re-extrude the profile to ensure we have a solid to subtract from
        // (Actually, the previous block already created the solid, but we need to subtract inside it)
        // Since linear_extrude creates a solid, we can just do the subtraction here if we re-extrude or use the previous context.
        // To be safe and clean in one