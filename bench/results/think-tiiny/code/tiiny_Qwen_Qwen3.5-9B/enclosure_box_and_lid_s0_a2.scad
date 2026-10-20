// Two-part enclosure for small electronics board (Arduino-based temp logger)
// Part 1: Box (Z=0 to 30)
// Part 2: Lid (Z=0 to 6)
// Both parts printed side-by-side on the bed (XY plane)

$fn = 64;

// Box Dimensions
box_outer_x = 70;
box_outer_y = 50;
box_outer_z = 30;
box_wall = 2;
box_floor = 2;

// Lid Dimensions
lid_plate_x = 70;
lid_plate_y = 50;
lid_plate_z = 2;
lip_outer_x = 65.6;
lip_outer_y = 45.6;
lip_thickness = 1.5;
lip_height = 4;
lip_clearance = 0.2; // 0.2mm clearance on each side relative to box inner

// Placement
gap_between_parts = 10;

// Calculate Inner Box Dimensions
box_inner_x = box_outer_x - (2 * box_wall);
box_inner_y = box_outer_y - (2 * box_wall);
box_inner_z = box_outer_z - box_floor;

// Calculate Lid Position (Centered on X, Y)
// Box Center: (0, 0)
// Box Right Edge: box_outer_x / 2 = 35
// Lid Left Edge: Box Right Edge + gap = 35 + 10 = 45
// Lid Center X: Lid Left Edge + lid_outer_x / 2 = 45 + 35 = 80
// Lid Center Y: 0
lid_center_x = (box_outer_x / 2) + gap_between_parts + (lid_plate_x / 2);
lid_center_y = 0;

// Box Module
module box() {
    difference() {
        cube([box_outer_x, box_outer_y, box_outer_z]);
        translate([
            (box_outer_x - (box_inner_x + 0.01)) / 2,
            (box_outer_y - (box_inner_y + 0.01)) / 2,
            box_floor
        ]) cube([box_inner_x + 0.01, box_inner_y + 0.01, box_inner_z + 0.01]);
    }
}

// Lid Module
module lid() {
    union() {
        cube([lid_plate_x, lid_plate_y, lid_plate_z]);
        translate([
            0,
            0,
            lid_plate_z
        ]) cube([lip_outer_x, lip_outer_y, lip_height]);
    }
}

// Main Assembly
// Box centered at (0,0)
// Lid centered at (lid_center_x, 0)
translate([0, 0, 0]) {
    box();
}

translate([lid_center_x, lid_center_y, 0]) {
    lid();
}