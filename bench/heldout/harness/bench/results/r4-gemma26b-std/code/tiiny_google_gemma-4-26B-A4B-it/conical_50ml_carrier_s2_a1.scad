// --- Dimensions ---
// Part 1: Base Block
base_width = 90;          // X dimension of base
base_depth = 90;          // Y dimension of base
base_height = 35;         // Z dimension of base

// Tube Seats (Blind holes)
seat_dia = 30.5;          // Diameter of tube seats
seat_depth = 30;          // Depth of the seat cut
seat_floor = 5;           // Remaining floor thickness (35 - 30)
seat_x_pos = [ -21, 21 ]; // X coordinates of seats
seat_y_pos = [ -24, 24 ]; // Y coordinates of seats

// Posts
post_thickness = 10;      // X dimension of posts
post_width = 16;          // Y dimension of posts
post_height = 160;        // Z height of posts
post_hole_size = 10.4;    // Square hole dimension (X-axis through-hole)
post_hole_z = 150;        // Z center of the hole

// Part 2: Handle
handle_width = 10;        // X dimension of handle
handle_depth = 10;        // Y dimension of handle
handle_length = 100;      // X dimension of handle
handle_y_start = 55;      // Y start position
handle_y_end = 65;        // Y end position

// General
$fn = 64;

// --- Part 1: Base and Posts ---
module part_1() {
    // The base must rest on the bed at Z=0. 
    // Previously, cube(center=true) placed the base at Z = -17.5.
    // We must translate the whole assembly so the bottom of the base is at Z=0.
    
    // We use a union to group the base and posts, then translate the whole thing.
    // The base bottom is at Z=0, so the center of the base is at Z = base_height/2.
    translate([0, 0, base_height/2]) {
        difference() {
            // Main block
            cube([base_width, base_depth, base_height], center = true);
            
            // Tube Seats (Blind holes)
            // To ensure they are blind and don't cut through the bottom, 
            // we position them from the top face downwards.
            for (i = [0:1]) {
                for (j = [0:1]) {
                    // Translate to seat center. 
                    // Z position: top face is at base_height/2. 
                    // We move down by seat_depth/2 and add a small epsilon to ensure clean cut.
                    translate([seat_x_pos[i], seat_y_pos[j], -seat_depth/2 + 0.01])
                        cylinder(d = seat_dia, h = seat_depth + 0.02);
                }
            }
        }

        // Posts
        // Posts stand ON the base. Base top is at Z = base_height.
        // Post center Z = base_height + post_height/2.
        for (side = [-1, 1]) {
            translate([side * (base_width/2 - post_thickness/2), 0, base_height + post_height/2]) {
                difference() {
                    // Post body
                    cube([post_thickness, post_width, post_height], center = true);
                    
                    // Square hole through X axis
                    // The hole is centered at Z = 150 (absolute).
                    // In this local coordinate system, the hole center is at:
                    // local_z = 150 - (base_height + post_height/2)
                    // However, the prompt says "rise to z=160" and "centered at z=150".
                    // This implies the post's absolute Z range is [35, 195] if it rises to 160 from the base.
                    // Wait, "rise to z=160" usually means the top face is at Z=160.
                    // If base is 35 and post is 160, top is 195. 
                    // If top is 160, post height is 125.
                    // Re-reading: "rise to z=160" and "centered at z=150".
                    // This implies the post top is at 160 and bottom is at 35.
                    // Therefore, post_height = 160 - 35 = 125.
                    // Let's adjust post_height to match the Z=160 requirement.
                    
                    // Let's assume the post top is at Z=160.
                    // Local Z center of hole: 150 - base_height - (post_height/2)
                    // But to keep it simple and follow "centered at z=150", 
                    // we will place the hole at absolute Z=150.
                    
                    translate([0, 0, 150 - (base_height + post_height/2)])
                        rotate([0, 90, 0])
                            cube([post_thickness + 2, post_hole_size, post_hole_size], center = true);
                }
            }
        }
    }
}

// Corrected Part 1 logic to ensure Z=0 start and Z=160 top.
module part_1_fixed() {
    // Base
    translate([0, 0, base_height/2]) {
        difference() {
            cube([base_width, base_depth, base_height], center = true);
            for (i = [0:1]) {
                for (j = [0:1]) {
                    translate([seat_x_pos[i], seat_y_pos[j], -seat_depth/2 + 0.01])
                        cylinder(d = seat_dia, h = seat_depth + 0.02);
                }
            }
        }
    }
    
    // Posts: Base top is at Z=35. Top of post is at Z=160.
    // Height = 160 - 35 = 125.
    // Center of hole at Z=150.
    // Local center of hole = 150 - 35 - (125/2) = 150 - 35 - 62.5 = 52.5
    post_h = 160 - base_height;
    for (side = [-1, 1]) {
        translate([side * (base_width/2 - post_thickness/2), 0, base_height + post_h/2]) {
            difference() {
                cube([post_thickness, post_width, post_h], center = true);
                // Hole centered at absolute Z=150
                translate([0, 0, 150 - (base_height + post_h/2)])
                    rotate([0, 90, 0])
                        cube([post_thickness + 2, post_hole_size, post_hole_size], center = true);
            }
        }
    }
}

// --- Part 2: Handle ---
module part_2() {
    // Handle: 10x10x100. Lying on bed (Z=0 to 10).
    // Centered on X=0. Spans Y=55 to 65.
    // This means Y center is 60.
    // X range is -50 to 50.
    translate([0, 60, 5])
        cube([handle_length, handle_depth, handle_width], center = true);
}

// --- Rendering ---
// Part 1
part_1_fixed();

// Part 2 (Placed side by side on the bed)
// Part 1 Y max is 45. Part 2 Y is 55-65. 
// To avoid collision and ensure they are "side by side" for printing:
translate([0, 110, 0]) 
    part_2();