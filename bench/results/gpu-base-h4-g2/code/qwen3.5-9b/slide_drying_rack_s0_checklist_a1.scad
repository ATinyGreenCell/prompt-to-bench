// Microscope slide drying rack - solid base with 10 parallel slots for standing slides.
// Orientation: Rests on XY plane at Z=0, builds upward. Centred on origin.

// Base dimensions
L_base = 90;
W_base = 45;
H_base = 20;

// Slide dimensions (75 x 25 x 1 mm)
slide_len = 75;
slide_w   = 25;
slide_thk = 1;

// Slot dimensions
slot_len = 77;      // Must be slightly shorter than slide_len to fit
slot_w   = 1.6;     // Width in Y
slot_deep = 10;     // Depth in Z

// Slot spacing
slot_spacing = 3.5; // Centre-to-centre in Y

// Number of slots
n_slots = 10;

// Derived positions
// Slots are centred in X (so they run from -48.5 to +48.5 roughly, fitting in 90mm)
// Slots are centred in Y.
// Position of slot i (0 to 9) in Y:
// Total span = (n_slots - 1) * slot_spacing = 9 * 3.5 = 31.5
// Half span = 15.75
// Y_pos[i] = -15.75 + i * 3.5

$fn = 64;

// Define the base block
base = translate([0, 0, 0]) cube([L_base, W_base, H_base]);

// Define a single slot cutter
// The slot runs along X, so we extrude a rectangle along X.
// To cut a slot of length 77mm, we extrude a 77mm long rectangle.
// The slot is open at the top, so we cut from Z=0 down to Z=10.
// We extend the cutter slightly past the faces to ensure clean cuts.

module slot_cutter(y_pos) {
    // Create a 2D profile for the slot: a rectangle 77mm long (X) and 1.6mm wide (Y).
    // We will extrude this along X.
    // Actually, since the slot runs along X, we can just use a cylinder or a rotated cube.
    // Let's use a cylinder with diameter = slot_w, height = slot_len, rotated 90 deg around Y?
    // No, simpler: A cube of size [slot_len, slot_w, slot_deep] rotated 90 deg around Y axis?
    // If we rotate a cube [L, W, H] around Y by 90 deg:
    // Original: X=L, Y=W, Z=H.
    // Rotated: X=W, Y=L, Z=H. This makes the long dimension Y. We want long dimension X.
    // So we don't need to rotate if we define the cube as [slot_len, slot_w, slot_deep].
    // Wait, the slot runs along X. So the long dimension is X.
    // So we need a shape that is long in X, narrow in Y, and deep in Z.
    // Cube([slot_len, slot_w, slot_deep]) is exactly that.
    // We just need to position it at the correct Y.
    
    // However, the rule says "extend 0.01-1 mm past the faces".
    // The slot is 77mm long. The block is 90mm.
    // If we cut a 77mm cube, the faces at X=38.5 and X=-38.5 are coplanar with the block faces?
    // No, the block is 90mm. The slot is 77mm. There is a margin of (90-77)/2 = 6.5mm on each side.
    // So the slot faces are NOT coplanar with the block faces.
    // But the slot width (1.6mm) is smaller than the block width (45mm).
    // The slot depth (10mm) is smaller than the block height (20mm).
    // So we just need to cut the volume defined by the slot.
    
    // Let's use a cylinder for the slot to ensure roundness if needed, but a cube is fine for a rectangular slot.
    // Let's use a cube for simplicity and precision.
    
    // Position:
    // X: Centred at 0. Length 77. So from -38.5 to +38.5.
    // Y: At y_pos. Width 1.6. So from y_pos - 0.8 to y_pos + 0.8.
    // Z: From 0 to 10.
    
    translate([0, y_pos, 0]) cube([slot_len, slot_w, slot_deep]);
}

difference() {
    union() {
        base;
        // Add the "shoulders" or just rely on the base being the main body?
        // The prompt says "Cut 10 parallel slots into the top face".
        // This implies the base is solid except for the slots.
        // So we just subtract the slots from the base.
    }
    
    // Cut the slots
    for (i = [0 : n_slots - 1]) {
        y = -((n_slots - 1) * slot_spacing / 2) + i * slot_spacing;
        slot_cutter(y);
    }
}