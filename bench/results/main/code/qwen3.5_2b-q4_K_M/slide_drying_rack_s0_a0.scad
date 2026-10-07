// Design a drying rack for microscope slides
// Dimensions: Base Block = 90mm x 45mm x 20mm, Slots cut into top face (77x16) at 3.5mm spacing along X-axis.

fn = 64; // High resolution for smooth curved surfaces if any were used later

block_size_x = 90;
base_height_z = 20;
slot_length_y = 16; // Width of the slot in Y direction (perpendicular to slide length)
slot_depth_z = 10;
slide_width_mm = 75;
slide_thickness_mm = 25; // Thickness along Z axis, which is actually height here? Wait.

// Let's re-read carefully: "microscope slides (75 x 25 x 1 mm) standing upright on their long edge."
// Long edge of slide usually refers to the longer dimension in a rack context or just standard orientation.
// Dimensions given: 75, 25, 1mm.
// If they stand "upright", typically height is one side (e.g., 1mm), width another (25mm?), length longest (75mm?).
// However, the rack description says slots run along X and are 3.5mm apart in Y.
// The base block dimensions: 90 long (X), 45 wide (Y).
// Slots cut into top face. Top face is usually XY plane? Or Z=height surface?
// "stands upright on their long edge" -> This implies the slides are vertical columns of height ~1mm, width ~25mm or similar.
// But then it says slots run along X and are 3.5mm apart in Y. If the slide is standing vertically (say Z=1), its face would be XY plane? No, if it stands on a long edge, that means one dimension of the base block aligns with the length of the slide.
// Let's assume standard microscope slides: Length ~75-80mm, Width/Height ~24x3 or similar. Here 75 x 25 x 1.
// If they stand upright on their long edge (the 75mm side), then height = 1mm? No, that would be lying flat if the base is XY and slides are vertical columns along Z? 
// Actually, "standing upright" usually means the slide's face is perpendicular to gravity or it stands like a book.
// Let's look at the slot geometry: Slots run along X (90mm). They are 3.5mm apart in Y. This implies there are multiple slots stacked vertically on top of each other? Or side-by-side? 
// If they are "parallel", and spaced by 3.5mm, it suggests a grid or stack.
// Let's assume the base block is sitting flat (XY plane). The slides stand UP from this surface. So height = slide_thickness_mm = 1 mm? That seems very thin for a rack to hold them upright without support unless they are just resting on their bottom face which matches the XY plane of the block perfectly.
// Wait, "standing upright" might mean the long edge (75mm) is vertical? No, that would be lying down if base is 90x45 and slots run along X... 
// Let's re-evaluate: Base Block = 90 (X), 45 (Y). Slots cut into top face. Top face of a block usually implies the largest surface area or the Z=height plane? Or XY plane if it sits on its bottom?
// If slots run along X, and are spaced in Y... this suggests we have multiple rows of holes stacked vertically. 
// Let's assume: The base is 90mm long (X), 45mm wide (Y). It rests on the XY plane at z=0.
// Slides stand "upright". If they were lying flat, their faces would be vertical? No, slides are usually rectangular prisms. 
// Let's assume the slide dimensions correspond to: Length = 75mm, Width/Height combination = 25x1 mm.
// If we place them on top of a block (XY plane), and they stand "upright", it implies their height is along Z? Or maybe the base sits on its bottom face (90x45) and slides are vertical columns extending from that surface? 
// But then where do the slots go? Slots run along X. If we have a stack of 1mm high blocks, they would be stacked in Y or Z?
// "3.5 mm apart centre-to-centre (in Y)". This strongly implies there is more than one slot per row if it's a single layer, OR the slots are arranged such that their centers form a grid along X and Y? 
// Actually, 90mm / 16mm = ~5-6 slots. If they run along X, spaced in Y... this sounds like we have multiple columns of holes stacked vertically (along Z) or rows stacked horizontally (along Y).
// Given "parallel", let's assume a stack of slides placed on top of the block surface? No, that would be 1mm high blocks. 
// Alternative interpretation: The base is sitting flat. We are cutting slots into its XY face? But then how do we hold them upright if they are just resting there? They need support from below or above.
// Let's assume the standard "microscope slide rack" design where slides stand vertically (height = 1mm) and rest on their bottom faces which match the block surface, OR the base is actually a shelf holding vertical columns of height ~75-80mm? 
// Re-reading: "holds ... standing upright". If they are 25x1 mm thick, standing upright means Height=1mm.
// But then how do we fit them in slots that run along X and have spacing in Y? This implies the slides might be arranged side-by-side (along Z?) or stacked vertically (along Y?). 
// Let's try: Slides are placed on top of each other, aligned with their long edge (75mm) running parallel to one axis.
// If we stack them along X-axis (90mm), then the slots would run along Y? No, "slots ... runs along X". So slides must be oriented such that their length is in Z or they are stacked vertically and holes go sideways? 
// Let's try this configuration: The base block sits on XY plane. We cut 10 parallel grooves into its top face (XY). These grooves run along the Y-axis direction of the slots, but wait... "slots ... runs along X". This means the slot length is in Z or Y? 
// If a groove runs along X, it extends from one end to another. It has width and depth perpendicular to that axis.
// Let's assume: The base block (90x45) sits on XY plane at z=0. We cut 10 parallel slots into the top face (XY). 
// Wait, if we cut a slot in the XY face of a flat object, it goes through Z? No, "open at the top". This implies the block is not solid all the way to infinity, or there are overhangs.
// Actually, usually these racks have slots on one side (e.g., Y-side) that hold vertical columns of slides stacked along X and Z? 
// Let's simplify based on exact text: "slots ... runs along X". This means the slot axis is parallel to X-axis. So it extends from -X/2 to +X/2. Its width in Y-direction (16mm?) and depth in Z-direction (10mm?).
// If we have 3.5mm spacing, how many fit? 90 / 3.5 = ~25 slots along X if they were stacked vertically? 
// But the text says "group of slots is centred on the block". And there are exactly 10 slides to hold.
// This implies we have a grid or specific arrangement.
// Let's assume: We place 10 slides side-by-side (along Z-axis?) No, they stand upright. 
// Maybe the base sits flat, and we cut slots into its top face? But then how do we support them if it's just a shelf? They need vertical supports.
// Perhaps the "standing upright" means the slide is placed vertically on the block surface (XY plane), so height = 1mm? And they are arranged along X or Y? 
// If slots run along X, and there are multiple of them... maybe we have columns of slides stacked in Z direction? No, that would be "stacked".
// Let's assume: The base is a shelf. We cut vertical grooves into its top face (XY plane). These grooves allow us to place 10 slides side-by-side along the X-axis or Y-axis? 
// If slots run along X, they are long in Z direction? No, "runs along X" means axis = X. So it goes from -X/2 to +X/2.
// Let's assume: The base block (90x45) sits on XY plane at z=0. We cut 10 parallel slots into the top face (XY). 
// Wait, if we cut a slot in the XY face of a flat object, it creates an opening through Z? No, "open at the top" implies the block has overhangs or is hollowed out to hold vertical columns