// --- Dimensions (mm) ---
outer_width = 90;          // Outer width and length of the box
outer_length = 90;         // Outer length and width of the box
wall_thickness = 2.5;       // Thickness of the four vertical walls
top_plate_thickness = 2;    // Thickness of the top plate (the stirring surface)
total_height = 40;         // Total height of the housing
screw_hole_diameter = 4.5;  // Diameter for M4 screw holes
screw_pattern_size = 71.5;  // Distance between screw holes (square pattern)
notch_width = 12;          // Width of the cable notch
notch_depth = 8;           // How far down the notch goes from the top edge
notch_height = 8;          // Height of the notch (from z=32 to z=40)

// --- Constants ---
$fn = 64;

// --- Implementation ---

// The part is modeled upside down: 
// The top plate (stirring surface) is at Z = 0 to Z = 2.
// The walls rise from Z = 2 to Z = 40.

module housing() {
    difference() {
        // Main Body
        union() {
            // The Top Plate (Base of the box in this orientation)
            cube([outer_width, outer_length, top_plate_thickness]);
            
            // The Four Walls
            translate([0, 0, top_plate_thickness])
            difference() {
                // Outer boundary of the walls
                cube([outer_width, outer_length, total_height - top_plate_thickness]);
                
                // Hollow out the inside
                translate([wall_thickness, wall_thickness, -0.01])
                cube([outer_width - 2*wall_thickness, outer_length - 2*wall_thickness, total_height]);
            }
        }

        // 1. Screw Holes (through the top plate)
        // We use a small offset to ensure they cut through the bottom face
        for (i = [-1, 1], j = [-1, 1]) {
            translate([i * screw_pattern_size / 2, j * screw_pattern_size / 2, -0.01])
            cylinder(d = screw_hole_diameter, h = top_plate_thickness + 0.02);
        }

        // 2. Cable Notch
        // Located in one wall, centered along the wall, reaching 8mm down from the open edge.
        // Open edge is at Z = 40. Notch is from Z = 32 to Z = 40.
        // We'll place it on the wall at Y = outer_length (the "front" wall).
        translate([outer_width/2 - notch_width/2, outer_length - wall_thickness - 0.1, total_height - notch_height])
        cube([notch_width, wall_thickness + 0.2, notch_height + 0.1]);
    }
}

// Render the part
housing();