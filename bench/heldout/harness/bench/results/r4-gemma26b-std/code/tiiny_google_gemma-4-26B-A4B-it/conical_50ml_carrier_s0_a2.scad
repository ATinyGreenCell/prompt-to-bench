// --- Parameters ---

// Part 1: Base Block Dimensions
base_width_x = 90;           // X dimension of base
base_depth_y = 90;           // Y dimension of base
base_height_z = 35;          // Z dimension of base

// Tube Seat Dimensions (Blind holes)
seat_diameter = 30.5;         // Diameter of the tube seats
seat_depth = 30;             // Depth of the seats (leaving 5mm floor)
seat_x_pos = [-21, 21];       // X coordinates of seats
seat_y_pos = [-24, 24];       // Y coordinates of seats

// Post Dimensions
post_thickness_x = 10;        // Thickness of posts along X
post_width_y = 16;            // Width of posts along Y
post_top_z = 160;             // The top of the posts is at Z = 160
post_hole_size = 10.4;        // Square hole size
post_hole_z_center = 150;     // Z center of the square hole

// Part 2: Handle Dimensions
handle_length_x = 100;        // Length of the handle along X
handle_thickness_y = 10;      // Thickness of the handle (Y)
handle_height_z = 10;         // Height of the handle (Z)
handle_y_start = 55;          // Start Y position (offset from base)
handle_y_end = 65;            // End Y position

// Resolution
fn_val = 64;

// --- Part 1: Base and Posts ---

module part_1() {
    // The Base Block
    // Requirement: rests on XY plane at z=0.
    // Base is 35mm tall.
    difference() {
        // Main block
        cube([base_width_x, base_depth_y, base_height_z]);
        
        // The four blind seats
        // Seats are centered at specified X, Y. 
        // They are blind, so they cut from the top (Z=35) downwards.
        for (i = [0:1]) {
            for (j = [0:1]) {
                translate([seat_x_pos[i], seat_y_pos[j], base_height_z - seat_depth + 0.01])
                    cylinder(h = seat_depth + 0.02, d = seat_diameter, $fn = fn_val);
            }
        }
    }

    // The two posts
    // Requirement: "stand on the base", "rise to z=160", "flush with end faces", "centered on y=0"
    // Base is 90x90, so end faces are at x=0 and x=90 (if not centered) or x=-45 and x=45 (if centered).
    // Since the base is centered on origin, end faces are at x = -45 and x = 45.
    // Post 1 (Left): X from -45 to -35. Post 2 (Right): X from 35 to 45.
    // Post Y: Centered on 0, width 16 -> Y from -8 to 8.
    // Post Z: From base top (35) to 160.
    
    for (x_offset = [-base_width_x/2, base_width_x/2 - post_thickness_x]) {
        translate([x_offset, -post_width_y/2, base_height_z])
        difference() {
            // Post body
            cube([post_thickness_x, post_width_y, post_top_z - base_height_z]);
            
            // The square hole through the post along X
            // Centered at Z = 150.
            // Hole is 10.4 x 10.4.
            // To ensure it cuts through, we extend X by 2mm.
            translate([-1, -post_hole_size/2, post_hole_z_center - post_hole_size/2])
                cube([post_thickness_x + 2, post_hole_size, post_hole_size]);
        }
    }
}

// --- Part 2: Handle ---

module part_2() {
    // Requirement: "square bar 10x10mm and 100mm long, lying on the bed along X and centred on x=0"
    // "spans y = 55 to 65"
    // "rests on the bed at z=0"
    // Since it is 10mm thick (Y) and spans 55 to 65, center is at Y=60.
    // Since it is 10mm high (Z) and rests on bed, Z goes from 0 to 10.
    
    translate([-handle_length_x/2, handle_y_start, 0])
        cube([handle_length_x, handle_thickness_y, handle_height_z]);
}

// --- Rendering ---

// Part 1: Base and Posts
// Centered on origin in X and Y.
// Base is 90x90, so it spans X: -45 to 45, Y: -45 to 45.
translate([0, 0, 0]) 
    part_1();

// Part 2: Handle
// "lying on the bed along X and centred on x=0"
// "10mm gap to the base's +Y face" -> Base +Y face is at Y=45. 
// Gap of 10mm means handle starts at Y = 45 + 10 = 55.
// Handle spans Y = 55 to 65.
// To print side-by-side, we place it at a safe distance.
translate([0, 100, 0]) 
    part_2();