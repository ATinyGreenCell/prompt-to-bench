// Adapter sleeve for 0.2 mL PCR tube in 1.5 mL rack
// Print orientation: Upside down (Collar on bed)
// Units: mm

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves

// Collar dimensions (Bottom, on bed)
$collar_diameter = 13;
$collar_thickness = 1.5;

// Sleeve body dimensions (Rising from collar)
$sleeve_outer_diameter = 10.8;
$sleeve_total_height = 21.5; // Total height of the sleeve body section

// Bore dimensions
$bore_diameter = 6.2;

// --- Calculations ---
// Total height of the part (Collar + Sleeve Body)
$part_total_height = $collar_thickness + $sleeve_total_height;

// Outer radius of the collar
$r_collar = $collar_diameter / 2;

// Outer radius of the sleeve body
$r_sleeve = $sleeve_outer_diameter / 2;

// Bore radius
$r_bore = $bore_diameter / 2;

// --- Geometry Construction ---

difference() {
    // 1. The Main Body (Collar + Sleeve)
    union() {
        // Collar (at Z = 0)
        cylinder(
            h = $collar_thickness,
            r = $r_collar,
            center = [0, 0, $collar_thickness / 2],
            $fn = $fn
        );
        
        // Sleeve Body (starts at Z = $collar_thickness)
        // Height is exactly $sleeve_total_height as per spec
        cylinder(
            h = $sleeve_total_height,
            r = $r_sleeve,
            center = [0, 0, $collar_thickness + $sleeve_total_height / 2],
            $fn = $fn
        );
    }
    
    // 2. The Bore (Hole through the center)
    // Extends slightly past the top and bottom faces to ensure clean cut
    cylinder(
        h = $part_total_height + 0.1,
        r = $r_bore,
        center = [0, 0, $part_total_height / 2],
        $fn = $fn
    );
}