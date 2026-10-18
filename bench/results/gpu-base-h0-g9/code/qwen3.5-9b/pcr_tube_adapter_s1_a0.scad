// Adapter Sleeve for 0.2mL PCR tubes in 1.5mL Rack Holes
// Print Orientation: Upside down (Collar on bed)
// Units: mm

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate holes

// Collar (Base)
$collar_outer_d = 13.0;
$collar_thickness = 1.5;

// Sleeve Body
$sleeve_outer_d = 10.8;
$sleeve_total_height = 21.5;
$sleeve_inner_d = 6.2;

// --- Calculated Variables ---
$collar_radius = $collar_outer_d / 2;
$sleeve_radius = $sleeve_outer_d / 2;
$sleeve_inner_radius = $sleeve_inner_d / 2;
$sleeve_body_height = $sleeve_total_height - $collar_thickness;

// --- Main Module ---
module adapter_sleeve() {
    // 1. Create the Collar (Base)
    // Lies on XY plane from z=0 to z=1.5
    difference() {
        // Outer shape of collar
        cylinder(
            h = $collar_thickness,
            r = $collar_radius,
            center = [0, 0, $collar_thickness / 2]
        );
        
        // Cut the bore through the collar
        cylinder(
            h = $collar_thickness + 2, // Extend slightly past faces
            r = $sleeve_inner_radius,
            center = [0, 0, $collar_thickness / 2]
        );
    }
    
    // 2. Create the Sleeve Body
    // Rises from z=1.5 to z=21.5
    translate([0, 0, $collar_thickness]) {
        difference() {
            // Outer shape of sleeve body
            cylinder(
                h = $sleeve_body_height,
                r = $sleeve_radius,
                center = [0, 0, $sleeve_body_height / 2]
            );
            
            // Cut the bore through the sleeve body
            cylinder(
                h = $sleeve_body_height + 2, // Extend slightly past faces
                r = $sleeve_inner_radius,
                center = [0, 0, $sleeve_body_height / 2]
            );
        }
    }
}

// --- Render ---
adapter_sleeve();