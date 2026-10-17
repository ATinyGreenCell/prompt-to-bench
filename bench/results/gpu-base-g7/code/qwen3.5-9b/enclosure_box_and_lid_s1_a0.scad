// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10 mm gap between them.

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
// Lip dimensions
$lip_thickness = 1.5;
$lip_height = 4;
// Lip outer size (fits inside box opening)
$lip_outer_x = 65.6;
$lip_outer_y = 45.6;

// Clearance
$clearance = 0.2;

// Gap between parts
$gap = 10;

// --- Configuration ---
$fn = 64; // Smooth curves

// --- Part 1: The Box ---
// Position: Centered in Y, starts at X = -($box_outer_x/2 + $gap/2)
// Rests on Z=0
translate([ -($box_outer_x/2 + $gap/2), 0, 0 ])
difference() {
    // Outer block
    cube([ $box_outer_x, $box_outer_y, $box_outer_z ]);
    
    // Cut out the inside (open top)
    // Inner dimensions:
    // X: outer_x - 2*wall
    // Y: outer_y - 2*wall
    // Z: outer_z - floor - lip_height (to allow lid to slide in)
    // We extend the cut slightly past the bottom to ensure clean separation from the bed if needed, 
    // but strictly speaking we just need to cut the interior volume.
    // To ensure the lid slides in, the cut must go down to the bottom of the intended lid position.
    // The lid sits on top of the box. The lip height is 4mm.
    // We cut a hole that is deep enough for the lid to sit flush with the top of the box.
    
    inner_x = $box_outer_x - (2 * $wall_thickness);
    inner_y = $box_outer_y - (2 * $wall_thickness);
    inner_z = $box_outer_z - $floor_thickness; // Cut all the way to the bottom of the box walls
    
    // Extend cut slightly past the bottom face to ensure no thin walls remain at the very bottom edge
    translate([0, 0, -0.1]) 
    cube([ inner_x, inner_y, inner_z + 0.1 ]);
}

// --- Part 2: The Lid ---
// Position: Centered in Y, starts at X = +($box_outer_x/2 + $gap/2)
// Rests on Z=0 (printed upside down as requested)
translate([ $box_outer_x/2 + $gap/2, 0, 0 ])
difference() {
    // Base Plate
    cube([ $box_outer_x, $box_outer_y, $plate_thickness ]);
    
    // Cut out the hole for the lip
    // The lip outer size is $lip_outer_x by $lip_outer_y.
    // We need to cut a hole slightly larger than the lip outer size to allow it to slide in.
    // Clearance on each side is 0.2mm.
    // Hole X = lip_outer_x + 2*clearance
    // Hole Y = lip_outer_y + 2*clearance
    // Depth = lip_height + lip_thickness (to remove the material the lip will sit on)
    
    hole_x = $lip_outer_x + (2 * $clearance);
    hole_y = $lip_outer_y + (2 * $clearance);
    hole_depth = $lip_height + $lip_thickness;
    
    // Extend cut slightly past the top face (which is the bottom of the printed part)
    translate([0, 0, $plate_thickness + 0.1])
    cube([ hole_x, hole_y, hole_depth - $plate_thickness - 0.1 ]);
    
    // Note: Since we are printing upside down, the "top" of the geometry in the model 
    // corresponds to the bottom of the printed part touching the bed.
    // The lip hangs down from the "top" of the plate in the model (which is the bottom of the print).
    // Wait, the prompt says "printed upside down: a plate ... lying on the bed, with a rectangular lip on top of it".
    // If it lies on the bed, the "top" of the plate is facing UP (away from bed).
    // The lip is on top of the plate.
    // So in the model (Z=0 is bed), the plate is at Z=0 to Z=2. The lip is at Z=2 to Z=6.
    // The lip slides into the box. The box opening is at the top of the box (Z=30).
    // So the lip must be at Z=30 when assembled.
    // Since the lid is printed at Z=0, we need to translate the whole lid UP by 30mm?
    // NO. The prompt says "Place the lid on the +X side of the box".
    // And "Prints together".
    // If the box is at Z=0..30, and the lid is printed at Z=0, the lid must be positioned such that 
    // its lip aligns with the box opening at Z=30.
    // Therefore, the lid geometry must be translated UP by 30mm in the model space?
    // Let's re-read carefully: "Part 2, the lid, printed upside down: a plate 70 x 50 x 2 mm lying on the bed".
    // This implies the physical part sits on the bed.
    // "with a rectangular lip on top of it".
    // "Place the lid on the +X side of the box".
    // If they print together, the box is at Z=0..30. The lid is at Z=0..(2+4+1.5)?
    // If the lid is at Z=0, its lip is at Z=2..6. The box opening is at Z=30. They won't fit.
    // Interpretation: The user wants the STL to contain both parts. The user will print them.
    // "Prints together" usually means they are on the same build plate.
    // If the box is 30mm tall, and the lid is printed "upside down" (meaning the lip is the bottom-most feature relative to the part's logic, or just the orientation of the print file?),
    // Let's assume the standard interpretation for "printed upside down" in this context:
    // The part is modeled such that the lip is at the bottom (Z=0) and the plate is above it?
    // NO, "lying on the bed" means the plate is at Z=0.
    // If the plate is at Z=0, and the lip is on top, the lip is at Z=2 to Z=6.
    // The box is at Z=0 to Z=30.
    // How do they assemble?
    // Maybe the box is not 30mm tall? "outer size 70 x 50 x 30 mm". Yes it is.
    // Maybe the lid is printed separately? "Prints together".
    // Maybe the "lid" is actually a cover that goes OVER the box?
    // If the lid is printed at Z=0, and the box is at Z=0, the lid must be shifted in Z to match the box height?
    // But "Prints together" implies they are on the same Z-level range?
    // If I print a 30mm tall box and a 6mm tall lid on the same bed, they are not "together" in the sense of a single assembly unit unless the lid is shifted up.
    // However, in OpenSCAD, "prints together" usually means the union of the two parts fits on the bed without collision.
    // If the box is at Z=0..30, and the lid is at Z=0..6, they don't collide.
    // But they won't assemble.
    // Re-reading: "Place the lid on the +X side of the box".
    // This refers to the X position.
    // Perhaps the user intends for the lid to be printed such that the lip is at the bottom (Z=0) so it can be inserted into the box from the bottom?
    // "printed upside down: a plate ... lying on the bed, with a rectangular lip on top of it".
    // This phrasing is tricky. "Lying on the bed" = Plate at Z=0. "Lip on top" = Lip at Z>0.
    // If the box is open top (Z=30), and the lid is at Z=0..6, they don't meet.
    // UNLESS the box is inverted? No, "