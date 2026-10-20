// Dimensions for 0.2 mL PCR Tube Adapter
// Units: mm

// Physical Dimensions
sleeve_outer_diameter = 10.8;   // Outer diameter of the main body
collar_diameter = 13.0;         // Diameter of the base collar
collar_thickness = 1.5;         // Height of the base collar
sleeve_height = 21.5;           // Total height of the sleeve body
bore_diameter = 6.2;            // Diameter of the internal bore

// Derived Dimensions
bore_radius = bore_diameter / 2;
sleeve_radius = sleeve_outer_diameter / 2;
collar_radius = collar_diameter / 2;
wall_thickness = sleeve_radius - bore_radius;

// Rendering Settings
$fn = 64; // High resolution for curved surfaces

// Main Assembly
union() {
    // 1. Base Collar (Rests on bed)
    // Adjusted to start exactly at z = 0
    cylinder(h = collar_thickness, r = collar_radius, center = false);

    // 2. Main Sleeve Body
    // Adjusted to start exactly at z = collar_thickness
    translate([0, 0, collar_thickness])
    cylinder(h = sleeve_height, r = sleeve_radius, center = false);

    // 3. Top Cap (to create the open bore)
    // We cut a thin disc out of the top of the cylinder to leave the bore open.
    // We extend the cutter slightly past the top face to ensure clean separation.
    translate([0, 0, collar_thickness + sleeve_height])
    cylinder(h = 1.0, r = sleeve_radius + 0.1, center = false);
}