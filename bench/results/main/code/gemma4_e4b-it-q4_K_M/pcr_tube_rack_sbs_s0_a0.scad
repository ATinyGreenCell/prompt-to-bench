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
    translate([center_x, center_y, -0.1]) // Extend slightly below Z=0 plane
    cylinder(r = hole_radius + 0.1, h = plate_height + 0.2, $fn = 64);
}

// Function to create the chamfer cut at a specific corner (A1)
module chamfer_cut() {
    // The A1 corner is defined by its center position: (offset_x_start, offset_y_start)
    // We need to cut from the outer edges of the plate.

    // Define the bounding box for the chamfer relative to the origin (center of the whole block)
    // Since the block is centered on the origin in X/Y, we must calculate the corner coordinates.
    
    // The actual physical corners are at:
    // Min X = -plate_length/2, Max X = plate_length/2
    // Min Y = -plate_width/2, Max Y = plate_width/2

    // A1 corner is defined by its center (offset_x_start, offset_y_start) relative to the block's local origin.
    // Since we are centering the whole assembly on (0,0), we need to find where this specific corner lies.
    
    // X coordinate of the A1 column center: 
    // Center X = -plate_length/2 + offset_x_start
    float x_a1_center = (-plate_length / 2) + offset_x_start;

    // Y coordinate of the A1 row center:
    // Center Y = plate_width/2 - offset_y_start (assuming positive Y is 'front' edge, and we measure from back edge)
    float y_a1_center = (plate_width / 2) - offset_y_start;

    // The chamfer starts at the physical corner of the plate.
    // We will cut a wedge shape starting from the outer edges near this corner.
    
    // Define the two lines forming the chamfer:
    // Line 1 (along X edge): y = Y_corner - leg * tan(45) / cos(45) -> simplified, it's just a line segment
    // Since the angle is 45 degrees, the cut forms an isosceles right triangle.

    // We will use a wedge shape defined by two intersecting planes/lines.
    
    // The corner we are cutting is the one corresponding to A1 (top-left or bottom-right depending on coordinate system setup).
    // Assuming X increases right, Y increases towards front edge:
    // Left Edge: X = -plate_length / 2
    // Back Edge: Y = -plate_width / 2

    // The cut starts at the corner (-plate_length/2, -plate_width/2) and extends inwards by 'chamfer_leg' along both axes.
    
    translate([x_a1_center - offset_x_start, y_a1_center + offset_y_start, 0]) // Translate to the A1 corner location (relative to block center)
    {
        // We define a wedge that cuts into the plate material.
        // The cut is made at the physical corner of the plate: (-plate_length/2, -plate_width/2).
        // Since we are translating the whole assembly so A1 is correctly positioned, 
        // the corner being chamfered is the one corresponding to the start point.

        // Let's simplify: We cut a wedge shape from the outer boundary near the A1 location.
        // The actual physical corner of the plate we are targeting is at X_min and Y_max (if Y increases towards front).
        
        // Re-evaluating placement based on centering:
        // Plate spans [-L/2, L/2] in X and [-W/2, W/2] in Y.
        // A1 center is at X = -L/2 + 14.38, Y = -W/2 + 11.24 (assuming positive Y is towards the front edge).

        // The corner being chamfered is the one closest to the origin of the plate's local coordinate system defined by A1 start point.
        // Let's assume the cut happens at the physical corner corresponding to the *start* of the grid placement (A1).
        
        // Corner coordinates: X_corner = -plate_length/2, Y_corner = -plate_width/2
        
        translate([x_a1_center + offset_x_start, y_a1_center - offset_y_start, 0]) // Position the cut relative to the block center (this is complex due to centering)
        {
            // A simpler approach: Create a large wedge and use difference() against the plate.
            // The wedge must be positioned such that its hypotenuse cuts the corner defined by the chamfer_leg distance from the physical edge.

            // We define a shape that is 0 at the corner and slopes up to 1 at the edges, then extrude it.
            
            // Using linear_extrude on a polygon defining the cut profile:
            polygon(points = [
                [0, 0], // Corner point (where material is removed)
                [chamfer_leg, 0], // Along X edge
                [0, chamfer_leg]  // Along Y edge
            ]);
        }
    }
}


// --- Main Assembly ---

difference() {
    // 1. The main block body
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

    // 3. Cut the chamfer mark at the A1 corner
    // We must translate the chamfer cut to the correct physical location on the block.
    // The A1 center is at (offset_x_start, offset_y_start) relative to the left-back corner of the plate.
    
    // Since the cube is centered at (0,0), its corners are at (+/- L/2, +/- W/2).
    // Left edge: X = -L/2. Back edge: Y = -W/2.
    // The A1 corner location relative to the block center is:
    float x_a1_corner_center = (-plate_length / 2) + offset_x_start; // X coordinate of A1 column center
    float y_a1_corner_center = (-plate_width / 2) + offset_y_start; // Y coordinate of A1 row center

    // The chamfer is cut at the physical corner corresponding to A1 (Left-Back corner).
    // We translate the wedge cutter so its inner vertex aligns with this corner.
    translate([x_a1_corner_center - chamfer_leg, y_a1_corner_center - chamfer_leg, 0]) {
        // The wedge shape defined above assumes its origin (0,0) is