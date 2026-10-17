// Tube rack - a flat plate with a regular grid of tube holes and two solid side walls.
// The two walls rest on a surface and the tubes pass through the holes. The short ends are open.
// NOVEL general part (not one of the 16 benchmark tasks).
//
// Parametric for augmentation. Ranges are the sane envelope a variant may be drawn from:

cols   = 6;
rows   = 2;
tube_d = 30.5;
pitch_x = 40;
pitch_y = 40;
base_t = 4;
wall_h = 70;

$fn = 48;

plate_L = cols * pitch_x + 2 * (pitch_x / 2);      // centre-to-centre span X + one radius each side
plate_W = rows * pitch_y + 2 * (pitch_y / 2);      // centre-to-centre span Y + one radius each side

difference() {
    translate([-plate_L / 2, -plate_W / 2, 0]) cube([plate_L, plate_W, base_t]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([
            -plate_L / 2 + pitch_x / 2 + i * pitch_x,
            -plate_W / 2 + pitch_y / 2 + j * pitch_y,
            -1
        ]) cylinder(h = base_t + 2, d = tube_d);
    for (i = [0 : cols - 1])
        translate([-plate_L / 2 + pitch_x / 2 + i * pitch_x, -plate_W / 2 - 1, 0])
            cube([pitch_x, plate_W + 2, base_t]);           // side walls along the long (X) edges
}