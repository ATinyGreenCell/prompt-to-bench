// Two-part enclosure for small electronics board
// Part 1: Box (left)
// Part 2: Lid (right, printed upside down)
// Prints together with a 10 mm gap.

$fn = 64;

// --- Dimensions ---

// Part 1: Box
// Outer dimensions (X x Y x Z)
BOX_OUT_X = 70;
BOX_OUT_Y = 50;
BOX_OUT_Z = 30;
// Wall thicknesses
BOX_WALL_THICK = 2;
BOX_FLOOR_THICK = 2;

// Part 2: Lid
// Base plate dimensions
LID_PLATE_X = 70;
LID_PLATE_Y = 50;
LID_PLATE_THICK = 2;
// Lip dimensions (outer size of the lip)
LIP_OUT_X = 65.6;
LIP_OUT_Y = 45.6;
LIP_THICK = 1.5;
LIP_HEIGHT = 4;
// Clearance check (calculated from outer sizes)
// Box inner X = 70 - 2*2 = 66. Lip outer X = 65.6. Clearance = (66 - 65.6)/2 = 0.2 mm.
// Box inner Y = 50 - 2*2 = 46. Lip outer Y = 45.6. Clearance = (46 - 45.6)/2 = 0.2 mm.

// --- Layout ---
// Gap between parts
PART_GAP = 10;

// --- Part 1: The Box ---
// Position: Centered on origin in X, Y, Z=0.
// Since it's open top, we build the floor and walls.
// We use difference to subtract the empty interior.

translate([0, 0, 0])
difference() {
    // 1. The solid block representing the outer volume
    cube([BOX_OUT_X, BOX_OUT_Y, BOX_OUT_Z], center = false);
    
    // 2. The empty interior to subtract
    // Inner dimensions:
    // X: 70 - 2*2 = 66
    // Y: 50 - 2*2 = 46
    // Z: 30 - 2 (floor) = 28 (open top)
    translate([
        BOX_WALL_THICK, 
        BOX_WALL_THICK, 
        0 // Floor is at Z=0, so empty space starts at Z=0
    ])
    cube([
        BOX_OUT_X - (2 * BOX_WALL_THICK),
        BOX_OUT_Y - (2 * BOX_WALL_THICK),
        BOX_OUT_Z - BOX_FLOOR_THICK
    ]);
}

// --- Part 2: The Lid ---
// Position: On the +X side of the box.
// Box center X = 35. Box right edge = 70.
// Lid left edge = 70 + 10 = 80.
// Lid center X = 80 + (70/2) = 115.
// Lid is printed upside down: It rests on the bed (Z=0).
// The "plate" is the bottom face (Z=0 to Z=2).
// The "lip" is on top of the plate (Z=2 to Z=6), but since it's upside down, 
// the lip physically sits on the bed? 
// Re-reading prompt: "a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
// If printed upside down, the "top" of the geometry (where the lip is) is facing the bed?
// No, "printed upside down" usually means the part is inverted relative to its design orientation.
// Design: Plate on bottom, lip on top.
// Print: Plate on top (facing Z+), lip on bottom (facing Z-)? 
// OR: The user wants the part to sit on the bed such that the lip is the bottom-most feature?
// Let's interpret "printed upside down" as: The geometry is flipped vertically.
// Original Design: Plate at Z=0..2, Lip at Z=2..6.
// Upside Down Design: Lip at Z=0..4, Plate at Z=4..6.
// BUT the prompt says: "a plate 70 x 50 x 2 mm lying on the bed".
// This implies the plate is the contact surface with the bed.
// If the plate is on the bed, and there is a lip "on top of it", then the lip is at Z=2..6.
// This contradicts "printed upside down" if the design was plate-bottom.
// Let's re-read carefully: "Part 2, the lid, printed upside down: a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
// This describes the physical state on the bed.
// Plate is at Z=0. Lip is at Z=2 (thickness 1.5) + height 4 = Z=5.5?
// Wait, "lip on top of it".
// If the plate is on the bed, the lip is above the plate.
// Why "printed upside down"? Maybe the design file usually has the lip on the bottom (for a snap fit)?
// Regardless, the instruction describes the geometry on the bed:
// 1. Plate (70x50x2) at Z=0.
// 2. Lip (1.5 thick wall, 4 tall) on top of the plate.
// 3. Lip outer size 65.6 x 45.6.
// 4. Lip is centred on the plate.
// 5. Lip slides into the box opening.
// Box opening is at the top (Z=28 to Z=30).
// If the lid is placed on the bed (Z=0), how does it slide into the box?
// It must be lifted. The "printed upside down" might refer to the orientation of the lip relative to the box?
// Actually, if the lid is on the bed, and the box is at Z=0..30, the lid must be placed ON TOP of the box.
// If the lid is "printed upside down", maybe the lip is the bottom part of the lid assembly?
// Let's reconsider the "printed upside down" phrase in context of 3D printing enclosures.
// Often, lids are printed with the lip on the bottom so it snaps in.
// If the user says "printed upside down: a plate... lying on the bed, with a rectangular lip on top of it",
// they are describing the visual appearance on the build plate.
// So: Bottom = Plate. Top = Lip.
// This means the lip is the highest point of the lid.
// When closing the box, the lip goes into the box opening.
// This makes sense. The "upside down" might just be a descriptor of how the user visualizes the "lid" part relative to a standard "box" part, or perhaps they mean the lip is the bottom of the *lid component* in a different context, but here they explicitly define the bed orientation.
// Let's stick to the explicit geometric description:
// Bed: Z=0.
// Plate: 70x50x2.
// Lip: On top of plate. Outer 65.6x45.6. Wall 1.5. Height 4.
// Total height = 2 + 1.5 + 4 = 7.5? Or is the 4mm height including the wall thickness?
// "1.5 mm thick wall, 4 mm tall". Usually means the protrusion is 4mm high.
// So Lip top Z = 2 + 1.5 + 4 = 7.5.
// Wait, if the lip is 1.5mm thick wall, does "4mm tall" mean the inner cavity is 4mm deep?
// "rectangular lip ... 4 mm tall". Usually implies the vertical dimension of the lip feature.
// Let's assume the lip protrudes 4mm from the top of the plate.
// So Lip Top Z = 2 + 4 = 6.
// The wall thickness is 1.5mm.
// Let's refine the lip geometry:
// It's a rim.
// Base: 70x50x2.
// Rim: Outer 65.6x45.6.
// The rim sits on the 70x50 plate.
// The rim has a vertical height of 4mm.
// The rim has a thickness of 1.5mm.
// So the rim is a hollow box shape sitting on the plate.
// Inner hole of rim:
// X_inner = 65.6 - 2*1.5 = 62.6.
// Y_inner = 45.6 - 2*1.5 = 42.6.
// Height of rim = 4mm.
// Total height of lid = 2 (