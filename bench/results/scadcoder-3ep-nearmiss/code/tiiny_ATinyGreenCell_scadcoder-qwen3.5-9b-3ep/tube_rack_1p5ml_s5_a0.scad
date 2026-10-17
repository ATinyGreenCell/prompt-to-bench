// Bench rack for 1.5 mL microcentrifuge tubes - a solid rectangular block with a regular
// grid of vertical tube holes, open at the top and closed at the bottom (a "floor" below
// the lowest hole). NOVEL general part, measurable with calipers.
//

length   = 106;
width    = 72;
height   = 30;
rows     = 4;
columns  = 6;
pitch_x  = 16;
pitch_y  = 16;
hole_d   = 11.2;
hole_depth = 25;
floor    = 5;

$fn = 48;

floor_z = height - floor;
holes_z = [floor_z + i * pitch_y + pitch_y / 2 | i = [0 : rows - 1]];

difference() {
    translate([-length / 2, -width / 2, 0]) cube([length, width, height]);
    for (y = [0 : rows - 1], x = [0 : columns - 1])
        translate([x * pitch_x + pitch_x / 2, y * pitch_y + pitch_y / 2, 0])
            cylinder(h = hole_depth + 0.01, d = hole_d);
}