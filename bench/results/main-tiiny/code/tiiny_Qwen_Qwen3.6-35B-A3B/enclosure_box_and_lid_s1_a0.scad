// --- Dimensions ---
// Box outer dimensions
BOX_W = 70;
BOX_D = 50;
BOX_H = 30;

// Box wall and floor thickness
BOX_WALL = 2;
BOX_FLOOR = 2;

// Lid plate dimensions
LID_W = 70;
LID_D = 50;
LID_THICK = 2;

// Lid lip dimensions
LIP_THICK = 1.5;
LIP_H = 4;
LIP_W = 65.6;
LIP_D = 45.6;

// Clearance for lip insertion
CLEARANCE = 0.2;

// Gap between parts on the print bed
PART_GAP = 10;

// --- Calculated Values ---
// Box inner dimensions
BOX_INNER_W = BOX_W - 2 * BOX_WALL;
BOX_INNER_D = BOX_D - 2 * BOX_WALL;
BOX_INNER_H = BOX_H - BOX_FLOOR;

// Lid lip inner dimensions (to fit inside the box)
// The lip slides into the box. The box opening is BOX_INNER_W x BOX_INNER_D.
// The lip outer size is LIP_W x LIP_D.
// Clearance is on each side, so we subtract 2*clearance from the box inner size to get the lip outer size?
// No, the user specified the lip outer size as 65.6 x 45.6.
// Let's check: BOX_INNER_W = 70 - 4 = 66.
// 66 - 65.6 = 0.4. 0.4 / 2 = 0.2. This matches the 0.2 mm clearance.
// So the lip fits inside the box with 0.2 mm gap on each side.

// --- Positioning ---
// Box is centered at X=0, Y=0.
// Lid is placed on the +X side with a 10 mm gap.
// Box extends from X = -35 to 35.
// Lid starts at X = 35 + 10 = 45.
// Lid width is 70, so it extends from 45 to 115.
// Center of lid in X: 45 + 35 = 80.
// Both are centered in Y.

// --- Part 1: The Box ---
// Built in print orientation: rests on XY plane, builds upward +Z.
// Open top.

module Box() {
    // Base plate (floor)
    // We build the box as a solid block and subtract the inner volume.
    // This ensures the floor and walls are solid.
    
    // Outer shell
    difference() {
        // Solid block
        cube([BOX_W, BOX_D, BOX_H], center = false);
        
        // Inner cavity (subtractive)
        // The cavity starts at z = BOX_FLOOR (thickness of floor)
        // It goes up to BOX_H (open top)
        // It is inset by BOX_WALL from the sides.
        translate([BOX_WALL, BOX_WALL, BOX_FLOOR]) {
            // Extend slightly past the top to ensure clean cut if needed, 
            // though open top means we just cut down to the floor level.
            // To avoid coplanar faces, we extend the cut slightly into the floor or up.
            // Let's extend the cut slightly below the floor level to ensure the bottom face is clean.
            // Actually, standard practice: cut volume is slightly larger than the void.
            // Void: X: [BOX_WALL, BOX_W-BOX_WALL], Y: [BOX_WALL, BOX_D-BOX_WALL], Z: [BOX_FLOOR, BOX_H]
            // Let's make the cut slightly deeper into the floor to avoid Z-fighting or coplanar issues.
            // Cut Z range: [BOX_FLOOR - 0.01, BOX_H + 0.01]
            cube([BOX_INNER_W, BOX_INNER_D, BOX_INNER_H + 0.01], center = false);
        }
    }
}

// --- Part 2: The Lid ---
// Printed upside down.
// The user says: "a plate 70 x 50 x 2 mm lying on the bed, with a rectangular lip on top of it".
// "Printed upside down" usually means the final part is inverted relative to the print orientation.
// However, the description "plate ... lying on the bed, with a lip on top of it" describes the geometry in the print orientation.
// If the lid is printed "upside down", it typically means the "top" of the lid (the side that faces up when closed) is the bottom of the print.
// But the description explicitly says: "a plate ... lying on the bed ... with a lip on top of it".
// This implies the geometry is: Plate on bed, Lip sticking up.
// When you flip this over to use it, the Plate becomes the top surface, and the Lip hangs down into the box.
// This matches the requirement: "slides into the box opening".
// So we model it exactly as described: Plate on Z=0, Lip extending +Z.

module Lid() {
    union() {
        // Plate
        // Centered in X, Y.
        // X: -35 to 35, Y: -25 to 25.
        translate([-LID_W/2, -LID_D/2, 0]) {
            cube([LID_W, LID_D, LID_THICK], center = false);
        }
        
        // Lip
        // Outer size 65.6 x 45.6, centered on the plate.
        // Height 4 mm.
        // Thickness 1.5 mm.
        // The lip is a hollow box? "1.5 mm thick wall".
        // Yes, it's a wall.
        
        // Lip outer dimensions
        lip_outer_w = LIP_W;
        lip_outer_d = LIP_D;
        lip_inner_w = lip_outer_w - 2 * LIP_THICK;
        lip_inner_d = lip_outer_d - 2 * LIP_THICK;
        
        // Lip position: Centered on the plate.
        // Plate is from -35 to 35 in X.
        // Lip is from -32.8 to 32.8 in X (65.6 width).
        // Lip is from -22.8 to 22.8 in Y (45.6 depth).
        
        // We build the lip as a solid block and subtract the inner void.
        // The lip sits on top of the plate.
        // Plate top is at Z = LID_THICK = 2.
        // Lip bottom is at Z = 2.
        // Lip top is at Z = 2 + LIP_H = 6.
        
        translate([-lip_outer_w/2, -lip_outer_d/2, LID_THICK]) {
            difference() {
                // Outer lip block
                cube([lip_outer_w, lip_outer_d, LIP_H], center = false);
                
                // Inner void
                // Extend slightly to ensure clean cut
                translate([LIP_THICK, LIP_THICK, -0.01]) {
                    cube([lip_inner_w, lip_inner_d, LIP_H + 0.01], center = false);
                }
            }
        }
    }
}

// --- Main Assembly ---
// Place parts side by side.
// Box at X=0.
// Lid at X=80 (center).

$fn = 64;

// Box
translate([0, 0, 0]) {
    Box();
}

// Lid
// Center of lid is at X=80, Y=0.
translate([80, 0, 0]) {
    Lid();
}