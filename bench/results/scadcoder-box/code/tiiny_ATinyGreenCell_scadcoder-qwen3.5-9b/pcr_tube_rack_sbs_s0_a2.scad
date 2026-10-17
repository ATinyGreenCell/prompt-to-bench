// PCR tube rack - a rectangular block with a 96-hole grid (8 x 12) for 0.2 mL tubes, with one
// chamfered orientation corner. NOVEL general part (a tube rack, not one of the 15 benchmark tasks).
//

cols   = 12;
rows   = 8;
tube_d = 6.2;
H      = 20;
pitch  = 9.0;
L      = 127.76;
W      = 85.48;
chamf  = 5;

$fn = 64;

p  = min(tube_d + 2, pitch);                 // keep a wall between neighbouring holes
margin = tube_d / 2 + p / 2 + 1.5;            // clearance around the grid
L2 = L - 2 * margin;
W2 = W - 2 * margin;

difference() {
    cube([L, W, H]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([margin + i * p, margin + j * p, -1]) cylinder(h = H + 2, d = tube_d);
    translate([0, 0, -1])
        cube([chamf, chamf, H + 2]);         // chamfer the A1 (left-back) vertical edge
}