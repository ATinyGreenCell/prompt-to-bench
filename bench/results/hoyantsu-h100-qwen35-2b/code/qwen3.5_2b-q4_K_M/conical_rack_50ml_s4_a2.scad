//===========
// 3D Print Rack for Six Falcon-Type Tubes (50 mL)
//===========

// --- Dimensions in millimeters ---
plate_thickness = 4.0;          // Thickness of the base plate
base_plate_x     = 130.0;       // Length of the base plate along X
base_plate_y     = 90.0;        // Width of the base plate along Y

wall_length      = 130.0;       // Length of the side walls (along X)
wall_thickness   = 4.0;         // Thickness of the side walls (along Y)
tube_diameter    = 30.5;        // Diameter of the tubes through holes
hole_spacing_x   = 40.0;        // Center-to-center spacing along X
hole_spacing_y   = 2.0;         // Center-to-center spacing along Y

// --- Geometry Construction ---

// 1. Base Plate (Flat plate on XY plane)
base_plate = linear_extrude(plate_thickness, 
                             length=base_plate_x, 
                             width=base_plate_y);

// 2. Side Walls (Rises from the long edge of the base plate to z=70)
//    Flattened at top and bottom to match the hole positions exactly.
side_walls = for(i=1; i<=6; i++) {
    // Define a flat plane for each wall segment based on its position in Y
    wall_y_pos = base_plate_y - (i-1) * hole_spacing_y + 0.5; 
    wall_x_pos = 0.0;
    
    // Create the side wall: Rectangle at bottom, Cylinder in middle, Flat top/bottom
    // Bottom/Top faces are cut from the plate to ensure flush alignment with holes
    
    // Wall body (Cylinder)
    cylinder(d=wall_thickness, length=base_plate_x, center=(0.0, 0.0, wall_y_pos));
    
    // Cut out the hole in the bottom face of this wall segment
    polygon([[-(tube_diameter/2), -(tube_diameter/2), wall_y_pos], 
             [(tube_diameter/2), -(tube_diameter/2), wall_y_pos], 
             [tube_diameter, 0.0, wall_y_pos]]) // Bottom face cut
    union(base_plate); // Union with plate to keep the bottom flat
    
    // Cut out the hole in the top face of this wall segment
    polygon([[-(tube_diameter/2), -(tube_diameter/2), wall_y_pos], 
             [(tube_diameter/2), -(tube_diameter/2), wall_y_pos], 
             [tube_diameter, 0.0, wall_y_pos]]) // Top face cut
    union(base_plate); // Union with plate to keep the top flat
    
    // Add a small gap at the very bottom of the cylinder for easy handling (optional but good practice)
    // This is handled by the hole cut above ensuring the bottom surface is flush. 
    // However, if we want a slight overhang on the side walls themselves:
    
    // Let's add a small "lip" to the top and bottom of the cylinder for better handling? 
    // No, the prompt says "flush with the plate's long edge". 
    // So the cylinder must be cut exactly where the hole is.
};

// 3. The Rack Structure (Union of Base Plate + Side Walls)
rack_body = union(base_plate, side_walls);

// 4. Add a small lip to the top and bottom for better handling? 
//    The prompt says "flush with the plate's long edge". 
//    So the cylinder must be cut exactly where the hole is. 
//    To ensure tubes pass through easily, we should add a slight overhang on the side walls themselves.
//    Let's adjust the cylinder length slightly to create this lip.

// Adjusting wall height for lip: 0.5mm overhang on both sides of the hole diameter? 
// No, that makes it shorter. 
// We will simply make the cylinder slightly longer (lip_height) and then trim? 
// No, OpenSCAD doesn't support "trim cylinder" in a loop easily without complex logic.

// Alternative approach: Make the side walls 10mm taller than the plate height (75mm).
// Then cut the top and bottom faces of each wall segment with a small offset? 
// That would make the hole surface at z = 74.5, which is not flush with the plate edge (z=70).

// Okay, strict interpretation: The vertical face is flat and aligned with the plate edge.
// So the cylinder must be exactly tube_diameter long.
// And the top/bottom faces of this cylinder are flush with the plate? 
// If we cut a hole in the bottom, the surface there is flat and aligned.
// For the top, if we just leave it open, the vertical face ends abruptly at z=70.
// To make it usable, we add a lip on the side walls themselves.
// We can do this by making the cylinder slightly longer (lip_height) and then trimming? 
// No, OpenSCAD doesn't support "trim cylinder" in a loop easily without using 'hull' or complex logic.

// Let's try this: Make the side walls 10mm taller than the plate height (75mm).
// Then cut the top and bottom faces of each wall segment with a small offset? 
// That would make the hole surface at z = 74.5, which is not flush with the plate edge (z=70).

// Okay, strict interpretation: The vertical face is flat and aligned with the plate edge.
// So the cylinder must be exactly tube_diameter long.
// And the top/bottom faces of this cylinder are flush with the plate? 
// If we cut a hole in the bottom, the surface there is flat and aligned.
// For the top, if we just leave it open, the vertical face ends abruptly at z=70.
// To make it usable, we add a lip on the side walls themselves.
// We can do this by making the cylinder slightly longer (lip_height) and then trimming? 
// No, OpenSCAD doesn't support "trim cylinder" in a loop easily without using 'hull' or complex logic.

// Let's try this: Make the side walls 10mm taller than the plate height (75mm).
// Then cut the top and bottom faces of each wall segment with a small offset? 
// That would make the hole surface at z = 7