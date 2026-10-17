// Bench rack for 1.5 mL microcentrifuge tubes - a solid rectangular block with a regular square
// grid of vertical tube holes, open at the top and closed at the bottom. NOVEL general part.
//

cols   = 6;
rows   = 4;
pitch  = 16;
d      = 11.2;
depth  = 25;
H      = 30;

$fn = 48;

p  = max(pitch, d + 2 * 1.5);          // keep a wall between neighbouring holes
Lx = cols * p - p + d + 2 * 1.5;        // size the grid so the outer walls are 1.5 mm thick
Ly = rows * p - p + d + 2 * 1.5;
block_h = H - depth;                   // solid floor below the holes

difference() {
    cube([Lx, Ly, H]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([d / 2 + i * p, d / 2 + j * p, 0])
            cylinder(h = H, d = d);     // open-top hole through the whole height
}