// Part 1: Base block with tube seats and vertical posts
// Part 2: Handle bar to be slid through the posts

// --- Dimensions Part 1 ---
base_x      = 90;    // Base length (X)
base_y      = 90;    // Base width (Y)
base_z      = 35;    // Base height (Z)

seat_d      = 30.5;  // Diameter of tube seats
seat_depth  = 30;    // Depth of tube seats
seat_floor  = 5;     // Remaining floor thickness (35 - 30)

seat_x_pos  = 21;    // X offset for seats
seat_y_pos  = 24;    // Y offset for seats

post_x_thick = 10;   // Thickness of posts (X dimension)
post_y_wide  = 16;   // Width of posts (Y dimension)
post_z_total  = 160; // Total height from Z=0

hole_sq_d    = 10.4; // Square hole dimension
hole_sq_z    = 150;  // Z height of the square hole center

// --- Dimensions Part 2 ---
handle_x     = 100;  // Length of handle (X)
handle_w     = 10;   // Width of handle (Y)
handle_h     = 10;   // Height of handle (Z)
handle_y_min  = 55;  // Y position start (55 to 65)
handle_y_max  = 65;

$fn = 64;

// --- Part 1: Base and Posts ---
module part_1() {
    difference() {
        union() {
            // Main Base Block
            translate([-base_x/2, -base_y/2, 0])
                cube([base_x, base_y, base_z]);
            
            // Post 1 (at -X end)
            // Positioned flush with end faces: X from -45 to -35
            translate([-base_x/2, -post_y_wide/2, base_z])
                cube([post_x_thick, post_y_wide, post_z_total - base_z]);
            
            // Post 2 (at +X end)
            // Positioned flush with end faces: X from 35 to 45
            translate([base_x/2 - post_x_thick, -post_y_wide/2, base_z])
                cube([post_x_thick, post_y_wide, post_z_total - base_z]);
        }

        // Tube Seats (Blind holes)
        // Seats are centered at x = +/- 21, y = +/- 24
        for (sx = [-seat_x_pos, seat_x_pos]) {
            for (sy = [-seat_y_pos, seat_y_pos]) {
                // Subtract 0.01 to ensure clean cut through the top face
                translate([sx, sy, base_z - seat_depth + 0.01])
                    cylinder(h = seat_depth + 0.01, d = seat_d);
            }
        }

        // Square holes through posts
        // Centered at z = 150.
        // Post 1 X range: [-45, -35]. Post 2 X range: [35, 45].
        // We use a large cube to ensure it cuts through the posts completely.
        
        // Hole 1 (Left Post)
        translate([-base_x/2 - 1, -hole_sq_d/2, hole_sq_z - hole_sq_d/2])
            cube([post_x_thick + 2, hole_sq_d, hole_sq_d]);
            
        // Hole 2 (Right Post)
        translate([base_x/2 - post_x_thick - 1, -hole_sq_d/2, hole_sq_z - hole_sq_d/2])
            cube([post_x_thick + 2, hole_sq_d, hole_sq_d]);
    }
}

// --- Part 2: Handle ---
module part_2() {
    // The handle is a 10x10x100 bar.
    // Centered on X (0), and spans Y from 55 to 65.
    // It lies on the bed (Z=0).
    translate([-handle_x/2, handle_y_min, 0])
        cube([handle_x, handle_w, handle_h]);
}

// --- Rendering ---
// Render Part 1
part_1();

// Render Part 2 (Offset for visibility)
translate([0, 100, 0]) part_2();