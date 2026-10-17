// 96-well PCR tube rack - a solid block with a regular square grid of vertical through-holes, for
// standing 0.2 mL (200 uL) PCR tubes. NOVEL part: a generic rack, not any one lab's specification.
//

cols   = 12;
rows   = 8;
tube_d = 6.2;
pitch  = 9.0;
H      = 20;
L      = 127.76;
W      = 85.48;
chamf  = 5;

$fn = 48;

size_d = tube_d + 2 * pitch;                 // grid pitch centred in the hole
L_d    = size_d * cols - 2 * pitch;          // diagonal size of the 12 x 8 grid
W_d    = size_d * rows - 2 * pitch;

translate([-(L_d / 2 - L / 2), -(W_d / 2 - W / 2), 0])          // centre the grid in the block
difference() {
    cube([L, W, H]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([
            -L / 2 + pitch / 2 + i * size_d,
            -W / 2 + pitch / 2 + j * size_d,
            -1
        ]) cylinder(h = H + 2, d = tube_d);
    translate([0, 0, -1])
        chamfer([chamf, 0]) cube([chamf, W, H + 2]);                   // orientation chamfer at A1
}