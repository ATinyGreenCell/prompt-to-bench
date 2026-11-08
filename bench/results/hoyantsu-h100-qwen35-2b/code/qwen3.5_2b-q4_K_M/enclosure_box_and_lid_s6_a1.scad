// Design a two-part enclosure for an electronics board (Arduino temperature logger).
// Parts print side-by-side with a 10mm gap.

// --- Parameters ---
// Part 1: Box dimensions in mm
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;
box_wall_thickness = 2;
box_floor_thickness = 2;

// Part 2: Lid plate dimensions (printed upside down, lying on bed)
lid_plate_width = 70;
lid_plate_depth = 50;
lid_plate_height = 2; // Thickness of the plate itself

// Lip dimensions for lid
lip_wall_thickness_lip = 1.5;
lip_height_lip = 4;
lip_outer_x = 65.6;
lip_outer_y = 45.6;

// Gap between parts (in mm)
gap_between_parts = 10;

// --- Variables for dimensions ---
var box_width = box_outer_x + gap_between_parts; // Total width of the assembly
var box_height = box_outer_z;
var box_depth = box_outer_y;
var lid_plate_thickness = lid_plate_height;
var lip_wall_thickness = lip_wall_thickness_lip;
var lip_height = lip_height_lip;

// --- Part 1: The Box (Boxy shape) ---
// Dimensions: X=70, Y=50, Z=30. Walls 2mm, Floor 2mm. Top open.
// We model the box as a large cube with corners cut off to form walls and floor.

box_part = rotate_extrude(90, translate([0, -1], [0, 0]), function() {
    // Define a bounding box slightly larger than outer dimensions for easier corner cutting
    var b_box_x = box_width + box_wall_thickness * 2;
    var b_box_y = box_depth + box_wall_thickness * 2;
    var b_box_z = box_height + box_floor_thickness * 2;

    // Create a large cube
    cube([b_box_x, b_box_y, b_box_z]);

    // Cut corners to form walls and floor (1mm thickness)
    polygon([box_width - box_wall_thickness, box_depth - box_wall_thickness], [0, 0], [90, 90]) rotate(90);
    polygon([box_width + box_wall_thickness, box_depth - box_wall_thickness], [0, 0], [90, 90]) rotate(-90);
    polygon([box_width - box_wall_thickness, box_depth + box_wall_thickness], [0, 0], [90, 90]) rotate(180);
    polygon([box_width + box_wall_thickness, box_depth + box_wall_thickness], [0, 0], [90, 90]) rotate(-180);

    // Cut the floor (bottom face) to thickness of 2mm
    polygon([box_width - box_floor_thickness, box_depth - box_floor_thickness], [0, 0], [90, 90]) rotate(90);
});

// --- Part 2: The Lid (Upside down plate with lip) ---
// Dimensions: Plate 70x50. Lip is a rectangular block on top.
// Lip dimensions: Width=65.6, Depth=45.6, Height=4mm. Wall thickness 1.5mm.

lid_part = rotate_extrude(90, translate([box_width/2 - lip_outer_x/2, box_depth/2 - lip_outer_y/2], [0, 0]), function() {
    // Create a large plate slightly larger than outer dimensions for easier corner cutting
    var b_plate_x = lid_plate_width + lip_wall_thickness * 2;
    var b_plate_y = lid_plate_depth + lip_wall_thickness * 2;

    cube([b_plate_x, b_plate_y, lid_plate_thickness]);

    // Cut corners to form the plate walls (1mm thickness)
    polygon([lid_plate_width - lip_wall_thickness, lid_plate_depth - lip_wall_thickness], [0, 0], [90, 90]) rotate(90);
    polygon([lid_plate_width + lip_wall_thickness, lid_plate_depth - lip_wall_thickness], [0, 0], [90, 90]) rotate(-90);
    polygon([lid_plate_width - lip_wall_thickness, lid_plate_depth + lip_wall_thickness], [0, 0], [90, 90]) rotate(180);
    polygon([lid_plate_width + lip_wall_thickness, lid_plate_depth + lip_wall_thickness], [0, 0], [90, 90]) rotate(-180);

    // Cut the plate bottom to thickness of 2mm
    polygon([lid_plate_width - lid_plate_thickness, lid_plate_depth - lid_plate_thickness], [0, 0], [90, 90]) rotate(90);

    // Create the lip on top (1.5mm thick wall)
    // Lip is centered on the plate face
    var lip_x = lid_plate_width / 2;
    var lip_y = lid_plate_depth / 2;
    
    // Lip dimensions: Width=65.6, Depth=45.6, Height=4mm
    polygon([lip_outer_x - lip_wall_thickness, lip_outer_y - lip_wall_thickness], [0, 0], [90, 90]) rotate(90);
    polygon([lip_outer_x + lip_wall_thickness, lip_outer_y - lip_wall_thickness], [0, 0], [90, 90]) rotate(-90);
    polygon([lip_outer_x - lip_wall_thickness, lip_outer_y + lip_wall_thickness], [0, 0], [90, 90]) rotate(180);
    polygon([lip_outer_x + lip_wall_thickness, lip_outer_y + lip_wall_thickness], [0, 0], [90, 90]) rotate(-180);

    // Cut the lip bottom to thickness of 4mm (lid height)
    polygon([lip_outer_x - lid_plate_thickness, lip_outer_y - lid_plate_thickness], [0, 0], [90, 90]) rotate(90);
});

// --- Final Assembly ---
// Union both parts. The gap is handled by the fact that they are placed side-by-side 
// and union() fills the space between them automatically if there's no overlap.
final_part = union([box_part, lid_part]);

print("Design complete: Box + Lid");