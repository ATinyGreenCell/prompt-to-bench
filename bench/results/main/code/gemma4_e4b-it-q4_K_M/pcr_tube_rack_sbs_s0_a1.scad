// --- Dimensions ---

plate_length = 127.76;  // X dimension of the plate (mm)
plate_width = 85.48;   // Y dimension of the plate (mm)
plate_height = 20;     // Z dimension of the plate (mm)

hole_diameter = 6.2;   // Diameter of each PCR tube hole (mm)
hole_radius = hole_diameter / 2; // Radius of each hole (mm)

spacing_x = 9.0;       // Center-to-center spacing along X (mm)
spacing_y = 9.0;       // Center-to-center spacing along Y (mm)

num_cols = 12;         // Number of columns (along X)
num_rows = 8;          // Number of rows (along Y)

offset_x_start = 14.38; // Distance from left edge to center of first column (A1) (mm)
offset_y_start = 11.24; // Distance from back edge to center of first row (A1) (mm)

chamfer_leg = 5;       // Leg length for the chamfer (mm)
chamfer_angle = 45;    // Angle of the chamfer (degrees)

// --- Global Settings ---
$fn = 64; // High resolution for curves

// --- Module Definitions ---

// Function to create a single hole cutter, slightly oversized for clean cutting
module hole_cutter(center_x, center_y) {
    // Extend slightly below Z=0 plane and above Z=plate_height for robust difference operation
    translate([center_x, center_y, -0.1]) 
    cylinder(r = hole_radius + 0.1, h = plate_height + 0.2, $fn = 64);
}

// Function to create the chamfer cut at the A1 corner (Left-Back)
module chamfer_cut() {
    // The block is centered at (0,0).
    // Left Edge: X = -plate_length / 2
    // Back Edge: Y = -plate_width / 2

    // Calculate the center coordinates of A1 relative to the block's origin (0,0)
    float x_a1_center = (-plate_length / 2) + offset_x_start; // X coordinate of A1 column center
    float y_a1_center = (-plate_width / 2) + offset_y_start; // Y coordinate of A1 row center

    // The chamfer is cut at the physical corner (Left-Back).
    // We need to translate a wedge shape so its inner vertex aligns with this corner.
    // The wedge profile is defined by points [0,0], [L, 0], [0, L] where L=chamfer_leg.

    // Translate the origin of the wedge cutter to the physical corner point: (X_corner, Y_corner)
    float x_corner = -plate_length / 2;
    float y_corner = -plate_width / 2;

    translate([x_corner, y_corner, -0.1]) { // Extend slightly below Z=0 plane
        // Define the wedge shape (a right triangle) that cuts into the material.
        // The points define the cut profile in the XY plane.
        polygon(points = [
            [0, 0], // Corner point where the cut starts (inner vertex of the chamfer)
            [chamfer_leg, 0], // Along X edge
            [0, chamfer_leg]  // Along Y edge
        ]);
    }
}


// --- Main Assembly ---

difference() {
    // 1. The main block body (Centered on origin)
    cube([plate_length, plate_width, plate_height], center = true);

    // 2. Cut the holes (96 tubes)
    for (col = [0 : num_cols - 1]) {
        for (row = [0 : num_rows - 1]) {
            // Calculate X position: Start offset + col * spacing
            float current_x = offset_x_start + col * spacing_x;
            // Calculate Y position: Start offset + row * spacing
            float current_y = offset_y_start + row * spacing_y;

            hole_cutter(current_x, current_y);
        }
    }

    // 3. Cut the chamfer mark at the A1 corner (Left-Back)
    chamfer_cut();
}