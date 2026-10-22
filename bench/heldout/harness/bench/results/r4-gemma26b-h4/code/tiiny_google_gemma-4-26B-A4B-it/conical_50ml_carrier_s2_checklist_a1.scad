// Part 1: Base Block with tube seats and posts
// Part 2: Handle Bar

// --- Dimensions Part 1 ---
base_x      = 90.0;    // Base length (X)
base_y      = 90.0;    // Base width (Y)
base_z      = 35.0;    // Base height (Z)

seat_d      = 30.5;    // Diameter of tube seats
seat_depth  = 30.0;    // Depth of tube seats
seat_floor  = 5.0;     // Remaining floor thickness

seat_x_pos  = 21.0;    // X offset for seats
seat_y_pos  = 24.0;    // Y offset for seats

post_x_thick = 10.0;   // Thickness of posts (X direction)
post_y_wide  = 16.0;   // Width of posts (Y direction)
post_z_high  = 160.0;  // Total height of posts (Z)

hole_size   = 10.4;    // Square hole size (X-axis through posts)
hole_z_pos  = 150.0;   // Z height of the hole center

// --- Dimensions Part 2 ---
handle_x    = 100.0;   // Length of handle (X)
handle_y    = 10.0;    // Width of handle (Y)
handle_z    = 10.0;    // Height of handle (Z)
handle_y_gap = 10.0;   // Gap between base +Y face and handle (Y direction)

// Calculated positions
handle_y_start = (base_y / 2) + handle_y_gap;

$fn = 64;

// --- MODULE: PART 1 ---
module part_1() {
    difference() {
        // The main body (Base + Posts)
        union() {
            // Main Base Block
            translate([-base_x/2, -base_y/2, 0])
                cube([base_x, base_y, base_z]);
            
            // Post 1 (at -X end, flush with end face)
            // End face is at -45. Post thickness 10. Post goes from -45 to -35.
            translate([-base_x/2, -post_y_wide/2, base_z])
                cube([post_x_thick, post_y_wide, post_z_high - base_z]);
            
            // Post 2 (at +X end, flush with end face)
            // End face is at 45. Post thickness 10. Post goes from 35 to 45.
            translate([base_x/2 - post_x_thick, -post_y_wide/2, base_z])
                cube([post_x_thick, post_y_wide, post_z_high - base_z]);
        }

        // Tube Seats (Blind holes)
        for (sx = [-seat_x_pos, seat_x_pos]) {
            for (sy = [-seat_y_pos, seat_y_pos]) {
                // Subtracting from the base. 
                // We place the cylinder so it cuts into the base from the top.
                translate([sx, sy, base_z - seat_depth + 0.01])
                    cylinder(h = seat_depth, d = seat_d);
            }
        }

        // Square holes through posts
        // The hole is centered at hole_z_pos and goes through the posts along X.
        // We create a cube that is wider than the posts to ensure a clean cut.
        // The posts are located at X = [-45, -35] and X = [35, 45].
        // To cut through both, we can use two separate cubes or one long one.
        // A single long one is safer for the boolean operation.
        translate([-base_x/2 - 1, -post_y_wide/2 - 1, hole_z_pos - hole_size/2])
            cube([base_x + 2, post_y_wide + 2, hole_size]);
    }
}

// --- MODULE: PART 2 ---
module part_2() {
    // Handle is a square bar 10x10, 100 long, centered on X.
    // Spans Y from 55 to 65.
    translate([-handle_x/2, handle_y_start, 0])
        cube([handle_x, handle_y, handle_z]);
}

// --- RENDERING ---
// To view Part 1:
part_1();

// To view Part 2 (uncomment below and comment part_1 above to see separately):
// translate([0, 100, 0]) part_2();