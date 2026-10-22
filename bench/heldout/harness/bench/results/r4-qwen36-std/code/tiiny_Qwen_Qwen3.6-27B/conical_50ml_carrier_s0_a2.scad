// Dimensions for Part 1: Base Block
base_x = 90;
base_y = 90;
base_z = 35;

// Dimensions for Part 1: Tube Seats
seat_diameter = 30.5;
seat_depth = 30;
seat_floor = 5; // base_z - seat_depth
seat_x_pos = 21;
seat_y_pos = 24;

// Dimensions for Part 1: Posts
post_x = 10;
post_y = 16;
post_z = 160;
post_hole_size = 10.4;
post_hole_z = 150;

// Dimensions for Part 2: Handle
handle_x = 100;
handle_y = 10;
handle_z = 10;
handle_y_start = 55;
handle_y_end = 65;

// Global settings
$fn = 64;

// Part 1: Base Block with Seats and Posts
// Centered on origin as requested.
translate([0, 0, 0]) {
    // Base Block
    translate([-base_x/2, -base_y/2, 0]) {
        cube([base_x, base_y, base_z], center = false);
    }
    
    // Tube Seats (Blind Holes)
    for (sx = [-seat_x_pos, seat_x_pos]) {
        for (sy = [-seat_y_pos, seat_y_pos]) {
            translate([sx, sy, seat_floor]) {
                cylinder(r = seat_diameter/2, h = seat_depth + 0.1, center = false); // +0.1 to ensure cut goes through
            }
        }
    }
    
    // Posts
    // Left Post: Flush with end face (-base_x/2), centred on y=0
    // The post is 10mm thick (X) and 16mm wide (Y).
    // It stands on the base at its X end.
    // "Flush with the end faces" means the outer face of the post aligns with the outer face of the base.
    // Base X range: [-45, 45]. Left end is -45.
    // Post X range: [-45 - 10, -45] = [-55, -45].
    // Post Y range: [-8, 8] (centered on y=0, width 16).
    translate([-base_x/2 - post_x, -post_y/2, 0]) {
        cube([post_x, post_y, post_z], center = false);
        // Hole in Left Post: Square 10.4x10.4 through X, centred at z=150
        // The hole goes through the X dimension.
        // Post center in X is -45 - 5 = -50.
        // Hole center in X is -50.
        translate([-base_x/2 - post_x/2, 0, post_hole_z]) {
            cube([post_x + 0.1, post_hole_size, post_hole_size], center = true); // +0.1 to ensure cut goes through
        }
    }
    
    // Right Post: Flush with end face (+base_x/2), centred on y=0
    // Base X range: [-45, 45]. Right end is 45.
    // Post X range: [45, 45 + 10] = [45, 55].
    // Post Y range: [-8, 8] (centered on y=0, width 16).
    translate([base_x/2, -post_y/2, 0]) {
        cube([post_x, post_y, post_z], center = false);
        // Hole in Right Post
        // Post center in X is 45 + 5 = 50.
        translate([base_x/2 + post_x/2, 0, post_hole_z]) {
            cube([post_x + 0.1, post_hole_size, post_hole_size], center = true); // +0.1 to ensure cut goes through
        }
    }
}

// Part 2: Handle
// Lying on the bed along X, centred on x=0.
// Spans y = 55 to 65.
// 10mm gap to base's +Y face (base is 90mm wide, so +Y face is at y=45. 55-45=10mm gap).
translate([0, (handle_y_start + handle_y_end)/2, handle_z/2]) { // Center handle in Y and Z
    translate([-handle_x/2, -handle_y/2, -handle_z/2]) {
        cube([handle_x, handle_y, handle_z], center = false);
    }
}