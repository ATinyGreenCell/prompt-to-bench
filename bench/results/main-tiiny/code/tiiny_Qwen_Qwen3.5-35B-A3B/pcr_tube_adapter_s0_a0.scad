// Dimensions for PCR tube adapter sleeve (0.2 mL tube in 1.5 mL rack hole)
// All units in millimetres

// Collar dimensions (base resting on build plate)
collar_diameter = 13;
collar_height = 1.5;

// Sleeve body dimensions
sleeve_outer_diameter = 10.8;
sleeve_height = 21.5 - collar_height; // Total height 21.5, subtract collar

// Bore dimensions (for 0.2 mL tube)
bore_diameter = 6.2;

// Safety margin for printing tolerance (slight clearance)
// The bore is slightly larger than 6.2mm to ensure fit, but user specified 6.2mm.
// We will use 6.2mm exactly as requested, relying on FDM tolerance.
// However, for the difference operation, we ensure the cutter extends past faces.

// Set resolution for curved surfaces
$fn = 64;

// Define the collar (base)
module collar() {
    difference() {
        // Main collar cylinder
        cylinder(h = collar_height, d = collar_diameter, center = false);
        
        // Cut the bore through the collar
        // Extends 0.5mm past the top face to ensure clean cut
        translate([0, 0, -0.5])
            cylinder(h = collar_height + 1, d = bore_diameter, center = false);
    }
}

// Define the sleeve body (rises from collar)
module sleeve_body() {
    difference() {
        // Main sleeve cylinder
        // Positioned on top of collar, so base is at z = collar_height
        translate([0, 0, collar_height])
            cylinder(h = sleeve_height, d = sleeve_outer_diameter, center = false);
        
        // Cut the bore through the sleeve body
        // Extends 0.5mm past the top face to ensure clean cut
        translate([0, 0, collar_height - 0.5])
            cylinder(h = sleeve_height + 1, d = bore_diameter, center = false);
    }
}

// Combine collar and sleeve body
union() {
    collar();
    sleeve_body();
}

// Final assembly
// The entire part is centered at origin in X/Y, resting on Z=0
translate([0, 0, 0]) {
    union();
}