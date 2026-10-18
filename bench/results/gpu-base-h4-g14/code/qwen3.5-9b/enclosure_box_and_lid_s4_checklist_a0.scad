// Two-part enclosure for electronics board.
// Part 1: Box (left) - 70x50x30mm outer, 2mm walls, 2mm floor, open top.
// Part 2: Lid (right) - Printed upside down, plate with lip sliding into box.
// Parts are placed side-by-side with a 10mm gap.

// Dimensions
box_X  = 70;
box_Y  = 50;
box_Z  = 30;
wall   = 2;
floor  = 2;

// Lid dimensions
lid_plate_X = 70;
lid_plate_Y = 50;
lid_plate_Z = 2;
lip_wall    = 1.5;
lip_height  = 4;
lip_outer_X = 65.6;
lip_outer_Y = 45.6;

// Gap between parts
gap = 10;

// Derived dimensions for the box inner cavity
box_inner_X = box_X - 2 * wall;
box_inner_Y = box_Y - 2 * wall;
box_inner_Z = box_Z - floor;

// Derived dimensions for the lid lip clearance
// Lip outer size is 65.6 x 45.6. Box inner is 66 x 46.
// Clearance = (Box Inner - Lip Outer) / 2 = (66 - 65.6)/2 = 0.2 mm.
// We model the lip as a solid block that sits on the plate.
// The lip block outer size is 65.6 x 45.6 x (lip_height + lip_wall).
// The lip block thickness (Z) is 1.5 + 4 = 5.5 mm.
// The plate is 2 mm thick. Total lid height = 7.5 mm.
// The lip sits on top of the plate.
// To slide into the box, the lip's outer face must be smaller than the box's inner face.
// Lip outer X = 65.6. Box inner X = 66. Diff = 0.4. Half diff = 0.2.
// Lip outer Y = 45.6. Box inner Y = 46. Diff = 0.4. Half diff = 0.2.

$fn = 64;

// --- Part 1: The Box ---
// Position: Centered in Y, starts at X = -gap/2 - box_X/2.
// Actually, let's center the whole assembly at X=0.
// Box center X = - (gap + box_X + lid_plate_X) / 2 + box_X/2
// Simpler: Box starts at X = - (gap + box_X) / 2.
// Lid starts at X = - (gap + box_X) / 2 + box_X + gap.

box_start_X = - (gap + box_X) / 2;
lid_start_X = box_start_X + box_X + gap;

// Box Module
module box() {
    // Main block with hole for top
    // We build a solid block and subtract the top opening.
    // Block size: box_X x box_Y x box_Z
    // Opening: (box_X - 2*wall) x (box_Y - 2*wall) x (box_Z - floor)
    
    translate([box_start_X, -box_Y/2, 0]) {
        // Base block
        cube([box_X, box_Y, box_Z]);
        
        // Cut out the top opening
        // The opening is a hole from floor+1 to top.
        // Hole size: inner_X x inner_Y x (box_Z - floor)
        // Position: centered in X and Y.
        // Z start: floor. Z end: box_Z.
        translate([0, 0, floor]) {
            cube([box_inner_X, box_inner_Y, box_Z - floor]);
        }
    }
}

// Lid Module
// The lid is printed upside down relative to the box opening?
// "Part 2, the lid, printed upside down: a plate ... lying on the bed"
// This implies the plate face is on the bed (Z=0). The lip is on top of the plate (positive Z).
// The lip slides into the box.
// So the lip's bottom face is at Z = lid_plate_Z.
// The lip's top face is at Z = lid_plate_Z + lip_height + lip_wall.
// The box opening is at Z = floor to box_Z.
// We need the lip to fit inside.
// Lip bottom Z = 2. Lip top Z = 2 + 4 + 1.5 = 7.5.
// Box opening Z range = 2 to 30.
// So the lip fits vertically.

module lid() {
    translate([lid_start_X, -lid_plate_Y/2, 0]) {
        // 1. The base plate
        cube([lid_plate_X, lid_plate_Y, lid_plate_Z]);
        
        // 2. The lip
        // The lip is a rectangular block sitting on the plate.
        // Outer dimensions: lip_outer_X x lip_outer_Y
        // Height: lip_height + lip_wall
        // It is centered on the plate.
        // We model it as a solid block.
        // Thickness in Z: lip_height + lip_wall = 5.5
        // Position Z: starts at lid_plate_Z (2)
        
        translate([0, 0, lid_plate_Z]) {
            cube([lip_outer_X, lip_outer_Y, lip_height + lip_wall]);
        }
    }
}

// --- Assembly ---
// We use a union to print them together.
// Since they are separate modules, we just call them.
// However, to ensure they don't merge into a single mesh that might cause issues with supports or slicing if they touch,
// we rely on the gap. The gap is 10mm, so they are far apart.

difference() {
    // We don't need a difference here unless we want to hide supports.
    // Just union the parts.
    union() {
        box();
        lid();
    }
}