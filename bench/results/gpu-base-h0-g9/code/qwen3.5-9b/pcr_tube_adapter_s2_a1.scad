// Adapter Sleeve for 0.2 mL PCR tube in 1.5 mL rack
// Print orientation: Upside down (Collar on bed)
// Units: mm

// Dimensions
$fn = 128; // High resolution for smooth curves and accurate holes

// Collar (Base)
$collar_diameter = 13.0;
$collar_thickness = 1.5;

// Sleeve Body
$sleeve_outer_diameter = 10.8;
$sleeve_total_height = 21.5;

// Bore
$bore_diameter = 6.2;

// Overcuts for clean printing (Rule 5)
$overcut = 0.1;

// Calculate derived dimensions
$collar_radius = $collar_diameter / 2;
$sleeve_outer_radius = $sleeve_outer_diameter / 2;
$bore_radius = $bore_diameter / 2;

// Calculate explicit heights to avoid floating point ambiguity
$collar_height = $collar_thickness;
$sleeve_body_height = $sleeve_total_height - $collar_thickness;

// Main Body Construction
difference() {
    // 1. Create the outer shell (Collar + Sleeve Body)
    
    // Collar Cylinder (Base)
    // Rests on bed at z=0
    cylinder(
        h = $collar_height,
        r1 = $collar_radius,
        r2 = $collar_radius,
        $fn = $fn
    );
    
    // Sleeve Body Cylinder (Rising from collar)
    // Starts at z = $collar_height, ends at z = $sleeve_total_height
    translate([0, 0, $collar_height])
    cylinder(
        h = $sleeve_body_height,
        r1 = $sleeve_outer_radius,
        r2 = $sleeve_outer_radius,
        $fn = $fn
    );
    
    // 2. Cut the Bore
    // The bore runs through the full height ($sleeve_total_height)
    // We extend the cutter slightly past the top and bottom to ensure clean cuts (Rule 5)
    // Start at z = -overcut, End at z = total_height + overcut
    translate([0, 0, -$overcut])
    cylinder(
        h = ($sleeve_total_height + ($overcut * 2)),
        r = $bore_radius,
        $fn = $fn
    );
}