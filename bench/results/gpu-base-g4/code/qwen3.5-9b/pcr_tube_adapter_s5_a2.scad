// Adapter Sleeve for 0.2mL PCR tube in 1.5mL rack
// Print orientation: Upside down (Collar on bed)
// Units: mm

// Dimensions
$fn = 128; // High resolution for smooth curves

// Collar (Base)
$collar_outer_d = 13;
$collar_thickness = 1.5;

// Sleeve Body
$sleeve_outer_d = 10.8;
// Spec: rises from collar (z=1.5) to z=21.5. Total height = 21.5.
$sleeve_total_height = 21.5;
$sleeve_inner_d = 6.2;

// Derived heights
$sleeve_body_height = $sleeve_total_height - $collar_thickness;

// Build the part
difference() {
    // 1. Outer Shell
    union() {
        // Collar (Disk)
        cylinder(
            h = $collar_thickness,
            d = $collar_outer_d,
            center = [0, 0, $collar_thickness/2]
        );
        
        // Sleeve Body (Cylinder)
        // Starts at z = $collar_thickness, ends at z = $sleeve_total_height
        cylinder(
            h = $sleeve_body_height,