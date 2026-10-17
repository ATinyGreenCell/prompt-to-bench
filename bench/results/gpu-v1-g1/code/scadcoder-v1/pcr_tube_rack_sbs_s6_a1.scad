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

size_d = tube_d + 2;                 // hole-wall clearance
grid_x = min(L - 2 * chamf, cols * pitch);      // keep the A1 chamfer clear of the grid
grid_y = min(W - 2 * chamf, rows * pitch);
P_x = grid_x / (cols - 1);
P_y = grid_y / (rows - 1);

difference() {
    translate([-L / 2, -W / 2, 0]) cube([L, W, H]);
    for (i = [0 : cols - 1])
        for (j = [0 : rows - 1])
            translate([-(size_d / 2), -(size_d / 2), -1])
                rotate([0, 0, 1]) cylinder(h = H + 2, d = tube_d);
    // A1 corner chamfer: remove the cone whose axis is the edge along X at y = -W / 2
    translate([-L / 2, -W / 2, 0])
        difference() {
            cube([L, chamf + 1, H]);
            translate([chamf, 0, -1]) rotate([-45, 0, 0]) cube([chamf * 1.414, chamf + 2, H + 2]);
        }
}