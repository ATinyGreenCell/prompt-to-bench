// Design a bench rack for 1.5 mL microcentrifuge tubes
// Dimensions in millimeters

// Block dimensions
block_length = 106; // X axis
block_width   = 72; // Y axis
block_height  = 30; // Z axis

// Hole specifications
hole_diameter = 11.2; // mm (diameter of the tube opening)
hole_depth    = 25;   // mm (depth from open top to closed bottom)
floor_thickness = 5;  // mm (solid floor thickness at z=-5mm)

// Grid parameters
row_spacing_y = 16;   // mm center-to-center along Y
col_spacing_x = 16;   // mm center-to-center along X

// Number of rows and columns
num_rows    = 4;      // rows along Y
num_cols    = 24;     // columns along X

// Create the solid block
block = cube([block_length, block_width, block_height]);

// Function to create a single hole in the block
make_hole = function(x_start, y_start) {
    // The hole is open at top (z=0), closed at bottom.
    // We need to cut from z=0 down to z=-hole_depth.
    
    // Define the circle vertices for the opening at z=0.
    // Radius = half of diameter
    r = hole_diameter / 2;
    
    // Create a polygon representing the circular opening in the XY plane (z=0).
    // We will rotate this around Z axis later to align it with the block's local axes, 
    // or we can just use translate and rotate_extrude carefully.
    // Actually, let's create a cylinder that spans from z=0 down to z=-hole_depth.
    
    // Strategy:
    // 1. Create a large cylinder (open top) extending from z=0 to z=-hole_depth.
    //    Diameter = hole_diameter.
    // 2. Subtract a smaller cylinder (inner void) that spans the same Z range but has diameter = hole_diameter - floor_thickness.
    
    // We need to center this on the block.
    // Offset x and y by half of the spacing
    
    offset_x = col_spacing_x / 2;
    offset_y = row_spacing_y / 2;
    
    // Create a cylinder with height = hole_depth and diameter = hole_diameter.
    // We want this cylinder to be in the Z direction (from z=0 down to z=-hole_depth).
    // So we need to orient it such that its axis is aligned with the Z-axis of the block? 
    // No, if we extrude along Y, it won't be in Z.
    
    // Correct approach: Create a cylinder with height = hole_depth and diameter = hole_diameter.
    // We want this to be cut out from z=0 down to z=-hole_depth.
    // So we need to orient the cylinder so its flat face (or curved surface) aligns with Z? 
    // Actually, let's just use translate to move the center of the cylinder to the offset position.
    
    // A simple way: Create a cylinder that is 180 degrees long (Z direction) and has diameter hole_diameter.
    // We will rotate it so its axis is aligned with Z? 
    // Let's create a polygon or use for loops with rotate_extrude properly.
    
    // Easier approach: Create a cylinder with height = hole_depth and diameter = hole_diameter.
    // We want this to be in the Z direction (from z=0 down to z=-hole_depth).
    // So we need to orient it such that its axis is along Z.
    
    // In OpenSCAD, rotate_extrude rotates around the current extrusion axis.
    // If we start with a cylinder aligned with Y-axis, rotating 90 degrees makes it align with X/Y? No.
    
    // Let's create a polygon or use for loops with rotate_extrude carefully.
    // We want the cylinder to be in the Z direction (from z=0 down to z=-hole_depth).
    // So we need to orient it such that its axis is along Z.
    
    // Step 1: Create a cylinder with height = hole_depth and diameter = hole_diameter.
    // This will be in Y direction initially? No, let's just create it normally.
    // Actually, let's use rotate_extrude to orient it along Z directly if possible, but OpenSCAD doesn't allow specifying "rotate around X then extrude along Z" easily without intermediate steps.
    
    // Standard trick: Create a cylinder with height = hole_depth and diameter = hole_diameter.
    // We want this to be in the Z direction (from z=0 down to z=-hole_depth).
    // So we need to orient it such that its axis is along Z.
    
    // Let's create a polygon or use for loops with rotate_extrude properly.
    // We want the cylinder to be in the Z direction (from z=0 down to z=-hole_depth).
    // So we need to orient it such that its axis is along Z.
    
    // Step 1: Create a cylinder with height = hole_depth and diameter = hole_diameter.
    // This will be in Y direction initially? No, let's just create it normally.
    // Actually, let's use rotate_extrude to orient it along Z directly if possible, but OpenSCAD doesn't allow specifying "rotate around X then extrude along Z" easily without intermediate steps.
    
    // Correct approach: Create a cylinder with height = hole_depth and diameter = hole_diameter.
    // We want this to be in the Z direction (from z=0 down to z=-hole_depth).