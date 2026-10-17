// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
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

// --- Part 1: The Box ---
// Position: Centered on Y, starts at X = -($gap_between_parts/2 + $box_outer_x/2)
// Actually, let's center the whole assembly on X=0.
// Box X center: -(gap + box/2)
// Lid X center: +(gap + box/2)

$box_x_pos = -($gap_between_parts/2 + $box_outer_x/2);
$box_y_pos = 0;
$box_z_pos = 0;

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
// Position: Centered on Y, starts at X = +($gap_between_parts/2 + $box_outer_x/2)
// Printed upside down means the plate is on the bed (Z=0) and the lip goes UP.
// Wait, user said "printed upside down: a plate ... lying on the bed, with a rectangular lip on top of it".
// This implies the plate is the bottom face touching the bed, and the lip extends upwards from it.
// This is the standard orientation for a lid if you print it right-side up relative to the box.
// However, the prompt says "printed upside down". 
// If the box is sitting on the bed (floor at Z=0), the lid must sit on top of the box.
// If the lid is printed "upside down", usually that means the feature that should be on top is printed facing down?
// Let's re-read carefully: "Part 2, the lid, printed upside down: a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
// This description describes the geometry relative to the print bed.
// "Plate lying on the bed" -> Plate is at Z=0.
// "Lip on top of it" -> Lip extends in +Z direction.
// This creates a shape that looks like a box with a raised rim.
// If we place this next to the box, the rim will be at Z=2 (plate) + 4 (lip) = 6mm high.
// The box is 30mm high. This lid will not cover the box if placed on the bed next to it.
// 
// Interpretation Correction:
// The user likely means the *geometry* is defined as a plate with a lip, but the *orientation* in the file should be such that it fits the box.
// OR, the user wants the part printed such that the "top" of the part (the lip) is facing the bed? No, that would make the lip go into the bed.
// Let's look at the dimensions.
// Box Inner: 66 x 46 x 28.
// Lip Outer: 65.6 x 45.6.
// Lip Height: 4mm.
// If the lid sits on the box, the total height of the lid assembly must be roughly the box height (30mm) minus some clearance, or it must be a separate piece that screws on.
// But the prompt says "Place the lid on the +X side of the box". This implies they print together on the bed.
// If they print together on the bed, the lid must be a separate piece sitting on the bed, and the box sits on the bed.
// If the lid is just a plate with a lip (height 6mm total), it won't cover the 30mm box.
// 
// Alternative Interpretation: The user wants the lid to be the *top* of the box, but printed separately? No, "print together".
// Maybe the "lip" is actually the *bottom* of the lid, and the main body of the lid is missing?
// Let's reconsider the "printed upside down" phrase.
// If I print a lid normally: Plate is at the top (Z=30), Lip is at the top (Z=30).
// If I print it upside down: Plate is at the bottom (Z=0), Lip is at the bottom (Z=0).
// But the prompt says: "a plate ... lying on the bed, with a rectangular lip on top of it".
// This explicitly defines the Z-axis growth: Plate at Z=0, Lip growing +Z.
// This results in a 6mm tall object.
// How does this cover a 30mm box? It doesn't.
// 
// Hypothesis: The user wants the lid to be a separate piece that sits *inside* the box? No, "enclosure".
// Hypothesis: The user wants the lid to be a separate piece that sits *on top* of the box, but the description of the geometry is relative to the *lid's own coordinate system* before rotation?
// "Part 2, the lid, printed upside down: [Description of geometry relative to bed]".
// If the description says "Plate on bed, Lip on top", then the printed part is 6mm tall.
// Perhaps the "Lip" is actually a recess? No, "lip on top of it".
// 
// Let's look at the dimensions again.
// Box: 70x50x30.
// Lid Plate: 70x50x2.
// Lip: 1.5 thick, 4 tall. Outer 65.6x45.6.
// If the lid is placed on the +X side of the box, maybe it's a *side cover*?
// "Two-part enclosure". Usually Top and Bottom.
// If it's a side cover, it would be 70x30x2 (approx). But the plate is 70x50.
// 
// Let's assume the user made a slight confusion in the description of the final assembly vs the print orientation, OR they want a specific "snap-fit" style where the lid is a separate block that sits on the bed, and the box sits on the bed, and they are just two separate printed objects that happen to be in the same file.
// BUT, if the lid is only 6mm tall, it doesn't enclose the 30mm box.
// 
// Wait, could "lip on top of it" mean the lip is the *bottom* of the lid, and the rest of the lid is implied to be the same size as the box?
// "a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it - a 1.5 mm thick wall, 4 mm tall, whose outer size is 65.6 x 45.6 mm".
// This sounds like the entire part is just the plate + lip.
// If so, this part is 6mm tall.
// If I put this next to the box, it's just a small block.
// 
// Let's try a different interpretation of "printed upside down".
// Maybe the user wants the lid to be the *bottom* of the box?
// If the box is the main