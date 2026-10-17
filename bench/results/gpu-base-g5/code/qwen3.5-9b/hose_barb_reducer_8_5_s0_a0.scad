$fn = 128;

// --- Dimensions ---
// Main bore diameter (constant through the part)
$BoreDiameter = 3.0;

// Section 1: 8mm Tubing Interface (Z=0 to Z=20)
$Z_Start_Section1 = 0;
$Z_End_Section1 = 20;
$Barb_Height_Section1 = 10;
$Barb_OD_Bottom_Section1 = 7.5;
$Barb_OD_Top_Section1 = 9.5;
$Barb_OD_Step_Section1 = 7.5; // Diameter after the sawtooth step
$Collar_Diameter_Section1 = 12.0;

// Section 2: 5mm Tubing Interface (Z=25 to Z=41)
$Z_Start_Section2 = 25;
$Z_End_Section2 = 41;
$Barb_Height_Section2 = 8;
$Barb_OD_Bottom_Section2 = 6.5;
$Barb_OD_Top_Section2 = 5.0;
$Barb_OD_Step_Section2 = 6.5; // Diameter after the sawtooth step

// --- Helper Functions ---

// Function to create a single sawtooth barb profile
// Returns a list of (z, radius) points for linear_extrude
function get_barb_profile(z_start, z_end, od_bottom, od_top, od_step) = 
    [
        [z_start, od_bottom/2],
        [z_start + $Barb_Height_Section1, od_top/2],
        [z_start + $Barb_Height_Section1, od_step/2],
        [z_end, od_step/2]
    ];

// Function to create the main body profile (bore + collar)
// Returns a list of (z, radius) points
function get_body_profile(z_start, z_end, bore_r, collar_d) = 
    [
        [z_start, bore_r],
        [z_start, collar_d/2],
        [z_end, collar_d/2],
        [z_end, bore_r]
    ];

// --- Main Construction ---

difference() {
    // 1. Create the Main Body (Collar + Bore)
    // We extrude the body profile from Z=0 to Z=41
    body_profile = get_body_profile($Z_Start_Section1, $Z_End_Section2, $BoreDiameter/2, $Collar_Diameter_Section1);
    
    // Extrude body
    body = linear_extrude(height = $Z_End_Section2 - $Z_Start_Section1, center = false)
        polygon(points = body_profile);
    
    // 2. Create the Barbs (Sawtooth profiles)
    
    // Section 1 Barbs (8mm tubing)
    // Two identical barbs stacked. 
    // Total height of section is 20. Barb height is 10.
    // They are stacked, so one is at Z=0 to 10, the other at Z=10 to 20.
    // However, the prompt says "From z = 0 to z = 20: two identical barbs... stacked".
    // And "each barb is 10 mm tall".
    // This implies the first barb occupies Z=0 to 10, and the second Z=10 to 20.
    
    barb1_profile = get_barb_profile($Z_Start_Section1, $Z_Start_Section1 + $Barb_Height_Section1, $Barb_OD_Bottom_Section1, $Barb_OD_Top_Section1, $Barb_OD_Step_Section1);
    barb2_profile = get_barb_profile($Z_Start_Section1 + $Barb_Height_Section1, $Z_End_Section1, $Barb_OD_Bottom_Section1, $Barb_OD_Top_Section1, $Barb_OD_Step_Section1);
    
    // Extrude barbs
    barb1 = linear_extrude(height = $Barb_Height_Section1, center = false)
        polygon(points = barb1_profile);
    
    barb2 = linear_extrude(height = $Barb_Height_Section1, center = false)
        polygon(points = barb2_profile);
    
    // Section 2 Barbs (5mm tubing)
    // From z = 25 to z = 41. Total height = 16.
    // Barb height = 8. Two stacked.
    // First barb: Z=25 to 33. Second barb: Z=33 to 41.
    
    barb3_profile = get_barb_profile($Z_Start_Section2, $Z_Start_Section2 + $Barb_Height_Section2, $Barb_OD_Bottom_Section2, $Barb_OD_Top_Section2, $Barb_OD_Step_Section2);
    barb4_profile = get_barb_profile($Z_Start_Section2 + $Barb_Height_Section2, $Z_End_Section2, $Barb_OD_Bottom_Section2, $Barb_OD_Top_Section2, $Barb_OD_Step_Section2);
    
    barb3 = linear_extrude(height = $Barb_Height_Section2, center = false)
        polygon(points = barb3_profile);
        
    barb4 = linear_extrude(height = $Barb_Height_Section2, center = false)
        polygon(points = barb4_profile);
        
    // Combine all parts into one union to subtract cleanly
    union() {
        translate([0, 0, 0]) body;
        translate([0, 0, 0]) barb1;
        translate([0, 0, 0]) barb2;
        translate([0, 0, 0]) barb3;
        translate([0, 0, 0]) barb4;
    }
    
    // 3. Cut the Bore
    // The bore runs straight through the full length (Z=0 to Z=41)
    // Diameter = 3mm -> Radius = 1.5mm
    bore_radius = $BoreDiameter / 2;
    bore_height = $Z_End_Section2 - $Z_Start_Section1;
    
    bore = cylinder(
        h = bore_height,
        r = bore_radius,
        center = [0, 0, bore_height/2]
    );
    
    difference() {
        union() {
            body;
            barb1;
            barb2;
            barb3;
            barb4;
        }
        translate([0, 0, 0]) bore;
    }
}