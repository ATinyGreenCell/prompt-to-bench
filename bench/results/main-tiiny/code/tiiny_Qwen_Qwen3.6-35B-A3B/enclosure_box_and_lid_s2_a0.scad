// --- Dimensions ---
// Box outer dimensions
BOX_W = 70;
BOX_D = 50;
BOX_H = 30;

// Box wall and floor thickness
WALL_THICK = 2;
FLOOR_THICK = 2;

// Lid plate dimensions (matches box outer footprint)
LID_W = 70;
LID_D = 50;
LID_THICK = 2;

// Lid lip dimensions
LIP_THICK = 1.5;
LIP_H = 4;
LIP_W = 65.6;
LIP_D = 45.6;

// Clearance for lip sliding into box
CLEARANCE = 0.2;

// Gap between parts on the bed
GAP = 10;

// --- Calculated Internal Dimensions ---
// Box internal width/depth
BOX_IN_W = BOX_W - 2 * WALL_THICK;
BOX_IN_D = BOX_D - 2 * WALL_THICK;

// Box internal height (excluding floor)
BOX_IN_H = BOX_H - FLOOR_THICK;

// Lid lip inner dimensions (to fit inside box)
// The lip is the part that goes *inside* the box.
// Box inner width is BOX_IN_W. Lip outer width is LIP_W.
// We need LIP_W + CLEARANCE = BOX_IN_W? Or is LIP_W the target fit?
// User said: "outer size is 65.6 x 45.6 mm ... so it slides into the box opening with 0.2 mm clearance on each side."
// Box inner width = 70 - 2*2 = 66 mm.
// 66 - 65.6 = 0.4 mm total clearance -> 0.2 mm per side. This matches.
// So the lip outer dimensions are fixed by the user's fit requirement.

// --- Helper Variables ---
// Offset for difference operations to ensure non-coplanar faces
OFFSET = 0.05;

// --- Part 1: The Box ---
// Positioned on the left side
// Center X: - (BOX_W/2 + GAP/2)
// Center Y: 0
// Z: 0

PART1_OFFSET_X = -(BOX_W / 2 + GAP / 2);
PART1_OFFSET_Y = 0;

module Box() {
    // 1. Create the outer shell (solid block)
    // We build it as a solid block first, then subtract the inside.
    // This ensures the bottom and walls are solid.
    difference() {
        // Outer block
        cube([BOX_W, BOX_D, BOX_H], center = false);
        
        // Inner cavity (subtractive)
        // The cavity starts at Z = FLOOR_THICK
        // The cavity dimensions are BOX_IN_W x BOX_IN_D x BOX_IN_H
        // We extend the cavity slightly upwards to ensure the top rim is cut cleanly
        translate([0, 0, FLOOR_THICK]) {
            $fn = 64;
            cube([BOX_IN_W, BOX_IN_D, BOX_IN_H + OFFSET], center = false);
        }
    }
}

// --- Part 2: The Lid ---
// Printed upside down.
// The user specifies: "a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it"
// Since it is printed upside down, the "top" of the design (highest Z) will be the bottom of the physical lid.
// The "plate" rests on the bed (Z=0). The "lip" sticks up from the plate.
// When flipped over, the plate becomes the top cover, and the lip hangs down to fit into the box.

// Position: Center X: + (BOX_W/2 + GAP/2)
// Center Y: 0
// Z: 0

PART2_OFFSET_X = (BOX_W / 2 + GAP / 2);
PART2_OFFSET_Y = 0;

module Lid() {
    // 1. The Plate (rests on bed)
    // Dimensions: LID_W x LID_D x LID_THICK
    // Centered in X/Y
    translate([0, 0, LID_THICK / 2]) {
        $fn = 64;
        cube([LID_W, LID_D, LID_THICK], center = true);
    }
    
    // 2. The Lip (sticks up from the plate)
    // The lip is centered on the plate.
    // Outer size: LIP_W x LIP_D.
    // Height: LIP_H.
    // Thickness: LIP_THICK (This usually refers to the wall thickness of the lip itself).
    // Wait, "1.5 mm thick wall, 4 mm tall".
    // Does "1.5 mm thick" mean the wall thickness of the lip structure?
    // Yes, typically a lip is a hollow or solid rim.
    // If it's a "wall", it implies a rim.
    // Let's assume the lip is a hollow rectangular tube (rim) sitting on the plate.
    // Outer dimensions: LIP_W x LIP_D.
    // Wall thickness: LIP_THICK.
    // Height: LIP_H.
    
    // To model this:
    // We can create a solid block of LIP_W x LIP_D x LIP_H.
    // Then subtract a hole in the middle.
    // The hole dimensions:
    // Hole_W = LIP_W - 2 * LIP_THICK
    // Hole_D = LIP_D - 2 * LIP_THICK
    
    // However, the user said "rectangular lip ... whose outer size is ...".
    // And "1.5 mm thick wall".
    // So the lip is a rim.
    
    // Position of the lip:
    // It sits on the plate. The plate is at Z=0 to Z=LID_THICK.
    // The lip starts at Z = LID_THICK and goes up to Z = LID_THICK + LIP_H.
    
    lip_wall_thick = LIP_THICK;
    lip_outer_w = LIP_W;
    lip_outer_d = LIP_D;
    lip_height = LIP_H;
    
    // Inner dimensions of the lip hole
    lip_inner_w = lip_outer_w - 2 * lip_wall_thick;
    lip_inner_d = lip_outer_d - 2 * lip_wall_thick;
    
    // Ensure inner dimensions are positive
    if (lip_inner_w > 0 && lip_inner_d > 0) {
        difference() {
            // Outer lip block
            // Centered in X/Y, sitting on top of the plate
            translate([0, 0, LID_THICK + lip_height / 2]) {
                $fn = 64;
                cube([lip_outer_w, lip_outer_d, lip_height], center = true);
            }
            
            // Inner hole (subtractive)
            // Extend slightly to ensure clean cut
            translate([0, 0, LID_THICK + lip_height / 2]) {
                $fn = 64;
                cube([lip_inner_w, lip_inner_d, lip_height + OFFSET], center = true);
            }
        }
    } else {
        // If walls are too thick for the outer size, just make a solid block
        // This shouldn't happen with given dimensions (65.6 - 3 = 62.6 > 0)
        translate([0, 0, LID_THICK + lip_height / 2]) {
            $fn = 64;
            cube([lip_outer_w, lip_outer_d, lip_height], center = true);
        }
    }
}

// --- Assembly ---
// Use union to combine both parts into one object for printing
union() {
    // Part 1: Box
    translate([PART1_OFFSET_X, PART1_OFFSET_Y, 0]) {
        Box();
    }
    
    // Part 2: Lid
    translate([PART2_OFFSET_X, PART2_OFFSET_Y, 0]) {
        Lid();
    }
}