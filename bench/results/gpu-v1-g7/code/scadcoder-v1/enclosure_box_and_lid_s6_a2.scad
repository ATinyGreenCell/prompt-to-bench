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

part_size_x = box_x + 10;
part_size_y = box_y + 10;
part_size_z = box_z + 10;

difference() {
    translate([-part_size_x / 2, -part_size_y / 2, 0]) cube([part_size_x, part_size_y, part_size_z]);
    // A vertical plane through the centre, 1 mm thick, splitting the part into two solid blocks
    translate([0, -part_size_y / 2 - 1, 0]) cube([2, part_size_y + 2, part_size_z]);
}