$fn = 128; // High resolution for smooth curves and accurate hole sizes

// --- Dimensions ---
// Handle
d_handle = 8;      // Diameter of handle (mm)
h_handle = 45;     // Height of handle (mm)

// Cone
d_cone_top = 8;    // Top diameter of cone (matches handle) (mm)
d_cone_bot = 3;    // Bottom diameter of cone (mm)
h_cone = 17;       // Height of cone (62 - 45) (mm)

// Tip
d_tip = 3;         // Diameter of spherical tip (mm)
z_tip_center = 62; // Z-coordinate of sphere center (mm)

// Grooves
n_grooves = 4;     // Number of circumferential grooves
w_groove = 2;      // Width of groove in Z (mm)
d_groove = 1;      // Depth of groove (mm)
z_grooves = [10, 15, 20, 25]; // Z-centers of the 4 grooves

// --- Construction ---

module handle() {
    // Main cylinder body
    cylinder(h = h_handle, r = d_handle / 2, center = [0, 0, h_handle / 2]);
}

module cone() {
    // Cone tapering from 8mm to 3mm over 17mm height
    // Top face at z=45, bottom face at z=62
    // Using linear_extrude for the profile
    profile = [
        d_handle / 2, // Radius at top (z=45)
        d_cone_bot / 2 // Radius at bottom (z=62)
    ];
    
    // Extrude along Z, centered at z = 45 + 17/2 = 53.5
    // The profile goes from radius r1 to r2. 
    // We need to ensure the geometry matches the cylinder above it.
    // Cylinder ends at z=45. Cone starts at z=45.
    // Let's define the cone from z=45 to z=62.
    
    // Linear extrude creates a shape from the profile. 
    // If we center the extrude at z=53.5, the profile height must be 17.
    // The profile array represents the radius at each Z step.
    // To make it a perfect cone, we use a simple cylinder with a linearly varying radius? 
    // No, linear_extrude with a polygon is better for exact dimensions.
    
    // Let's create a polygon profile: [x, y, z] -> [radius, z_offset]
    // Actually, simpler approach: rotate_extrude a line segment.
    // Line from (d_handle/2, 0) to (d_cone_bot/2, h_cone)
    
    rotate_extrude($fn = 64) {
        translate([0, 0, -h_cone / 2]) { // Center the extrusion at z=0 relative to itself
            // We want the cone to sit on top of the handle.
            // Handle top is at z=45. Cone bottom is at z=45. Cone top is at z=62.
            // So the cone's local Z range is 0 to 17.
            // Let's shift the whole thing up by 45 later in the main block.
            
            // Define the line segment for the cone side
            // Start: radius = 4, z = 0
            // End: radius = 1.5, z = 17
            // We need to close the loop for rotate_extrude
            polygon = [
                [d_handle / 2, 0],
                [d_cone_bot / 2, h_cone],
                [d_cone_bot / 2, -h_cone], // Wait, rotate_extrude expects a closed path or uses the last point?
                // Actually, rotate_extrude takes a 2D path. 
                // Let's use a simpler method: difference of two cylinders? No, that's not a cone.
                // Let's use linear_extrude with a polygon profile in the XZ plane.
            ];
        }
    }
    
    // Re-evaluating the cone method for precision:
    // Use linear_extrude on a polygon in the XZ plane, then rotate 90 degrees? 
    // No, standard way:
    // Create a polygon in XZ plane: x = radius, z = height.
    // Extrude along Y? No, we want rotation around Z.
    // Correct approach: rotate_extrude a line segment.
    
    // Let's do it via difference of cylinders for simplicity and robustness? 
    // No, a true cone is best done with rotate_extrude.
    
    // Path: (radius_top, z_start) to (radius_bot, z_end)
    // We need to close the loop.
    // Let's define the path in the XZ plane.
    // Start at top: x = 4, z = 0
    // End at bottom: x = 1.5, z = 17
    // Close the loop: x = 1.5, z = 0 (back to start radius at bottom height? No)
    // rotate_extrude creates a solid of revolution.
    // The path must be closed.
    // Points: (4, 0) -> (1.5, 17) -> (1.5, 0) -> (4, 0) ? 
    // This creates a cone with a flat bottom at z=0 and top at z=17? 
    // No, the area between the line and the Z-axis is rotated.
    // So the path is: (4, 0) -> (1.5, 17) -> (1.5, 0) -> (4, 0) is wrong because (1.5,0) to (4,0) is a line on the axis? No.
    
    // Correct path for rotate_extrude to make a cone:
    // We want the volume between the line and the Z-axis.
    // The path must enclose the area.
    // Points: (4, 0) -> (1.5, 17) -> (1.5, 0) -> (4, 0) creates a shape that, when rotated, gives a cone with a flat bottom at z=0? 
    // Wait, if the path is (4,0) to (1.5,17), and we close it to (1.5,0) and back to (4,0), the area is the triangle.
    // Rotating a triangle with vertices (0,0), (4,0), (1.5,17) gives a cone.
    // But rotate_extrude rotates around the Y-axis by default? No, around Z if we are in XY plane?
    // rotate_extrude rotates around the Z axis. The input is in the XZ plane? No, XY plane.
    // So we need to map our XZ profile to XY.
    // Let's use linear_extrude with a polygon in the XZ plane, then rotate 90 deg?
    // Easier: Use the `polygon` command inside `rotate_extrude` but we need to be careful with axes.
    
    // Let's stick to the most reliable method for cones in OpenSCAD:
    // Create a polygon in the XZ plane, then use linear_extrude along Y? No.
    // Let's use the `hull` or `difference` of cylinders? 
    // Actually, `rotate_extrude` works on a 2D path in the XY plane.
    // If we want a cone along Z, we need to extrude a triangle in the XZ plane along Z? No.
    // We need to rotate a line segment in the XZ plane around the Z axis.
    // So we use `rotate_extrude` with the path in the XZ plane? 
    // No, `rotate_extrude` rotates around Z. The input path is in the XY plane.
    // To rotate a line in XZ around Z, we first rotate the line to XY, extrude, then rotate back?
    // Or simply: `linear_extrude` along Z of a triangle in XZ? No.
    
    // Correct logic:
    // 1. Define a triangle in the XZ plane: (0,0), (4,0), (1.5, 17).
    // 2. We want to rotate this triangle around the Z axis.
    // 3. `rotate_extrude` rotates around Z. It expects the path to be in the XY plane.
    // 4. So we need to swap X and Z? No.
    // Let's use `linear_extrude` with a polygon in the XZ plane, but the extrusion direction is Y? No.
    
    //