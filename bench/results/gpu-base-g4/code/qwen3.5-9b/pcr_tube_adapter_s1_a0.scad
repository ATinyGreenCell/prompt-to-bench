// Adapter Sleeve for 0.2mL PCR tube in 1.5mL rack
// Print orientation: Upside down (Collar on bed)
// Units: mm

// --- Dimensions ---
$fn = 128; // High resolution for smooth curves

// Collar (Base)
$collar_diameter = 13.0;
$collar_thickness = 1.5;

// Sleeve Body
$sleeve_outer_diameter = 10.8;
$sleeve_total_height = 21.5;

// Bore
$bore_diameter = 6.2;

// --- Calculations ---
$collar_radius = $collar_diameter / 2;
$sleeve_outer_radius = $sleeve_outer_diameter / 2;
$sleeve_inner_radius = $bore_diameter / 2;
$sleeve_body_height = $sleeve_total_height - $collar_thickness;

// --- Main Block ---
difference() {
    // 1. The Outer Shape (Union of Collar and Sleeve Body)
    union() {
        // Collar (Lies on Z=0)
        cylinder(
            h = $collar_thickness,
            d1 = $collar_diameter,
            d2 = $collar_diameter,
            center = false
        );

        // Sleeve Body (Rises from Z=1.5 to Z=21.5)
        translate([0, 0, $collar_thickness]) {
            cylinder(
                h = $sleeve_body_height,
                d1 = $sleeve_outer_diameter,
                d2 = $sleeve_outer_diameter,
                center = false
            );
        }
    }

    // 2. The Bore Hole (Runs through full height)
    // Extends slightly past the top and bottom to ensure clean cut
    translate([0, 0, -0.1]) {
        cylinder(
            h = $sleeve_total_height + 0.2,
            d1 = $bore_diameter,
            d2 = $bore_diameter,
            center = false
        );
    }
}