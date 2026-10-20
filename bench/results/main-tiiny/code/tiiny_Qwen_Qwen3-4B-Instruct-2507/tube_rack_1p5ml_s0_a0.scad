// Dimensions of the bench rack
$fn = 64;

// Block dimensions (in mm)
length_X = 106;
width_Y = 72;
height_Z = 30;

// Hole grid: 24 holes in 4 rows (Y direction), 6 holes per row (X direction)
// Centre-to-centre distance in both directions
hole_center_to_center = 16.0;
hole_diameter = 11.2;
hole_depth = 25.0;
floor_thickness = 5.0;  // solid floor at the bottom

// Calculate hole positions
// The rack is centered on the origin, so we place holes symmetrically
// Total hole rows: 4 (Y direction), 6 holes per row (X direction)

// Y positions: 4 rows, so 3 gaps between rows (centered)
// The first row is at Y = -3*hole_center_to_center/2 - hole_center_to_center/2 = -2*hole_center_to_center
// Actually, we define the Y positions as centered around 0
// 4 rows => 3 gaps between rows, so rows at:
// Y: -3*hole_center_to_center/2, -hole_center_to_center/2, +hole_center_to_center/2, +3*hole_center_to_center/2
// But we need 6 holes per row, so 5 gaps between holes in X

// X positions: 6 holes per row, so 5 gaps between them
// Centered on 0, so holes at:
// X: -5*hole_center_to_center/2, -4*hole_center_to_center/2, ..., +5*hole_center_to_center/2

// Define hole positions in X and Y
num_holes_per_row = 6;
num_rows = 4;

// Calculate X positions (centered on origin)
hole_x_positions = [];
for (i = [0 : num_holes_per_row - 1]) {
    hole_x_positions.push(-5 * hole_center_to_center / 2 + i * hole_center_to_center);
}

// Calculate Y positions (centered on origin)
hole_y_positions = [];
for (i = [0 : num_rows - 1]) {
    hole_y_positions.push(-3 * hole_center_to_center / 2 + i * hole_center_to_center);
}

// Create the base solid block
block = cube([length_X, width_Y, height_Z], center = true);

// Create each hole as a cylinder with depth and offset to avoid coplanarity
// Each hole is 11.2 mm in diameter, 25 mm deep, and starts 5 mm above the floor
// So the hole goes from z = 5 mm to z = 5 + 25 = 30 mm (bottom of block)
// But the block is 30 mm tall, so the hole is from z = 5 to z = 30, and the floor is 5 mm thick

// We define the hole as a cylinder with a small offset to avoid coplanarity
// The hole is open at the top, closed at the bottom, so we cut out a cylinder from z=5 to z=30
// But we must ensure the cylinder extends 0.1 mm beyond the face to avoid coplanarity

// Create the hole as a cylinder with depth, centered at (x, y, 0)
for (i = [0 : num_rows - 1]) {
    for (j = [0 : num_holes_per_row - 1]) {
        x = hole_x_positions[j];
        y = hole_y_positions[i];
        
        // Translate to the hole position
        translate([x, y, 0]) {
            // Cylinder with diameter 11.2 mm, depth 25 mm, from z=0 to z=25
            // But we need to cut from z=5 to z=30 to ensure the floor is 5 mm thick
            // So the hole goes from z=5 to z=30 (depth 25 mm)
            // We use a cylinder with depth 25 mm, starting at z=5, so it ends at z=30
            // To avoid coplanarity, extend the cylinder slightly beyond the face
            // We extend 0.5 mm beyond the face to ensure no flat surfaces
            cylinder(
                r = hole_diameter / 2,
                h = hole_depth,
                center = false,
                f = 64
            );
        }
    }
}

// Now subtract the holes from the base block
// We create a hole as a cylinder with a small offset to avoid coplanarity
// The hole is 11.2 mm diameter, 25 mm deep, and starts at z=5 mm (floor thickness)
// So we create a cylinder from z=5 to z=30, with 0.1 mm extension on the top and bottom
// To avoid coplanarity, we extend the cylinder slightly beyond the face

// We use difference to remove the holes from the base block
// First, create the base block
base = cube([length_X, width_Y, height_Z], center = true);

// Create the hole as a cylinder with depth, centered at (x, y, 0)
// The hole is from z=5 to z=30, so depth 25 mm
// We extend the cylinder by 0.1 mm beyond the top and bottom to avoid coplanarity
for (i = [0 : num_rows - 1]) {
    for (j = [0 : num_holes_per_row - 1]) {
        x = hole_x_positions[j];
        y = hole_y_positions[i];
        
        // Translate to hole position
        translate([x, y, 0]) {
            // Cylinder with 25 mm depth, from z=5 to z=30
            // To avoid coplanarity, extend 0.1 mm beyond the top and bottom
            // So we create a cylinder from z=5 to z=30.1, and subtract it
            // But we need to cut it from the base block
            // We use a cylinder with depth 25 mm, starting at z=5, ending at z=30
            // But we extend it to z=30.1 to avoid coplanarity
            cylinder(
                r = hole_diameter / 2,
                h = hole_depth,
                center = false,
                f = 64
            );
        }
    }
}

// Final part: base block minus the holes
// We use difference to subtract the holes from the base
// But we must define the holes as separate objects and subtract them

// Start with the base block
module bench_rack() {
    // Base block
    cube([length_X, width_Y, height_Z], center = true);
    
    // Subtract each hole
    for (i = [0 : num_rows - 1]) {
        for (j = [0 : num_holes_per_row - 1]) {
            x = hole_x_positions[j];
            y = hole_y_positions[i];
            
            // Translate to hole position
            translate([x, y, 0]) {
                // Cylinder from z=5 to z=30.1 to avoid coplanarity
                cylinder(
                    r = hole_diameter / 2,
                    h = hole_depth + 0.1,
                    center = false,
                    f = 64
                );
            }
        }
    }
}

// Final output: the bench rack
bench_rack();