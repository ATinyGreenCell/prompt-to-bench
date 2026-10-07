// --- Dimensions in Millimeters ---

// Overall housing dimensions
outer_x = 90;    // Outer width of the box (X)
outer_y = 90;    // Outer depth of the box (Y)
top_plate_thickness = 2; // Thickness of the top plate (Z from 0 to 2)
wall_height = 40; // Height of the walls above the top plate (Total height is 42mm, but wall rises to Z=40)
wall_thickness = 2.5; // Thickness of the four side walls

// Screw hole dimensions
screw_hole_diameter = 4.5; // Diameter for M4 screw holes
screw_pattern_size = 71.5; // Side length of the square pattern for mounting holes

// Cable notch dimensions (on one wall)
notch_width = 12;      // Width of the cable notch
notch_depth = 8;       // Depth of the cable notch from the open edge (Z=40 down to Z=32)

// Rendering settings
$fn = 64;

// --- Module Definitions ---

// Function to create a rectangular prism centered at origin
module box(x, y, z) {
    cube([x, y, z]);
}

// --- Main Assembly ---

difference() {
    // 1. The main outer shell structure (Union of top plate and walls)

    union() {
        // A. Top Plate (Lies on Z=0 plane, thickness = 2mm)
        translate([0, 0, 0]) {
            box(outer_x, outer_y, top_plate_thickness);
        }

        // B. Walls (Four vertical walls rising from the top plate)
        // The inner dimensions are calculated based on outer size and wall thickness.
        inner_x = outer_x - 2 * wall_thickness;
        inner_y = outer_y - 2 * wall_thickness;

        // Wall 1: Front (Parallel to Y-axis, centered in X)
        translate([-(outer_x/2) + wall_thickness/2, 0, top_plate_thickness]) {
            box(wall_thickness, outer_y, wall_height);
        }

        // Wall 2: Back (Parallel to Y-axis, centered in X)
        translate([(outer_x/2) - wall_thickness/2, 0, top_plate_thickness]) {
            box(wall_thickness, outer_y, wall_height);
        }

        // Wall 3: Left (Parallel to X-axis, centered in Y)
        translate([0, -(outer_y/2) + wall_thickness/2, top_plate_thickness]) {
            box(outer_x, wall_thickness, wall_height);
        }

        // Wall 4: Right (Parallel to X-axis, centered in Y)
        translate([0, (outer_y/2) - wall_thickness/2, top_plate_thickness]) {
            box(outer_x, wall_thickness, wall_height);
        }
    }

    // 2. Cutouts (Subtractions)

    // A. Screw Holes in the Top Plate (Z=0 to Z=2)
    for (i = [-1, 1]) { // X positions relative to center
        for (j = [-1, 1]) { // Y positions relative to center
            translate([
                (screw_pattern_size/2) * i,
                (screw_pattern_size/2) * j,
                -0.1 // Start slightly below Z=0 for clean cut
            ]) {
                cylinder(h = top_plate_thickness + 0.2, r = screw_hole_diameter / 2);
            }
        }
    }

    // B. Cable Notch in one wall (Let's choose the Right Wall: X = outer_x/2 - wall_thickness/2)
    // The right wall is defined by X > (outer_x/2) - wall_thickness/2 and Y between -(outer_y/2) + wall_thickness/2 and (outer_y/2) - wall_thickness/2.
    // We cut into the solid structure from the outside face of this wall.

    // The right wall's X position is: R_wall_X = outer_x/2 - wall_thickness/2
    right_wall_center_x = (outer_x / 2) - (wall_thickness / 2);

    translate([
        right_wall_center_x, // Position along X axis of the right wall
        0,                    // Centered in Y for simplicity, though it spans the full height/width of the wall section
        top_plate_thickness  // Start cutting from the top surface (Z=2) downwards
    ]) {
        // The notch is 12mm wide (along X direction if viewed from side), and reaches 8mm down from Z=40.
        // Since we are cutting into the wall, its length should be along Y axis for a standard cable entry slot.

        // Let's define the cut shape: A rectangle centered on the right wall face (Y-axis span)
        // The notch is 12mm wide (along X direction of the wall thickness), and reaches 8mm down from Z=40.
        // Wait, the description says: "notch for the power cable: 12 mm wide, centred along the wall, reaching 8 mm down from the open edge (from z = 32 to z = 40)."

        // The right wall spans Y from -(outer_y/2) + wall_thickness/2 to (outer_y/2) - wall_thickness/2.
        // Centered along the wall means centered in Y.
        notch_center_y = 0; // Center of the wall section in Y

        // The notch is 12mm wide (this must be the dimension parallel to the X-axis if we are cutting through the thickness, but it's usually the length along the wall).
        // Assuming "12 mm wide" means the span along the Y direction of the slot.
        notch_span_y = notch_width; // 12mm span in Y

        // The depth is 8mm from Z=40, meaning it goes from Z=32 to Z=40.
        // Since we start cutting at Z=top_plate_thickness (Z=2), this cut must go through the wall structure up to Z=40.

        // We model a rectangular prism that cuts into the right wall:
        translate([0, -notch_span_y/2, 32]) { // Start cutting at Z=32 (8mm down from Z=40)
            box(wall_thickness + 1, notch_span_y + 1, 8); // Extend slightly past the wall thickness and height range
        }
    }
}