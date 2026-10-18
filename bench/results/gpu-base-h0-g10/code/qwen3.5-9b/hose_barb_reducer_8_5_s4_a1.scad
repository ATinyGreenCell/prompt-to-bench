// Hose-barb Reducer Design
// Units: millimetres
// Orientation: Standing upright along Z, resting on XY plane at z=0

// --- Dimensions ---
// Main bore diameter (constant through the part)
$main_bore_d = 3.0;
$main_bore_r = $main_bore_d / 2;

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
$collar_r = $collar_od / 2;

// Section 3: 5mm Tubing Barbs (z = 25 to 41)
$z_start_3 = 25;
$z_end_3 = 41;
$barb_height_3 = 8;
$barb_od_bottom_3 = 6.5;
$barb_od_top_3 = 5.0;
$barb_count_3 = 2;

// --- Geometry Generation ---

module build_part() {
    // Define the profile points for the outer shell in the XZ plane.
    // X = Radius, Z = Height.
    // The profile traces the outer boundary and the inner "steps" to create the solid volume.
    
    // Barb 1 (z=0 to 10): R 3.75 -> 4.75. Step down to 3.75 at z=10.
    // Barb 2 (z=10 to 20): R 3.75 -> 4.75. Step down to 3.75 at z=20.
    // Collar (z=20 to 25): R 6.0.
    // Barb 3 (z=25 to 33): R 3.25 -> 2.5. Step down to 3.25 at z=33.
    // Barb 4 (z=33 to 41): R 3.25 -> 2.5. Step down to 3.25 at z=41.
    
    $profile_pts = [
        // Start at bottom of Barb 1
        [$barb_od_bottom_1 / 2, $z_start_1],
        // Top of Barb 1
        [$barb_od_top_1 / 2, $z_start_1 + $barb_height_1],
        // Step down to base of Barb 2
        [$barb_od_bottom_1 / 2, $z_start_1 + $barb_height_1],
        // Top of Barb 2
        [$barb_od_top_1 / 2, $z_end_1],
        // Step down to base of Collar
        [$barb_od_bottom_1 / 2, $z_end_1],
        // Outer edge of Collar
        [$collar_r, $z_end_1],
        [$collar_r, $z_end_2],
        // Step down to base of Barb 3
        [$barb_od_bottom_3 / 2, $z_end_2],
        // Top of Barb 3
        [$barb_od_top_3 / 2, $z_end_2 + $barb_height_3],
        // Step down to base of Barb 4
        [$barb_od_bottom_3 / 2, $z_end_2 + $barb_height_3],
        // Top of Barb 4
        [$barb_od_top_3 / 2, $z_end_3],
        // Step down to end
        [$barb_od_bottom_3 / 2, $z_end_3],
        // Close loop back to start
        [$barb_od_bottom_1 / 2, $z_start_1]
    ];
    
    // Create the outer shell using linear_extrude
    // We use a polygon that traces the full perimeter (up the outside, down the steps)
    // to ensure the volume is solid.
    linear_extrude(height=$z_end_3, center=false)
    polygon(points=$profile_pts, convexity=1);
    
    // Subtract the central bore
    difference() {
        // The main body is the result of the linear_extrude above.
        // We need to subtract a cylinder of radius $main_bore_r from z=0 to z=$z_end_3.
        // Since we are inside a difference(), we define the cutter.
        cylinder(
            h=$z_end_3,
            r=$main_bore_r,
            center=false
        );
    }
}

// Set global resolution for curved surfaces (though this part is mostly linear, 
// good practice for any potential curves or future edits)
$fn = 64;

// Build the part
build_part();