// Part 1: Base block with tube seats and vertical posts
// Part 2: Handle bar to be slid through the posts

// --- DIMENSIONS PART 1 ---
base_x      = 90.0;    // Base length (X)
base_y      = 90.0;    // Base width (Y)
base_z      = 35.0;    // Base height (Z)

seat_d      = 30.5;    // Diameter of tube seat
seat_depth  = 30.0;    // Depth of tube seat
seat_floor  = 5.0;     // Remaining floor thickness (35 - 30)

post_x_thick = 10.0;   // Thickness of post along X
post_y_wide  = 16.0;   // Width of post along Y
post_z_top   = 160.0;  // Top surface of post at Z=160

hole_sq_d    = 10.4;   // Square hole dimension (X-axis through post)
hole_sq_z    = 150.0;  // Z-height of the square hole center

// --- DIMENSIONS PART 2 ---
handle_x     = 100.0;  // Length of handle (X)
handle_w     = 10.0;   // Width of handle (Y)
handle_h     = 10.0;   // Height of handle (Z)
handle_y_min  = 55.0;  // Y-position start (55 to 65)
handle_y_max  = 65.0;  // Y-position end

// --- CONSTANTS ---
$fn = 64;

// --- PART 1: BASE AND POSTS ---
module part_1() {
    difference() {
        union() {
            // The Base Block
            translate([-base_x/2, -base_y/2, 0])
                cube([base_x, base_y, base_z]);

            // Post 1 (at -X end)
            // Positioned flush with end face (-45) and centered on Y
            translate([-base_x/2, -post_y_wide/2, base_z])
                cube([post_x_thick, post_y_wide, post_z_top - base_z]);

            // Post 2 (at +X end)
            // Positioned flush with end face (+45) and centered on Y
            translate([base_x/2 - post_x_thick, -post_y_wide/2, base_z])
                cube([post_x_thick, post_y_wide, post_z_top - base_z]);
        }

        // Tube Seats (Blind holes)
        // Centers: x = -21, 21; y = -24, 24
        for (sx = [-21, 21], sy = [-24, 24]) {
            translate([sx, sy, base_z - seat_depth + 0.01])
                cylinder(h = seat_depth + 0.1, d = seat_d);
        }

        // Square holes through posts
        // The hole is centered at z = 150. 
        // It is a square 10.4 x 10.4.
        // It goes "straight through it along X".
        // We only subtract from the posts.
        
        // Hole in Post 1
        translate([-base_x/2 - 1, -post_y_wide/2 - 1, hole_sq_z - hole_sq_d/2])
            cube([post_x_thick + 2, post_y_wide + 2, hole_sq_d]);
            
        // Hole in Post 2
        translate([base_x/2 - post_x_thick - 1, -post_y_wide/2 - 1, hole_sq_z - hole_sq_d/2])
            cube([post_x_thick + 2, post_y_wide + 2, hole_sq_d]);
    }
}

// --- PART 2: HANDLE ---
module part_2() {
    // The handle is a 10x10 bar, 100mm long.
    // It lies on the bed (Z=0) along X.
    // It spans Y from 55 to 65.
    // Centered on X means X goes from -50 to 50.
    translate([-handle_x/2, handle_y_min, 0])
        cube([handle_x, handle_w, handle_h]);
}

// --- RENDERING ---
// Render Part 1
part_1();

// Render Part 2 (Offset for visibility in preview)
translate([0, 100, 0]) part_2();