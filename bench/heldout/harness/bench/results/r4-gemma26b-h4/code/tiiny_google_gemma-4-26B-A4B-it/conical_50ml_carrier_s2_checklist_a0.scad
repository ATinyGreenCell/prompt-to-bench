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
// Base +Y face is at Y = 45. Handle spans Y = 55 to 65.
handle_y_start = (base_y / 2) + handle_y_gap;
handle_y_end   = handle_y_start + handle_y;

$fn = 64;

// --- MODULE: PART 1 ---
module part_1() {
    difference() {
        union() {
            // Main Base Block
            translate([-base_x/2, -base_y/2, 0])
                cube([base_x, base_y, base_z]);
            
            // Post 1 (at -X end)
            translate([-base_x/2, -post_y_wide/2, base_z])
                cube([post_x_thick, post_y_wide, post_z_high - base_z]);
            
            // Post 2 (at +X end)
            translate([base_x/2 - post_x_thick, -post_y_wide/2, base_z])
                cube([post_x_thick, post_y_wide, post_z_high - base_z]);
        }

        // Tube Seats (Blind holes)
        // Seats are centered at x = +/- 21, y = +/- 24
        // We use a loop to define the 4 positions
        for (sx = [-seat_x_pos, seat_x_pos]) {
            for (sy = [-seat_y_pos, seat_y_pos]) {
                translate([sx, sy, base_z - seat_depth + 0.01])
                    cylinder(h = seat_depth, d = seat_d);
            }
        }

        // Square holes through posts
        // Hole is centered at z = 150. 
        // Post 1 is at X = [-45, -35]. Post 2 is at X = [35, 45].
        // We cut through the whole block width to ensure clean holes.
        translate([-base_x/2 - 1, -post_y_wide/2 - 1, hole_z_pos - hole_size/2])
            cube([base_x + 2, post_y_wide + 2, hole_size]);
    }
}

// --- MODULE: PART 2 ---
module part_2() {
    // Handle is a square bar 10x10, 100 long, centered on X.
    // It spans Y from 55 to 65.
    // In OpenSCAD, to center on X, we use -50 to 50.
    // To place Y from 55 to 65, we translate by (55 - 90/2) = 10.
    // Wait, the prompt says "10mm gap to the base's +Y face".
    // Base +Y face is at 45. So handle Y starts at 45 + 10 = 55.
    // Handle Y center is 60.
    
    translate([-handle_x/2, handle_y_start, 0])
        cube([handle_x, handle_y, handle_z]);
}

// --- RENDERING ---
// To view Part 1:
part_1();

// To view Part 2 (uncomment below and comment part_1 above to see separately):
// translate([0, 100, 0]) part_2();