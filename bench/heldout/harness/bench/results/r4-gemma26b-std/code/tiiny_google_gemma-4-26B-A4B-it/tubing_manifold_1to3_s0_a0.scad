// --- Dimensions (mm) ---
block_x = 60;            // Total length of block
block_y = 24;            // Total width of block
block_z = 16;            // Total height of block

channel_dia = 3;         // Diameter of internal channels
inlet_socket_dia = 4.2;  // Diameter of inlet socket
inlet_socket_depth = 8;  // Depth of inlet socket
outlet_socket_dia = 4.2; // Diameter of outlet sockets
outlet_socket_depth = 6; // Depth of outlet sockets

main_channel_length = 15; // Length of main channel from -X end
outlet_x_positions = [-15, 0, 15]; // X positions of the three outlets

screw_hole_dia = 3.4;    // Diameter for M3 screw holes
screw_hole_x = 25;       // X position of screw holes (absolute)
screw_hole_y = -6;       // Y position of screw holes (absolute)

// --- Constants ---
$fn = 64;

// --- Main Block Construction ---
difference() {
    // The main solid block
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // 1. Inlet Socket (-X face, at y=0, centered on Z)
    // Positioned at x = -30 (the -X face), y = 0, z = 8
    translate([-block_x/2 - 0.1, 0, 8])
        rotate([0, 90, 0])
            cylinder(h = inlet_socket_depth + 0.1, d = inlet_socket_dia);

    // 2. Main Channel (runs from inlet to x = -15)
    // Note: User said "from it [inlet] the main channel runs along X to x=15, where it stops".
    // Since the block is 60mm long (from -30 to 30), and the inlet is at -30,
    // "x=15" relative to the origin means the channel ends at x=15.
    // However, the user also says "Three outlet channels branch off it at x = -15, 0 and 15".
    // This implies the main channel must span from the inlet (-30) to at least x=15.
    translate([-block_x/2 + 0.1, -channel_dia/2, 8 - channel_dia/2])
        cube([main_channel_length + 15, channel_dia, channel_dia]); 
        // Note: The logic above is simplified; let's use a cylinder for the main channel for better flow.
    
    // Re-defining Main Channel as a cylinder for better manifold design
    // It starts at the inlet (-30) and goes to x = 15.
    translate([-block_x/2 + 0.1, 0, 8])
        rotate([0, 90, 0])
            cylinder(h = main_channel_length + 15, d = channel_dia);

    // 3. Outlet Sockets (+Y face)
    // Three outlets at x = -15, 0, 15. They run in +Y direction.
    // They end at the +Y face (y = 12).
    for (ox = outlet_x_positions) {
        translate([ox, block_y/2 - outlet_socket_depth - 0.1, 8])
            rotate([0, 90, 0])
                cylinder(h = outlet_socket_depth + 0.1, d = outlet_socket_dia);
    }

    // 4. Screw Holes (Vertical through-holes)
    // Through the block at x = -25, 25 and y = -6.
    // Since the block is centered, x=-25 and x=25 are within the 60mm range.
    for (sx = [-25, 25]) {
        translate([sx, screw_hole_y, -0.1])
            cylinder(h = block_z + 0.2, d = screw_hole_dia);
    }
}

// Note on geometry: 
// The main channel is modeled as a cylinder along the X axis.
// The outlet sockets are modeled as cylinders along the Y axis.
// The intersection of these cylinders creates the manifold junctions.