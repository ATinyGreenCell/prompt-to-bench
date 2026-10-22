// Manifold block: 1-in / 3-out, FDM print orientation (rests on XY, z=0)

// ---- Block dimensions (mm) ----
L = 60;   // length along X
W = 24;   // width  along Y
H = 16;   // height along Z

// ---- Channel geometry (all in mid-plane z = 8) ----
ch_d   = 3;    // channel bore diameter
ch_r   = ch_d / 2;
z_mid  = 8;    // mid-plane height

// ---- Socket geometry (4.2 mm bore for 4 mm tubing) ----
sock_d = 4.2;
sock_r = sock_d / 2;

// ---- Socket depths ----
inlet_depth  = 8;   // -X face, y = 0
outlet_depth = 6;   // +Y face, x = -15, 0, 15

// ---- Screw holes (M3 clearance) ----
screw_d = 3.4;
screw_r = screw_d / 2;
screw_x = [-25, 25];
screw_y = -6;

// ---- Branch / main channel X positions ----
branch_x = [-15, 0, 15];

$fn = 64;

// ================= SOLID BLOCK =================
module block() { translate([-L/2, -W/2, 0]) cube([L, W, H]); }

// ================= CUTS =================

// 1) Inlet socket: -X face, y = 0, 8 mm deep
module inlet_sock() { translate([-L/2 - 0.5, 0, z_mid])
    rotate([0, 90, 0])
    cylinder(h = inlet_depth + 0.5, r = sock_r, $fn = 64); }

// 2) Main channel: from inlet (x=-30) to x=15, closed inside
module main_ch() { translate([-L/2, 0, z_mid])
    rotate([0, 90, 0])
    cylinder(h = 45 + 0.5, r = ch_r, $fn = 64); }

// 3) Three outlet channels: branch at x=-15,0,15, run +Y to +Y face
module outlet_chs() { for (bx = branch_x)
    translate([bx, 0, z_mid])
        rotate([90, 0, 0])
        cylinder(h = W + 0.5, r = ch_r, $fn = 64); }

// 4) Three outlet sockets: +Y face, 6 mm deep
module outlet_socks() { for (bx = branch_x)
    translate([bx, W/2 + 0.5, z_mid])
        rotate([90, 0, 0])
        cylinder(h = outlet_depth + 0.5, r = sock_r, $fn = 64); }

// 5) Two M3 vertical through-holes
module screw_holes() { for (sx = screw_x)
    translate([sx, screw_y, -0.5])
        cylinder(h = H + 1, r = screw_r, $fn = 64); }

// ================= FINAL PART =================
difference() {
    block();
    inlet_sock();
    main_ch();
    outlet_chs();
    outlet_socks();
    screw_holes();
}