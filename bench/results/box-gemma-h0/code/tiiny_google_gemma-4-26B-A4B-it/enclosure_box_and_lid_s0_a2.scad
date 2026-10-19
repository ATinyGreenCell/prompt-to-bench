// --- Dimensions ---
// Box Dimensions
box_width = 70;          // X dimension of box
box_depth = 50;          // Y dimension of box
box_height = 30;         // Z dimension of box
box_wall_thick = 2;      // Thickness of the walls
box_floor_thick = 2;     // Thickness of the bottom floor

// Lid Dimensions
lid_plate_w = 70;        // X dimension of the lid plate
lid_plate_d = 50;        // Y dimension of the lid plate
lid_plate_h = 2;         // Z dimension of the lid plate
lid_lip_thick = 1.5;     // Thickness of the lip wall
lid_lip_h = 4;           // Height of the lip wall
lid_lip_w = 65.6;        // X dimension of the lip (outer)
lid_lip_d = 45.6;        // Y dimension of the lip (outer)

// Layout
gap = 10;                // Gap between the two parts
$fn = 64;                // Smoothness for curves

// --- Part 1: The Box ---
// Requirement: Rests on the XY plane at z = 0 and builds upward (+Z).
// Requirement: Centered on X and Y.
// Box dimensions: 70x50x30.
// To ensure the bottom face is at Z=0, we translate the cube by +box_height/2.
translate([0, 0, box_height/2]) {
    difference() {
        // Main outer body
        cube([box_width, box_depth, box_height], center = true);
        
        // Hollow interior
        // We subtract a cube that is slightly larger in Z to ensure clean cut through top
        // The interior starts at Z = box_floor_thick and goes to box_height
        // To center the subtraction, we translate it to the center of the box
        // but offset it so the floor is 2mm thick.
        translate([0, 0, -box_height/2 + box_floor_thick + 0.01])
            cube([box_width - 2*box_wall_thick, box_depth - 2*box_wall_thick, box_height], center = true);
    }
}

// --- Part 2: The Lid ---
// Requirement: Printed upside down: a plate 70 x 50 x 2 mm lying on the bed, 
// with a rectangular lip on top of it.
// Requirement: Place the lid on the +X side of the box.
// Requirement: Rests on the XY plane at z = 0.

// Calculation for X position:
// Box X range is [-35, 35].
// Gap is 10.
// Lid X range starts at 35 + 10 = 45.
// Lid X center is 45 + (70/2) = 80.
translate([box_width/2 + gap + lid_plate_w/2, 0, 0]) {
    // The lid is built from the bed up.
    // Plate is at Z=0.
    union() {
        // The base plate (lying on the bed)
        // To rest on Z=0, we translate the cube by +lid_plate_h/2
        translate([0, 0, lid_plate_h/2])
            cube([lid_plate_w, lid_plate_d, lid_plate_h], center = true);
        
        // The Lip (on top of the plate)
        // The lip sits on the plate, so its base is at Z = lid_plate_h.
        // To center it on Z, we translate to lid_plate_h + lid_lip_h/2.
        translate([0, 0, lid_plate_h + lid_lip_h/2])
            cube([lid_lip_w, lid_lip_d, lid_lip_h], center = true);
    }
}