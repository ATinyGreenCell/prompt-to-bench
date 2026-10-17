// Two-part enclosure for a small electronics board (e.g. an Arduino-based temperature logger).
// Both parts print together on the bed with a 10 mm gap between them.
// NOVEL general part (a generic box with a matching lid) - not a part any one lab ordered.
//

box_x   = 70;
box_y   = 50;
box_z   = 30;
wall    = 2;
floor   = 2;
lip_t   = 1.5;
lip_h   = 4;
lip_x   = 65.6;
lip_y   = 45.6;
clearance = 0.2;

$fn = 32;

gap = 10;

module box() {
    difference() {
        cube([box_x, box_y, box_z]);
        translate([wall, wall, wall]) cube([box_x - 2 * wall, box_y - 2 * wall, box_z - floor]);   // hollow, open top
    }
}

module lid() {
    plate_t = 2;
    union() {
        translate([-lip_x / 2, -lip_y / 2, 0]) cube([lip_x, lip_y, plate_t]);                 // plate
        translate([-lip_x / 2, -lip_y / 2, 0]) cube([lip_x, lip_y, lip_t]);                   // top wall
        translate([0, -lip_y / 2, plate_t]) cube([lip_x, lip_y + 2 * lip_h, lip_t]);           // front lip
        translate([0, lip_y / 2, plate_t]) cube([lip_x, lip_y + 2 * lip_h, lip_t]);           // rear lip
    }
}

box();
translate([0, box_y + gap, 0]) lid();