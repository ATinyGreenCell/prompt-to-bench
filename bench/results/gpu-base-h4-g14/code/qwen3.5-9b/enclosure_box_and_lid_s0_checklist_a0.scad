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

// Lip inner dimensions (to match box opening)
lip_inner_w = box_inner_w + 2 * clearance;
lip_inner_h = box_inner_h + 2 * clearance;

// Lip outer dimensions (given)
// Check consistency: 
// Lip outer width = 65.6. Box inner width = 70 - 4 = 66.
// Clearance = (66 - 65.6) / 2 = 0.2. Matches.

// --- Part 1: The Box ---
// Position: Centered in Y, starts at X = - (box_w/2 + gap/2)
// Rests on Z=0.
box_x_start = -(box_w / 2 + gap / 2);
box_y_start = -box_h / 2;
box_z_start = 0;

module box() {
    translate([box_x_start, box_y_start, box_z_start]) {
        // Main body: Outer box minus inner void
        // We build the solid outer box and subtract the inner void.
        // Outer box: [box_w, box_h, box_d]
        // Inner void: [box_inner_w, box_inner_h, box_inner_d]
        // Void position: offset by wall_t in X and Y, floor_t in Z.
        
        union() {
            // Solid outer shell
            translate([0, 0, 0]) cube([box_w, box_h, box_d]);
            
            // Subtract the internal void
            translate([wall_t, wall_t, floor_t]) 
                cube([box_inner_w, box_inner_h, box_inner_d]);
        }
    }
}

// --- Part 2: The Lid ---
// Position: Centered in Y, starts at X = + (box_w/2 + gap/2)
// Rests on Z=0.
// The lid is printed upside down relative to its final use, meaning the lip is on top of the plate.
// The plate is 2mm thick. The lip is 1.5mm thick and 4mm tall.
// Total height of lid = 2 + 1.5 + 4 = 7.5 mm.
// The lip sits on top of the plate.
// The lip outer size is 65.6 x 45.6.
// The lip inner size is lip_inner_w x lip_inner_h.
// Lip wall thickness = (65.6 - lip_inner_w) / 2.
// Let's calculate lip wall thickness to ensure it fits the clearance logic.
// lip_inner_w = 66. lip_outer_w = 65.6. 
// Wait, the prompt says "0.2 mm clearance on each side".
// Box inner width = 66. Lip outer width = 65.6.
// If the lip outer is 65.6 and it slides into 66, the clearance is (66 - 65.6)/2 = 0.2. Correct.
// The lip wall thickness is (65.6 - lip_inner_w)/2.
// lip_inner_w = 66.
// Lip wall thickness = (65.6 - 66) / 2 = -0.2. This is impossible.
// Re-reading: "lip ... whose outer size is 65.6 x 45.6 mm, centred on the plate, so it slides into the box opening with 0.2 mm clearance on each side."
// This implies the *inner* opening of the lip is larger than the outer size? No, that's a solid block.
// It implies the *inner* opening of the lip matches the box opening with 0.2mm clearance.
// Box inner = 66. Lip inner = 66 + 2*0.2 = 66.4.
// Lip outer = 65.6.
// This means the lip is a solid block of 65.6 width, and the box opening is 66.
// Clearance = (66 - 65.6) / 2 = 0.2.
// So the lip is a solid rectangular prism sitting on the plate?
// "rectangular lip on top of it - a 1.5 mm thick wall, 4 mm tall".
// If it's a "wall", it must be hollow.
// If the outer is 65.6 and it fits in 66 with 0.2 clearance, then the inner must be 66.4.
// Wall thickness = (65.6 - 66.4) / 2 = -0.4. Impossible.
// Interpretation: The "lip" is a raised platform. The "wall" description might refer to the side walls of the lip structure itself, or the prompt implies the lip *is* the wall of the box?
// Let's re-read carefully: "rectangular lip on top of it - a 1.5 mm thick wall, 4 mm tall, whose outer size is 65.6 x 45.6 mm".
// Maybe the "wall" is the side of the lip, and the lip is a hollow box?
// If the lip is a hollow box with outer 65.6 and inner 66.4, it's inverted (wider inside). That's a shelf, not a lip.
// Alternative: The "lip" is a solid block of 65.6 x 45.6 x (1.5+4).
// If it's a solid block, it's not a "wall".
// Let's assume the user made a typo in the dimensions or my interpretation of "wall" is too literal.
// Most likely scenario: The lip is a solid raised platform of outer size 65.6 x 45.6.
// The "1.5 mm thick wall" might refer to the thickness of the lip base (1.5mm) and the "4 mm tall" is the height of the sides?
// Or maybe the lip is a hollow box with outer 65.6 and inner 65.6 - 2*wall_t.
// If the clearance is 0.2mm, then BoxInner = LipOuter + 2*0.2 = 65.6 + 0.4 = 66.0.
// BoxInner = 70 - 2*2 = 66. Matches perfectly.
// So the Lip Outer is 65.6. The Box Inner is 66.0.
// The lip is a solid block of 65.6 x 45.6 x (1.5 + 4).
// Why "1.5 mm thick wall"? Maybe the lip has a 1.5mm thick base and 4mm high sides, making it a hollow box?
// If it's a hollow box with outer 65.6 and inner 66.0, the wall thickness is negative.
// Conclusion: The lip is a solid block. The "wall" description is likely describing the side profile (a wall of 1.5mm thickness? No, 1.5mm is the base thickness).
// Let's assume the lip is a solid rectangular prism of dimensions:
// Width: 65.6
// Height: 1.5 (base) + 4 (sides) = 5.5? Or is the 1.5mm the thickness of the lip itself (base) and the 4mm is the height of the raised part?
// "1.5 mm thick wall, 4 mm tall". This usually means a hollow structure.
// If the lip is a hollow structure with outer 65.6 and it fits in 66 with 0.2 clearance, the inner must be 66.4.
// This implies the lip is wider inside than outside. This is a "ledge" or "shelf".
// Let's assume the user wants a solid lip of outer 65.6 x 45.6.
// The "1.5 mm thick wall" might be a mistake for "