// Two-part enclosure for a small electronics board - prints in one go with a part between them.
// Part 1: open-top box (wall .2 mm, floor .2 mm). Part 2: lid plate with a rectangular lip that
// slides into the opening. The lip is centred on the plate with .2 mm clearance on each side.
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

$fn = 64;

box3d   = cube([box_x - 2 * wall, box_y - 2 * wall, box_z - floor]);
floor3d = cube([box_x - 2 * wall, box_y - 2 * wall, floor]);
lip3d   = cube([lip_x, lip_y, lip_t]);
over3d  = cube([lip_x, lip_y, lip_h]);

module box() {
    difference() {
        union() { box3d; floor3d; }
        translate([wall, wall, wall]) cube([box_x - 2 * wall, box_y - 2 * wall, box_z]);
    }
}

module lid() {
    clx = box_x - 0.4;
    cly = box_y - 0.4;
    translate([clx / 2, cly / 2, 0]) union() {
        cube([lip_x, lip_y, lip_t]);                 // plate
        translate([0, 0, lip_t]) cube([lip_x, lip_y, lip_h]);  // lip
    }
}

box();
translate([0, box_y + 10, 0]) lid();