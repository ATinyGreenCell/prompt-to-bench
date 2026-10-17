// Hose-barb reducer: 8mm ID to 5mm ID
// Orientation: Standing upright along Z, resting on XY plane at z=0.
// Centered on origin in X and Y.

$fn = 128; // High resolution for smooth curves and accurate hole sizes

// --- Dimensions ---
// Main bore
$BoreID = 3.0;

// Upper Section (z=0 to z=20): 8mm tubing connection
$UpperStartZ = 0;
$UpperEndZ = 20;
$BarbCountUpper = 2;
$BarbHeightUpper = 10;
$BarbBaseODUpper = 7.5;
$BarbTipODUpper = 9.5;
$BarbStepODUpper = 7.5; // Diameter after the sawtooth tip

// Collar Section (z=20 to z=25)
$CollarStartZ = 20;
$CollarEndZ = 25;
$CollarOD = 12.0;

// Lower Section (z=25 to z=41): 5mm tubing connection
$LowerStartZ = 25;
$LowerEndZ = 41;
$BarbCountLower = 2;
$BarbHeightLower = 8;
$BarbBaseODLower = 6.5;
$BarbTipODLower = 5.0;
$BarbStepODLower = 6.5; // Diameter after the sawtooth tip

// --- Helper Functions ---

// Function to create a single sawtooth barb profile using linear_extrude
// z_start: bottom of the barb
// z_end: top of the barb
// base_od: diameter at z_start
// tip_od: diameter at the peak of the sawtooth
// step_od: diameter at the bottom of the next step (z_end)
// angle: rotation angle of this specific barb
module create_sawtooth_barb(z_start, z_end, base_od, tip_od, step_od, angle) {
    $h_total = z_end - z_start;
    $h_quarter = $h_total / 4;
    
    // Define the profile points (radius, z)
    // Segment 1: Flat base from z_start to z_start + h_quarter
    // Segment 2: Linear growth to tip_od at z_start + h_half
    // Segment 3: Linear shrink to step_od at z_start + 3/4 h_total
    // Segment 4: Flat step from z_start + 3/4 h_total to z_end
    
    $r_start = base_od / 2;
    $r_tip = tip_od / 2;
    $r_step = step_od / 2;
    
    $pts = [
        [$r_start, z_start],
        [$r_start, z_start + $h_quarter],
        [$r_tip, z_start + $h_quarter * 2], // Peak
        [$r_step, z_start + $h_quarter * 3], // End of slope
        [$r_step, z_end]
    ];
    
    // Create the profile polygon
    $profile = polygon(points = $pts, close = true);
    
    // Extrude the profile
    translate([0, 0, z_start]) {
        rotate([0, 0, angle]) {
            linear_extrude(height = $h_total, center = true) {
                $profile;
            }
        }
    }
}

// Function to create the main body (bore + collar)
module create_main_body() {
    // Main bore cylinder
    translate([0, 0, $UpperStartZ]) {
        cylinder(h = $LowerEndZ - $UpperStartZ, r = $BoreID / 2 + 0.01, $fn = 32);
    }
    
    // Collar cylinder
    translate([0, 0, $CollarStartZ]) {
        cylinder(h = $CollarEndZ - $CollarStartZ, r = $CollarOD / 2 + 0.01, $fn = 32);
    }
}

// --- Main Assembly ---

difference() {
    // 1. Create the main body (bore and collar)
    create_main_body();
    
    // 2. Cut out the Upper Barbs (8mm tubing)
    // Stacked: one at z=0, one at z=10
    $angle_step_upper = 2 * PI / $BarbCountUpper;
    for (i = [0 : $BarbCountUpper - 1]) {
        $angle = i * $angle_step_upper;
        $z_start = $UpperStartZ + (i * $BarbHeightUpper);
        $z_end = $z_start + $BarbHeightUpper;
        
        create_sawtooth_barb($z_start, $z_end, $BarbBaseODUpper, $BarbTipODUpper, $BarbStepODUpper, $angle);
    }
    
    // 3. Cut out the Lower Barbs (5mm tubing)
    // Stacked: one at z=25, one at z=33
    $angle_step_lower = 2 * PI / $BarbCountLower;
    for (i = [0 : $BarbCountLower - 1]) {
        $angle = i * $angle_step_lower;
        $z_start = $LowerStartZ + (i * $BarbHeightLower);
        $z_end = $z_start + $BarbHeightLower;
        
        create_sawtooth_barb($z_start, $z_end, $BarbBaseODLower, $BarbTipODLower, $BarbStepODLower, $angle);
    }
}