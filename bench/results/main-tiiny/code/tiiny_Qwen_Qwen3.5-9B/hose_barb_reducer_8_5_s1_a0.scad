// Hose-Barb Reducer: 8mm ID to 5mm ID
// Print Orientation: Standing upright along Z, resting on XY plane at z=0.
// Centered on origin in X and Y.

$fn = 128; // High resolution for smooth curves and accurate hole sizing

// --- Dimensions ---
// Main bore
$main_bore_d = 3.0;

// Upper Section (8mm tubing)
$upper_section_start_z = 0;
$upper_section_end_z = 20;
$upper_barb_count = 2;
$upper_barb_height = 10;
$upper_barb_bottom_od = 7.5;
$upper_barb_top_od = 9.5;
$upper_barb_step_back = 7.5; // Diameter after the sawtooth peak
$upper_barb_spacing = 12;   // Center-to-center distance between barbs

// Collar Section
$collar_start_z = 20;
$collar_end_z = 25;
$collar_diameter = 12;

// Lower Section (5mm tubing)
$lower_section_start_z = 25;
$lower_section_end_z = 41;
$lower_barb_height = 8;
$lower_barb_bottom_od = 6.5;
$lower_barb_top_od = 5.0;
$lower_barb_step_back = 6.5;
$lower_barb_spacing = 12;   // Center-to-center distance between barbs

// --- Helper Function: Sawtooth Barb ---
// Creates a barb with a linear taper, a peak, and a step back.
// Uses linear_extrude with a polygon defined by the profile.
module sawtooth_barb(z_start, z_end, bottom_od, top_od, step_back_od, spacing) {
    // Calculate the height of the barb
    $h = z_end - z_start;
    
    // Define the profile points for the cross-section (radius vs height)
    // We need to extrude a shape that creates the outer wall.
    // The profile will be a list of [radius, height] points.
    // Start at bottom_od/2, go to top_od/2, then step back to step_back_od/2.
    
    $r_bottom = bottom_od / 2;
    $r_top = top_od / 2;
    $r_step = step_back_od / 2;
    
    // Profile points: (radius, z_offset)
    // 1. Bottom flat
    // 2. Taper up to top
    // 3. Step down to step_back
    // 4. Flat at step_back
    
    $profile = [
        [$r_bottom, 0],
        [$r_top, $h],
        [$r_step, $h],
        [$r_step, $h], // Duplicate last point to close loop for extrusion if needed, 
                       // but linear_extrude usually handles open profiles if we define the path correctly.
                       // Actually, for a solid extrusion, we need a closed loop or a specific path.
                       // Let's define the path as a closed loop: Bottom -> Top -> Step -> Bottom.
    ];
    
    // Re-defining as a closed loop for linear_extrude to ensure solid volume
    $path = [
        [$r_bottom, 0],
        [$r_top, $h],
        [$r_step, $h],
        [$r_step, 0],
        [$r_bottom, 0]
    ];
    
    // Create the 2D profile
    $p = polygon($path);
    
    // Extrude
    linear_extrude(height=$h, center=true) {
        rotate_extrude(center=true) {
            translate([0, 0, 0]) $p;
        }
    }
    
    // Position the barb
    translate([0, 0, z_start]) {
        // We need to place the barbs at specific Y coordinates.
        // Since the module is called inside a loop, we pass the Y offset.
        // However, the module above creates the whole object. 
        // Let's refactor: The module should just create the geometry, and we translate it.
        // But the geometry above is rotationally symmetric. We can just translate it.
        
        // Wait, the logic above creates the whole barb. 
        // We need to place it at the correct Y.
        // Let's adjust the module to accept a Y offset or handle it in the loop.
        // To keep the module clean, let's assume the module creates the shape centered at (0,0,z_start)
        // and we translate it.
        
        // Actually, the linear_extrude + rotate_extrude creates a cylinder-like object centered at (0,0,z_start).
        // We need to move it to the correct Y.
        
        // Let's restructure: The module creates the shape. We translate it.
        // But the shape is defined relative to (0,0).
        // So we translate the whole result.
        
        // Correction: The linear_extrude + rotate_extrude block above creates the object.
        // We need to translate it to the correct Y position.
        // Let's modify the call site to handle Y.
    }
}

// --- Main Assembly ---
difference() {
    // 1. Create the Main Body (Hollow Cylinder)
    // Outer diameter is determined by the largest feature (Upper Barb Top OD = 9.5mm)
    // But wait, the upper barbs have a step back to 7.5mm. The top is 9.5mm.
    // The lower barbs have a step back to 6.5mm. The bottom is 6.5mm.
    // The collar is 12mm.
    // So the max outer diameter is the collar (12mm).
    
    $max_od = $collar_diameter;
    $main_body_od = $max_od;
    $main_body_id = $main_bore_d;
    
    // Create the main hollow cylinder
    // We need to ensure the bore is clean.
    cylinder(h=41, r=$main_body_od/2, $fn=128);
    
    // Cut the main bore
    cylinder(h=41, r=$main_bore_d/2, $fn=128);
    
    // 2. Create the Upper Barbs (8mm tubing)
    // These are added to the body.
    // We need to place them at Y = +/- spacing/2.
    $y_offset = $upper_barb_spacing / 2;
    
    for (i = [-1, 1]) {
        translate([0, i * $y_offset, 0]) {
            // The barb geometry:
            // z: 0 to 20
            // Profile: 7.5 -> 9.5 -> 7.5
            
            // We need to create the solid shape of the barb.
            // Using linear_extrude + rotate_extrude.
            
            $h = $upper_barb_height;
            $r_bottom = $upper_barb_bottom_od / 2;
            $r_top = $upper_barb_top_od / 2;
            $r_step = $upper_barb_step_back / 2;
            
            // Define the 2D profile path
            $path = [
                [$r_bottom, 0],
                [$r_top, $h],
                [$r_step, $h],
                [$r_step, 0],
                [$r_bottom, 0]
            ];
            
            $p = polygon($path);
            
            linear_extrude(height=$h, center=true) {
                rotate_extrude(center=true) {
                    $p;
                }
            }
        }
    }
    
    // 3. Create the Collar (z=20 to z=25)
    // Diameter 12mm.
    // This is already covered by the main body cylinder if we made it 12mm.
    // But we need to ensure the transition is smooth or sharp as described.
    // The description says "cylindrical collar".
    // Since the main body is 12mm, this is just part of the main body.
    // No extra subtraction needed unless there's a specific feature.
    
    // 4. Create the Lower Barbs (5mm tubing)
    // z: 25 to 41
    // Profile: 6.5 -> 5.0 -> 6.5
    
    $y_offset_lower = $lower_barb_spacing / 2;
    
    for (i = [-1, 1]) {
        translate([0, i * $y_offset_lower, 0]) {
            $h = $lower_barb_height;
            $r_bottom = $lower_barb_bottom_od / 2;
            $r_top = $lower_barb_top_od / 2;
            $r_step = $lower_barb_step_back / 2;
            
            $path = [