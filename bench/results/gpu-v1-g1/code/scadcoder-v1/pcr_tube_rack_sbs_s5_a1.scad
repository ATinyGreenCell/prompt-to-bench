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

size_d = tube_d + 2 * pitch;                 // grid pitch centred in the part (inner dimension)
L_i    = min(L, size_d * (cols - 1));         // fit the grid in the length the user gives
W_i    = min(W, size_d * (rows - 1));         // fit the grid in the width the user gives

difference() {
    translate([-L / 2, -W / 2, 0]) cube([L, W, H]);
    for (i = [0 : cols - 1])
        for (j = [0 : rows - 1])
            translate([-(size_d / 2) + i * pitch, -(size_d / 2) + j * pitch, -1])
                cylinder(h = H + 2, d = tube_d);
    // orientation chamfer: remove 45 deg (leg = min(chamf, L/2, W/2, H)) from the A1 vertical edge
    cf = min(chamf, L / 2, W / 2, H);
    translate([-(L / 2 - cf), -W / 2, 0])
        cube([cf, W + 2 * cf, H + 1]);        // a wedge against the A1 edge, open to the inside
}