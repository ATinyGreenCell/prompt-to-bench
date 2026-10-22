// --- Parameters ---
// Block Dimensions
block_x = 60;           // Total length (X)
block_y = 24;           // Total width (Y)
block_z = 16;           // Total height (Z)

// Channel Dimensions
channel_dia = 3;        // Diameter of internal channels
inlet_socket_dia = 4.2; // Diameter of inlet socket
inlet_socket_depth = 8; // Depth of inlet socket
outlet_socket_dia = 4.2; // Diameter of outlet sockets
outlet_socket_depth = 6; // Depth of outlet sockets

// Screw Holes
screw_hole_dia = 3.4;    // Diameter for M3 screw holes
screw_x_pos = 25;       // X position of screw holes
screw_y_pos = -6;       // Y position of screw holes
screw_hole_depth = 20;  // Depth (through-hole)

// Internal Geometry Positions
// The block is centered on X and Y. 
// X range is [-30, 30]. Y range is [-12, 12].
inlet_x_face = -30;      // The -X face
inlet_y_pos = 0;        // Centered on Y (user specified y=0)
main_channel_end_x = 15; // Where the main channel stops (relative to origin)

// Outlet branch positions (X coordinates)
// User specified: x = -15, 0, 15
outlet_x_coords = [-15, 0, 15]; 

// Resolution
$fn = 64;

// --- Main Assembly ---

difference() {
    // The Main Block
    // Centered on X and Y, resting on Z=0
    translate([-block_x/2, -block_y/2, 0])
        cube([block_x, block_y, block_z]);

    // 1. Inlet Socket (on -X face)
    // Located at x = -30, y = 0, z = 8. 
    // It is 8mm deep, so it goes from x = -30 to x = -22.
    translate([-block_x/2 - 1, inlet_y_pos, block_z/2])
        rotate([0, 90, 0])
            cylinder(h = inlet_socket_depth + 1, d = inlet_socket_dia);

    // 2. Main Channel (running along X)
    // Starts from the end of the inlet socket (x = -22) and goes to x = 15.
    // To ensure a clean boolean, we start from the -X face and end at 15.
    translate([-block_x/2 - 1, inlet_y_pos, block_z/2])
        rotate([0, 90, 0])
            cylinder(h = main_channel_end_x - (-block_x/2) + 2, d = channel_dia);

    // 3. Outlet Sockets (on +Y face)
    // Located at x = [-15, 0, 15], y = 12, z = 8.
    // They are 6mm deep, so they go from y = 12 down to y = 6.
    for (x_pos = outlet_x_coords) {
        translate([x_pos, block_y/2 - 1, block_z/2])
            rotate([90, 0, 0])
                cylinder(h = outlet_socket_depth + 2, d = outlet_socket_dia);
    }

    // 4. Outlet Channels (branching from main channel to +Y face)
    // These connect the main channel (at z=8) to the outlet sockets.
    // The main channel exists up to x=15.
    // The outlets are at x=-15, 0, 15.
    for (x_pos = outlet_x_coords) {
        translate([x_pos, -1, block_z/2])
            cylinder(h = block_y/2 + 2, d = channel_dia);
    }

    // 5. Screw Holes (Vertical through-holes)
    // User specified: x = -25 and 25, y = -6.
    for (x_pos = [-25, 25]) {
        translate([x_pos, screw_y_pos, -1])
            cylinder(h = block_z + 2, d = screw_hole_dia);
    }
}