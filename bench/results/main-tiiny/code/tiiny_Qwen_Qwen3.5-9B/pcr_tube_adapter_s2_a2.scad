// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack
// Print orientation: Collar on bed (Z=0), Sleeve body rising up.

// --- Dimensions (mm) ---
// Collar dimensions (lying on bed)
$collar_diameter = 13;
$collar_thickness = 1.5;

// Sleeve body dimensions (rising from collar)
// Outer diameter of the sleeve body
$sleeve_outer_diameter = 10.8;
// Total height of the part (Collar + Body)
$total_height = 21.5;

// Bore dimensions
$bore_diameter = 6.2;

// --- Configuration ---
$fn = 64; // High resolution for smooth holes and cylinders

module adapter_sleeve() {
    // Calculate derived heights
    $collar_height = $collar_thickness;
    $sleeve_body_height = $total_height - $collar_height;
    
    // Calculate radii
    $collar_radius = $collar_diameter / 2;
    $sleeve_outer_radius = $sleeve_outer_diameter / 2;
    $bore_radius = $bore_diameter / 2;
    
    // Center of the part is at (0,0,0)
    // The collar sits from z=0 to z=$collar_height
    // The sleeve body sits from z=$collar_height to z=$total_height
    
    difference() {
        // --- Main Body (Union of Collar and Sleeve) ---
        union() {
            // 1. The Collar (Lying on the bed, z=0 to z=1.5)
            // Cylinder centered at (0,0, $collar_height/2)
            translate([0, 0, $collar_height/2]) {
                cylinder(
                    h = $collar_height,
                    r = $collar_radius,
                    $fn = $fn
                );
            }
            
            // 2. The Sleeve Body (Rising from the collar, z=1.5 to z=21.5)
            // Cylinder centered at (0,0, $collar_height + $sleeve_body_height/2)
            translate([0, 0, $collar_height + $sleeve_body_height/2]) {
                cylinder(
                    h = $sleeve_body_height,
                    r = $sleeve_outer_radius,
                    $fn = $fn
                );
            }
        }
        
        // --- Bore (Hole through the center) ---
        // The hole runs through the full height ($total_height)
        // Centered at (0,0, $total_height/2)
        translate([0, 0, $total_height/2]) {
            cylinder(
                h = $total_height,
                r = $bore_radius,
                $fn = $fn
            );
        }
    }
}

// Render the part
adapter_sleeve();