// Bench rack for 1.5 mL microcentrifuge tubes - a solid rectangular block with a regular
// grid of vertical tube holes, open at the top and closed at the bottom (a "floor" below
// the lowest hole). NOVEL general part, parametric in its grid and hole size.
//

L   = 106;
W   = 72;
H   = 30;
rows = 4;
cols = 6;
pX   = 16;
pY   = 16;
d    = 11.2;
depth = 25;

$fn = 48;

floor_z = H - depth;

module tube_hole(x, y) {
    translate([x, y, 0]) cylinder(h = depth, d = d);
}

difference() {
    cube([L, W, H]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([-L / 2 + pX / 2 + i * pX, -W / 2 + pY / 2 + j * pY, 0])
            tube_hole(0, 0);
}