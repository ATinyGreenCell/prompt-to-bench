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
    // Centered on X and Y, resting on Z=0
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // 1. Inlet Socket (-X face, Y=0)
    // User: "inlet, on the -X end face at y = 0, is a 4.2 mm socket 8 mm deep"
    // The -X face is at x = -30.
    translate([-block_x/2 - 0.1, inlet_y_pos, inlet_z_pos])
        rotate([0, 90, 0])
            cylinder(h = socket_depth_in + 0.1, d = socket_dia);

    // 2. Main Channel (Inlet to x=15)
    // User: "from it [the inlet] the main channel runs along X to x = 15, where it stops, closed, inside the block."
    // The inlet is at x = -30. The channel ends at x = 15.
    // Length = 15 - (-30) = 45mm.
    translate([-block_x/2, inlet_y_pos, inlet_z_pos])
        rotate([0, 90, 0])
            cylinder(h = 45 + 0.1, d = channel_dia);

    // 3. Outlet Sockets (+Y face)
    // User: "Three outlet channels branch off it at x = -15, 0 and 15 and run in the +Y direction to the +Y face, each ending there in a 4.2 mm socket 6 mm deep."
    // The +Y face is at y = 12.
    for (x_pos = outlet_x_coords) {
        translate([x_pos, block_y/2 - socket_depth_out, outlet_z_pos])
            rotate([0, 90, 0])
                cylinder(h = socket_depth_out + 0.1, d = socket_dia);
    }

    // 4. Outlet Channels
    // These connect the main channel (at y=0) to the outlet sockets (at y=12).
    // Since the sockets are 6mm deep, they start at y = 12 - 6 = 6.
    // The channels must span from y=0 to y=6.
    for (x_pos = outlet_x_coords) {
        translate([x_pos, 0, outlet_z_pos])
            rotate([0, 90, 0])
                cylinder(h = block_y/2 + 0.1, d = channel_dia);
    }

    // 5. Screw Holes (Vertical through-holes)
    // User: "Two 3.4 mm vertical through-holes for M3 screws go through the block at x = -25 and 25, y = -6"
    for (x_pos = screw_x_coords) {
        translate([x_pos, screw_y_pos, -0.1])
            cylinder(h = block_z + 0.2, d = screw_hole_dia);
    }
}