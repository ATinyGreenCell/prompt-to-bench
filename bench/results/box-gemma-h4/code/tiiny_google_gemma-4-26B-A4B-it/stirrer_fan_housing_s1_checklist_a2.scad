// Magnetic Stirrer Housing
// Designed for an 80mm PC fan.
// Print orientation: Top plate on the bed (z=0).
// Centered on X and Y.

// Dimensions
outer_dim      = 90.0;    // Outer width and length (mm)
top_thickness  = 2.0;     // Thickness of the top plate (mm)
wall_thickness = 2.5;     // Thickness of the four walls (mm)
total_height   = 40.0;    // Total height from top plate to open edge (mm)
hole_diam      = 4.5;     // Diameter of M4 screw holes (mm)
hole_pattern   = 71.5;    // Square pattern for fan mounting holes (mm)
notch_width    = 12.0;    // Width of the cable notch (mm)
notch_depth    = 8.0;     // Depth of the notch from the open edge (mm)

$fn = 64;

// Calculations
wall_height = total_height - top_thickness;

// We build the part starting from Z=0 to avoid "2 separate bodies" 
// and ensure the bounding box Z is exactly 40.0.
difference() {
    // --- MAIN BODY ---
    union() {
        // 1. The top plate (z=0 to z=2)
        // Centered on X and Y
        translate([-outer_dim/2, -outer_dim/2, 0])
            cube([outer_dim, outer_dim, top_thickness]);
        
        // 2. The four walls (z=2 to z=40)
        // We build the walls as a single hollowed block to ensure it's one body
        translate([-outer_dim/2, -outer_dim/2, top_thickness]) {
            difference() {
                // Outer wall boundary
                cube([outer_dim, outer_dim, wall_height]);
                // Inner cavity
                translate([wall_thickness, wall_thickness, -0.1])
                    cube([outer_dim - 2*wall_thickness, outer_dim - 2*wall_thickness, wall_height + 0.2]);
            }
        }
    }

    // --- SUBTRACTIONS ---

    // 1. Screw Holes (M4)
    // Pattern is 71.5mm square, centered on the plate.
    // Holes go through the top plate (z=0 to z=2).
    for (sx = [-1, 1], sy = [-1, 1]) {
        translate([sx * hole_pattern / 2, sy * hole_pattern / 2, -0.1])
            cylinder(h = top_thickness + 0.2, d = hole_diam);
    }

    // 2. Cable Notch
    // Centered along one wall, reaching 8mm down from the open edge.
    // Open edge is at Z = 40. Notch is from Z = 32 to Z = 40.
    // We place it on the wall at +Y (Y = outer_dim/2).
    // The notch cuts through the wall thickness.
    translate([-notch_width / 2, outer_dim / 2 - wall_thickness, total_height - notch_depth])
        cube([notch_width, wall_thickness + 0.2, notch_depth + 0.1]);
}