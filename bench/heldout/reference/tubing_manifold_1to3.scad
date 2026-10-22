// Manifold block: one tubing inlet split into three outlets through internal channels
// Category: hardware. 3 mm channels in the mid-plane: an inlet socket on the -X face feeds a main
// channel that ends inside the block; three branches run to sockets on the +Y face.
// Print: PETG, lying on its bottom face, 0.15 mm layers, 100 % infill (watertight walls);
// the 3 mm channels bridge cleanly. Leak-test before use; glue the tubing into the sockets.
// SPDX-License-Identifier: CERN-OHL-P-2.0

/* [Manifold] */
block = [60, 24, 16];     // X, Y, Z [mm], centred in X and Y
ch_z = 8;                 // channel mid-plane
ch_d = 3;
sock_d = 4.2;             // socket for 4 mm OD tubing
inlet_sock = 8;           // inlet socket depth (from the -X face)
outlet_sock = 6;          // outlet socket depth (from the +Y face)
main_end = 15;            // the main channel stops at x = 15
outlets_x = [-15, 0, 15];
screw_d = 3.4;            // M3 clearance
screws = [[-25, -6], [25, -6]];

/* [Hidden] */
eps = 0.01;

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    // inlet socket and main channel along +X
    translate([-block.x / 2 - 1, 0, ch_z]) rotate([0, 90, 0]) cylinder(d = sock_d, h = inlet_sock + 1, $fn = 48);
    translate([-block.x / 2 - 1, 0, ch_z]) rotate([0, 90, 0]) cylinder(d = ch_d, h = block.x / 2 + main_end + 1, $fn = 48);
    // outlet branches along +Y, each ending in a socket
    for (x = outlets_x) {
        translate([x, 0, ch_z]) rotate([-90, 0, 0]) cylinder(d = ch_d, h = block.y / 2 + 1, $fn = 48);
        translate([x, block.y / 2 - outlet_sock, ch_z]) rotate([-90, 0, 0]) cylinder(d = sock_d, h = outlet_sock + 1, $fn = 48);
    }
    for (p = screws) translate([p.x, p.y, -1]) cylinder(d = screw_d, h = block.z + 2, $fn = 32);
}
