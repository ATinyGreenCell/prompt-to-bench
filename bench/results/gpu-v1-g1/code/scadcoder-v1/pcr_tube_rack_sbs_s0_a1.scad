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
L_d    = cols * size_d - size_d + 2 * chamf; // keep a chamfer margin at the left edge
W_d    = rows * size_d - size_d + 2 * chamf; // keep a chamfer margin at the back edge

difference() {
    translate([-L / 2, -W / 2, 0]) cube([L, W, H]);
    for (i = [0 : cols - 1])
        for (j = [0 : rows - 1])
            translate([-(size_d / 2 - chamf) + i * size_d, -(size_d / 2 - chamf) + j * size_d, -1])
                cylinder(h = H + 2, d = tube_d);
    translate([-(chamf + 0.01), -(chamf + 0.01), 0]) cube([chamf * 2 + 0.02, chamf * 2, H]);     // chamfer the A1 (left-back) vertical edge
}