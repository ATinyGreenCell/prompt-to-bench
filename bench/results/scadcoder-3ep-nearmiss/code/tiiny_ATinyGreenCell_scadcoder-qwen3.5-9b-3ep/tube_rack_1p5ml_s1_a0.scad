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

floor_t = 5;
hole_depth = depth - floor_t;

difference() {
    cube([L, W, H]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([pX * i + L / 2 - pX * (cols - 1) / 2,
                    pY * j + W / 2 - pY * (rows - 1) / 2, 0])
            cylinder(h = hole_depth, d = d, $fn = 48);
}