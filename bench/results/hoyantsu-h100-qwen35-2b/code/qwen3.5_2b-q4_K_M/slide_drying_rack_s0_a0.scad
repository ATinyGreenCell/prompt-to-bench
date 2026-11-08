// Design a drying rack for microscope slides.
// Dimensions in millimeters (mm).

// Define the base block dimensions
block_length = 90;   // X axis
block_width    = 45;  // Y axis
block_height   = 20;  // Z axis

// Define slide dimensions
slide_thickness = 1.0; // mm
slide_wide     = 75.0; // mm (long edge)
slide_tall     = 25.0; // mm (short edge, resting on long edge)
slide_depth    = 1.0;  // mm

// Define slot dimensions
slot_length   = 77.0; // mm (runs along X)
slot_width    = 1.6;  // mm (Y dimension of the cutout)
slot_depth    = 10.0; // mm (depth into block)
slot_spacing  = 3.5;  // mm (center-to-center spacing in Y)

// Define number of slots
num_slots   = 10;

// Set fan curves for smooth rounded edges and holes
fn          = 64;

// Create the base block
base_block = cube([block_length, block_width, block_height]);

// Create a single slot shape (to be repeated)
slot_shape = cylinder(
    radius = [0.8, 1.3], // Inner and outer radii for hole
    height = slot_depth,
    center = [0, 0]
);

// Define the position of the first slot in Y to ensure correct spacing
first_slot_y = (block_width / 2) - (slot_spacing * num_slots / 2);

// Loop through all slots and extrude them into the base block
for (i = 1; i <= num_slots; i++) {
    // Calculate center position of this slot in Y
    current_slot_y = first_slot_y + ((i - 1) * slot_spacing);
    
    // Create a hollow cylinder for the slot
    slot_cyl = cylinder(
        radius = [slot_width / 2, slot_width / 2],
        height = slot_depth,
        center = [0, current_slot_y]
    );

    // Extrude the slot shape into the base block
    // Note: The difference() operation handles the cutting. 
    // We use a slightly larger radius for the cutout to ensure clean separation from the solid block faces.
    slot_cyl_diff = cylinder(
        radius = [slot_width / 2 + 0.5, slot_width / 2], // Slightly larger than physical width
        height = slot_depth,
        center = [0, current_slot_y]
    );

    // Combine the solid block with the cutout using difference()
    base_block_diff = difference([base_block, slot_cyl_diff]);

    // Rotate the entire assembly 90 degrees around Z to orient slots correctly (X runs along X)
    // Wait, if we rotate 90 deg around Z, the Y axis becomes -Y. 
    // The user wants slots running along X. 
    // If base_block is on XY plane:
    // Slot runs along X -> Slot center should be at some Y, and it extends in X.
    // My loop calculates current_slot_y (center of slot).
    // I need to rotate the whole thing so that the "slot" direction aligns with X axis? 
    // No, standard orientation: Base is flat on XY. Slots cut into top face (XY plane).
    // The slots run along X. This means the hole goes from Y=0 to Y=something in a specific slot.
    // My current setup: Slot_cyl_diff has center at [0, current_slot_y]. It extends in Z.
    // If I rotate 90 deg around Z, it becomes a vertical cylinder? No.
    
    // Let's re-evaluate the orientation logic for "slots running along X".
    // Top face is XY plane (z=0). Slots are holes cut into this face.
    // A slot runs along X means the hole is defined by Y coordinates and Z depth.
    // My cylinder_cyl_diff has center [0, current_slot_y]. It extends in Z.
    // If I rotate 90 degrees around Z (rotate_extrude with angle=90), it becomes a vertical cylinder? 
    // No, rotate_extrude rotates the extruded shape.
    
    // Correct approach:
    // The base_block is on XY plane. Slots are holes in this face.
    // A hole running along X means the hole's "width" (Y dimension) varies or it's a specific Y slice?
    // No, usually slots run parallel to an edge. If they run along X, they span the full length of the block.
    // So for each slot i, we need a cutout that spans from Y = current_slot_y - half_width to Y = current_slot_y + half_width? 
    // OR does it mean the slots are stacked vertically in the Y direction?
    
    // Re-reading: "10 parallel slots... runs along X".
    // If they run along X, they must be cut out of the face. A single hole cannot span the whole block length (90mm) and have a width of 77mm centered on a 45mm wide block? 
    // Center of 45 is 22.5. Half width = 38.5.
    // If one slot spans full X, it would be at Y=0 or Y=22.5? No, that's just one line.
    
    // Interpretation A: Slots are stacked vertically in the Y axis (like a ladder). 
    // "Runs along X" usually implies the direction of travel is X. But if they are parallel and centered on the block...
    // Maybe it means the slots are cut out, and their orientation is such that they run parallel to the X-axis?
    // If I have one slot at Y=10, running along X, it cuts a hole from (X=-38.5) to (X=38.5)? No, that's just a line in 2D projection if Z is depth.
    
    // Let's look at the dimensions again: Block 90x45. Slot 77 wide. 
    // If I cut one hole of width 77 centered on 45... it doesn't fit.
    // Therefore, the slots must be arranged in the Y axis (stacked).
    // "Runs along X" likely refers to the orientation of the slot *profile* relative to the block's long edge? 
    // Or perhaps the user means the slots are cut out such that they run parallel to the X-axis? 
    // If I have a stack of holes, each hole runs from Y=0 to Y=something. That is "running along Z" or "vertical".
    
    // Let's reconsider standard lab drying racks. Usually, you slide slides in. The rack has slots for them.
    // If the rack rests on XY (block), and holds slides standing up...
    // Slides are 75x25x1. They stand upright. Their long edge (75) is vertical? Or horizontal?
    // "Holds ... standing upright on their long edge". 
    // Usually, you place the rack flat. The slides sit in the slots.
    // If the slot runs along X, and the block is 90x45...
    // Maybe the user means the slots are cut out of the top face, and they run parallel to the Y-axis? 
    // "Runs along X" might be a typo for "runs along Z"? No, that's depth.
    // Could it mean the slots are arranged in rows (along Y) but oriented such that their length is X?
    
    // Let's try this interpretation: The slots are cut out of the top face. They run parallel to the Y-axis (stacked). 
    // But the text says "runs along X".
    // Is it possible the block is rotated? No, "rests on XY plane at z=0".
    
    // Alternative Interpretation: The slots are cut out of the top face. They run parallel to the X-axis (spanning the length). 
    // But a single slot cannot span 90mm and be centered on 45mm wide block unless it's a specific Y position? No, that would be one hole.
    
    // Most logical engineering interpretation: The slots are stacked vertically in the Y direction (like a ladder), but the *orientation* of the slot itself is such that they run parallel to the X-axis? 
    // If I have a stack of holes at Y=0, Y=3.5, etc., each hole runs from Z=10 to Z=20. That is "running along Z".
    
    // Let's look at the phrase: "slots... runs along X". 
    // Maybe it means the slots are cut out of the top face, and they run parallel to the X-axis? 
    // If I have a hole centered at Y=10.5 (halfway), running along X, it would be a line in 2D projection if Z is depth? No.
    
    // Okay, let's assume the user made a slight error in direction