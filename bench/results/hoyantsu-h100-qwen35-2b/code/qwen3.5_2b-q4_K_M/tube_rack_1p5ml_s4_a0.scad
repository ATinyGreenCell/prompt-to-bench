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

        // Remove the hole from the main block
        // Note: The requirement states "extend 0.01-1 mm past the faces". 
        // Since we are cutting a cylinder through the solid, the default behavior of difference() 
        // usually cuts exactly at the face unless specified otherwise or if using specific extrusion offsets.
        // To strictly follow rule #5 ("make every cutting shape extend 0.01-1 mm past the faces"),
        // we must explicitly offset the cylinder's height so it sits slightly below and above the block surface.
        
        // Offset calculation: 
        // We want the hole to be open at top (z=block_height) and bottom (z=block_height - hole_depth).
        // The cut starts at z = block_height + floor(hole_depth/2) - offset_top? No, simpler logic:
        // The cylinder extends from z = -offset_bottom to z = +offset_top.
        // We want the solid part of the cylinder to be from z=0 (floor) to z=block_height-floor_thickness.
        // So the cylinder should span from z = -(block_height - floor(hole_depth/2)) to z = +(block_height). 
        // Wait, let's re-evaluate "extend past faces".
        // Usually, this means the cut starts 0.5mm below the top face and ends 0.5mm above the bottom face? Or just slightly beyond?
        // Rule #5 says: "make every cutting shape extend 0.01-1 mm past the faces it cuts".
        // This implies we should offset the cylinder's vertical extent by a small amount (e.g., 0.2 or 0.3mm) to ensure clean separation and avoid coplanar faces if they were meant to be flush, though here the floor is solid.
        // Let's assume "past the face" means extending slightly below the top surface of the block and slightly above the bottom surface of the hole (which is the floor).
        
        // Cylinder parameters:
        // Height = block_height + floor(hole_depth/2) - 0.5? No, that would be weird.
        // Let's define the cylinder to go from z = -(block_height - floor(hole_depth/2)) to z = +(block_height). 
        // Actually, simpler: The hole is a void. We want the material removed to be the space between z=0 and z=block_height-floor_thickness.
        // So the cylinder should span from z = -(block_height - floor(hole_depth/2) + 0.5?) No.
        
        // Correct logic for "open at top, closed at bottom":
        // Top face of block is at Z = block_height. Bottom face of hole (floor) is at Z = block_height - hole_depth.
        // We want the cylinder to cut through this range.
        // To satisfy rule #5 ("extend 0.01-1 mm past faces"), we will offset the cylinder's top and bottom by a small value, say 0.2mm (or 0.3mm). 
        // Let's use 0.3mm to be safe and ensure no coplanar faces if any logic shifts slightly.
        
        offset = 0.3; 
        
        // Top of cylinder: block_height + offset
        // Bottom of cylinder: -(block_height - hole_depth) - offset? 
        // Wait, the floor is at block_height - hole_depth. The cylinder must start below this floor and end above it.
        // So bottom = -(block_height - hole_depth) - offset (to go past the floor).
        // Top = block_height + offset (to go past the top face).
        
        // Let's verify: 
        // Block height 30. Hole depth 25. Floor at 5mm from bottom.
        // Cylinder Bottom: -(30 - 25) - 0.3 = -4.7 mm. (Below floor by 0.3mm). Correct.
        // Cylinder Top: 30 + 0.3 = 30.3 mm. (Above top face by 0.3mm). Correct.
        
        hole_offset = translate([cx, cy, -(block_height - hole_depth) - offset], [hole_diameter/2, hole_diameter/2, 0]);
        block = difference(block, hole_offset);
    }
}

// Final assembly with floor
final_part = union(block, cube([block_length, block_width, floor_thickness]));

print("Part built successfully.");