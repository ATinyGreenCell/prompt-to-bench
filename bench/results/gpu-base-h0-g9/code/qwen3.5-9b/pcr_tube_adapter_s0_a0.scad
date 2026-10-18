// Adapter Sleeve for 0.2mL PCR Tube in 1.5mL Rack
// Print Orientation: Upside down (Collar on bed)
// Units: mm

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves and accurate holes

// Collar (Base)
$collar_outer_diameter = 13.0;
$collar_thickness = 1.5;

// Sleeve Body
$sleeve_outer_diameter = 10.8;
$sleeve_total_height = 21.5;
$sleeve_inner_diameter = 6.2;

// --- Calculated Variables ---
$collar_radius = $collar_outer_diameter / 2;
$sleeve_outer_radius = $sleeve_outer_diameter / 2;
$sleeve_inner_radius = $sleeve_inner_diameter / 2;
$sleeve_body_height = $sleeve_total_height - $collar_thickness;

// --- Main Part ---
difference() {
    // 1. Create the outer solid shape
    union() {
        // Collar (Disk)
        cylinder(
            h = $collar_thickness,
            r = $collar_radius,
            center = [0, 0, 0]
        );
        
        // Sleeve Body (Cylinder rising from top of collar)
        translate([0, 0, $collar_thickness]) {
            cylinder(
                h = $sleeve_body_height,
                r = $sleeve_outer_radius,
                center = [0, 0, $collar_thickness]
            );
        }
    }
    
    // 2. Cut the central bore through the full height
    // The bore must extend slightly past the top and bottom faces to ensure clean cuts
    translate([0, 0, -0.1]) {
        cylinder(
            h = $sleeve_total_height + 0.2,
            r = $sleeve_inner_radius,
            center = [0, 0, 0]
        );
    }
}