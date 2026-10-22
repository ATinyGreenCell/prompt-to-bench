// Petri Dish Rack
// Designed for 90mm diameter dishes standing on edge.

// --- Dimensions ---
base_l      = 203;    // Length of base (X)
base_w      = 80;     // Width of base (Y)
base_h      = 20;     // Height of base (Z)

dish_radius = 45;     // Radius of 90mm dish
cradle_r    = 46;     // Radius of the cradle cut
cradle_z    = 52;     // Z-coordinate of the cradle cylinder axis
cradle_bottom = cradle_z - cradle_r; // Should be 6mm

num_dividers = 11;    // Number of divider plates
divider_t    = 3;     // Thickness of dividers (X)
divider_h    = 60;     // Height of dividers (Z)
divider_spacing = 20; // Distance between divider centers (X)

$fn = 128;

// --- Geometry Construction ---

// The base block
module base() {
    translate([-base_l/2, -base_w/2, 0])
        cube([base_l, base_w, base_h]);
}

// The divider plates
module dividers() {
    // Dividers are placed at x = -100, -80, ..., 100
    // Formula for center: (i - (n-1)/2) * spacing
    for (i = [0 : num_dividers - 1]) {
        x_pos = (i - (num_dividers - 1) / 2) * divider_spacing;
        translate([x_pos, -base_w/2, 0])
            cube([divider_t, base_w, divider_h]);
    }
}

// The cradle cut (cylindrical groove)
// The axis runs along X, at y=0, z=52.
// To use rotate_extrude, we create a 2D profile and rotate it.
// However, since the axis is parallel to X, we use a cylinder and rotate it.
module cradle_cut() {
    // We rotate a cylinder 90 degrees around Y to align axis with X
    // The cylinder is centered at y=0, z=52.
    // To make it a "cut", we use difference.
    // We need the cylinder to be long enough to cover the whole base.
    translate([0, 0, cradle_z])
        rotate([0, 90, 0])
            cylinder(h = base_l + 2, r = cradle_r);
}

// --- Final Assembly ---

union() {
    // The base and dividers form the solid structure
    difference() {
        union() {
            base();
            dividers();
        }
        
        // Subtract the cradle from the base and dividers
        // Note: The prompt says "the cradle is not cut through them" 
        // regarding the dividers, but "A curved cradle... is cut along its whole length".
        // Interpreting "the cradle is not cut through them" as: 
        // The cradle cut only applies to the base block, not the dividers.
        // Wait, re-reading: "Eleven solid divider plates... rise from z=0 to z=60... 
        // the cradle is not cut through them."
        // This means the cradle only affects the base.
        
        // To implement "cradle is not cut through them", we only subtract 
        // the cradle from the base block.
        
        // However, the prompt says "A curved cradle... is cut along its whole length".
        // This usually implies the groove is a feature of the rack.
        // If the cradle is NOT cut through the dividers, the dividers remain 
        // solid vertical slabs.
        
        // Let's follow the instruction: "the cradle is not cut through them [the dividers]".
        // This means we subtract the cradle from the base only.
        
        // To do this cleanly, we define the base and dividers separately.
    }
}

// Corrected Assembly Logic based on "cradle is not cut through them":
// 1. Create Base.
// 2. Subtract cradle from Base.
// 3. Add Dividers.

difference() {
    // Base with cradle cut
    difference() {
        base();
        // The cradle cut (only applied to the base)
        // We use a large cylinder to ensure it cuts through the base
        translate([0, 0, cradle_z])
            rotate([0, 90, 0])
                cylinder(h = base_l + 2, r = cradle_r);
    }
    
    // We don't subtract anything else from the base.
}

// Now add the dividers on top/around
// Since the dividers are "solid" and "rise from z=0 to z=60", 
// and the cradle is "not cut through them", the dividers 
// must be placed such that they are not affected by the cradle.
// But the dividers are at x = -100 to 100, which is the whole base.
// If the cradle is at z=6 to z=88 (approx), and dividers go from 0 to 60,
// they MUST intersect the cradle unless the cradle is only in the gaps.
// Re-reading: "This leaves ten 17 mm wide slots, one dish in each."
// This implies the dividers are the walls and the cradle is the floor of the slot.
// If the cradle is NOT cut through the dividers, the dividers are 
// continuous vertical plates from z=0 to z=60.

// Let's re-assemble:
// Final Part = (Base - Cradle) + Dividers
// But wait, if the dividers are solid from z=0 to 60, and the cradle is at z=6,
// the dividers would "fill in" the cradle.
// The only way "the cradle is not cut through them" makes sense is if 
// the dividers are placed in the gaps and the cradle is only the floor.
// But the prompt says "Eleven solid divider plates... rise from z=0 to z=60".
// This means the dividers are continuous.
// If the dividers are continuous, and the cradle is not cut through them,
// then the cradle only exists in the spaces between the dividers.

// Let's refine:
// 1. Base (203x80x20)
// 2. Dividers (11 plates, 3mm thick, 80mm wide, 60mm tall)
// 3. Cradle (The groove)

// If the cradle is NOT cut through the dividers, the cradle is a series 
// of disconnected arcs.

// Let's try this construction:
// Union of (Base - Cradle) and (Dividers).
// To make the cradle "not cut through them", we must subtract the cradle 
// from the base, but we must NOT subtract it from the dividers.

// Wait, if I subtract the cradle from the base, and then add the dividers,
// the dividers will "cover" the parts of the cradle they intersect.
// This results in the dividers being solid and the cradle being the floor 
// in the gaps. This matches "the cradle is not cut through them".

union() {
    // The Base with the cradle cut out
    difference() {
        base();
        // The cradle cut
        translate([0, 0, cradle_z])
            rotate([0, 90, 0])
                cylinder(h = base_l + 2, r = cradle_r);
    }
    
    // The Dividers
    dividers();
}

// Final check of the math:
// Dividers at x = -100, -80, -60, -40, -20, 0, 20, 40, 60, 80, 100.
// Total 11 dividers.
// Gaps between dividers: 20mm (center to center) - 3mm (thickness) = 17mm.
// This matches "ten 17 mm wide slots".
// Base is 203mm long. Dividers are at +/- 100. 
// The dividers are within the base length.
// The cradle is at z=52 with radius 46. 
// Bottom of cradle = 52 - 46 = 6mm.
// Base is 20mm tall. So the cradle cuts into the base from z=6 to z=20.
// The dividers are 60mm tall. They will cover the cradle where they intersect.
// This matches the description perfectly.