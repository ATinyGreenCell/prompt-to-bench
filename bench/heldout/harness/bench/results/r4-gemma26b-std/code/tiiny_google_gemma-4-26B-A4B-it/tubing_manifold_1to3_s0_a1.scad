// --- Dimensions (mm) ---
block_x = 60;            // Total length of block
block_y = 24;            // Total width of block
block_z = 16;            // Total height of block

channel_dia = 3;         // Diameter of internal channels
inlet_socket_dia = 4.2;  // Diameter of inlet socket
inlet_socket_depth = 8;  // Depth of inlet socket
outlet_socket_dia = 4.2; // Diameter of outlet sockets
outlet_socket_depth = 6; // Depth of outlet sockets

// The main channel runs from the inlet (-30) to x = 15.
// Total length of main channel = 30 (to center) + 15 (from center) = 45mm.
main_channel_length = 45; 

// Outlet positions relative to origin
outlet_x_positions = [-15, 0, 15]; 

screw_hole_dia = 3.4;    // Diameter for M3 screw holes
screw_hole_x = [-25, 25]; // X positions of screw holes
screw_hole_y = -6;       // Y position of screw holes

// --- Constants ---
$fn = 64;

// --- Main Block Construction ---
difference() {
    // The main solid block
    // Centered on X and Y, resting on Z=0
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // 1. Inlet Socket (-X face, at y=0, centered on Z)
    // Face is at x = -30. Socket goes 8mm deep into the block.
    // Socket is centered on Y=0 and Z=8.
    translate([-block_x/2 - 0.1, -inlet_socket_dia/2, 8 - inlet_socket_dia/2])
        cube([inlet_socket_depth + 0.1, inlet_socket_dia, inlet_socket_dia]);
    
    // Using cylinder for the socket to ensure it's a proper socket/bore
    translate([-block_x/2 - 0.1, -inlet_socket_dia/2, 8])
        rotate([0, 90, 0])
            cylinder(h = inlet_socket_depth + 0.1, d = inlet_socket_dia);

    // 2. Main Channel
    // Runs from the inlet (-30) to x = 15.
    // The inlet socket is at x=-30, so the channel starts there.
    // Total length = 30 + 15 = 45.
    translate([-block_x/2 + 0.1, -channel_dia/2, 8 - channel_dia/2])
        cube([main_channel_length, channel_dia, channel_dia]);
    
    // Using cylinder for the main channel for smooth flow and better rendering
    translate([-block_x/2 + 0.1, 0, 8])
        rotate([0, 90, 0])
            cylinder(h = main_channel_length, d = channel_dia);

    // 3. Outlet Sockets (+Y face)
    // Three outlets at x = -15, 0, 15. 
    // They run in +Y direction to the +Y face (y = 12).
    // They end at the face, so they are cut from the face inward.
    for (ox = outlet_x_positions) {
        translate([ox - outlet_socket_dia/2, block_y/2 - outlet_socket_depth + 0.1, 8 - outlet_socket_dia/2])
            cube([outlet_socket_dia, outlet_socket_depth, outlet_socket_dia]);
            
        // Using cylinder for the socket to ensure it's a proper socket/bore
        translate([ox, block_y/2 - outlet_socket_depth + 0.1, 8])
            rotate([0, 90, 0])
                cylinder(h = outlet_socket_depth + 0.1, d = outlet_socket_dia);
    }

    // 4. Screw Holes (Vertical through-holes)
    // Through the block at x = -25 and 25, y = -6.
    for (sx = screw_hole_x) {
        translate([sx, screw_hole_y - screw_hole_dia/2, -0.1])
            cylinder(h = block_z + 0.2, d = screw_hole_dia);
    }
}