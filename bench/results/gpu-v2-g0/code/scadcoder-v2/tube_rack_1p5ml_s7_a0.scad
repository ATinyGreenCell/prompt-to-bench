// Bench rack for 1.5 mL microcentrifuge tubes - a solid rectangular block with a regular
// grid of vertical tube holes, open at the top and closed at the bottom (a "floor" below
// the lowest hole). NOVEL general part (a generic hole grid, not tied to one tool).
//

l     = 106;
w     = 72;
h     = 30;
rows  = 4;
cols  = 6;
pitch_x = 16;
pitch_y = 16;
d     = 11.2;
depth = 25;

$fn = 48;

floor = h - depth;

difference() {
    translate([-l / 2, -w / 2, 0]) cube([l, w, h]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([
            -l / 2 + (pitch_x / 2) + i * pitch_x,
            -w / 2 + (pitch_y / 2) + j * pitch_y,
            -1
        ]) cylinder(h = depth + 2, d = d);
}