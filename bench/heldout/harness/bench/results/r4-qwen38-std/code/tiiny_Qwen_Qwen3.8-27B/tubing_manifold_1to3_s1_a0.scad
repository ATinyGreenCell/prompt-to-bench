// Manifold block: 1-in / 3-out, FDM print orientation (rests on XY, z=0)
// All dimensions in mm, measured with calipers.

// Overall block
L   = 60;   // length along X
W   = 24;   // width  along Y
H   = 16;   // height along Z
z0  = 0;    // bottom rests on bed
zc  = 8;    // channel mid-plane (H/2)

// Channels
d_ch  = 3.0;   // channel bore diameter
r_ch  = d_ch / 2;

// Inlet socket (-X face, y = 0)
d_in  = 4.2;   // socket bore for 4 mm tubing
r_in  = d_in / 2;
dep_in = 8;    // socket depth into block

// Outlet sockets (+Y face)
d_out = 4.2;   // socket bore for 4 mm tubing
r_out = d_out / 2;
dep_out = 6;   // socket depth into block

// Screw holes (M3 clearance)
d_scr = 3.4;   // vertical through-hole diameter
r_scr = d_scr / 2;

// Branch / main-channel geometry (X positions)
x_in   = -30;  // inlet face (block -X end)
x_main_end = 15;   // main channel stops here (closed, inside block)
x_branch = [-15, 0, 15];  // where the three outlets branch off

$fn = 64;

// ---------- SOLID BLOCK ----------
block = translate([0, 0, z0])
    cube([L, W, H], center = [true, true, false]);

// ---------- CHANNELS (mid-plane z = 8) ----------

// Inlet socket: 4.2 mm bore, 8 mm deep, from -X face at y = 0
inlet_socket = translate([x_in, 0, zc])
    rotate([0, 90, 0])
    cylinder(h = dep_in, r = r_in, $fn = $fn);

// Main channel: 3 mm bore along X, from x_in to x_main_end (closed end)
main_channel = translate([x_in, 0, zc])
    rotate([0, 90, 0])
    cylinder(h = (x_main_end - x_in), r = r_ch, $fn = $fn);

// Three outlet channels: 3 mm bore along +Y, from y = 0 to +Y face
outlet_channels = for (xb = x_branch)
    translate([xb, 0, zc])
    rotate([90, 0, 0])
    cylinder(h = W / 2, r = r_ch, $fn = $fn);

// Three outlet sockets: 4.2 mm bore, 6 mm deep, from +Y face
outlet_sockets = for (xb = x_branch)
    translate([xb, W / 2, zc])
    rotate([90, 0, 0])
    cylinder(h = dep_out, r = r_out, $fn = $fn);

// ---------- SCREW HOLES (vertical through) ----------
screw_holes = for (xs = [-25, 25])
    translate([xs, -6, z0 - 1])   // extend 1 mm past bottom face
        cylinder(h = H + 2, r = r_scr, $fn = $fn);  // extend 1 mm past top face

// ---------- ASSEMBLY ----------
difference() {
    block;
    inlet_socket;
    main_channel;
    outlet_channels;
    outlet_sockets;
    screw_holes;
}