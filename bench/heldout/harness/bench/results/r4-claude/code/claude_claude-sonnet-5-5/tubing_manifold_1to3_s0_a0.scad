// Manifold block: 1 inlet -> 3 outlets
$fn = 64;

block_l = 60;        // block length (X)
block_w = 24;        // block width (Y)
block_h = 16;        // block height (Z)
mid_z = 8;           // channel mid-plane height

ch_d = 3;            // channel diameter
sock_d = 4.2;        // tubing socket diameter
inlet_depth = 8;     // inlet socket depth
outlet_depth = 6;    // outlet socket depth

main_end_x = 15;     // main channel stops here
outlet_x = [-15, 0, 15];  // outlet branch X positions

screw_d = 3.4;       // M3 clearance hole
screw_x = [-25, 25]; // screw hole X positions
screw_y = -6;        // screw hole Y position

eps = 0.5;           // cutter overshoot

difference() {
    // solid block, centred in X/Y, on bed
    translate([-block_l/2, -block_w/2, 0])
        cube([block_l, block_w, block_h]);

    // inlet socket on -X face at y = 0
    translate([-block_l/2 - eps, 0, mid_z])
        rotate([0, 90, 0])
            cylinder(d = sock_d, h = inlet_depth + eps);

    // main channel from inlet to x = 15 (closed end)
    translate([-block_l/2 - eps, 0, mid_z])
        rotate([0, 90, 0])
            cylinder(d = ch_d, h = (main_end_x + block_l/2) + eps);

    // outlet branches running +Y
    for (x = outlet_x) {
        // channel from y = 0 to +Y face
        translate([x, 0, mid_z])
            rotate([-90, 0, 0])
                cylinder(d = ch_d, h = block_w/2 + eps);
        // socket at +Y face
        translate([x, block_w/2 - outlet_depth, mid_z])
            rotate([-90, 0, 0])
                cylinder(d = sock_d, h = outlet_depth + eps);
    }

    // vertical M3 through-holes
    for (x = screw_x)
        translate([x, screw_y, -eps])
            cylinder(d = screw_d, h = block_h + 2*eps);
}