// Two-part enclosure for small electronics board
// Part 1: Box (Left)
// Part 2: Lid (Right, printed upside down as specified)
// Prints together with a 10mm gap between them.

// --- Dimensions ---
// Box Outer Dimensions (X x Y x Z)
$box_outer_x = 70;
$box_outer_y = 50;
$box_outer_z = 30;

// Wall and Floor Thickness
$wall_thickness = 2;
$floor_thickness = 2;

// Lid Dimensions
// Plate thickness
$plate_thickness = 2;
// Lip thickness
$lip_thickness = 1.5;
// Lip height (extends above plate)
$lip_height = 4;
// Lip Outer Size (X x Y)
$lip_outer_x = 65.6;
$lip_outer_y = 45.6;

// Clearance
// The lip outer size is 65.6 vs box inner 66.0 (70 - 2*2).
// Difference is 0.4mm total, so 0.2mm clearance per side.
$clearance_x = 0.2;
$clearance_y = 0.2;

// Gap between parts
$gap_between_parts = 10;

// --- Configuration ---
$fn = 64; // Smooth curves

// --- Positioning ---
// Center the whole assembly on X=0.
// Box X center: -(gap + box/2)
// Lid X center: +(gap + box/2)
// Both centered on Y=0.

$box_x_pos = -($gap_between_parts/2 + $box_outer_x/2);
$box_y_pos = 0;
$box_z_pos = 0;

$lid_x_pos = $gap_between_parts/2 + $box_outer_x/2;
$lid_y_pos = 0;
$lid_z_pos = 0;

// --- Part 1: The Box ---
translate([
    $box_x_pos, 
    $box_y_pos, 
    $box_z_pos
])
difference() {
    // Outer Block
    cube([
        $box_outer_x, 
        $box_outer_y, 
        $box_outer_z
    ]);
    
    // Cut out the inside (open top)
    // Inner dimensions:
    // X: 70 - 2*2 = 66
    // Y: 50 - 2*2 = 46
    // Z: 30 - 2 (floor) = 28
    translate([
        $wall_thickness, 
        $wall_thickness, 
        $floor_thickness
    ])
    cube([
        $box_outer_x - (2 * $wall_thickness), 
        $box_outer_y - (2 * $wall_thickness), 
        $box_outer_z - $floor_thickness
    ]);
}

// --- Part 2: The Lid ---
// Specification: "printed upside down: a plate 70 x 50 x 2 mm lying on the bed, 
// with a rectangular lip on top of it".
// This means the plate is at Z=0 and the lip grows in +Z.
// The lip dimensions are defined by its outer size (65.6 x 45.6) and thickness (1.5).
// The lip sits on the plate.
// To match the clearance:
// Box Inner X = 66. Lip Outer X = 65.6. Gap = 0.4mm (0.2mm each side).
// Box Inner Y = 46. Lip Outer Y = 45.6. Gap = 0.4mm (0.2mm each side).
// This geometry allows the lip to slide into the box opening if the lid were placed on top.
// Since they print side-by-side, this part is just a block sitting on the bed.

translate([
    $lid_x_pos, 
    $lid_y_pos, 
    $lid_z_pos
])
difference() {
    // 1. The Base Plate (70 x 50 x 2)
    cube([
        $box_outer_x, 
        $box_outer_y, 
        $plate_thickness
    ]);
    
    // 2. The Lip (Rectangular block on top of the plate)
    // Outer size: 65.6 x 45.6
    // Thickness: 1.5
    // It sits on top of the plate (Z starts at 2.0)
    translate([
        ($box_outer_x - $lip_outer_x) / 2, 
        ($box_outer_y - $lip_outer_y) / 2, 
        $plate_thickness
    ])
    cube([
        $lip_outer_x, 
        $lip_outer_y, 
        $lip_thickness
    ]);
    
    // 3. The Hole (Cutout inside the lip)
    // The lip is a "wall" or "frame". We need to cut the inside of the lip.
    // Lip Outer: 65.6 x 45.6
    // Clearance: 0.2mm per side.
    // Lip Inner: (65.6 - 0.4) x (45.6 - 0.4) = 65.2 x 45.2
    // Thickness of the cut: The lip is 1.5mm thick.
    // We cut a hole that is 1.5mm deep (into the lip) and extends slightly past the bottom to ensure clean separation from the plate.
    translate([
        ($lip_outer_x - ($lip_outer_x - 0.4)) / 2, 
        ($lip_outer_y - ($lip_outer_y - 0.4)) / 2, 
        $plate_thickness
    ])
    cube([
        $lip_outer_x - 0.4, 
        $lip_outer_y - 0.4, 
        $lip_thickness + 0.1 // Extend slightly past the lip bottom to ensure clean cut
    ]);
}