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
lip    = cube([lip_x, lip_y, lip_t]);
lip_d  = cube([lip_x, lip_y, lip_h]);

difference() {
    union() { box3d; floor3d; }
    translate([wall, wall, floor]) cube([box_x - 2 * wall, box_y - 2 * wall, box_z - floor + 1]);   // open top
}

plate = union() { lip; lip_d; };

box = translate([-box_x / 2, -box_y / 2, 0]) box3d;
floor = translate([-box_x / 2, -box_y / 2, 0]) floor3d;
lip_p = translate([box_x / 2 + 10, -box_y / 2, 0]) plate;

box;
floor;
lip_p;