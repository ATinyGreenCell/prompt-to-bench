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
    // Requirement: 90x90x35, rests on XY plane at z=0, centered on X and Y.
    // This means Z goes from 0 to 35.
    difference() {
        // Main block
        cube([base_width_x, base_depth_y, base_height_z], center = false);
        
        // The four blind seats
        // Seats are centered at X = +/- 21, Y = +/- 24.
        // They are 30mm deep. Since base is 35mm tall, they leave 5mm floor.
        // Top of base is at Z=35. Hole goes from Z=35 down to Z=5.
        for (i = [0:1]) {
            for (j = [0:1]) {
                // Translate to seat center. 
                // Since cube is not centered (0,0,0) but (45,45,0), 
                // we offset the seat centers by 45.
                translate([seat_x_pos[i] + 45, seat_y_pos[j] + 45, base_height_z - seat_depth + 0.01])
                    cylinder(h = seat_depth + 0.02, d = seat_diameter, center = false, $fn = fn_val);
            }
        }
    }

    // The Two Posts
    // Requirement: 10mm thick (X) and 16mm wide (Y).
    // Stand on the base at its two X ends, flush with end faces, centered on Y=0.
    // Base X ends are at 0 and 90.
    // Post 1 (Left): X from 0 to 10. Center X = 5.
    // Post 2 (Right): X from 80 to 90. Center X = 85.
    // Post Y: Centered on Y=0 means Y from -8 to 8.
    // Post Z: Rises to 160. Since it stands on the base, Z goes from 35 to 160.
    
    for (i = [0:1]) {
        // Calculate X center to be flush with ends (0 and 90)
        // If i=0, center is 5. If i=1, center is 85.
        x_center = (i == 0) ? 5 : 85;
        
        // Post is centered on Y=0. In our non-centered base, Y=0 is at coordinate 45.
        y_center = 45; 
        
        // Post height is 160 - 35 = 125.
        // Post Z goes from 35 to 160.
        translate([x_center, y_center, 35]) {
            difference() {
                // Post body
                cube([post_thickness_x, post_width_y, post_top_z - 35], center = true);
                
                // Square hole through the post along X
                // Hole is 10.4 x 10.4, centered at Z=150.
                // Since the post is translated to Z=35, the hole's local Z is 150 - 35 = 115.
                // We extend the hole in X to ensure it cuts through the post.
                translate([0, 0, 150 - 35])
                    cube([post_thickness_x + 2, hole_size, hole_size], center = true);
            }
        }
    }
}

// --- Part 2: Handle ---

module part_2() {
    // Requirement: Square bar 10x10, 100mm long, lying on the bed along X.
    // Centered on X=0. Spans Y=55 to 65.
    // "Lying on the bed" means Z goes from 0 to 10.
    // Centered on X=0 means X goes from -50 to 50.
    // Spans Y=55 to 65 means Y center is 60.
    
    translate([0, 60, 5])
        cube([100, 10, 10], center = true);
}

// --- Final Assembly (for visualization) ---

// Print Part 1
part_1();

// Print Part 2 (offset for visibility)
translate([0, 120, 0]) part_2();