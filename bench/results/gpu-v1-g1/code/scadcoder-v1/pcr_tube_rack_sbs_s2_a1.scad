// 96-well PCR tube rack - a solid block with a regular grid of vertical through-holes for 0.2 mL
// tubes, in the ANSI/SLAS microplate footprint. NOVEL part - not one of the 16 benchmark tasks.
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

size_d = tube_d + 2;                 // hole plus wall (the walls are thin but that's what was asked for)
L2     = L - 2 * size_d;
W2     = W - 2 * size_d;
H2     = H - chamf;                  // chamfered edge reduces height only at one edge

translate([L / 2, W / 2, 0])
difference() {
    cube([L, W, H]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([L / 2 - pitch * i, W / 2 - pitch * j, -1]) cylinder(h = H + 2, d = size_d);
    translate([0, 0, -1])
        cube([chamf, W + 2, H + 2]);           // chamfer the vertical edge at the A1 corner
}