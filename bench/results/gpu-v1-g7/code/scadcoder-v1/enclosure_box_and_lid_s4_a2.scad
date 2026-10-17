// Two-part box enclosure for a small electronics board (e.g. an Arduino-based temperature logger),
// printed as one piece with a part between them. NOVEL general part.
//

box_x   = 70;
box_y   = 50;
box_z   = 30;
wall    = 2;
floor   = 2;

lip_t   = 1.5;
lip_h   = 4;
clearance = 0.2;

$fn = 48;

part_center_x = (box_x + box_x + 10) / 2;      // two parts with a 10 mm gap, centred on the bed
part_center_y = box_y / 2;

module box() {
    difference() {
        cube([box_x, box_y, box_z + floor]);
        translate([wall, wall, floor]) cube([box_x - 2 * wall, box_y - 2 * wall, box_z + 1]);   // hollow, open top
    }
}

module lid() {
    plate_h = 2;
    union() {
        translate([part_center_x - box_x / 2, part_center_y - box_y / 2, 0])
            cube([box_x, box_y, plate_h]);                                          // plate
        translate([part_center_x - (box_x / 2 - clearance), part_center_y - (box_y / 2 - clearance), 0])
            cube([box_x - 2 * clearance, box_y - 2 * clearance, lip_h + lip_t]);    // lip (open top)
    }
}

box();
translate([part_center_x, 0, 0]) lid();