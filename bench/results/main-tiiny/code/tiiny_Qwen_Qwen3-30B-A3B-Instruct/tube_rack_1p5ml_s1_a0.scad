// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions in millimetres

// Overall block dimensions
length_x = 106;   // Length along X axis
width_y = 72;     // Width along Y axis
height_z = 30;    // Height along Z axis

// Hole grid parameters
hole_diameter = 11.2;         // Diameter of each hole
hole_depth = 25;            // Depth of each hole (from top surface)
floor_thickness = 5;          // Solid floor thickness at bottom of hole
hole_spacing_x = 16;         // Centre-to-centre spacing along X
hole_spacing_y = 16;          // Centre-to-centre spacing along Y
num_holes_x = 6;              // Number of holes along X (columns)
num_holes_y = 4;               // Number of holes along Y (rows)

// Calculate centre of hole grid
grid_centre_x = length_x / 2;
grid_centre_y = width_y / 2;

// Calculate starting X and Y positions for the first hole
// to centre the grid
start_x = grid_centre_x - ((num_holes_x - 1) * hole_spacing_x) / 2;
start_y = grid_centre_y - ((num_holes_y - 1) * hole_spacing_y) / 2;

// Set resolution for smooth holes
$fn = 64;

// Main block
module bench_rack() {
    difference() {
        // Solid block
        cube([length_x, width_y, height_z], center = true);

        // Cut out holes
        for (i = [0 : num_holes_x - 1]) {
            for (j = [0 : num_holes_y - 1]) {
                // Calculate hole centre
                hole_x = start_x + i * hole_spacing_x;
                hole_y = start_y + j * hole_spacing_y;

                // Cut a cylinder from top to bottom, but only down to floor_thickness
                // Extend slightly beyond to ensure clean difference
                translate([hole_x, hole_y, height_z - 0.01]) {
                    cylinder(h = height_z + 0.01, d = hole_diameter, center = false);
                }
            }
        }
    }
}

// Render the bench rack
benck_rack();