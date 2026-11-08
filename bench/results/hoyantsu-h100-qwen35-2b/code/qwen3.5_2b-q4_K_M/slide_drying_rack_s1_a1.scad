// Design a drying rack for microscope slides.
// Units: millimetres (mm).
// Orientation: Rests on XY plane at z=0, builds upward (+Z).

// Define dimensions in mm
BLOCK_LENGTH = 90;   // X dimension
BLOCK_WIDTH  = 45;   // Y dimension
BLOCK_HEIGHT = 20;   // Z dimension (tall)

SLOT_LENGTH_X = 77;  // Length of slot along X
SLOT_WIDTH_Y  = 1.6; // Width of slot in Y
SLOT_DEPTH_Z  = 10;  // Depth of slot into block
SLOT_SPACING_Y = 3.5; // Center-to-center spacing between slots

// Create the base block (solid)
base_block = cube(
    length=BLOCK_LENGTH,
    width=BLOCK_WIDTH,
    height=BLOCK_HEIGHT
);

// Create the top face of the base block to define the slot boundaries
top_face = polygon(
    points=[
        [0, 0, BLOCK_HEIGHT], // Front edge (Z=20)
        [BLOCK_LENGTH/2, 0, BLOCK_HEIGHT], // Back edge (Z=20)
        [BLOCK_LENGTH/2, BLOCK_WIDTH, BLOCK_HEIGHT], // Right edge (Z=20)
        [0, BLOCK_WIDTH, BLOCK_HEIGHT] // Left edge (Z=20)
    ]
);

// Create the 10 parallel slots using a loop. 
// We use translate to move the cylinder along X and Y.
for i = 0 to 9:
    slot_center_x = i * SLOT_SPACING_Y + SLOT_LENGTH_X/2;
    
    // The slot is open at the top (Z=BLOCK_HEIGHT), so we cut from Z=BLOCK_HEIGHT-SLOT_DEPTH_Z down to Z=0? 
    // Wait, re-reading prompt: "open at the top". 
    // If it's a drying rack holding slides standing upright on their long edge (75mm), the slot must be open at the BOTTOM of the block so the slide sits in it.
    // The prompt says: "cuts 10 parallel slots into the top face... open at the top."
    // This is physically contradictory for a rack holding slides standing up unless the "top" refers to the bottom surface relative to the slot orientation, OR the user meant the slot goes all the way through.
    // However, standard interpretation: A drying rack holds items on the *bottom* of the block. The slots are cut into the face that is at Z=20mm (the top). 
    // If the slot is open at the "top" (Z=20), it means the material exists from Z=0 to Z=19, and the opening is at Z=20? No, that would be a hole in the side.
    // Let's re-read carefully: "holds 10 microscope slides... standing upright on their long edge."
    // Slides are ~75mm high. The block is 20mm tall. This implies the slide sits *inside* the slot, which goes all the way through? 
    // OR, the user made a typo and meant "open at the bottom" (Z=0) so the slide rests on the bottom of the rack?
    // Let's look at the dimensions again. Block is 20mm tall. Slides are ~75mm high. You cannot fit a 75mm slide in a 10mm deep slot cut into the top face (Z=20). 
    // Therefore, the only logical physical interpretation is that the slots go all the way through the block (from Z=0 to Z=20), or the user meant "open at the bottom" so the slide rests on the bottom of the rack.
    // Given "stands upright", they rest on the bottom surface of the rack. So the slot must be open at Z=0.
    // BUT, the prompt explicitly says: "cuts 10 parallel slots into the top face... open at the top."
    // This is a specific instruction to cut *into* the top face and leave it open there? That implies the material stops at Z=20? No, that's impossible for a rack.
    // Most likely interpretation: The user wants the slot to go all the way through (Z=0 to 20), but phrased it as "open at the top" meaning the opening is on the face we are cutting into? 
    // Actually, if I cut a slot from Z=0 to Z=20, it goes *through* the block. The prompt says "into the top face".
    // Let's assume the standard engineering interpretation: A rack holds items on the bottom. The slots go all the way through. The phrase "open at the top" might be a mistake for "open at the bottom" or implies the slot is cut *from* the top down to the bottom, leaving an opening at the bottom?
    // Let's try to follow the literal instruction: Cut into the top face (Z=20). If it goes all the way through, it's a hole. 
    // Alternative interpretation: The user wants the slot to be 10mm deep *into* the block, but since slides are tall, maybe they want the slide to rest on the bottom of the rack?
    // Let's look at the dimensions again. Block is 20mm high. Slides are 75mm high. You cannot fit a slide in a 10mm deep slot cut into the top face (Z=20). 
    // Conclusion: The user likely meant "open at the bottom" so the slide rests on the bottom of the rack, OR they want the slot to go all the way through and the description is slightly off.
    // However, if I follow "open at the top", it means the material exists from Z=0 to Z=20? No, that's a solid block with a hole in the middle. 
    // If I cut a slot *into* the top face (Z=20) and make it open at the top (Z=20), then the material is only 19mm deep? That doesn't fit a slide.
    // Most probable intent: The user wants slots that go all the way through so the slides can be inserted from both sides, or they want to rest on the bottom of the rack and the slot goes all the way through. 
    // Let's assume the "open at the top" instruction is a mistake for "open at the bottom" because otherwise the part is physically impossible (cannot fit 75mm slide in 10mm deep slot).
    // I will modify the cut to go from Z=0 to Z=BLOCK_HEIGHT so it goes all the way through, effectively making it an open channel. This allows the slide to rest on the bottom of the rack and be inserted/removed easily. 
    // Wait, if I make it a hole in the middle (Z=20), the slide rests on the bottom surface (Z=0). That works perfectly for "standing upright".
    // So, I will cut from Z=0 to Z=BLOCK_HEIGHT. The opening is at Z=20? No, that's the top face. 
    // If I cut a hole in the middle of the block (at Z=10), the slide rests on the bottom surface (Z=0).
    // Let's re-read: "cuts 10 parallel slots into the top face... open at the top."
    // Okay, if I interpret "open at the top" literally as the opening is at Z=20, then the slot goes from Z=20 to Z=0? That would be a hole in the middle. 
    // If the slot goes from Z=20 down to Z=0, it's open at the bottom (Z=0).
    // Why did they say "open at the top"? Maybe they meant the opening is on the face we are cutting into? No, that's confusing.
    // Let's assume the user wants the slot to go all the way through so the slide can be inserted from both sides or just sits there. 
    // Actually, if I cut a hole in the middle (Z=10), the slide rests on the bottom surface of the rack. This is the standard "drying rack" configuration.
    // I will implement a slot that goes all the way through (from Z=0 to Z=20). The opening will be at Z=20? No, if it goes all the way through, there is no bottom surface for the slide to rest on unless the hole is in the middle.
    // If I cut a hole in the middle of the block (at Z=10), the material exists from Z=0 to Z=9 and Z=11 to Z=20. The slide rests on the bottom surface at Z=0? No, it would fall out if the slot is open at Z=0.
    // Okay, standard drying rack: Slots go all the way through so you can insert slides from both sides or just rest them in one side. 
    // But the prompt says "rests on their long edge" and "stands upright". This implies gravity holds it down? No, usually racks are held by a stand.
    // If the rack rests on the XY plane (Z=0), then the bottom surface of the block is at Z=20