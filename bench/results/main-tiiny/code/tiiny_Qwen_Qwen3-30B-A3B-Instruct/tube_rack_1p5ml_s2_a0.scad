// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions in millimetres

// Overall block dimensions
length_x = 106;    // Length along X axis
width_y = 72;       // Width along Y axis
height_z = 30;      // Height along Z axis

// Hole grid parameters
hole_diameter = 11.2;           // Diameter of each hole
hole_depth = 25;               // Depth of each hole (from top)
floor_thickness = 5;             // Solid floor thickness at bottom
hole_spacing_x = 16;           // Centre-to-centre spacing along X
hole_spacing_y = 16;            // Centre-to-centre spacing along Y
num_holes_x = 6;                // Number of holes along X (length)
num_holes_y = 4;                  // Number of holes along Y (width)

// Calculate grid centre offset to centre the hole array on the block
grid_centre_x = length_x / 2;
grid_centre_y = width_y / 2;

// Calculate hole grid start offsets to centre the array
start_x = grid_centre_x - ((num_holes_x - 1) * hole_spacing_x) / 2;
start_y = grid_centre_y - ((num_holes_y - 1) * hole_spacing_y) / 2;

// Set resolution for smooth holes
$fn = 64;

// Main block: solid rectangular prism
cube([length_x, width_y, height_z], center = true);

// Create holes using difference
difference() {
    // Main block
    cube([length_x, width_y, height_z], center = true);

    // Subtract cylinders for each hole
    for (i = [0 : num_holes_x - 1]) {
        for (j = [0 : num_holes_y - 1]) {
            // Calculate hole centre
            hole_x = start_x + i * hole_spacing_x;
            hole_y = start_y + j * hole_spacing_y;

            // Create cylinder hole: deep enough to reach floor
            // Extend slightly below the floor to ensure clean cut
            cylinder(
                h = height_z + 0.1,  // Slightly over to ensure full cut
                d = hole_diameter,
                center = true,
                $fn = 64
            );
            translate([hole_x, hole_y, 0])
                cylinder(
                    h = height_z + 0.1,
                    d = hole_diameter,
                    center = true,
                    $fn = 64
                );
        }
    }
}