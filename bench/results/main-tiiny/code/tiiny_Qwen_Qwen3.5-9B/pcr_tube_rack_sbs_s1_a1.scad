// 96-Well PCR Tube Rack (ANSI/SLAS Footprint)
// Designed for FDM 3D printing. Rests on XY plane at Z=0.

// --- Dimensions (mm) ---
// Overall Block Dimensions
$w_block = 127.76; // Width (X)
$d_block = 85.48;  // Depth (Y)
$h_block = 20.0;   // Height (Z)

// Hole Specifications
$d_hole = 6.2;    // Hole diameter
$spacing = 9.0;   // Centre-to-centre spacing (X and Y)
$cols = 12;       // Number of columns (along X)
$rows = 8;        // Number of rows (along Y)

// Grid Offset (Distance from edge to first hole centre)
$offset_x = 14.38; // Distance from left edge (X=0) to first hole
$offset_y = 11.24; // Distance from back edge (Y=0) to first hole

// Chamfer Specifications
$chamfer_leg = 5.0; // Leg length of the 45-degree chamfer
$chamfer_angle = 45; // Degrees

// --- Configuration ---
$fn = 64; // Resolution for curved shapes

// --- Generation ---

// Define the main block
block = cube([
    $w_block, 
    $d_block, 
    $h_block
], center=true);

// Define the hole cutter
// We extend slightly past the hole diameter to ensure clean cutting
// Rule 5: extend 0.01-1 mm past faces. Using 0.5mm.
$cut_extension = 0.5;
$cut_diameter = $d_hole + 2 * $cut_extension;

hole_cutter = cylinder(
    h = $h_block + 2, // Extend slightly above and below to ensure full cut
    r = $cut_diameter / 2,
    center=true
);

// Define the chamfer cutter
// We need to cut a 45-degree chamfer with leg $chamfer_leg
// This is a wedge shape.
// The wedge needs to be tall enough to cut through the whole block height.
$chamfer_height = $h_block + 2;

// Create the wedge profile for the chamfer
// A 45-degree chamfer means the cut goes in X and Z equally.
// We create a polygon profile rotated 45 degrees.
// The profile is a triangle with base $chamfer_leg and height $chamfer_leg.
chamfer_profile = polygon(
    points = [
        [0, 0],           // Bottom corner (to be cut)
        [$chamfer_leg, 0], // Bottom of cut
        [$chamfer_leg, $chamfer_leg], // Top of cut (diagonal)
        [0, $chamfer_leg]  // Top corner (to be cut)
    ],
    center = [0, 0]
);

// Extrude the chamfer profile to create the wedge
chamfer_wedge = linear_extrude(
    h = $chamfer_height,
    center = true
)(
    chamfer_profile
);

// Position the chamfer wedge
// It needs to be at the A1 corner (X=0, Y=0 relative to block corner).
// Since the block is centered at origin, the corner is at:
// X = -$w_block/2 + $chamfer_leg
// Y = -$d_block/2 + $chamfer_leg
// Z = 0 to $h_block
chamfer_wedge_pos = translate([
    -$w_block/2 + $chamfer_leg,
    -$d_block/2 + $chamfer_leg,
    0
])(
    chamfer_wedge
);

// Create the 96 holes using a for loop
// Loop over columns (X) and rows (Y)
holes = for (c = [0:$cols-1], r = [0:$rows-1]) {
    // Calculate position of the hole centre
    // X position: offset_x + c * spacing
    // Y position: offset_y + r * spacing
    // Note: The user defined offsets from the "left edge" and "back edge".
    // In our centered block model:
    // Left edge X = -$w_block/2
    // Back edge Y = -$d_block/2
    
    pos_x = -$w_block/2 + $offset_x + c * $spacing;
    pos_y = -$d_block/2 + $offset_y + r * $spacing;
    
    translate([pos_x, pos_y, 0])(hole_cutter);
}

// Combine all parts
// 1. Start with the block
// 2. Subtract the holes
// 3. Subtract the chamfer wedge

final_rack = union(
    block,
    // We use difference to cut holes and chamfer
    difference() {
        // The main body
        block,
        
        // The holes
        holes,
        
        // The chamfer
        chamfer_wedge_pos
    }
);

// Render the final part
final_rack;