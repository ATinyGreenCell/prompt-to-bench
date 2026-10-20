// Variables for Box
box_x = 70;
box_y = 50;
box_z = 30;
wall_thick = 2;
floor_thick = 2;

// Variables for Lid
lid_x = 70;
lid_y = 50;
lid_plate_thick = 2;
lip_outer_x = 65.6;
lip_outer_y = 45.6;
lip_wall_thick = 1.5;
lip_height = 4;

// Layout
gap = 10;

// Global
$fn = 64;

// Box Module
module box() {
    // Outer shape
    difference() {
        cube([box_x, box_y, box_z], center = false);
        // Inner cutout (walls and floor)
        // Inner dimensions
        inner_x = box_x - 2 * wall_thick;
        inner_y = box_y - 2 * wall_thick;
        inner_z = box_z - floor_thick;
        // Position inner cutout above floor
        translate([wall_thick, wall_thick, floor_thick]) {
            cube([inner_x, inner_y, inner_z], center = false);
        }
    }
}

// Lid Module
module lid() {
    union() {
        // Plate
        cube([lid_x, lid_y, lid_plate_thick], center = false);
        // Lip
        lip_inner_x = lip_outer_x - 2 * lip_wall_thick;
        lip_inner_y = lip_outer_y - 2 * lip_wall_thick;
        translate([
            (lid_x - lip_outer_x) / 2,
            (lid_y - lip_outer_y) / 2,
            lid_plate_thick
        ]) {
            difference() {
                cube([lip_outer_x, lip_outer_y, lip_height], center = false);
                translate([lip_wall_thick, lip_wall_thick, 0]) {
                    cube([lip_inner_x, lip_inner_y, lip_height], center = false);
                }
            }
        }
    }
}

// Main Script
// Box centered at origin
translate([-box_x / 2, -box_y / 2, 0]) {
    box();
}

// Lid on +X side with gap
translate([
    box_x / 2 + gap,
    -lid_y / 2,
    0
]) {
    lid();
}