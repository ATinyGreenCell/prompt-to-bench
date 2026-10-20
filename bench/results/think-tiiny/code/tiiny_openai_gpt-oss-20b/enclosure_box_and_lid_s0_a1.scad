//============================================================
//  Two‑part enclosure for a small electronics board
//  (Arduino‑based temperature logger)
//============================================================

//============================================================
//  Global settings
//============================================================

$fn = 64;  // Resolution for curved surfaces (not used here but kept for consistency)

//============================================================
//  Box (Part 1)
//============================================================

// Box outer dimensions (X × Y × Z) in mm
box_outer_x = 70;          // Width
box_outer_y = 50;          // Depth
box_outer_z = 30;          // Height

// Wall thickness (mm)
box_wall_thickness = 2;

// Floor thickness (mm)
box_floor_thickness = 2;

// Derived inner cavity dimensions (mm)
box_inner_x = box_outer_x - 2 * box_wall_thickness;   // 66
box_inner_y = box_outer_y - 2 * box_wall_thickness;   // 46
box_inner_z = box_outer_z - box_floor_thickness;        // 28

//============================================================
//  Lid (Part 2)
//============================================================

// Plate dimensions (mm)
lid_plate_x = 70;          // Width
lid_plate_y = 50;          // Depth
lid_plate_z = 2;           // Thickness

// Lip dimensions (mm)
lid_lip_thickness = 1.5;  // Wall thickness of the lip
lid_lip_height = 4;        // Height of the lip

// Lip outer dimensions (mm)
lid_lip_outer_x = 65.6;    // Width
lid_lip_outer_y = 45.6;    // Depth

// Lip inner dimensions (mm)
lid_lip_inner_x = lid_lip_outer_x - 2 * lid_lip_thickness;   // 62.6
lid_lip_inner_y = lid_lip_outer_y - 2 * lid_lip_thickness;   // 42.6

//============================================================
//  Gap between parts on the bed (mm)
//============================================================

gap = 10;

//============================================================
//  Build the box
//============================================================

box = difference() {
    // Outer solid
    cube([box_outer_x, box_outer_y, box_outer_z], center = false);

    // Inner cavity (cut out)
    translate([box_wall_thickness, box_wall_thickness, box_floor_thickness]) {
        cube([box_inner_x, box_inner_y, box_inner_z], center = false);
    }
}

//============================================================
//  Build the lid
//============================================================

// Plate (bottom of the lid)
plate = cube([lid_plate_x, lid_plate_y, lid_plate_z], center = false);

// Lip (raised ring on top of the plate)
lip = difference() {
    // Outer lip
    cube([lid_lip_outer_x, lid_lip_outer_y, lid_lip_height], center = false);

    // Inner lip (creates the hollow)
    cube([lid_lip_inner_x, lid_lip_inner_y, lid_lip_height], center = false);
}

// Position the lip on top of the plate
lip = translate([lid_plate_x / 2, lid_plate_y / 2, lid_plate_z]) lip;

// Combine plate and lip into a single lid solid
lid = union() {
    plate;
    lip;
}

//============================================================
//  Position parts on the bed
//============================================================

// Box is centered at the origin (XY plane)
box_pos = [0, 0, 0];

// Lid is placed on the +X side of the box with a 10 mm gap
// The box’s right face is at x = +box_outer_x/2 = +35 mm
// Therefore the lid’s left face should be at x = +35 mm + 10 mm = +45 mm
lid_pos = [box_outer_x / 2 + gap, 0, 0];

//============================================================
//  Final assembly (both parts together)
//============================================================

union() {
    translate(box_pos) box;
    translate(lid_pos) lid;
}