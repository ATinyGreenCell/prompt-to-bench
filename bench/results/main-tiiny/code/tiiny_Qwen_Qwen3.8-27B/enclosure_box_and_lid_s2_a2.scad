// Two-part enclosure for a small electronics board (e.g. Arduino temperature logger)
// Both parts are printed in the same file, side by side on the bed with a 10 mm gap.

// ---------- Global ----------
$fn = 64;

// ---------- Part 1: Box ----------
box_outer_x = 70;   // outer X size of the box
box_outer_y = 50;   // outer Y size of the box
box_outer_z = 30;   // outer Z height of the box
box_wall    = 2;    // wall thickness
box_floor   = 2;    // floor thickness
// The box is open at the top.

// ---------- Part 2: Lid (printed upside down) ----------
lid_plate_x = 70;   // plate X size
lid_plate_y = 50;   // plate Y size
lid_plate_z = 2;    // plate thickness (lies on the bed)
lip_wall    = 1.5;  // lip wall thickness
lip_height  = 4;    // lip height (extends upward from the plate in print orientation)
// Lip outer size: 65.6 x 45.6 mm, centred on the plate.
// This gives 0.2 mm clearance on each side relative to the box inner opening (66 x 46).
lip_outer_x = 65.6;
lip_outer_y = 45.6;

// ---------- Layout ----------
// Box is centred on the origin in X and Y.
// Lid is placed on the +X side of the box with a 10 mm gap between them.
// The gap is measured between the nearest faces of the two parts.
// Box extends from x = -35 to x = +35.
// Lid plate extends from x = 35 + 10 = 45 to x = 45 + 70 = 115.
// So the lid centre in X is at 45 + 35 = 80.
lid_offset_x = box_outer_x / 2 + 10 + lid_plate_x / 2;  // 35 + 10 + 35 = 80

// ---------- Part 1: Box ----------
// The box is a rectangular shell: outer box minus inner cavity.
// The cavity is open at the top (z = box_outer_z), so the cutting box extends
// 1 mm past the top face to ensure a clean cut with no coplanar faces.
module box() {
    // Outer solid
    difference() {
        cube([box_outer_x, box_outer_y, box_outer_z], center = [true, true, false]);
        
        // Inner cavity: starts at z = box_floor, extends 1 mm past the top
        inner_x = box_outer_x - 2 * box_wall;  // 66 mm
        inner_y = box_outer_y - 2 * box_wall;  // 46 mm
        inner_z = box_outer_z - box_floor + 1; // extends 1 mm past top for clean cut
        
        translate([-inner_x/2, -inner_y/2, box_floor])
            cube([inner_x, inner_y, inner_z], center = [true, true, false]);
    }
}

// ---------- Part 2: Lid (printed upside down) ----------
// The lid consists of a flat plate on the bed and a rectangular lip on top.
// When assembled, the lip slides into the box opening.
module lid() {
    // Plate: 70 x 50 x 2 mm, lying on the bed (z = 0 to z = 2)
    // Lip: a rectangular ring (hollow rectangle) on top of the plate
    // Outer size: 65.6 x 45.6 mm, wall thickness: 1.5 mm, height: 4 mm
    // The lip sits on top of the plate, so it starts at z = lid_plate_z
    union() {
        // Plate
        cube([lid_plate_x, lid_plate_y, lid_plate_z], center = [true, true, false]);
        
        // Lip (hollow rectangular ring)
        translate([0, 0, lid_plate_z])
            difference() {
                // Outer lip block
                cube([lip_outer_x, lip_outer_y, lip_height], center = [true, true, false]);
                
                // Inner cavity of the lip, extends 1 mm past the top for clean cut
                lip_inner_x = lip_outer_x - 2 * lip_wall;  // 62.6 mm
                lip_inner_y = lip_outer_y - 2 * lip_wall;  // 42.6 mm
                lip_inner_z = lip_height + 1;
                
                translate([-lip_inner_x/2, -lip_inner_y/2, 0])
                    cube([lip_inner_x, lip_inner_y, lip_inner_z], center = [true, true, false]);
            }
    }
}

// ---------- Assemble both parts side by side ----------
// Box is centred on the origin.
// Lid is translated to the +X side with a 10 mm gap.
union() {
    // Part 1: Box at origin
    box();
    
    // Part 2: Lid on the +X side
    translate([lid_offset_x, 0, 0])
        lid();
}