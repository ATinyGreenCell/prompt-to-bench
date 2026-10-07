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
notch_width = 12;      // Width of the cable notch (span along Y axis, matching report's implied dimension)
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

    // B. Cable Notch in one wall (Right Wall: X > outer_x/2 - wall_thickness/2)
    right_wall_center_x = (outer_x / 2) - (wall_thickness / 2);

    translate([
        right_wall_center_x, // Position along X axis of the right wall
        0,                    // Centered in Y for simplicity
        top_plate_thickness  // Start cutting from the top surface (Z=2) downwards
    ]) {
        // The notch is 12mm wide (span along Y axis), and reaches 8mm down from Z=40.
        notch_span_y = notch_width; // 12mm span in Y

        // To match the report's implied geometry, we must ensure the cut only affects the wall structure itself.
        // The right wall is defined by X being near outer_x/2 and spanning Y across its thickness.
        // We cut a slot of width=12mm (Y span) and depth=8mm (Z range 32 to 40).

        // Since the notch must be centered along the wall, we center it in Y relative to the full outer dimension, but constrained by the wall thickness.
        // The wall spans from -(outer_y/2 - wall_thickness/2) to (outer_y/2 - wall_thickness/2).
        // We center the 12mm notch span around Y=0 for simplicity and symmetry in the cut, as done previously.

        translate([0, -notch_span_y/2, 32]) { // Start cutting at Z=32 (8mm down from Z=40)
            // The cutter must be wide enough to pass through the wall thickness (which is 2.5mm).
            // We use a small X dimension for the cut since we are only cutting into the face of the right wall, not completely through it in X direction relative to the center line.
            box(wall_thickness + 1, notch_span_y + 1, 8); // Cut depth is 8mm (Z=32 to Z=40)
        }
    }
}