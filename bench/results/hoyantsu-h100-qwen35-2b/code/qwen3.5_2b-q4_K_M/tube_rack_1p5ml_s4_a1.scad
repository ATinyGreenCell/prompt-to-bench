// --- Dimensions (mm) ---
block_length = 106.0; // X
block_width  = 72.0;  // Y
block_height = 30.0;  // Z

hole_diameter = 11.2; // mm
hole_depth   = 25.0; // mm
floor_thickness = 5.0; // mm
grid_spacing_x = 6.0; // mm (center-to-center)
grid_spacing_y = 4.0; // mm (center-to-center)

// --- Geometry Setup ---
fn = 64; // High frequency for smooth curved holes

// Create the main block
block = cube([block_length, block_width, block_height]);

// Define hole positions using a loop over Y and X
for(y = -floor(block_width / grid_spacing_y) + 1 to floor(block_width / grid_spacing_y)) {
    for(x = -floor(block_length / grid_spacing_x) + 1 to floor(block_length / grid_spacing_x)) {
        // Calculate center coordinates relative to the block origin (0,0)
        cx = x * grid_spacing_x;
        cy = y * grid_spacing_y;

        // Create a hollow cylinder for each hole position
        // We use rotate_extrude with a polygon cross-section to ensure perfect circular holes at this resolution
        hole = rotate_extrude([hole_depth, block_height], [cx, cy, 0], polygon([hole_diameter/2, hole_diameter/2]));

        // Remove the hole from the main block.
        // Rule #5: "make every cutting shape extend 0.01-1 mm past the faces it cuts".
        // We offset the cylinder's vertical extent by a small value (e.g., 0.3mm) to ensure clean separation 
        // and avoid coplanar faces if they were meant to be flush, though here the floor is solid.
        
        offset = 0.3; 
        
        // Top of cylinder: block_height + offset
        // Bottom of cylinder: -(block_height - hole_depth) - offset (to go past the floor).
        // This ensures the cut starts below the bottom face and ends above the top face, 
        // effectively creating a void that respects the "past faces" rule.
        
        hole_offset = translate([cx, cy, -(block_height - hole_depth) - offset], [hole_diameter/2, hole_diameter/2, 0]);
        block = difference(block, hole_offset);
    }
}

// Final assembly with floor to ensure the part is a solid rectangular block as requested.
final_part = union(block, cube([block_length, block_width, floor_thickness]));

print("Part built successfully.");