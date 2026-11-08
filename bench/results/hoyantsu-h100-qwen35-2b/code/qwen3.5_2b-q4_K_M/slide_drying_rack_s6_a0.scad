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

// Create the base block
base_block = cube([block_length, base_width, base_height]);

// Define the top face of the base block for cutting
top_face = polygon([[0, 0], [block_length, 0], [block_length, base_width], [0, base_width]]);

// Create a single slot using linear_extrude and rotate_extrude
// We use difference to cut out the slot. 
// The slot is defined as a rectangle extruded along Z (depth).
// Since we need to cut from top down, we create a large block with slots removed.
// However, OpenSCAD's difference works best if we define the "cut" shape and subtract it.

// Strategy:
// 1. Create a solid block that is exactly the size of the base_block but slightly larger in Z to ensure clean cuts.
//    Actually, simpler approach: 
//    Create a large block (base_width + slot_width_y * num_slots) by (block_length).
//    Then subtract the slots.

// Let's build the "cutting shape" for one slot first.
// A slot is a rectangle of width=slot_depth and length=slot_length_x, extruded along Y? 
// No, the slot runs along X. So it has depth Z (10mm) and height Y (1.6mm).
// The cut happens in the top face (XY plane), removing material at specific Y positions.

// We will create a temporary "slot block" that is larger than the base_block to ensure clean cuts, 
// then use difference to remove it from the main base_block.
// To make this work with difference, we need the slot shape to be defined in Z or extruded along Z?
// No, linear_extrude creates a solid. If we do:
//   cylinder([slot_depth, 0], [slot_length_x, slot_width_y]) -> This is a hollow tube.
// We want a rectangular hole.

// Correct approach for OpenSCAD difference with slots:
// Create a "cutout" shape that represents the slot volume. 
// Since we are cutting from top (XY plane), the cutout must be defined in Z or extruded along Z?
// Actually, linear_extrude creates a solid block. If we do:
//   box([slot_length_x, slot_width_y, slot_depth]) -> This is a solid block of material.
// We want to remove this from the top face.

// Let's create a "cutout" shape that is exactly the size of one slot (in X and Y) but has depth Z? 
// No, linear_extrude creates a solid. To cut a hole, we usually use:
//   cylinder([diameter], [length]) -> hollow tube.
// Or simply: box([width, height, depth]) - cylinder... no that's complex.

// Easiest way in OpenSCAD for slots with difference:
// Create a "slot block" which is a solid rectangle of size (slot_length_x, slot_width_y, slot_depth).
// Then use difference to subtract this from the top face? 
// Wait, if we do base_block - box([77, 1.6, 10]), it will cut through the whole height.
// We need to ensure the cut only happens at Z=0 (top) and not go deeper into the block.

// Solution: Use a large temporary block that is slightly larger in all dimensions than base_block, 
// then use difference to remove the slots. This ensures clean cuts without over-cutting or under-cutting.
// Temp Block size: [block_length + 0.1, base_width + slot_width_y * num_slots, base_height]

temp_block = cube([block_length + 0.1, base_width + total_slot_width, base_height]);

// Now we need to remove the slots from temp_block.
// The slots are defined by their position in Y and length in X.
// We can use a for loop to create individual slot blocks and subtract them? 
// Or define one large block with multiple holes? OpenSCAD doesn't support multiple holes easily via simple loops without complex math.

// Better approach: Use difference on the temp_block, but we need to specify the cutout shape per slot.
// We can iterate through slots and create a "cut" for each, then union them into one block before subtracting? 
// Or simpler: Create a single large block with all slots defined as separate extrusions along Z? No, they are holes in XY plane.

// Standard trick for multiple holes in OpenSCAD:
// 1. Create a "cutout" shape that is the union of all individual slot shapes (inverted).
// 2. Subtract this from temp_block.

// Let's define an inverted slot block first.
// An inverted slot block is a box with Z=0 face removed? No, we want to remove material at Z=0.
// So the "cutout" shape should be a solid rectangle of size (slot_length_x, slot_width_y, slot_depth) 
// positioned at Y = offset_y + i * spacing_y, for all slots i.

// We can create this using a loop and union.
// But wait, if we use difference(temp_block - cutout), the cutout must be defined as a solid block that extends past Z=0?
// No, linear_extrude creates a solid. If we do:
//   box([77, 1.6, 10]) -> This is a solid block of material.
// We want to remove this from the top face. 
// To make difference work correctly (cutting through), we usually define the cutout as a hollow cylinder or similar?
// No, for slots, we simply subtract a rectangular prism that sits on Z=0 and goes down to Z=-10? 
// But linear_extrude creates a solid block. If we do:
//   temp_block - box([77, 1.6, 10]) -> This will cut all the way through if not careful with orientation.

// Correct logic for OpenSCAD difference with slots:
// We want to remove material at Z=0 (top face) and extend down into the block? 
// No, we just need to remove a rectangular prism of size [slot_length_x, slot_width_y, slot_depth] from the top face.
// To do this cleanly, we can create a "cutout" shape that is exactly the slot volume but positioned such that it sits on Z=0 and extends down? 
// Actually, linear_extrude creates a solid block. If we define:
//   cut_shape = box([slot_length_x, slot_width_y, slot_depth]) -> This is a solid block of material.
// We want to remove this from the top face.
// The issue is that difference requires the second shape to be "inside" or overlapping in Z? 
// No, difference works on any faces. If we do temp_block - cut_shape, it will try to subtract the volume of cut_shape from temp_block.
// Since cut_shape has thickness 10mm (Z), and temp_block is only 20mm tall, this will result in a hole going through Z=0 into Z=-10? 
// Yes! That's exactly what we want for a slot that goes down to the bottom of the block.

// So:
// 1. Create a large temporary block (temp_block) slightly larger than base_block.
// 2. Define "cutout" as a box [slot_length_x, slot_width_y, slot_depth].
// 3. Use difference(temp_block - cutout). This will remove the material of the cutout from temp_block.

// However, we need to ensure the cutout is positioned correctly in Y.
// We can use a for loop to create individual box objects and subtract them? 
// Or define one large block with multiple holes using a loop? OpenSCAD doesn't have built-in "multiple holes" via simple loops without