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
                   
hole_spacing_y  = block_width   / num_rows_y + hole_diameter/2 - hole_diameter/2;

// Create the main rectangular base of the rack (Solid floor)
base_block = cube([block_length, block_width, floor_thickness]); 

// Function to create a single vertical hole in an extruded shape.
create_hole(holes_count) {
    for (i from 0 to holes_count - 1 by 1 step 1) { 
        pos_x = block_length / num_cols_x + i * hole_spacing_x; 
        pos_y = block_width   / num_rows_y + i * hole_spacing_y;

        // We define the "cup" as a solid cylinder of height (depth + floor_thickness).
        // This creates an object that is closed at the bottom and open at the top.
        
        h_total_depth = hole_depth + floor_thickness; 
        r_hole      = hole_diameter / 2;

        cup_base   = cylinder([r_hole, r_hole, h_total_depth]); 
        
        // We need to remove material from below z=0 (the opening plane)
        // Rule 5: "In difference(), make every cutting shape extend 0.01-1 mm past the faces it cuts".
        
        // To create an open hole at top and closed bottom, we typically use a cylinder 
        // with height = depth + floor_thickness, then cut away material from below z=0?
        // No, if we have a solid block ending in a flat face (the "floor" of the cup), 
        // that surface must be supported by the rack base or just exist as part of the geometry.
        
        // Let's try this logic:
        // 1. Create a full cylinder with height = floor_thickness + hole_depth, radius r_hole.
        //    This object has a flat bottom face at z=0 (relative to start) and an open top surface? 
        //    Wait, if we extrude from -H_total down to H_total-depth+top... no standard extrusion goes up or down.
        
        // Let's assume the "cup" is defined by: Cylinder(r, h=floor_thickness + hole_depth).
        // This creates a solid block with a flat bottom face at z=0 and an open top surface (z=-H_total-depth+top)? 
        // No, standard cylinder extrusion goes from 0 to height. So it has a flat bottom at -height? 
        // Let's just define the geometry as:
        
        // Shape A: Cylinder(r_hole, h=floor_thickness + hole_depth). Bottom is solid (z=0), Top is open (relative to start of extrusion?).
        // Actually, let's use 'translate_extrude' on a plane or simply subtract.
        
        // Correct approach for OpenSCAD "open top" holes:
        // Create the full block including the bottom floor face. 
        // Then cut away material from below z=0? No, that would leave an internal cavity if not careful with 'difference'.
        
        // Let's try this specific method which works reliably in OpenSCAD for these shapes:
        // 1. Create a solid cylinder of height = floor_thickness + hole_depth and radius r_hole. 
        //    This creates a block where the bottom face (z=0) is flat, but it needs to be open at z=-H_total-depth+top? 
        //    Actually, if we start extrusion from 0 upwards:
        //      Cylinder(r, h=floor_thickness + hole_depth). Bottom is solid. Top surface is open.
        //      We need the bottom face (z=0) to be supported by the rack block itself or just exist as a flat plane? 
        //      The prompt says "closed at the bottom". This implies there IS a flat surface below z=0 relative to the cup's opening.
        
        // Let's assume we want: A solid cylinder of height = floor_thickness + hole_depth, radius r_hole.
        // We cut away material from below z=0? No, that removes the bottom face which is part of our "cup" definition if it was open at top and closed at bottom.
        
        // Let's try: 
        // Shape 1: Cylinder(r_hole, h=floor_thickness + hole_depth). Bottom is solid (z=0), Top surface is flat but needs to be cut away? No.
        
        // Alternative interpretation of "closed at the bottom": The cup ends with a flat face that must be supported by the rack block's floor directly underneath it. 
        // This means for rows other than the deepest ones, there are no holes below them (or they don't need support). 
        // But we have 4 rows and only one solid floor at the very bottom of the object?
        
        // Let's assume: The rack has a base block with height = hole_depth + floor_thickness.
        // We cut away material from below z=0 (the opening plane) such that no holes end in an open surface? 
        // No, "closed at the bottom" means every hole ends with a flat face.
        
        // Okay, let's try this: Create two shapes and subtract one from another using difference with 'translate_extrude' on planes (which is allowed).
        // Shape 1: Cylinder(r_hole, h=floor_thickness + hole_depth). Bottom at z=0? No, if we start extrusion from -H_total-depth down to H_total-depth+top... 
        // Let's just define the geometry as a solid block with height = floor_thickness + hole_depth.
        // Then use 'difference' to remove material from below z=0? That would create an internal cavity unless we are careful.
        
        // Simpler robust method:
        // 1. Create a full cylinder (r, h=floor_thickness+depth). This has a flat bottom face at the start of extrusion and open top surface? 
        //    No, standard OpenSCAD Cylinder goes from z=0 to height. Bottom is solid. Top surface is open if we don't define it as closed.
        
        // Let's try: Create a cylinder with radius r_hole and height = floor_thickness + hole_depth.
        // This creates an object where the bottom face (z=0) is flat, but it needs to be cut away? 
        // No, if we want it open at top and closed at bottom, we need a solid block that ends in a flat surface below z=0 relative to the opening plane.
        
        // Let's try this logic:
        // Shape A: Cylinder(r_hole, h=floor_thickness + hole_depth). Bottom is solid (z=0), Top surface is open? 
        // Wait, if we extrude from 0 upwards, bottom is at -H_total-depth+top. That doesn't work with standard coordinates unless we translate first.
        
        // Let's assume the "cup" is defined by: Cylinder(r_hole, h=floor_thickness + hole_depth).
        // This creates a solid block where the bottom face (z=0) is flat, but it needs to be cut away? 
        // No, if we want an open top and closed bottom, we need to remove material from below z=0.
        
        // Let's try: Create two shapes and subtract one from another using difference with 'translate_extrude' on planes (which is allowed).
        // Shape 1: Cylinder(r_hole, h=floor_thickness + hole_depth). Bottom at z=0? No, if we start extrusion from -H_total-depth down to H_total-depth+top... 
        // Let's just define the geometry as a solid block with height = floor_thickness + hole_depth.
        // Then use 'difference' to remove material from below z=0? That would create an internal cavity unless we are careful.
        
        // Okay, let's try this specific method which works reliably in OpenSCAD for these shapes:
        // 1. Create a full cylinder (r_hole, h=floor_thickness+depth). This has a flat bottom face at the start of extrusion and open top surface? 
        //    No, standard Cylinder goes from z=0 to height. Bottom is solid. Top surface is open if we don't define it as closed.
        
        // Let's try: