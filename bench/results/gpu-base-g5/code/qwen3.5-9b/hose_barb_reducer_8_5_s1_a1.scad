// Hose-barb Reducer: 8mm ID to 5mm ID
// Orientation: Standing upright on XY plane (Z axis up)
// Centered at origin in X and Y

// --- Dimensions ---
// Main bore diameter (constant through part)
$main_bore_d = 3.0;

// Upper Section (z=0 to z=20): 8mm tubing connection
$upper_start_z = 0;
$upper_end_z = 20;
$upper_barb_height = 10;
$upper_barb_count = 2;
$upper_barb_bottom_od = 7.5;
$upper_barb_top_od = 9.5;
$upper_collar_od = 12;
$upper_collar_height = 5; // 20 to 25

// Lower Section (z=25 to z=41): 5mm tubing connection
$lower_start_z = 25;
$lower_end_z = 41;
$lower_barb_height = 8;
$lower_barb_count = 2;
$lower_barb_bottom_od = 6.5;
$lower_barb_top_od = 5.0;

// --- Main Part Construction ---

difference() {
    union() {
        // 1. Upper Section (0 to 20)
        // Base cylinder for the upper section (from 0 to 20)
        cylinder(
            h = $upper_end_z,
            r = $upper_collar_od / 2,
            $fn = 64
        );
        
        // Add Upper Barbs
        for (i = [0 : $upper_barb_count - 1]) {
            translate([0, 0, $upper_start_z + i * $upper_barb_height]) {
                // Create a single barb profile
                difference() {
                    // Tapered section (bottom half of barb)
                    cylinder(
                        h = $upper_barb_height / 2,
                        r1 = $upper_barb_bottom_od / 2,
                        r2 = $upper_barb_top_od / 2,
                        $fn = 64
                    );
                    // Step section (top half of barb)
                    cylinder(
                        h = $upper_barb_height / 2,
                        r = $upper_barb_bottom_od / 2,
                        $fn = 64
                    );
                    // Cut out the main bore
                    cylinder(
                        h = $upper_barb_height,
                        r = $main_bore_d / 2 + 0.01, 
                        $fn = 64
                    );
                }
            }
        }

        // 2. Collar Section (20 to 25)
        cylinder(
            h = $upper_collar_height,
            r = $upper_collar_od / 2,
            $fn = 64
        );

        // 3. Lower Section (25 to 41)
        // Base cylinder for the lower section (from 25 to 41)
        cylinder(
            h = $lower_end_z - $lower_start_z,
            r = $lower_barb_bottom_od / 2, // Max OD of lower barbs
            $fn = 64
        );

        // Add Lower Barbs
        for (i = [0 : $lower_barb_count - 1]) {
            translate([0, 0, $lower_start_z + i * $lower_barb_height]) {
                // Create a single barb profile
                difference() {
                    // Tapered section (bottom half of barb)
                    cylinder(
                        h = $lower_barb_height / 2,
                        r1 = $lower_barb_bottom_od / 2,
                        r2 = $lower_barb_top_od / 2,
                        $fn = 64
                    );
                    // Step section (top half of barb)
                    cylinder(
                        h = $lower_barb_height / 2,
                        r = $lower_barb_bottom_od / 2,
                        $fn = 64
                    );
                    // Cut out the main bore
                    cylinder(
                        h = $lower_barb_height,
                        r = $main_bore_d / 2 + 0.01, 
                        $fn = 64
                    );
                }
            }
        }
    },
    
    // Cut the main bore through the entire length
    cylinder(
        h = $lower_end_z,
        r = $main_bore_d / 2 + 0.01, // Slight overcut
        $fn = 64
    )
}