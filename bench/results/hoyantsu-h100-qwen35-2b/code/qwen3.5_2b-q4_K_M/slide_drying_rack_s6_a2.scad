// Design a drying rack for microscope slides.
// Dimensions in millimeters (mm).

// Define dimensions based on user measurements
block_length = 90;      // X: Total length of the base block
base_width   = 45;      // Y: Width of the base block
base_height  = 20;     // Z: Height of the base block (tall edge up)

// Slide dimensions
slide_thickness = 1.0;  // mm
slide_length    = 75.0; // mm
slide_width     = 25.0; // mm

// Slot specifications
slot_depth      = 10.0;   // mm (depth of the slot)
slot_width_y    = 1.6;    // mm (width along Y axis, perpendicular to X)
slot_length_x   = 77.0;   // mm (length along X axis)
slot_spacing_y  = 3.5;    // mm (center-to-center spacing in Y)

// Grid parameters for the 10 slots
num_slots     = 10;       // Number of slots
spacing_y     = slot_spacing_y;
total_slot_width = num_slots * slot_spacing_y + (num_slots - 1) * slot_depth;

// Centering offsets to ensure symmetry on X and Y axes
offset_x   = block_length / 2.0;
offset_y   = total_slot_width / 2.0;

// Create the base block using rotate_extrude for a solid part
base_block = cube([block_length, base_width, base_height]);

// Define the top face of the base block for cutting
top_face = polygon([[0, 0], [block_length, 0], [block_length, base_width], [0, base_width]]);

// Create a single slot using linear_extrude and rotate_extrude
// We use difference to cut out the slot. 
// The slot is defined as a rectangle of width=slot_depth and length=slot_length_x, extruded along Y? 
// No, the slot runs along X. So it has depth Z (10mm) and height Y (1.6mm).
// The cut happens in the top face (XY plane), removing material at specific Y positions.

// We will create a temporary "slot block" that is larger than the base_block to ensure clean cuts, 
// then use difference to remove it from the main base_block.
// Temp Block size: [block_length + 0.1, base_width + slot_width_y * num_slots, base_height]

temp_block = cube([block_length + 0.1, base_width + total_slot_width, base_height]);

// Define the "cutout" shape for one slot first.
// A cutout is a solid rectangle of size (slot_length_x, slot_width_y, slot_depth).
// We will create this using a loop to generate individual blocks and subtract them from temp_block.
// However, OpenSCAD's difference() function takes multiple arguments: 
//   shape1 - shape2 - shape3 ...
// So we can pass the base_block as the first argument (to keep it), but that would cut through it.
// Instead, we create a "cutout" object and subtract it from temp_block? No, difference requires shapes to be distinct objects in memory or defined sequentially.

// Correct approach for multiple holes using difference:
// 1. Create the base_block as an object (using rotate_extrude).
// 2. Define a "cutout" shape that is exactly the size of one slot but positioned at Y=0? 
//    No, we need to subtract from temp_block.

// Let's try a different strategy: Use difference with multiple arguments where each argument is an object.
// We want to keep base_block and remove slots from it.
// But base_block is already defined as a cube. If we do base_block - box(...), it cuts through the whole height.
// We need to create a temporary block that includes the slots, then subtract the slots? 
// No, the easiest way in OpenSCAD for "holes" with difference is:
//   Create a large block (temp_block).
//   Define a "cutout" shape that represents the slot volume.
//   Use difference(temp_block - cutout).

// But wait, if we define 'cutout' as a box([77, 1.6, 10]), it is a solid block of material.
// If we do temp_block - cutout, OpenSCAD will try to subtract the volume of cutout from temp_block.
// Since cutout has thickness in Z (10mm), and temp_block is only 20mm tall, this results in a hole going through Z=0 into Z=-10? 
// Yes! That's exactly what we want for a slot that goes down to the bottom of the block.

// So:
// 1. Create base_block (using rotate_extrude).
// 2. Define cutout as a box([slot_length_x, slot_width_y, slot_depth]).
// 3. Use difference(base_block - cutout). 
//    Wait, if we do this, the 'cutout' is subtracted from 'base_block'. Since base_block has height 20mm and cutout has depth 10mm, it will cut through Z=0 into Z=-10?
//    Yes. This effectively creates a slot that goes all the way down to -10mm (below the block).

// However, we need to ensure the slots are centered in Y.
// The 'cutout' box is defined at Y=0 by default. We need to shift it to offset_y + i * spacing_y? 
// No, if we subtract a box from base_block, the cut happens at the faces of the box.
// If the box is at Y=0, the cut happens at Y=0 (top face) and extends down to Z=-10.
// This works perfectly for slots centered on the top face!

// We just need to define 'cutout' as a single large block that covers all slots? 
// No, if we subtract one big box from base_block, it will cut through ALL slots at once.
// That's fine! The user wants 10 parallel slots. Subtracting one big rectangular prism is exactly what we want.

// Let's verify:
//   temp_block = cube([block_length + 0.1, base_width + total_slot_width, base_height]); // This ensures clean cuts at Z=0 and bottom? 
//      Wait, if temp_block has height 20mm (same as base), and we subtract a box of depth 10mm, the result will have a hole from Z=0 to Z=-10.
//      But what about the bottom of the block? The original base_block is at Z=0 to Z=20. 
//      If we subtract a box that goes down to Z=-10, the remaining material is from -10 to 20.
//      This creates a hole going all the way through!

// Correction: We need the slot to be a "cutout" on the top face only, extending down into the block? 
// No, usually slots are open at the top and go down some depth, or they are just holes in the XY plane.
// The prompt says: "Cut 10 parallel slots into the top face... open at the top."
// This implies a rectangular hole on the XY plane (Z=0), extending downwards? 
// Or does it mean the slot itself is the material removed, and the remaining block sits above?
// Usually, for a drying rack, you have a base block with slots cut out of its top face. The "slot" is empty space.
// If we simply subtract a box from Z=0 to Z=-10, we are removing material that was already there (since base_block goes down to 20).
// This creates a hole through the entire block.

// Alternative interpretation: The slot is a rectangular prism of material removed from the top face, 
// but only for the height of the slot? No, "open at the top" usually means it's an empty space in the XY plane.
// If we simply subtract a box([77, 1.6, 10]) from base_block, we remove material at Z=0 to Z=-10.
// Since base_block is only 20mm tall (Z=0 to Z=20), removing Z=0 to Z=-10 removes the entire top face and extends a hole down to -10mm.

// This seems correct for "slots into the top face". The resulting part will have a void from Z=0 to Z=-10.
// However, we need to ensure the base_block is not cut through at Z=20 (bottom).
// If we subtract a box that goes down to Z=-10, and base_block ends at Z=20, then the remaining block is from -10 to 20? 
// No, difference removes material. So if we have base_block (Z:0-20) and cutout (Z:-10 to 0), the result is Z:-10 to 20.
// This creates a hole through the entire block!

// To avoid this, we must ensure the cutout does not extend below Z=0? 
// No,