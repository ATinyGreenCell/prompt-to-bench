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
$lip_height = 4; // Note: The prompt says "4 mm tall". 
                  // If the lip is a wall, does it mean the wall is 4mm high?
                  // Or the total height of the lip structure is 4mm?
                  // Given "1.5 mm thick wall, 4 mm tall", this usually means the wall height is 4mm.
                  // However, the previous prompt said "lip on top of it... 4mm tall".
                  // Let's re-read carefully: "a rectangular lip on top of it - a 1.5 mm thick wall, 4 mm tall".
                  // This implies the wall height is 4mm.
                  // BUT, the previous code used $lip_height = 4 and $lip_thickness = 1.5.
                  // If the wall is 4mm tall, the outer dimension of the lip would be Plate + 4 = 6mm.
                  // The prompt says "whose outer size is 65.6 x 45.6 mm". This refers to the footprint.
                  // It does not specify the total height of the lip structure, just the wall height.
                  // Wait, if the wall is 4mm tall, and it sits on a 2mm plate, the total height is 6mm.
                  // Let's assume the wall height is 4mm.
                  // However, looking at the previous code's variable names, I set $lip_height = 4.
                  // If I change the logic to a frame, the height of the frame is the critical dimension.
                  // Let's assume the "4 mm tall" refers to the wall height.
                  // So the lip structure is: Plate (2mm) + Wall (4mm) = 6mm total height.
                  // The footprint is 65.6 x 45.6.
                  // The hole inside the wall needs to match the box inner dimensions.
                  // Box Inner: 66 x 46.
                  // Lip Outer: 65.6 x 45.6.
                  // This means the Lip Outer is SMALLER than the Box Inner.
                  // This confirms the Lip is a frame that slides IN.
                  // The hole inside the lip must be smaller than the Lip Outer by the wall thickness (1.5mm).
                  // Lip Inner X = 65.6 - 1.5 = 64.1.
                  // Lip Inner Y = 45.6 - 1.5 = 44.1.
                  // Box Inner X = 66.
                  // Clearance = (66 - 64.1) / 2 = 0.95mm. This is a very tight fit but valid.
                  // Wait, the prompt said "0.2 mm clearance on each side".
                  // If Box Inner = 66, and Clearance = 0.2, then Lip Inner = 65.6.
                  // If Lip Inner = 65.6 and Lip Wall = 1.5, then Lip Outer = 65.6 + 1.5 + 1.5 = 68.6.
                  // But the prompt says "whose outer size is 65.6 x 45.6 mm".
                  // There is a contradiction in the prompt's numbers if we assume standard geometry.
                  // Let's re-read: "lip on top of it - a 1.5 mm thick wall, 4 mm tall, whose outer size is 65.6 x 45.6 mm".
                  // This explicitly defines the Outer Size of the lip as 65.6 x 45.6.
                  // And the Box Outer is 70 x 50. Wall 2mm. Box Inner = 66 x 46.
                  // If Lip Outer = 65.6, then Lip Inner = 65.6 - 1.5 - 1.5 = 62.6.
                  // Clearance = (66 - 62.6) / 2 = 1.7mm.
                  // The prompt says "0.2 mm clearance".
                  // This implies the user might have meant the *Inner* size of the lip is 65.6?
                  // Or the wall is thinner?
                  // Given the explicit "outer size is 65.6", I must follow that. The "0.2mm clearance" might be an approximation or based on a different wall thickness in the user's mind, but the dimensions are explicit.
                  // I will follow the explicit dimensions: Lip Outer = 65.6 x 45.6, Wall = 1.5.
                  // This results in a clearance of ~1.7mm, which is actually quite good for a slide-in fit.
                  // The "4 mm tall" refers to the wall height.

// Re-evaluating "4 mm tall":
// If the wall is 4mm tall, the lip structure is 2mm (plate) + 4mm (wall) = 6mm high.
// The previous code used $lip_height = 4. If I use that for the wall height, the total height is 6.
// Let's stick to the explicit numbers.

$lip_outer_x = 65.6;
$lip_outer_y = 45.6;
$lip_wall_thickness = 1.5;
$lip_wall_height = 4; // The wall is 4mm tall.

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
// Structure:
// 1. Base Plate: 70 x 50 x 2
// 2. Lip Frame: Sits on top of the plate.
//    - Outer Footprint: 65.6 x 45.6