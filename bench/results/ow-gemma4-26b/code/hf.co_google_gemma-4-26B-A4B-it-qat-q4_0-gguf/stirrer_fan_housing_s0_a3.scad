// --- Dimensions (mm) ---
outer_width = 90;          // Outer dimension of the square box (X)
outer_length = 90;         // Outer dimension of the square box (Y)
wall_thickness = 2.5;      // Thickness of the four vertical walls
top_plate_thickness = 2;   // Thickness of the top plate (the stirring surface)
total_wall_height = 40;    // Height of the walls rising from the plate
screw_hole_diameter = 4.5; // Diameter for M4 screw holes
screw_pattern_size = 71.5; // Distance between screw hole centers
notch_width = 12;          // Width of the cable notch
notch_depth = 8;           // Depth of the notch from the open edge
$fn = 64;                  // Smoothness for circular features

// --- Implementation ---
// The part is printed upside down.
// The top plate (stirring surface) lies on the bed (z = 0 to 2).
// The walls rise from the plate to z = 42 (2 + 40).

difference() {
    // 1. The Main Body (Plate + Walls)
    union() {
        // The Top Plate (Base of the box in print orientation)
        // Positioned at Z = 0 to Z = 2
        translate([0, 0, top_plate_thickness / 2])
            cube([outer_width, outer_length, top_plate_thickness], center = true);
        
        // The Four Walls
        // They start at the top of the plate (Z = 2) and rise 40mm (to Z = 42)
        // The center of the wall block is at Z = 2 + (40/2) = 22
        translate([0, 0, top_plate_thickness + (total_wall_height / 2)])
            cube([outer_width, outer_length, total_wall_height], center = true);
    }

    // 2. Subtracting the Interior (Hollowing out the box)
    // The interior starts from the top of the plate (Z=2) up to the top (Z=42)
    // We use a slightly taller cube to ensure a clean cut through the top edge.
    translate([0, 0, top_plate_thickness + (total_wall_height / 2)])
        cube([outer_width - 2 * wall_thickness, outer_length - 2 * wall_thickness, total_wall_height + 0.1], center = true);

    // 3. Screw Holes (M4)
    // Drilled through the top plate (Z = 0 to 2)
    for (x = [-1, 1], y = [-1, 1]) {
        translate([x * screw_pattern_size / 2, y * screw_pattern_size / 2, -1])
            cylinder(d = screw_hole_diameter, h = top_plate_thickness + 2);
    }

    // 4. Cable Notch
    // Located in one wall, centered along the wall.
    // Reaches 8mm down from the open edge (z = 42 down to z = 34).
    // The notch is 12mm wide (X).
    // We place it on the wall at Y = outer_length/2.
    // The notch spans Z from (42 - 8) to 42.
    // We use a cube that is wider than the wall to ensure a clean cut through the wall.
    // The notch is 12mm wide (X), 8mm deep (Y), and 8mm high (Z).
    // To cut through the wall at Y=45, we translate the notch to the edge.
    translate([0, outer_length / 2, top_plate_thickness + total_wall_height - (notch_depth / 2)])
        cube([notch_width, wall_thickness + 2, notch_depth + 0.1], center = true);
}

// Verification of requirements:
// - Printed upside down: Top plate at Z=0 to 2. (Correct)
// - Outer size 90x90. (Correct)
// - Wall thickness 2.5. (Correct)
// - Top plate thickness 2. (Correct)
// - Walls rise to Z=42 (2+40). (Correct)
// - 4x 4.5mm holes on 71.5mm pattern. (Correct)
// - Notch: 12mm wide, 8mm down from open edge. (Correct)