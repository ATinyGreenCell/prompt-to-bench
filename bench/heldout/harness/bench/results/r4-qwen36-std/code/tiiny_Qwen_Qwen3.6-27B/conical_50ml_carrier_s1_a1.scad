// Dimensions for Part 1: Base Block
base_x = 90;
base_y = 90;
base_z = 35;

// Dimensions for Part 1: Tube Seats
seat_dia = 30.5;
seat_depth = 30;
seat_floor = 5; // base_z - seat_depth
seat_x_pos = 21;
seat_y_pos = 24;

// Dimensions for Part 1: Posts
post_x = 10;
post_y = 16;
post_z = 160;
post_hole_x = 10.4;
post_hole_y = 10.4;
post_hole_z = 150;

// Dimensions for Part 2: Handle
handle_x = 100;
handle_y = 10;
handle_z = 10;
handle_y_start = 55;
handle_y_end = 65;

// Global settings
$fn = 64;

// --- Part 1: Base Block ---
// Centered on origin in X and Y, resting on z=0
difference() {
    // Main base block
    cube([base_x, base_y, base_z], center = true);
    
    // Four blind seats for 50 mL tubes
    for (sx = [-seat_x_pos, seat_x_pos]) {
        for (sy = [-seat_y_pos, seat_y_pos]) {
            translate([sx, sy, -base_z/2]) {
                cylinder(r = seat_dia / 2, h = seat_depth + 1, center = false);
            }
        }
    }
    
    // Two posts
    for (px = [-base_x/2 + post_x/2, base_x/2 - post_x/2]) {
        translate([px, 0, -base_z/2]) {
            cube([post_x, post_y, post_z], center = false);
            
            // Square hole through post along X axis
            // Hole is centered at z=150 relative to base bottom.
            // Post starts at z=0 (relative to base bottom).
            // So hole center is at z=150.
            // Hole extends 10.4mm in Y and 10.4mm in Z.
            translate([post_x/2, -post_hole_y/2, post_hole_z - post_hole_y/2]) {
                cube([post_x + 1, post_hole_y, post_hole_y + 1], center = false);
            }
        }
    }
}

// --- Part 2: Handle ---
// Lying on the bed along X, centred on x = 0
// Spans y = 55 to 65
translate([0, handle_y_start, 0]) {
    cube([handle_x, handle_y, handle_z], center = false);
}