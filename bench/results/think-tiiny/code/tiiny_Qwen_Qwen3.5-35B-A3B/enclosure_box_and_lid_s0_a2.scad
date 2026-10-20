// Global settings
$fn = 64;

// Part 1: The Box
// Dimensions
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;
box_wall_thickness = 2;
box_floor_thickness = 2;

// Calculated dimensions for the void
box_inner_x = box_outer_x - 2 * box_wall_thickness;
box_inner_y = box_outer_y - 2 * box_wall_thickness;
box_inner_z = box_outer_z - box_floor_thickness;

// Tolerance for difference() to ensure no coplanar faces
box_tolerance = 0.02;

// Part 1: The Box Model
// Centered at origin (0,0,0)
box = difference() {
    // Outer shell
    cube([box_outer_x, box_outer_y, box_outer_z], center = true);
    
    // Inner void (cutting shape)
    // Positioned to leave floor thickness at bottom and open at top
    // Center Z is at floor_thickness + inner_z / 2
    translate([0, 0, box_floor_thickness + box_inner_z / 2])
        cube([box_inner_x + box_tolerance, box_inner_y + box_tolerance, box_inner_z + box_tolerance], center = true);
}

// Part 2: The Lid
// Dimensions
lid_plate_x = 70;
lid_plate_y = 50;
lid_plate_z = 2;
lid_lip_outer_x = 65.6;
lid_lip_outer_y = 45.6;
lid_lip_height = 4;
lid_lip_wall_thickness = 1.5;

// Calculated dimensions for the lip void
lid_lip_inner_x = lid_lip_outer_x - 2 * lid_lip_wall_thickness;
lid_lip_inner_y = lid_lip_outer_y - 2 * lid_lip_wall_thickness;

// Tolerance for difference()
lid_tolerance = 0.02;

// Part 2: The Lid Model
// The lid is composed of a base plate and a lip frame.
// The lip frame is a hollow box sitting on the plate.
// The entire lid is centered at (0,0,0) relative to its own origin, then translated.

// Base Plate
lid_plate = cube([lid_plate_x, lid_plate_y, lid_plate_z], center = true);

// Lip Frame
// Constructed as a solid block minus an inner void
lid_lip_outer = cube([lid_lip_outer_x, lid_lip_outer_y, lid_lip_height], center = true);
lid_lip_inner = cube([lid_lip_inner_x + lid_tolerance, lid_lip_inner_y + lid_tolerance, lid_lip_height + lid_tolerance], center = true);
lid_lip = difference() {
    lid_lip_outer;
    lid_lip_inner;
}

// Union Plate and Lip
lid_part = union() {
    lid_plate;
    lid_lip;
}

// Positioning
// Box is at (0,0,0)
// Lid is placed on the +X side with a 10mm gap
// Box X range: -35 to 35
// Gap: 10mm
// Lid X range: 45 to 115
// Lid Center X: 80
lid_position_x = box_outer_x / 2 + 10 + lid_plate_x / 2;

// Final Output
translate([lid_position_x, 0, 0])
    lid_part;

translate([0, 0, 0])
    box;