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
// Base max Y is 90/2 = 45. Gap of 10mm means handle starts at Y=55.
handle_gap_y = 10; // mm (Gap from +Y face of base, which is at Y=45)
handle_center_x = 0; // mm

// --- Global Settings ---
$fn = 64;

// ======================================================================
// PART 1: BASE BLOCK AND POSTS
// ======================================================================

module part1() {
    difference() {
        // 1. Base Block (Solid) - Centered on origin, Z=0 to Z=35
        cube([base_size_x, base_size_y, base_height], center = true);

        // 2. Tube Seat Cutouts (4 holes)
        // The floor is at Z = -floor_thickness/2 = -2.5 if centered on Z=0.
        // Since the base block starts at Z=-17.5 and ends at Z=17.5, the bottom face is at Z=-17.5.
        // We want a 5mm floor (Z from -17.5 to -12.5). The cut must go through this.
        // Cut starts slightly below the base bottom (-18.0) and goes deep enough.
        translate([0, 0, -base_height/2 - 1]) { // Start cutting below the lowest point of the block
            for (i = [1:4]) {
                if (i == 1) { // Seat 1: (-X, -Y)
                    // Center at Z=0 relative to the cut origin. Tube depth is 30mm.
                    translate([seat_x1, seat_y1, 0])
                        cylinder(h = tube_depth + 2, r = tube_diameter / 2); // Extend slightly past floor/base
                } else if (i == 2) { // Seat 2: (+X, -Y)
                    translate([seat_x2, seat_y1, 0])
                        cylinder(h = tube_depth + 2, r = tube_diameter / 2);
                } else if (i == 3) { // Seat 3: (-X, +Y)
                    translate([seat_x1, seat_y2, 0])
                        cylinder(h = tube_depth + 2, r = tube_diameter / 2);
                } else { // Seat 4: (+X, +Y)
                    translate([seat_x2, seat_y2, 0])
                        cylinder(h = tube_depth + 2, r = tube_diameter / 2);
                }
            }
        }

        // 3. Posts (Two posts on X ends)
        // The base block is centered at Z=0 and has height 35mm (-17.5 to 17.5).
        // Posts rise from the top face of the base (Z = 17.5) up to Z = 17.5 + 160 = 177.5.
        // Since we are centering everything on origin, the posts must be centered vertically around Z=0 for simplicity in modeling,
        // but they must sit flush on the base top (Z=17.5).

        // Post 1: Left side (-X end)
        translate([-base_size_x/2 - post_thickness_x/2, 0, base_height/2]) { // Start at Z = 17.5
            cube([post_thickness_x, post_width_y, post_height]);

            // Hole through Post 1 (along X axis)
            // The hole is centered at Z=150 relative to the base center (Z=0).
            translate([hole_diameter/2 + 0.01, 0, hole_z_center - base_height/2]) { // Adjust Z offset: 150 - 17.5 = 132.5 from post bottom
                cube([hole_size - 0.02, post_width_y + 0.02, post_height]);
            }
        }

        // Post 2: Right side (+X end)
        translate([base_size_x/2 + post_thickness_x/2, 0, base_height/2]) { // Start at Z = 17.5
            cube([post_thickness_x, post_width_y, post_height]);

            // Hole through Post 2 (along X axis)
            translate([-hole_diameter/2 - 0.01, 0, hole_z_center - base_height/2]) { // Adjust Z offset: 150 - 17.5 = 132.5 from post bottom
                cube([hole_size - 0.02, post_width_y + 0.02, post_height]);
            }
        }

    }
}


// ======================================================================
// PART 2: HANDLE
// ======================================================================

module part2() {
    // Base max Y is base_size_y / 2 = 45 mm.
    // Handle starts at Y = 45 + handle_gap_y = 55 mm.
    // The handle must be centered on X=0, and its length is 100mm (X direction).

    translate([handle_center_x, base_size_y/2 + handle_gap_y - handle_height/2, 0]) {
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