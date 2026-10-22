// --- Dimensions for Part 1: Base Block and Posts ---

// Base block dimensions
base_size_x = 90; // mm
base_size_y = 90; // mm
base_height = 35; // mm

// Tube seat dimensions
tube_diameter = 30.5; // mm
tube_depth = 30; // mm
floor_thickness = 5; // mm

// Tube seat positions (relative to center)
seat_x1 = -21; // mm
seat_x2 = 21;  // mm
seat_y1 = -24; // mm
seat_y2 = 24;  // mm

// Post dimensions
post_thickness_x = 10; // mm (X dimension)
post_width_y = 16;    // mm (Y dimension)
post_height = 160;    // mm
hole_size = 10.4;     // mm
hole_diameter = 10.4; // mm

// Post hole position (centered along X, at Z=150)
hole_z_center = 150; // mm

// --- Dimensions for Part 2: Handle ---

handle_width = 10;  // mm
handle_height = 10; // mm
handle_length = 100; // mm

// Handle placement relative to base (+Y face)
handle_gap_y = 10; // mm (Gap from +Y face of base, which is at Y=45)
handle_center_x = 0; // mm

// --- Global Settings ---
$fn = 64;

// ======================================================================
// PART 1: BASE BLOCK AND POSTS
// ======================================================================

module part1() {
    difference() {
        // 1. Base Block (Solid)
        cube([base_size_x, base_size_y, base_height], center = true);

        // 2. Tube Seat Cutouts (4 holes)
        translate([0, 0, -floor_thickness]) { // Start cutting from the bottom surface
            for (i = [1:4]) {
                if (i == 1) { // Seat 1: (-X, -Y)
                    translate([seat_x1, seat_y1, 0])
                        cylinder(h = tube_depth + 1, r = tube_diameter / 2);
                } else if (i == 2) { // Seat 2: (+X, -Y)
                    translate([seat_x2, seat_y1, 0])
                        cylinder(h = tube_depth + 1, r = tube_diameter / 2);
                } else if (i == 3) { // Seat 3: (-X, +Y)
                    translate([seat_x1, seat_y2, 0])
                        cylinder(h = tube_depth + 1, r = tube_diameter / 2);
                } else { // Seat 4: (+X, +Y)
                    translate([seat_x2, seat_y2, 0])
                        cylinder(h = tube_depth + 1, r = tube_diameter / 2);
                }
            }
        }

        // 3. Posts (Two posts on X ends)
        // Post 1: Left side (-X end)
        translate([-base_size_x/2 - post_thickness_x/2, 0, 0]) {
            cube([post_thickness_x, post_width_y, post_height]);

            // Hole through Post 1 (along X axis)
            translate([hole_diameter/2 + 0.01, 0, hole_z_center - post_height/2]) {
                cube([hole_size - 0.02, post_width_y + 0.02, post_height]);
            }
        }

        // Post 2: Right side (+X end)
        translate([base_size_x/2 + post_thickness_x/2, 0, 0]) {
            cube([post_thickness_x, post_width_y, post_height]);

            // Hole through Post 2 (along X axis)
            translate([-hole_diameter/2 - 0.01, 0, hole_z_center - post_height/2]) {
                cube([hole_size - 0.02, post_width_y + 0.02, post_height]);
            }
        }

    }
}


// ======================================================================
// PART 2: HANDLE
// ======================================================================

module part2() {
    // The handle needs to span Y from (Base_Y_Max + Gap) to (Base_Y_Max + Gap + Handle_Height)
    // Base Max Y is base_size_y / 2 = 45 mm.
    // Start Y position: 45 + 10 = 55 mm
    // End Y position: 55 + 10 = 65 mm

    translate([handle_center_x, handle_gap_y, 0]) {
        cube([handle_length, handle_height, handle_width]);
    }
}


// ======================================================================
// FINAL ASSEMBLY (Rendered as two separate parts)
// ======================================================================

// Render Part 1: Base Block and Posts
color("gray") {
    part1();
}

// Render Part 2: Handle
color("blue") {
    part2();
}