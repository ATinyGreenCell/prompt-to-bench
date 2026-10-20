// Bench rack for 1.5 mL microcentrifuge tubes
// Dimensions in millimetres

// Overall block dimensions
length_x = 106;   // Length along X axis
width_y = 72;    // Width along Y axis
height_z = 30;     // Height along Z axis

// Hole grid parameters
hole_diameter = 11.2;         // Diameter of each hole
hole_depth = 25;            // Depth of each hole (from top surface)
floor_thickness = 5;            // Solid floor thickness at bottom of hole
hole_spacing_x = 16;            // Centre-to-centre spacing along X
hole_spacing_y = 16;           // Centre-to-centre spacing along Y
num_holes_x = 6;              // Number of holes along X (columns)
num_holes_y = 4;             // Number of holes along Y (rows)

// Calculate centre of hole grid
grid_centre_x = length_x / 2;
grid_centre_y = width_y / 2;

// Calculate starting X and Y positions for the first hole
// to centre the grid
start_x = grid_centre_x - ((num_holes_x - 1) * hole_spacing_x) / 2;
start_y = grid_centre_y - ((num_holes_y - 1) * hole_spacing_y) / 2;

// Set resolution for smooth holes
$fn = 64;

// Main block: place it on the XY plane at z = 0, so it prints flat
// The block is now centred in X and Y, but bottom at z = 0, top at z = 30
// So we shift the entire model down by 15 mm in Z to centre it at z = 0 to 30
// But instead, we'll build it from z = 0 up, so we don't use center = true

module bench_rack() {
    difference() {
        // Solid block from z = 0 to z = 30, centred in X and Y
        translate([0, 0, 0]) {
            cube([length_x, width_y, height_z], center = false);
        }

        // Cut out holes: each hole is 25 mm deep, so from z = 0 to z = 25
        // The floor is 5 mm thick, so the hole goes from z = 0 to z = 25
        // We cut a cylinder from z = 0 to z = 25 + 0.01 to ensure clean difference
        for (i = [0 : num_holes_x - 1]) {
            for (j = [0 : num_holes_y - 1]) {
                // Calculate hole centre
                hole_x = start_x + i * hole_spacing_x;
                hole_y = start_y + j * hole_spacing_y;

                // Cut a cylinder from bottom (z=0) to just beyond hole depth
                // Extend 0.01 mm beyond to avoid coplanar faces
                translate([hole_x, hole_y, -0.01]) {
                    cylinder(h = hole_depth + 0.02, d = hole_diameter, center = false);
                }
            }
        }
    }
}

// Render the bench rack with bottom at z = 0
bench_rack();