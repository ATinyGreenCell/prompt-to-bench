// Dimensions for the PCR tube adapter sleeve (Final verified version)

// Collar dimensions
collar_diameter = 13;  // Diameter of the collar in mm
collar_thickness = 1.5; // Thickness of the collar in mm

// Sleeve body dimensions
sleeve_outer_diameter = 10.8; // Outer diameter of the sleeve body in mm
sleeve_height = 21.5;         // Height of the sleeve body (rises from z=1.5 to z=21.5)

// Bore dimensions
bore_diameter = 6.2;       // Diameter of the central bore in mm

// Positioning and tolerances
collar_z_top = collar_thickness; // Collar occupies Z: [0, 1.5]
sleeve_bottom_z = collar_thickness; // Sleeve starts at Z=1.5
sleeve_top_z = sleeve_bottom_z + sleeve_height; // Total height: 23.0

// --- 1. Collar ---
module adapter_collar() {
    // Cylinder with diameter 13 mm (Radius = 6.5) and height 1.5 mm
    cylinder(h = collar_thickness, r = collar_diameter / 2, $fn = 100); // Increased fn for better circularity
}

// --- 2. Sleeve Body ---
module adapter_sleeve() {
    difference() {
        // Outer shape of the sleeve body (Cylinder with OD 10.8 mm, Radius = 5.4)
        cylinder(h = sleeve_height, r = sleeve_outer_diameter / 2, $fn = 100); // Increased fn for better circularity

        // Inner bore (cutout). Translate slightly below to ensure full cut through the body.
        translate([0, 0, -0.1]) { 
            cylinder(h = sleeve_height + 0.2, r = bore_diameter / 2, $fn = 100);
        }
    }
}

// --- Assembly ---

// Place the collar at the bottom (z=0 to z=1.5)
translate([0, 0, 0]) {
    adapter_collar();
}

// Place the sleeve body starting exactly where the collar ends (z=1.5)
translate([0, 0, sleeve_bottom_z]) {
    adapter_sleeve();
}