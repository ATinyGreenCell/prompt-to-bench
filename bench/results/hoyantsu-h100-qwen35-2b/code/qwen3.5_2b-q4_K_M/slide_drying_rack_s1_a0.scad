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

// Create the top face of the base block
top_face = polygon(
    points=[
        [0, 0, BLOCK_HEIGHT], // Front edge (Z=20)
        [BLOCK_LENGTH/2, 0, BLOCK_HEIGHT], // Back edge (Z=20)
        [BLOCK_LENGTH/2, BLOCK_WIDTH, BLOCK_HEIGHT], // Right edge (Z=20)
        [0, BLOCK_WIDTH, BLOCK_HEIGHT] // Left edge (Z=20)
    ]
);

// Create the 10 parallel slots using a loop
for i = 0 to 9:
    slot = translate(
        x=i * SLOT_SPACING_Y + SLOT_LENGTH_X/2,
        y=SLOT_WIDTH_Y/2, // Center of slot in Y
        z=BLOCK_HEIGHT - SLOT_DEPTH_Z
    ) * cylinder(
        radius=SLOT_WIDTH_Y / 2,
        height=SLOT_DEPTH_Z
    );

// Combine the base block and the slots into a single solid part
drying_rack = union([base_block, slot for i in [0..9]]);

// Render the final model
render(drying_rack);