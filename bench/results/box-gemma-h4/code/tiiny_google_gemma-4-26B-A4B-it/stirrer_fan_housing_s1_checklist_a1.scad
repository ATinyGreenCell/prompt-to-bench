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

module housing() {
    difference() {
        // --- MAIN BODY ---
        union() {
            // The top plate (z=0 to z=2)
            cube([outer_dim, outer_dim, top_thickness], center = true);
            
            // The four walls (z=2 to z=40)
            // We use a hull or a union of cubes to create the wall structure
            translate([0, 0, top_thickness + wall_height / 2]) {
                difference() {
                    // Outer boundary of walls
                    cube([outer_dim, outer_dim, wall_height], center = true);
                    // Inner cavity (to be hollowed out)
                    cube([outer_dim - 2 * wall_thickness, outer_dim - 2 * wall_thickness, wall_height + 2], center = true);
                }
            }
        }

        // --- SUBTRACTIONS ---

        // 1. The Cavity (to make it an open box)
        // This hollows out the space above the top plate
        translate([0, 0, top_thickness + wall_height / 2])
            cube([outer_dim - 2 * wall_thickness, outer_dim - 2 * wall_thickness, wall_height + 2], center = true);

        // 2. Screw Holes (M4)
        // Pattern is 71.5mm square, centered.
        // Holes go through the top plate (z=0 to z=2)
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([sx * hole_pattern / 2, sy * hole_pattern / 2, -1])
                cylinder(h = top_thickness + 2, d = hole_diam);
        }

        // 3. Cable Notch
        // Centered along one wall, reaching 8mm down from the open edge.
        // Open edge is at Z = 40. Notch is from Z = 32 to Z = 40.
        // We place it on the wall at +Y (Y = outer_dim/2).
        // The notch cuts through the wall thickness.
        translate([-notch_width / 2, outer_dim / 2 - wall_thickness / 2, total_height - notch_depth])
            cube([notch_width, wall_thickness + 1, notch_depth + 1]);
    }
}

// Execute module
// The module is already designed with center=true for X and Y.
// To ensure the bottom of the plate is at Z=0, we must translate the whole object.
// Since the top plate is 2mm thick and centered at Z=0, its bottom is at Z=-1.
// We translate by +1 to put the bottom at Z=0.
translate([0, 0, 1]) housing();