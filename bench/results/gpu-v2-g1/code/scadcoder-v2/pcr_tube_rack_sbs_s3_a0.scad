// 96 PCR tube (0.2 mL) rack - a block with a regular grid of vertical through-holes for the
// standard microplate (ANSI/SLAS) footprint, with a 45-degree chamfer off one vertical edge as
// an orientation mark. NOVEL general part.
//

cols   = 12;
rows   = 8;
tube_d = 6.2;
pitch  = 9.0;
block_l = 127.76;
block_w = 85.48;
block_h = 20;
offset_x = 14.38;
offset_y = 11.24;
chamfer = 5;

$fn = 48;

leg = min(chamfer, block_l, block_w, block_h);

difference() {
    translate([-block_l / 2, -block_w / 2, 0]) cube([block_l, block_w, block_h]);
    for (i = [0 : cols - 1], j = [0 : rows - 1])
        translate([offset_x + i * pitch, offset_y + j * pitch, -1]) cylinder(h = block_h + 2, d = tube_d);
    translate([-block_l / 2, -block_w / 2, 0])
        rotate([0, 0, 45]) cube([leg, leg, leg]);
}