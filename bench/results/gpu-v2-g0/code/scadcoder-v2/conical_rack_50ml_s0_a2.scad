// Tube rack for six 50 mL conical (Falcon-type) tubes - printed upside down and flipped over.
// A flat plate with a 2x3 hole grid and two solid walls run along the long edges. The two
// short ends are open. The walls and plate form a U-cross section along X. NOVEL general part.
//

cols   = 3;
rows   = 2;
tube_d = 30.5;
pitch_x = 40;
pitch_y = 40;
plate_w = 130;
plate_h = 90;
plate_t = 4;
wall_h = 70;

$fn = 48;

plate_n = cols * rows;

difference() {
    union() {
        translate([-plate_w / 2, -plate_h / 2, 0]) cube([plate_w, plate_h, plate_t]);
        translate([-plate_w / 2, -plate_h / 2, 0]) cube([plate_w, 4, wall_h]);      // left wall
        translate([-plate_w / 2, plate_h - 4, 0]) cube([plate_w, 4, wall_h]);      // right wall
    }
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([
            -plate_w / 2 + pitch_x / 2 + i * pitch_x,
            -plate_h / 2 + pitch_y / 2 + j * pitch_y,
            -1
        ]) cylinder(h = plate_t + 2, d = tube_d);
}