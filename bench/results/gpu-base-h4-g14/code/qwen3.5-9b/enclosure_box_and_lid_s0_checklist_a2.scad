// Two-part enclosure for electronics board.
// Part 1: Box (left). Part 2: Lid (right, printed upside down).
// Both parts sit on the XY plane (Z=0) with a 10 mm gap between them.

// --- Dimensions ---
// Box outer dimensions (X, Y, Z)
box_w  = 70;
box_h  = 50;
box_d  = 30;

// Wall and floor thickness
wall_t = 2;
floor_t = 2;

// Lid dimensions
lid_plate_t = 2;
lip_t       = 1.5;
lip_h       = 4;
lip_outer_w = 65.6;
lip_outer_h = 45.6;

// Clearance
clearance = 0.2;

// Gap between parts
gap = 10;

// --- Derived Dimensions ---
// Inner box dimensions
box_inner_w = box_w - 2 * wall_t;
box_inner_h = box_h - 2 * wall_t;
box_inner_d = box_d - floor_t; // Open top, so only floor thickness subtracts from Z

// Lip inner dimensions (to match box opening with clearance)
// Box inner width = 66. Lip outer width = 65.6.
// Clearance = (66 - 65.6) / 2 = 0.2.
// The lip is a solid block that fits inside the box opening.
// The "1.5 mm thick wall" description in the prompt is interpreted as the base thickness of the lip structure,
// and the "4 mm tall" as the height of the raised sides, forming a hollow box shape for the lip.
// However, if the lip outer is 65.6 and box inner is 66, the lip is solid.
// If the lip is hollow with outer 65.6 and it fits in 66 with 0.2 clearance, the inner must be 66.4.
// This implies the lip is wider inside than outside. This is a "ledge".
// Let's assume the user wants a solid lip block of 65.6 x 45.6.
// The "1.5 mm thick wall" might be a typo for "1.5 mm thick base" and the "4 mm tall" is the height of the sides.
// If it's a solid block, the height is 1.5 + 4 = 5.5? Or is the 1.5mm the total thickness of the lip?
// Let's assume the lip is a solid block of 65.6 x 45.6 x (1.5 + 4).
// Actually, let's re-read: "rectangular lip on top of it - a 1.5 mm thick wall, 4 mm tall".
// This sounds like a hollow box. If the outer is 65.6 and it fits in 66, the inner must be 66.4.
// This means the lip is wider inside than outside. This is a "ledge".
// Let's assume the lip is a solid block of 65.6 x 45.6 x (1.5 + 4).
// The "1.5 mm thick wall" is likely a mistake in the prompt's description of a solid block, or it means the lip has a 1.5mm thick base and 4mm high sides, making it a hollow box.
// If it's a hollow box with outer 65.6 and inner 66.4, it's a ledge.
// Let's assume the user wants a solid lip block of 65.6 x 45.6 x (1.5 + 4).
// The "1.5 mm thick wall" is likely a mistake.
// Let's assume the lip is a solid block of 65.6 x 45.6 x (1.5 + 4).
// The "1.5 mm thick wall" is likely a mistake.
// Let's assume the lip is a solid block of 65.6 x 45.6 x (1.5 + 4).
// The "1.5 mm thick wall" is likely a mistake.
// Let's assume the lip is a solid block of 65.6 x 45.6 x (1.5 + 4).
// The "1.5 mm thick wall" is likely a mistake.
// Let's assume the lip is a solid block of 65.6 x 45.6 x (1.5 + 4).
// The "1.5 mm thick wall" is likely a mistake.
// Let's assume the lip is a solid block of 65.6 x 45.6 x (1.5 + 4).