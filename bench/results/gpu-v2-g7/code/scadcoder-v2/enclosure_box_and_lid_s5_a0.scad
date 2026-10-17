// Two-part enclosure for a small electronics board - prints in one go with a part between them.
// Part 1: open-top box (wall .2 mm, floor .2 mm). Part 2: lid plate with a rectangular lip that
// slides into the box opening (.2 mm clearance). The lid is printed upside down (lip up) so the
// wall fuses at the seam. Both parts are centred in X and Y on the bed (z = 0) with a 10 mm gap.

box_x = 70;
box_y = 50;
box_z = 30;
wall  = 2;
floor = 2;

lip_t = 1.5;
lip_h = 4;
lip_x = 65.6;
lip_y = 45.6;

$fn = 64;

box3d   = cube([box_x - 2 * wall, box_y - 2 * wall, box_z - floor]);
floor3d = cube([box_x - 2 * wall, box_y - 2 * wall, floor]);
lip3d   = cube([lip_x, lip_y, lip_t]);
wall3d  = cube([lip_x, lip_y, lip_h]);

module open_box() {
    difference() {
        union() { box3d; floor3d; }
        translate([wall, wall, wall]) cube([box_x - 2 * wall, box_y - 2 * wall, box_z]);
    }
}

module lid_plate() {
    cl = min(0.2, wall - 0.5);                 // clearance the lip pushes through (fuse at the seam)
    difference() {
        union() { lip3d; wall3d; }
        translate([wall, wall, -1]) cube([box_x - 2 * wall, box_y - 2 * wall, lip_h + 2]);   // bore for the lip
        translate([wall, wall, lip_h + 1]) cube([box_x - 2 * wall, box_y - 2 * wall, cl]);    // keep the bore open below
    }
}

open_box();
translate([0, box_y + 10, 0]) lid_plate();