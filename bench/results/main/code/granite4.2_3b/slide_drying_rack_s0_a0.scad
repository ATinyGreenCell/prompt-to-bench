// Dimensions in millimetres
block_length = 90;      // X dimension of base block
block_width = 45;       // Y dimension of base block
block_height = 20;      // Z height of base block
slide_length = 75;      // Slide length (long edge) in mm
slide_width = 25;       // Slide width (short edge) in mm
slide_thickness = 1;    // Slide thickness in mm
slot_length = 77;       // Slot length along X direction in mm
slot_width = 1.6;        // Slot cross-sectional width in Y direction in mm
slot_depth = 10;         // Slot depth (Z) from top surface in mm
slot_spacing = 3.5;      // Centre-to-centre spacing between slots along Y direction in mm
num_slots = 10;          // Number of parallel slots

// Create the drying rack base block centered on origin in X and Y, resting at z=0
translate([block_length/2, block_width/2, block_height/2])
cube([block_length, block_width, block_height], center=true);

// Define slot parameters for each slot i (0 to 9)
for (i = [0:num_slots-1]) {
    // Slot position along Y direction based on centre spacing
    y_offset = (i + 0.5) * slot_spacing;
    
    // Slot start and end positions in X direction, centered within block width
    x_start = (block_length - slot_length) / 2;
    x_end   = x_start + slot_length;
    
    // Create the rectangular extrusion for the slot: a channel along Z with cross-sectional shape
    // The slot is defined as a rectangular prism extending downward from the top face of the block.
    // We'll use difference to carve out the slot, ensuring non-coplanar faces by offsetting slightly.
    
    // Define the outer rectangle (the full channel) centered in X and Y within the block's top face.
    // The slot runs along X from x_start to x_end at y = y_offset, with depth slot_depth downward.
    
    // Create a rectangular prism representing the slot: extends -slot_width/2 to +slot_width/2 in Y and full Z depth.
    // But we only want the channel along X direction; so define it as a hollow shape? Instead, use difference of two boxes.
    
    // Outer box that represents the full rectangular cross-section (Y width = slot_width) extending from y = y_offset - slot_width/2 to y = y_offset + slot_width/2
    // and z from 0 to block_height - slot_depth (since top of block is at z=block_height/2, but we build upward from base).
    
    // Actually, the block's top face is at z = block_height/2. The slot starts at that top surface and goes down slot_depth mm.
    // So the slot region occupies: x in [x_start, x_end], y in [y_offset - slot_width/2, y_offset + slot_width/2], z in [block_height/2 - slot_depth, block_height/2].
    
    // We'll create a rectangular prism for the slot region and subtract it from the base.
    
    // Define the slot as:
    //   x range: [x_start, x_end]
    //   y range: [y_offset - slot_width/2, y_offset + slot_width/2]
    //   z range: [block_height/2 - slot_depth, block_height/2]
    
    // Create the solid representing the slot region (a rectangular prism) and subtract it from the base.
    
    // Since we are using difference(), we need to make sure the cutting shape extends slightly beyond faces.
    // We'll offset by 0.01 mm in all directions where needed, but OpenSCAD's $fn handles rounding; here we just ensure non-coplanar by using a small extra depth?
    
    // Instead of trying to be too clever, we'll use difference with a slightly larger shape that extends beyond the slot boundaries, then clip appropriately.
    // But simpler: define the slot as a rectangular prism and subtract it directly; if faces become coplanar exactly, $fn=64 will still work but rule 6 says holes come out round and to size – we are using difference on a rectangular cut, which is fine.
    
    // To avoid exact coplanarity (rule 5), we'll make the slot shape extend 0.01 mm beyond the intended boundaries in one direction by slightly increasing the depth or width? But rule says: "make every cutting shape extend 0.01-1 mm past the faces it cuts". So we can simply increase the slot_depth by 0.01 mm, which is acceptable and avoids coplanarity.
    
    // We'll define a small extra margin in Z direction (the depth) of 0.01 mm beyond the intended slot_depth? Actually, the slot should be exactly slot_depth deep; but rule says cutting shape extends past faces by 0.01-1 mm. So we can set the cut region to have depth = slot_depth + 0.01 mm, and then subtract that from the block. This ensures no face is exactly coplanar with the original surface.
    
    // Let's define:
    //   slot_cut_depth = slot_depth + 0.01;   // extends slightly beyond intended depth
    
    // But note: the slot must be open at the top, meaning the top of the slot (the opening) is flush with the block's top surface? Actually, "open at the top" means the slot opens upward to allow slides to stand upright. So the slot should end exactly at the top surface (z = block_height/2). The cut shape must extend a tiny bit below that to avoid coplanarity.
    
    // We'll define the slot region as:
    //   x in [x_start, x_end]
    //   y in [y_offset - slot_width/2, y_offset + slot_width/2]
    //   z in [block_height/2 - slot_depth, block_height/2 - 0.01]   (so the cut shape goes down to just below the top surface)
    
    // Then subtract this from the base; the remaining part will have a small recessed opening that is slightly larger than intended? But we want the slot to be exactly slot_depth deep, and open at the top meaning the top edge of the slot is flush with the block's top surface.
    
    // Actually, "open at the top" means the slot opens upward – i.e., the top face of the slot (the opening) is coplanar with the block's top surface? Or does it mean the slot has an open top edge so a slide can stand upright? Typically, for a drying rack holding slides standing upright on their long edge, the slot should be wide enough to accommodate the slide width and depth such that the slide sits vertically.
    
    // Given: slide dimensions 75 x 25 x 1 mm (standing upright on long edge). The slot runs along X direction, is 77 mm long, 1.6 mm wide (Y), and 10 mm deep, open at the top.
    // So the slot cross-section in Y is 1.6 mm width; the slot depth (Z) is 10 mm downward from the top surface. The slot is open at the top meaning the top of the slot (the upper edge) is flush with the block's top surface? Or does "open at the top" mean there is no lid, i.e., the slot opens upward so a slide can stand up?
    
    // Interpretation: The slot is a channel that goes down 10 mm from the top surface; the opening (the top edge) is open to allow slides to sit upright on their long edge. So the slot's top face should be coplanar with the block's top surface, but the cut shape must extend slightly below so faces are not exactly coplanar.
    
    // Therefore, we define the slot region as:
    //   x in [x_start, x_end]
    //   y in [y_offset - slot_width/2, y_offset + slot_width/2]
    //   z in [block_height/2 - slot_depth, block_height/2]   (this region is exactly the intended cut)
    
    // But if we subtract this exact rectangular prism from the base, the resulting surface at z = block_height/2 will be exactly coplanar with the original top face? Actually, the base's top face is a square; after subtraction, the remaining shape has a recessed opening that is exactly flush – but the cut faces are planar and may align perfectly.
    
    // Rule 5: "In difference(), make every cutting shape extend 0.01-1 mm past the faces it cuts, so no faces are exactly coplanar."
    // So we must ensure the cutting shape (the one we subtract) extends slightly beyond the intended cut surface in at least one direction by a small amount (0.01–1 mm).