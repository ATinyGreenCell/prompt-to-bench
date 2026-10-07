// Dimensions for the PCR tube adapter sleeve

// Collar dimensions
collar_diameter = 13;  // Diameter of the collar in mm
collar_thickness = 1.5; // Thickness of the collar in mm

// Sleeve body dimensions
sleeve_outer_diameter = 10.8; // Outer diameter of the sleeve body in mm
sleeve_height = 21.5;         // Total height of the sleeve body (from z=1.5 to z=21.5)

// Bore dimensions
bore_diameter = 6.2;       // Diameter of the central bore in mm

// Positioning and tolerances
collar_z_top = collar_thickness; // Collar sits from z=0 to z=1.5 (assuming it rests on the bed at z=0, but the description implies a specific Z range)
sleeve_bottom_z = collar_thickness; // Sleeve starts where the collar ends (at z=1.5)
sleeve_top_z = sleeve_bottom_z + sleeve_height; // Total height calculation

// --- 1. Collar ---
module adapter_collar() {
    cylinder(h = collar_thickness, r = collar_diameter / 2, $fn = 64);
}

// --- 2. Sleeve Body ---
module adapter_sleeve() {
    difference() {
        // Outer shape of the sleeve body (a cylinder)
        cylinder(h = sleeve_height, r = sleeve_outer_diameter / 2, $fn = 64);

        // Inner bore (cutout)
        translate([0, 0, -1]) { // Translate slightly below to ensure full cut through the body
            cylinder(h = sleeve_height + 2, r = bore_diameter / 2, $fn = 64);
        }
    }
}

// --- Assembly ---

// Place the collar at the bottom (z=0 to z=1.5)
translate([0, 0, 0]) {
    adapter_collar();
}

// Place the sleeve body starting from where the collar ends (z=1.5)
translate([0, 0, sleeve_bottom_z]) {
    adapter_sleeve();
}