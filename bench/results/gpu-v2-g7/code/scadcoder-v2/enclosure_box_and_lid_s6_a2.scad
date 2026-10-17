// Two-part enclosure for a small electronics board - prints in one go with a part between them.
// Part 1: open-top box (wall 2 mm, floor 2 mm). Part 2: lid plate with a rectangular lip that
// slides into the box opening (0.2 mm clearance). The lip overhangs the plate edge by 1.5 mm.
//

box_x = 70;
box_y = 50;
box_z = 30;
wall  = 2;
floor = 2;

lip_t = 1.5;
lip_h = 4;
lip_x = 65.6;
lip_y = 45.6;

$fn = 32;

box3d   = cube([box_x - 2 * wall, box_y - 2 * wall, box_z - floor]);
floor3d = cube([box_x - 2 * wall, box_y - 2 * wall, floor]);
lip3d   = cube([lip_x, lip_y, lip_t]);
base3d  = cube([lip_x, lip_y, lip_h]);

module open_box() {
    difference() {
        union() { box3d; floor3d; }
        translate([wall, wall, wall]) cube([box_x - 2 * wall, box_y - 2 * wall, box_z - floor + 1]);
    }
}

module lid() {
    cl = min(lip_x - 0.4, box_x - 2 * wall - 0.4);   // stop the lip at the box walls with a little clearance
    cy = min(lip_y - 0.4, box_y - 2 * wall - 0.4);
    difference() {
        union() { base3d; translate([0, 0, lip_h]) cube([lip_x, lip_y, lip_t]); }
        translate([wall, wall, lip_h + 1]) cube([cl, cy, lip_t + 1]);   // pocket for the lip
    }
}

open_box();
translate([35, 0, 0]) lid();