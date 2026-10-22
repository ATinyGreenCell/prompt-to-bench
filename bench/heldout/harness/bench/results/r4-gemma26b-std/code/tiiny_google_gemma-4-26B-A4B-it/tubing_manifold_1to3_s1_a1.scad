// --- Dimensions (mm) ---
block_x = 60;           // Total length of block
block_y = 24;           // Total width of block
block_z = 16;           // Total height of block

channel_dia = 3.0;      // Diameter of internal channels
socket_dia = 4.2;       // Diameter of tubing sockets
socket_depth_in = 8.0;  // Depth of inlet socket
socket_depth_out = 6.0; // Depth of outlet sockets

inlet_x_pos = -30;       // Center of -X face (60/2)
inlet_y_pos = 0;         // Offset from center Y
inlet_z_pos = 8;         // Mid-plane Z

outlet_x_coords = [-15, 0, 15]; // X positions of the three outlets
outlet_z_pos = 8;        // Mid-plane Z

screw_hole_dia = 3.4;    // Diameter for M3 screws
screw_x_coords = [-25, 25]; // X positions of screw holes
screw_y_pos = -6;        // Y position of screw holes

// --- Parameters ---
$fn = 64;

// --- Main Block ---
difference() {
    // The solid block
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // 1. Inlet Socket (-X face, Y=0)
    // Positioned at the -X face (x = -30)
    translate([-block_x/2 - 0.1, inlet_y_pos, inlet_z_pos])
        rotate([0, 90, 0])
            cylinder(h = socket_depth_in + 0.1, d = socket_dia);

    // 2. Main Channel (Inlet to x=15)
    // Starts at the inlet face and runs to x = 15.
    // The inlet is at x = -30. The channel length is 45mm.
    translate([-block_x/2, inlet_y_pos, inlet_z_pos])
        rotate([0, 90, 0])
            cylinder(h = 45 + 0.1, d = channel_dia);

    // 3. Outlet Sockets (+Y face)
    // Three outlets at x = -15, 0, 15 running in +Y direction
    // They end at the +Y face (y = 12)
    for (x_pos = outlet_x_coords) {
        translate([x_pos, block_y/2 - socket_depth_out, outlet_z_pos])
            rotate([0, 90, 0])
                cylinder(h = socket_depth_out + 0.1, d = socket_dia);
    }

    // 4. Outlet Channels (Connecting main channel to outlet sockets)
    // The main channel is at y=0. The outlet sockets are at y=12.
    // The channels must bridge the gap from y=0 to the start of the sockets.
    for (x_pos = outlet_x_coords) {
        translate([x_pos, 0, outlet_z_pos])
            rotate([0, 90, 0])
                cylinder(h = block_y/2 + 0.1, d = channel_dia);
    }

    // 5. Screw Holes (Vertical through-holes)
    // Through the block at x = -25 and 25, y = -6
    for (x_pos = screw_x_coords) {
        translate([x_pos, screw_y_pos, -0.1])
            cylinder(h = block_z + 0.2, d = screw_hole_dia);
    }
}