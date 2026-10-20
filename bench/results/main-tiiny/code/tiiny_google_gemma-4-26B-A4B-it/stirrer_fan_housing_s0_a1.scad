// --- Dimensions (mm) ---
outer_width = 90;          // Outer width and length of the box
outer_length = 90;         // Outer length and width of the box
wall_thickness = 2.5;       // Thickness of the four vertical walls
top_plate_thickness = 2;    // Thickness of the stirring surface (bottom of the box)
total_height = 40;         // Total height of the housing
screw_hole_diameter = 4.5;  // Diameter for M4 screw holes
screw_pattern_size = 71.5; // Distance between screw holes (center-to-center)
notch_width = 12;          // Width of the cable notch (along the wall)
notch_depth = 2.5;         // Depth of the notch (cuts through the wall thickness)
notch_height = 8;          // Height of the notch (from Z=32 to Z=40)

// --- Constants ---
$fn = 64;

// --- Modeling ---

// The part is printed upside down.
// The top plate (stirring surface) is at Z = 0 to Z = 2.
// The walls rise from Z = 2 to Z = 40.

module stirrer_housing() {
    difference() {
        // 1. The solid outer shell
        union() {
            // The top plate (resting on bed at Z=0)
            cube([outer_width, outer_length, top_plate_thickness]);
            
            // The four walls rising from the top plate
            // We use a hull or a union of cubes to create the walls
            translate([0, 0, top_plate_thickness])
            cube([outer_width, outer_length, total_height - top_plate_thickness]);
        }

        // 2. Hollow out the inside to create the box cavity
        // The cavity starts at the top of the plate (Z = top_plate_thickness)
        // and goes to the top of the box (Z = total_height).
        translate([wall_thickness, wall_thickness, top_plate_thickness - 0.01])
        cube([outer_width - 2 * wall_thickness, outer_length - 2 * wall_thickness, total_height - top_plate_thickness + 0.02]);

        // 3. Screw holes for the fan
        // Pattern is 71.5mm square, centered on the plate.
        // Holes go through the top plate (Z=0 to Z=2).
        for (x = [-screw_pattern_size/2, screw_pattern_size/2]) {
            for (y = [-screw_pattern_size/2, screw_pattern_size/2]) {
                translate([outer_width/2 + x, outer_length/2 + y, -1])
                cylinder(d = screw_hole_diameter, h = top_plate_thickness + 2);
            }
        }

        // 4. Cable notch
        // "In one wall, cut a notch... 12mm wide, centered along the wall, 
        // reaching 8mm down from the open edge (from z=32 to z=40)."
        // The open edge is at Z = 40.
        // The notch is 12mm wide (along Y), 8mm high (along Z), and cuts through the wall.
        // We place it on the wall at X = outer_width.
        // The notch is centered at Y = outer_length/2.
        // The notch height is from Z = 32 to Z = 40.
        translate([outer_width - notch_depth, outer_length/2 - notch_width/2, total_height - notch_height])
        cube([notch_depth + 1, notch_width, notch_height + 0.01]);
    }
}

// Render the part
// Centered on XY plane, resting on Z=0.
translate([-outer_width/2, -outer_length/2, 0])
stirrer_housing();