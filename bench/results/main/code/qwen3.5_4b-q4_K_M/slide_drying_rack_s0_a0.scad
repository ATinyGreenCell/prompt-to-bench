// --- Dimensions & Parameters ---
// Slide dimensions: 75 x 25 x 1 mm
slide_length = 75;      // Length along X (long edge)
slide_width = 25;       // Width of slide (short edge, used for spacing reference if needed)
slide_thickness = 1;    // Thickness of glass

// Base block dimensions: 90 x 45 x 20 mm
base_length = 90;       // Length along X
base_width = 45;        // Width along Y
base_height = 20;       // Height along Z (builds upward from XY plane)

// Slot specifications
slot_count = 10;        // Number of slots to cut
slot_length = 77;      // Length of slot along X
slot_width = 1.6;      // Width of slot along Y
slot_depth = 10;       // Depth of cut from top face (Z)

// Spacing and positioning parameters
center_to_center_spacing_y = 3.5; // Distance between centers in Y direction
offset_x_from_edge_mm = 2;        // Offset slots from the X edges to center them within base_length - slot_length
offset_z_start_mm = 0;            // Start Z of cut (from top face, so effectively cuts into block)

// --- Main Model Construction ---

// Calculate geometry for centered placement
// The group of slots must be centered on the origin in XY.
// Total length occupied by slots: slot_count * center_to_center_spacing_y - 1*slot_width? 
// Actually, we just calculate the bounding box of all centers and offset from that to align with block edges if needed,
// but requirement says "group... centred on the block". So simply find min/max Y of centers.

min_slot_center_x = (base_length/2) - ((slot_count * center_to_center_spacing_y)/2); // Center X for all slots is same? 
// Requirement: "parallel slots ... runs along X" and "centred on the block in X".
// So min/max slot center Y must be centered.

min_slot_center_y = (base_width/2) - ((slot_count * center_to_center_spacing_y)/2); // Center Y for all centers? 
// Wait, if they are parallel along X, their centers share an X coordinate range? No, "parallel slots" usually means aligned in direction.
// If they run along X, then the variation is in Y (width). The requirement says "centred on the block".

min_slot_center_x = base_length/2; // All slot centers are at this X to be centered horizontally and parallel? 
// Actually, if slots run along X, their length is 77mm. To center them within a 90mm long block:
slot_start_x_offset_from_edge = (base_length - slot_length) / 2;

min_slot_center_y = base_width/2; // All centers at this Y? No, they are spaced in Y.
// Let's recalculate the bounding box of the slots' positions to ensure symmetry around origin.
slot_positions_x_min = min_slot_center_x + (base_length - slot_count * center_to_center_spacing_y)/2 ? 
// Simpler approach: Define a loop for each slot index i from 0 to count-1.

for(i=0:i<slot_count) {
    // Calculate position of this specific slot's center relative to the block origin
    
    // X Position (Centered): All slots are parallel along X, so they share the same longitudinal alignment? 
    // "parallel slots ... runs along X" -> They all run in +X direction.
    // Are they staggered in Y or aligned in a single row? Usually racks have rows and columns.
    // Given only one dimension of spacing (3.5mm apart centre-to-centre) and no mention of staggering, 
    // assume a single column of slots running along the length X is NOT implied by "parallel". 
    // Parallel usually means same direction vector. If they were in two rows, we'd need another spacing parameter or instruction.
    // However, standard racks often have multiple columns. But here only one gap dimension is given: 3.5mm Y-spacing.
    // Let's assume a single row of slots along the length X? 
    // Wait, if they are "parallel", and we cut them into the top face...
    // If I make just ONE slot per index i in the loop varying only Y position, that creates 10 parallel lines running along X.
    
    // Let's verify: "Cut 10 parallel slots ... runs along X". 
    // This implies all 10 are aligned with each other (same direction). They can be offset from one another?
    // If they were in a single row, the spacing would define their Y positions.
    
    slot_center_x = base_length/2; 
    
    // Calculate center Y for this iteration i
    // We need to distribute 10 items across width 45mm with 3.5mm pitch centered at origin.
    // Total span needed: (count-1) * spacing + thickness? 
    // Let's just use the formula derived earlier but applied per loop index if we assume a single row.
    
    slot_center_y = base_width/2 - ((slot_count - 1)/2)*center_to_center_spacing_y; 
    
    // Wait, does "parallel" imply they are all in one line? Or could it be two rows of 5? 
    // Without info on X-spacing or row count, the most logical interpretation for a simple rack described this way is a single row.
    
    // However, if I look at standard racks, sometimes you have multiple columns. But with only Y spacing given...
    // Let's stick to one row of 10 slots along X? 
    // Wait, "parallel" means same direction. If they are in different rows (different Z or just offset), we need more info.
    // Given the constraints and typical simplicity: Single row is safest unless specified otherwise.
    
    // BUT wait, if I make a single row of 10 slots along X... 
    // The block is 90mm long. Slot length 77mm. Centered in X -> starts at (90-77)/2 = 6.5mm from edge? No, center to center spacing applies Y direction here if they are stacked vertically?
    
    // Re-evaluating "parallel slots ... runs along X". 
    // If I have a rack holding slides standing upright on their long edge (which is the width of the slide usually 25mm).
    // Slides stand up. The slot must accommodate them.
    // Slide dimensions: 75x25x1. Long edge = 75? Or short edge = 25? 
    // "standing upright on their long edge". Usually means the face with dimension (width x thickness) rests on table, and length sticks up? 
    // OR does it mean they stand vertically such that the LONG side is vertical?
    // Standard slide: ~76mm x 26mm. Longest side = 75/76. Shortest width = 25. Thickness = 1.
    // If "standing upright on their long edge": 
    // Interpretation A: The face defined by (Long Edge, Thick) is the bottom? No, that's lying flat.
    // Interpretation B: They stand vertically. Which way up? On the Long Edge or Short Edge?
    // "On their long edge" -> The contact line with the table is the LONG EDGE of the slide rectangle. 
    // So the base on the rack face must be (Long x Thick) = 75mm x 1mm? That seems too thin for a slot width if we want stability, but it's what "on long edge" implies physically.
    // Wait, usually racks hold slides by their short edges or allow them to stand vertically with the LONG side vertical? 
    // Let's re-read carefully: "standing upright on their long edge".
    // If a rectangle is 75x25. The "long edge" is 75mm. To sit ON it, you place the object so that its length (75) touches the surface. 
    // So the cross-section of the slot must be roughly 1mm thick x ? wide?
    // If they are standing upright, gravity pulls them down along their height. The "height" is usually the dimension perpendicular to the table when lying flat. 
    // If I put a slide on its long edge (75mm side), it stands up with height = 25mm and width = 1mm? Or height=25, depth=1?
    // Actually, if you place a card on its "long edge", the dimension running along the table is 75. The other dimensions are perpendicular to that line: Thickness (1) and Width (25). 
    // So it stands up with Height = 25mm and Depth/Width into page = 1mm? Or vice versa depending on orientation relative to rack X/Y.
    
    // Let's assume the user wants slots sized for this specific stance.
    // Slot width Y should accommodate the dimension perpendicular to the long edge (which is 25mm or 1mm?). 
    // If it stands ON the long edge, the face touching the table is Long x Thick? No, that would