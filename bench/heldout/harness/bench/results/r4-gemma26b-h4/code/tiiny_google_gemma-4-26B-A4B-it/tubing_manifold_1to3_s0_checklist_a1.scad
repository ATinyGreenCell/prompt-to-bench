// Manifold block for splitting one tubing line into three.
// Corrected version: ensures all channels are subtracted at z=8.

// --- Dimensions ---
L_block = 60.0;      // Length (X)
W_block = 24.0;      // Width (Y)
H_block = 16.0;      // Height (Z)

chan_d  = 3.0;       // Diameter of internal channels
inlet_d = 4.2;       // Diameter of inlet socket
inlet_h = 8.0;       // Depth of inlet socket
outlet_d = 4.2;      // Diameter of outlet socket
outlet_h = 6.0;      // Depth of outlet socket

screw_d = 3.4;       // Diameter of M3 screw holes
screw_x = 25.0;      // X position of screw holes
screw_y = -6.0;      // Y position of screw holes

$fn = 64;

// --- Calculations ---
z_mid = 8.0; // Specified mid-plane Z = 8

// --- Geometry Construction ---

module block_body() {
    // The main block centered on X and Y, sitting on Z=0
    translate([-L_block/2, -W_block/2, 0])
        cube([L_block, W_block, H_block]);
}

module channels() {
    // 1. Inlet Socket and Main Channel
    // Inlet is at -X face (x = -30), centered at y=0, z=8.
    // It is a 4.2mm socket 8mm deep.
    // The main channel starts from the end of the socket and runs to x=15.
    
    // Inlet socket (on the -X face)
    translate([-L_block/2, 0, z_mid])
        rotate([0, 90, 0])
            cylinder(h = inlet_h + 1, d = inlet_d);

    // Main channel (along X)
    // Starts from the end of the inlet socket (x = -30 + 8 = -22)
    // and runs to x = 15.
    translate([-L_block/2 + inlet_h, 0, z_mid])
        rotate([0, 90, 0])
            cylinder(h = 15 - (-L_block/2 + inlet_h) + 1, d = chan_d);

    // 2. Outlet Channels (along Y)
    // Branching at x = -15, 0, 15.
    // They run in +Y direction to the +Y face (y = 12).
    // The outlet socket is 6mm deep at the face.
    
    outlet_x_coords = [-15, 0, 15];
    for (cx = outlet_x_coords) {
        // Branch from main channel (y=0) to the start of the socket (y=6)
        // The socket is at y=12, depth 6, so it starts at y=6.
        translate([cx, 0, z_mid])
            cylinder(h = 6 + 1, d = chan_d);
            
        // Outlet socket at the +Y face (y = 12)
        translate([cx, W_block/2 - outlet_h, z_mid])
            rotate([0, 90, 0])
                cylinder(h = outlet_h + 1, d = outlet_d);
    }
}

module screw_holes() {
    // Two 3.4 mm vertical through-holes at x = -25 and 25, y = -6
    for (sx = [-screw_x, screw_x]) {
        translate([sx, screw_y, -1])
            cylinder(h = H_block + 2, d = screw_d);
    }
}

// --- Final Assembly ---

difference() {
    block_body();
    channels();
    screw_holes();
}