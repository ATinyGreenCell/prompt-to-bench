// Tube rack - a flat plate with a regular grid of through-holes for conical (Falcon-type) tubes,
// with two solid walls along the long edges. Printed upside down and flipped over, it stands on the
// two walls with the tubes passing through the holes. NOVEL general part.
//

cols   = 6;
pitch_x = 40;
pitch_y = 40;
layer_h = 4;
wall_h  = 70;
tube_d  = 30.5;

$fn = 48;

plate_w = cols * pitch_x + 2 * (pitch_x / 2);   // centre-to-centre span + one radius each side
plate_t = layer_h;

difference() {
    translate([-plate_w / 2, -plate_t / 2, 0]) cube([plate_w, plate_t, layer_h]);
    for (i = [-cols / 2 : 1 : cols / 2 - 1])
        for (j = [-1 : 1])
            translate([i * pitch_x, j * pitch_y, -1]) cylinder(h = layer_h + 2, d = tube_d);
}

for (i = [-1 : 1])
    translate([-130 / 2, i * plate_t / 2, 0]) cube([130, 4, wall_h]);