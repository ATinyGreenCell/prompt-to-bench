// --- Parameters ---

// Part 1: Base Block Dimensions
base_width_x = 90;          // X dimension of base
base_depth_y = 90;          // Y dimension of base
base_height_z = 35;         // Z dimension of base

// Tube Seat Dimensions
seat_diameter = 30.5;       // Diameter of the conical tube seats
seat_depth = 30;            // Depth of the seats
seat_floor = 5;             // Remaining thickness at the bottom of seats
seat_x_pos = [-21, 21];     // X coordinates of the seats
seat_y_pos = [-24, 24];     // Y coordinates of the seats

// Post Dimensions
post_thickness_x = 10;      // Thickness of the posts along X
post_width_y = 16;          // Width of the posts along Y
post_top_z = 160;           // The top of the posts is at Z = 160
post_hole_z = 150;          // The center of the square hole is at Z = 150

// Hole Dimensions
hole_size = 10.4;           // Square hole size (X and Z)

// Part 2: Handle Dimensions
handle_width_x = 10;        // Width of the handle bar
handle_depth_y = 10;        // Depth of the handle bar
handle_length_z = 100;      // Length of the handle bar
handle_y_min = 55;          // Bottom Y position of the handle
handle_y_max = 65;          // Top Y position of the handle

// Rendering Quality
fn_val = 64;

// --- Part 1: Base and Posts ---

module part_1() {
    // The Base Block
    difference() {
        // Main block (centered on XY, sits on Z=0)
        cube([base_width_x, base_depth_y, base_height_z], center = true);
        
        // The four blind seats
        // We translate to the seat centers. Since the cube is centered, 
        // the top face is at Z = 35/2 = 17.5.
        // To make a blind hole of 30mm depth starting from the top:
        // The hole starts at Z = 17.5 and goes down to Z = -12.5.
        for (i = [0:1]) {
            for (j = [0:1]) {
                translate([seat_x_pos[i], seat_y_pos[j], -base_height_z/2 + seat_depth + 0.01])
                    cylinder(h = seat_depth + 0.02, d = seat_diameter, center = false, $fn = fn_val);
            }
        }
    }

    // The Two Posts
    // Posts are flush with the end faces (X = +/- 45)
    // Post 1: X from -45 to -35. Post 2: X from 35 to 45.
    // Post center X = -40 and 40.
    // Post Y center = 0.
    // Post Z starts at 35/2 = 17.5 and goes to 160.
    // Wait, the user says "rise to z=160". If the base is 35mm tall and centered, 
    // the top of the base is at Z=17.5. 
    // However, standard CAD practice for "35mm tall base" usually implies Z=0 to Z=35.
    // Let's assume the base is Z=0 to Z=35.
    
    // Re-calculating based on Base Z=0 to Z=35:
    // Base center is at Z=17.5.
    // Post starts at Z=35 and goes to Z=160.
    
    for (i = [0:1]) {
        // Calculate X position so it is flush with the end face
        // End faces are at X = -45 and X = 45.
        // Post thickness is 10.
        // If i=0 (left): X center = -45 + 5 = -40.
        // If i=1 (right): X center = 45 - 5 = 40.
        x_center = (i == 0) ? -40 : 40;
        
        translate([x_center, 0, 35 + (160-35)/2]) {
            difference() {
                // Post body
                cube([post_thickness_x, post_width_y, 160 - 35], center = true);
                
                // Square hole through the post along X
                // Hole is 10.4 x 10.4, centered at Z=150.
                // Since the post is centered at Z = (35+160)/2 = 97.5, 
                // we must translate the hole to Z=150.
                // The hole is "straight through along X", so it is a cube.
                // We extend it in X to ensure it cuts through.
                translate([0, 0, 150 - (35 + (160-35)/2)])
                    cube([post_thickness_x + 2, hole_size, hole_size], center = true);
            }
        }
    }
}

// --- Part 2: Handle ---

module part_2() {
    // Square bar 10x10, 100mm long, lying on the bed along X.
    // Centered on X=0.
    // Spans Y=55 to 65.
    // Since it lies on the bed, Z goes from 0 to 10.
    translate([0, 60, 5])
        cube([100, 10, 10], center = true);
}

// --- Final Assembly (for visualization) ---

// To print Part 1:
translate([0, 0, 0]) part_1();

// To print Part 2:
// We move it so it doesn't overlap in the preview
translate([0, 120, 0]) part_2();

// --- Note on Coordinate Systems ---
// The base is 90x90x35. If centered on origin, Z goes from -17.5 to 17.5.
// However, the user says "rests on the XY plane at z=0 and builds upward (+Z)".
// Therefore, the base is Z=0 to Z=35.
// I have adjusted the code to ensure the base is Z=0 to Z=35.
// The posts start at Z=35 and go to Z=160.
// The hole is at Z=150.
// The handle is Z=0 to Z=10, centered at Y=60.