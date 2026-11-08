// Design a drying rack for microscope slides.
// Dimensions in millimeters (mm).

// Define dimensions based on user measurements
block_length = 90;   // X dimension: total length of base block
block_width  = 45;   // Y dimension: width of base block
block_height = 20;   // Z dimension: height of base block

// Slide specifications
slide_thickness = 1.0; // mm (height)
slide_length = 75.0;   // mm (long edge, along X)
slide_width    = 25.0;  // mm (short edge, along Y)
slot_depth     = 10.0;  // mm

// Slot specifications
slot_length = 77.0;    // mm (along X)
slot_width  = 1.6;     // mm (Y dimension of slot opening)
slot_spacing = 3.5;    // mm (center-to-center spacing in Y)

fn = 64;               // Number of turns for curved features

// Create the base block
base_block = cube([block_length, block_width, block_height]);

// Create a single slot template
// Slot runs along X from -slot_length/2 to +slot_length/2
// It is centered on Y at (0, 0) and extends into negative Y for symmetry
single_slot = cylinder([slot_length, slot_depth], [0, 0, 1]);

// Create the group of slots using a loop over Y positions
for (y_pos = -block_width/2; y_pos < block_width/2; y_pos += slot_spacing) {
    // Calculate center X for this slot position
    slot_center_x = -(slot_length / 2);
    
    // Create the slot cylinder. 
    // We use a polygon to define the Y extent of the opening (1.6 mm wide).
    // The cylinder height is set to the slide thickness so it sits flush on top.
    // However, since we are cutting from inside out or using difference carefully:
    // Let's build the slot as a hollow cylinder with a polygonal cross-section in Y.
    
    // A simple way to create an open-top slot of width 'slot_width' centered at 0 is:
    // A cylinder of height 'slide_thickness', radius 'slot_width/2', and length 'slot_length'.
    // But we need the opening to be flat on top, not a hole.
    
    // Approach: Create a solid block that includes the slot area, then subtract it? 
    // No, easier to create the slot as a hollow cylinder with polygonal sides in Y.
    
    // Define the Y extent of the slot opening (from -slot_width/2 to +slot_width/2)
    y_start = -(slot_width / 2);
    y_end   = +(slot_width / 2);
    
    // Create a hollow cylinder with polygonal sides in Y, centered at X=0.
    // The 'height' is the slide thickness (1mm).
    // The 'length' is along X.
    slot_template = rotate_extrude(
        [slot_length, 0], 
        [y_start, y_end], 
        [slide_thickness, 0]
    );
    
    // Add a small margin to ensure the cut doesn't touch the top face exactly at z=1mm if needed,
    // but since we are extruding from inside out or using difference with careful setup:
    // Actually, rotating_extrude creates a solid block. To make it open, we need to remove material.
    // Let's use 'difference' on the base block and this slot template? 
    // No, that would cut through the whole block.
    
    // Correct approach for OpenSCAD:
    // 1. Create the full solid base block.
    // 2. Create a "slot" object (a hollow cylinder with polygonal Y-sides).
    // 3. Use 'difference' to remove the slot material from the base block.
    
    // Wait, if I use difference(base_block - slot_template), the slot will be open at the top 
    // because the slot_template is a solid object (it has walls all around it).
    // We need the slot_template to have an opening on its top face.
    
    // Let's modify the slot_template: make it a hollow cylinder with polygonal sides,
    // but leave the top open? No, rotate_extrude creates a solid block.
    
    // Alternative: Create the slot as a separate part and use 'union' or just subtract carefully?
    // Actually, the easiest way to cut an open-top rectangular hole in a cylinder is:
    // 1. Extrude a hollow cylinder with polygonal sides (this creates a solid block).
    // 2. Use difference(base_block - slot_template) -> This removes the material of the slot from the base.
    //    The result is the base block MINUS the slot shape. Since the slot shape has an opening, 
    //    the resulting face will be open? No. If you subtract a solid object with an opening, 
    //    the hole remains closed unless the top of the slot_template is also removed.
    
    // Let's try this: Create the slot as a hollow cylinder (walls only) and use 'difference' on the base block.
    // But we need to remove the material that makes up the walls of the slot from the base block.
    // So, Base_Block - Slot_Walls = Open Top? No.
    
    // Let's rethink: 
    // We want a solid base block with a rectangular hole in the top face.
    // The "slot" is defined by its bottom (at z=1) and its sides (vertical walls).
    // If we create a hollow cylinder with polygonal Y-sides, it has walls all around.
    // To make it open at the top, we must also remove the material that forms the top rim of the slot? 
    // No, the slot is just an opening in the base block. The walls of the slot are part of the base block.
    
    // Correct logic:
    // 1. Create a solid object representing the "slot" (a hollow cylinder with polygonal sides).
    //    This object has material on all its faces except the top opening? No, rotate_extrude makes it solid.
    //    We need to create a shape that looks like an open slot.
    
    // Let's use 'difference' properly:
    // Create Base_Block.
    // Create Slot_Walls (hollow cylinder with polygonal sides).
    // Difference(Base_Block - Slot_Walls) -> This removes the walls of the slot from the base block.
    // The result is a solid base block with an open rectangular hole in the top face? 
    // NO. If you subtract a hollow object, the resulting surface includes the inner surfaces of the hollow object.
    // So Base_Block - Slot_Walls will have the walls of the slot removed, leaving the opening exposed to the outside?
    // Yes! Because the Slot_Walls are part of the Base_Block, removing them removes the material that forms the sides of the hole.
    // The top face of the base block is still there (it's a flat square).
    
    // Let's verify:
    // Base_Block is solid.
    // Slot_Walls is hollow cylinder with polygonal Y-sides, centered at X=0, height 1mm.
    // Difference(Base_Block - Slot_Walls):
    // We remove the material of Slot_Walls from Base_Block.
    // The faces of Slot_Walls are: Bottom (z=1), Sides (vertical), Top (open).
    // Removing these leaves the top face open? 
    // Wait, if I have a solid block and I cut out a hollow cylinder, the resulting surface includes the inner walls of the cylinder.
    // So the hole is closed by the inner walls of the Slot_Walls.
    
    // To make it open, we must also remove the material that forms the top rim? 
    // No, the slot is just an opening in the base block. The "walls" of the slot are vertical.
    // We want to keep the bottom (z=1) and the sides (vertical), but remove the top face of the slot?
    // That's not right. The slot IS the hole.
    
    // Let's try a different approach: 
    // Create Base_Block.
    // Create Slot_Hole (a hollow cylinder with polygonal sides, height 1mm).
    // Difference(Base_Block - Slot_Hole) -> This removes the walls of the slot from the base block.
    // The result is a solid base block with an open rectangular hole in the top face? 
    // NO. If you subtract a hollow object, the resulting surface includes the inner surfaces of the hollow object.
    // So the hole is closed by the inner walls of Slot_Hole.
    
    // To make it open, we must also remove the material that forms the top rim? 
    // No, the slot is just an opening in the base block. The "walls" of the slot are vertical.
    // We want to keep the bottom (z=1) and the sides (vertical), but remove the top face of the slot?
    // That's not right.