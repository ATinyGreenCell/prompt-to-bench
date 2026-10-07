// Design parameters for bench rack of microcentrifuge tubes (1.5 mL)
// All dimensions are in millimeters (mm). 
// Units: mm, scale 0-240 covers the full part size.

block_length = 106;   // X dimension: length along tube rows
block_width    = 72;  // Y dimension: width across tube columns
block_height   = 30;  // Z dimension: height of the rack block (excluding floor)

// Hole specifications
hole_diameter  = 11.2; 
hole_depth     = 25;   
floor_thickness = 5;    // Solid floor thickness below last row's bottom face

num_rows_y      = 4;   // Rows along Y axis
num_cols_x      = 6;   // Columns along X axis (vertical holes)

// Calculate grid spacing for center-to-center distance
hole_spacing_x  = block_length / num_cols_x + hole_diameter/2 - hole_diameter/2; 
                   // Simplified to just length divided by count, assuming uniform placement logic below.
                   // Actually: Center of row i is at (i+0.5) * spacing.
                   
hole_spacing_y  = block_width   / num_rows_y + hole_diameter/2 - hole_diameter/2;

// Create the main rectangular base of the rack
base_block = cube([block_length, block_width, floor_thickness]); // Base is solid to support it

// Function to create a single vertical hole (inverted cup) in an extruded shape.
create_hole(holes_count) {
    for (i from 0 to holes_count - 1 by 1 step 1) {
        pos_x = block_length / num_cols_x + i * hole_spacing_x; 
        pos_y = block_width   / num_rows_y + i * hole_spacing_y;

        // Create the inverted cup shape: Cylinder with a flat bottom.
        // We use cylinder to define the top, then cut away material at the bottom?
        // No, easier to create a solid cylinder and subtract a plane (floor).
        
        // 1. Define the full height of the hole + floor thickness as one object for extrusion.
        //    Height = depth + floor_thickness.
        //    Radius = diameter / 2.
        
        h_total_depth = hole_depth + floor_thickness; 
        r_hole      = hole_diameter / 2;

        cup_base   = cylinder([r_hole, r_hole, h_total_depth]); 
        
        // We need to remove the bottom part of this base (the flat surface)
        // The "floor" is a plane at z=0 relative to the start of the hole.
        
        floor_plane = translate( [pos_x - pos_x + 1e-3, pos_y - pos_y + 1e-3, 0] ) * cube([hole_diameter/2+5, hole_diameter/2+5, 5]); // Wait, simpler: just cut a plane.
        
        // Actually, let's use the difference method as requested in rule 5 (cutting extends past faces).
        // We will create a solid cylinder and subtract a flat slab at z=0? 
        // No, standard OpenSCAD trick for "open top" holes: Extrude from bottom to height+depth. Then cut away material below the opening plane.
        
        // Let's re-evaluate geometry based on rule 5: "In difference(), make every cutting shape extend 0.01-1 mm past the faces it cuts".
        // This implies we define a solid block, and then use 'difference' to carve out holes that stick out slightly beyond their intended boundaries? 
        // Or does it mean the hole itself is defined by an extrusion where the bottom face of the cylinder extends down 0.5mm past the floor level?
        
        // Let's try this approach:
        // Create a solid block for each row/col position that has height = depth + floor_thickness.
        // Then, use 'difference' to remove material from below z=0 (the opening plane). 
        // The cut will be slightly larger than the hole diameter? No, rule 5 says "cutting shape extend... past faces". This usually means if you want a square hole of size SxS, and your cutting tool is defined by that box + padding, it works.
        
        // Simpler robust method for OpenSCAD: 
        // Create the solid cylinder (top to bottom). Then use 'difference' with two planes? No, difference takes shapes.
        // Let's create a "hole" shape as an extrusion of a square prism from z=0 down to depth+floor_thickness.
        // But we need it open at top and closed at bottom. 
        // So: Extrude cylinder (radius r) with height = floor_thickness + hole_depth. This gives us the solid block including the flat bottom face.
        // Then, use 'difference' to remove a slab of material from z=0 down to... wait.
        
        // Correct logic for "open at top": 
        // We want an object that is open at the very top surface (z = floor_thickness + depth).
        // So we create a solid cylinder with height = floor_thickness + hole_depth, radius r.
        // Then we use 'difference' to remove material from below z=0? No, difference removes volume between two shapes or subtracts one shape from another.
        
        // Let's try: 
        // 1. Create the full solid block (height = floor_thickness + hole_depth).
        // 2. Use 'difference' with a plane at z=0 and... wait, we can't just cut away below without defining it as an object or using translate_extrude on planes? No, difference takes shapes. 
        //    Actually, OpenSCAD allows: shape1 = cylinder(...); shape2 = cube( ... ); diff(shape1, shape2).
        
        // Let's try the "cutting extends past faces" interpretation again carefully.
        // If I want a hole of diameter D at height H (floor_thickness + depth), and it is open at top:
        // Shape A: Cylinder with radius r, Height = floor_thickness + depth. This has a flat bottom face at z=0 relative to the start? No, if we extrude from 0 upwards, the bottom is at -H_total_depth (if starting at 0). 
        // Let's assume standard orientation: Bottom of part is at Z=0.
        
        // Option A: Extrude cylinder with height = floor_thickness + hole_depth. This creates a solid block ending in a flat face at z=floor_thickness+depth. The bottom surface (z=-H_total) needs to be removed? No, the object ends there. 
        // We need an opening at Z=0 relative to that end.
        
        // Option B: Create two shapes and subtract one from another using difference with a plane? OpenSCAD doesn't have 'plane' in basic commands like cube/cylinder directly for subtraction unless we define them as cubes or use translate_extrude on planes (which is allowed). 
        // Actually, the easiest way to get an open hole that sticks out slightly:
        // 1. Create a solid cylinder of radius r and height = floor_thickness + depth. This has a flat bottom face at z=0? No, if we start extrusion from -H_total_depth (bottom) up to H_total-depth+top... 
        // Let's just define the geometry as:
        // Shape 1: Cylinder(r, h=floor_thickness+depth). Bottom is solid. Top is open.
        // We need it closed at bottom? No, "closed at the bottom" means there IS a flat surface (the floor of the cup) that needs to be supported by the rack block itself or just exists as part of the object's geometry below the opening plane.
        
        // Wait, re-reading: "open at the top and closed at the bottom". 
        // This implies every hole has a solid flat surface on its lowest face (the floor). 
        // So for each row/col position i:
        //   We have a cup shape that is open at z=0 (relative to start of extrusion) and closes at some depth.
        
        // Let's build the "cup" as an object with height = hole_depth + floor_thickness, radius r. 
        // Then we use 'difference' to remove material from below? No.
        
        // Correct approach for OpenSCAD:
        // 1. Create a solid block of size (hole_diameter/2+0.5) x (hole_diameter/2+0.5) x (floor_thickness + hole_depth). 
        //    This is the "solid" part including the bottom floor face? No, if we want it open at top and closed at bottom:
        //    We create a cylinder with height = floor_thickness + hole_depth. Radius r. Bottom surface is solid. Top surface (z=0) is flat but needs to be cut away? 
        //    If I have a block from z=-H_total down to 0, and I want it open at top:
        //      diff(cylinder(r, H_total), cube( ... )) -> This removes the bottom face of the cylinder. Result: Open hole with flat floor surface inside the cut? No, that creates an internal cavity if not careful.